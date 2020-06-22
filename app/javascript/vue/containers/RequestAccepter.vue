<template>
  <modal
    :value="!!value"
    @input="$emit('input', null)"
    title="リクエストされた内容"
  >
    <template v-if="value">
      {{ value.startAt | date('M/d(E) HH:mm') }}～{{
        value.endAt | date('HH:mm')
      }}

      <!--Footer-->
      <div class="flex justify-end pt-2">
        <button
          class="px-4 bg-transparent p-3 rounded-lg text-indigo-500 hover:bg-gray-100 hover:text-indigo-400 mr-2"
          @click="submit(value.id)"
        >
          リクエストを承認する
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
}

export default defineComponent<Props>({
  components: { Modal },
  props: {
    value: Object
  },
  setup(props, context) {
    const { mutate, loading, error, onDone } = useMutation<
      RequestScheduleMutation,
      RequestScheduleMutationVariables
    >(RequestScheduleDocument)

    const submit = (blankScheduleId: string) => {
      console.log(blankScheduleId)
      mutate({ input: { blankScheduleId: blankScheduleId } })
    }

    onDone(() => {
      context.emit('input', null)
    })

    return { submit }
  }
})
</script>

<style></style>
