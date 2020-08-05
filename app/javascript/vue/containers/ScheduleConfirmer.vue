<template>
  <div v-if="schedule">
    <modal
      :value="!!state.scheduleId"
      @input="close"
      :title="schedule | confirmTitle(currentUser)"
    >
      <template v-if="!state.isConfirmed">
        {{ schedule.startAt | date('M/d(E) HH:mm') }}～{{
          schedule.endAt | date('HH:mm')
        }}

        <div v-if="schedule.occupation">
          <template v-if="currentUser.isCompany">
            <p>応募者名</p>
            <span>{{ schedule | requestIndividualName() }}</span>
          </template>
          <p>ポジション</p>
          <span>{{ schedule.occupation.name }}</span>
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
        <div class="flex justify-between pt-2"></div>
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
  useScheduleQuery,
  useCurrentUserQuery,
  User
} from '@/graphql/types'
import Modal from '@/vue/components/Modal.vue'
import ConfirmDialog from '@/vue/components/ConfirmDialog.vue'

const initialState = {
  isConfirmed: false,
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

    const currentUserRef = useCurrentUserQuery()
    const currentUser = useResult(
      currentUserRef.result,
      {},
      (data) => data.currentUser
    )

    const confirmTitle = (schedule: Schedule) => {
      if (schedule.mine) {
        return schedule.responder.name
      } else {
        return schedule.requester.name
      }
    }

    const cancel = (scheduleId: string) => {
      state.isConfirmed = true
      mutate({ input: { scheduleId: scheduleId, isAccept: false } })
    }

    const close = () => {
      context.root.$router.push({ query: null })
    }

    onDone(() => {
      if (state.isConfirmed) {
        return
      }
      close()
    })

    watch(
      () => context.root.$route.query,
      (query) => {
        state.scheduleId = query.confirmed_schedule_id
      }
    )

    return { currentUser, cancel, state, schedule, close, confirmTitle }
  }
})
</script>

<style></style>
