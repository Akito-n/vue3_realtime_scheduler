<template>
  <div>
    <modal
      :value="!!value"
      @input="$emit('input', null)"
      :title="state.isCancelled ? 'キャンセルしました' : 'リクエストされた内容'"
    >
      <template v-if="value && !state.isCancelled">
        {{ value.startAt | date('M/d(E) HH:mm') }}～{{
          value.endAt | date('HH:mm')
        }}

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
            @click="submit(value.id)"
          >
            リクエストを承認する
          </button>
        </div>
      </template>
      <template v-else-if="value">
        <div>
          {{ value.requester.name }}へ調整不可の連絡をしました。
          あなたの空き予定の追加日程の入力、更新をお願いします。
        </div>
      </template>
    </modal>
    <confirm-dialog v-model="state.confirming" @ok="cancel(value.id)" />
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
import { useMutation } from '@vue/apollo-composable'
import {
  Schedule,
  RespondScheduleMutationVariables,
  RespondScheduleDocument,
  RespondScheduleMutation
} from '@/graphql/types'
import Modal from '@/vue/components/Modal.vue'
import ConfirmDialog from '@/vue/components/ConfirmDialog.vue'

type Props = {
  value?: Schedule | null
}

const initialState = {
  isCancelled: false,
  confirming: false
}

export default defineComponent<Props>({
  components: { ConfirmDialog, Modal },
  props: {
    value: Object
  },
  setup(props, context) {
    const { mutate, loading, error, onDone } = useMutation<
      RespondScheduleMutation,
      RespondScheduleMutationVariables
    >(RespondScheduleDocument)

    const state = reactive({ ...initialState })

    const submit = (scheduleId: string) => {
      console.log(scheduleId)
      mutate({ input: { scheduleId: scheduleId } })
    }

    const cancel = (scheduleId: string) => {
      state.isCancelled = true
      mutate({ input: { scheduleId: scheduleId, isAccept: false } })
      console.log(state)
    }

    onDone(() => {
      if (state.isCancelled) {
        return
      }
      context.emit('input', null)
    })

    watch(
      () => props.value,
      (newValue) => {
        Object.assign(state, initialState)
      }
    )

    return { submit, cancel, state }
  }
})
</script>

<style></style>
