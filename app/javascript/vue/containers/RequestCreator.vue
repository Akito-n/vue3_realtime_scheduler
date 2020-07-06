<template>
  <modal :value="!!value" @input="$emit('input', null)" title="選択した内容">
    <template v-if="value">
      {{ startAt | date('M/d(E) HH:mm') }}～{{ endAt | date('HH:mm') }}

      <!--Footer-->
      <div class="flex justify-end pt-2">
        <div
          v-for="occupation in result.currentUser.occupations.nodes"
          :key="occupation.id"
        >
          <label class="ml-3">
            <input
              type="radio"
              :value="occupation.id"
              v-model="state.selectedOccupationId"
            />
            {{ occupation.name }}
          </label>
        </div>
        <button
          class="px-4 bg-transparent p-3 rounded-lg text-indigo-500 hover:bg-gray-100 hover:text-indigo-400 mr-2"
          @click="submit(value.id, startAt, endAt, state.selectedOccupationId)"
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
  useCurrentUserQuery,
  Schedule,
  RequestScheduleToIndividualUserMutation,
  RequestScheduleToIndividualUserMutationVariables,
  RequestScheduleToIndividualUserDocument,
  RequestScheduleToOccupationMutation,
  RequestScheduleToOccupationMutationVariables,
  RequestScheduleToOccupationDocument
} from '@/graphql/types'
import Modal from '@/vue/components/Modal.vue'

type Props = {
  value?: Schedule | null
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
    const toIndividualUser = useMutation<
      RequestScheduleToIndividualUserMutation,
      RequestScheduleToIndividualUserMutationVariables
    >(RequestScheduleToIndividualUserDocument)

    const toOccupation = useMutation<
      RequestScheduleToOccupationMutation,
      RequestScheduleToOccupationMutationVariables
    >(RequestScheduleToOccupationDocument)

    const state = reactive({
      selectedOccupationId: ''
    })

    const { result } = useCurrentUserQuery()

    const submit = (
      blankScheduleId: string,
      startAt: Date,
      endAt: Date,
      occupationId: string
    ) => {
      if (result.value.currentUser.isCompany) {
        toIndividualUser.mutate({
          input: { blankScheduleId, startAt, endAt, occupationId }
        })
      } else {
        toOccupation.mutate({ input: { blankScheduleId, startAt, endAt } })
      }
    }

    toIndividualUser.onDone(() => {
      context.emit('input', null)
    })
    toOccupation.onDone(() => {
      context.emit('input', null)
    })

    return { state, submit, result }
  }
})
</script>

<style></style>
