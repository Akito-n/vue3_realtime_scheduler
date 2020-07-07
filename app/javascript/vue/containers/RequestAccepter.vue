<template>
  <div v-if="schedule">
    <modal
      :value="!!state.scheduleId"
      @input="close"
      :title="state.isCancelled ? 'キャンセルしました' : 'リクエストされた内容'"
    >
      <template v-if="!state.isCancelled">
        {{ schedule.startAt | date('M/d(E) HH:mm') }}～{{
          schedule.endAt | date('HH:mm')
        }}

        <div v-if="schedule.occupation">
          <p>案件名</p>
          <span
            >{{ schedule.occupation.companyName }}:{{
              schedule.occupation.name
            }}</span
          >
          <p>応募経路</p>
          <span>{{ schedule.occupation.applyFrom }}</span>
          <p>所要時間</p>
          <span>{{ schedule.occupation.requiredTime }}時間</span>
          <p>訪問場所</p>
          <span>{{ schedule.occupation.address }}</span>
          <p>持ち物</p>
          <span>{{ schedule.occupation.item }}</span>
        </div>
        <!--Footer-->
        <div class="flex justify-between pt-2">
          <button
            class="px-4 bg-transparent p-3 rounded-lg text-indigo-500 hover:bg-gray-100 hover:text-indigo-400 mr-2"
            @click="state.confirming = true"
          >
            承認しない
          </button>
          <button
            class="px-4 bg-transparent p-3 rounded-lg text-indigo-500 hover:bg-gray-100 hover:text-indigo-400 mr-2"
            @click="submit(schedule.id)"
          >
            リクエストを承認する
          </button>
        </div>
      </template>
      <template v-else>
        <div>
          {{ schedule.requester.name }}へ調整不可の連絡をしました。
          あなたの空き予定の追加日程の入力、更新をお願いします。
        </div>
      </template>
    </modal>
    <confirm-dialog v-model="state.confirming" @ok="cancel(schedule.id)" />
  </div>
</template>
<script lang="ts">
import Vue from 'vue'
import {
  defineComponent,
  reactive,
  computed,
  watch
} from '@vue/composition-api'
import { useMutation, useResult } from '@vue/apollo-composable'
import {
  Schedule,
  RespondScheduleMutationVariables,
  RespondScheduleDocument,
  RespondScheduleMutation,
  useScheduleQuery
} from '@/graphql/types'
import Modal from '@/vue/components/Modal.vue'
import ConfirmDialog from '@/vue/components/ConfirmDialog.vue'

const initialState = {
  isCancelled: false,
  confirming: false,
  scheduleId: null
}

export default defineComponent({
  components: { ConfirmDialog, Modal },
  props: {},
  setup(props, context) {
    const state = reactive({ ...initialState })

    const scheduleRef = useScheduleQuery(() => ({
      scheduleId: state.scheduleId
    }))
    const schedule = useResult(scheduleRef.result, {}, (data) => data.schedule)
    const { mutate, loading, error, onDone } = useMutation<
      RespondScheduleMutation,
      RespondScheduleMutationVariables
    >(RespondScheduleDocument)

    const submit = (scheduleId: string) => {
      console.log(scheduleId)
      mutate({ input: { scheduleId: scheduleId } })
    }

    const cancel = (scheduleId: string) => {
      state.isCancelled = true
      mutate({ input: { scheduleId: scheduleId, isAccept: false } })
    }

    const close = () => {
      context.root.$router.push({ query: null })
    }

    onDone(() => {
      if (state.isCancelled) {
        return
      }
      close()
    })

    watch(
      () => context.root.$route.query,
      (query) => {
        state.scheduleId = query.requested_schedule_id
      }
    )

    return { submit, cancel, state, schedule, close }
  }
})
</script>

<style></style>
