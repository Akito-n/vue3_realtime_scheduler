<template>
  <modal :value="!!value" @input="$emit('input', null)" title="選択した内容">
    <template v-if="value">
      {{ startAt | date('M/d(E) HH:mm') }}～{{ endAt | date('HH:mm') }}

      <!--Footer-->
      <div class="flex justify-end pt-2">
        <button
          class="px-4 bg-transparent p-3 rounded-lg text-indigo-500 hover:bg-gray-100 hover:text-indigo-400 mr-2"
          @click="submit(value.id, startAt, endAt)"
        >
          面接日程をリクエストする
        </button>
      </div>
    </template>
  </modal>
</template>

<script lang="ts">
import Vue from 'vue'
import { defineComponent, reactive, computed } from '@vue/composition-api'
import { useMutation } from '@vue/apollo-composable'
import {
  BlankSchedule,
  RequestScheduleMutation,
  RequestScheduleMutationVariables,
  RequestScheduleDocument
} from '@/graphql/types'
import Modal from '@/vue/components/Modal.vue'

type Props = {
  value?: BlankSchedule | null
  startAt?: Date
  endAt?: Date
}

export default defineComponent<Props>({
  components: { Modal },
  props: {
    value: Object,
    startAt: Date,
    endAt: Date
  },
  setup(props, context) {
    const { mutate, loading, error, onDone } = useMutation<
      RequestScheduleMutation,
      RequestScheduleMutationVariables
    >(RequestScheduleDocument)

    const submit = (blankScheduleId: string, startAt: Date, endAt: Date) => {
      mutate({ input: { blankScheduleId, startAt, endAt } })
    }

    onDone(() => {
      context.emit('input', null)
    })

    return { submit }
  }
})
</script>

<style></style>
