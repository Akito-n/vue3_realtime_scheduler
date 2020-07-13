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
        <div v-if="value.requester.__typename == 'Occupation'">
          <span>応募経路</span>
          <p>{{ value.requester.applyFrom }}</p>
          <span>所要時間</span>
          <p>{{ value.requester.requiredTime }}時間</p>
          <span>訪問場所</span>
          <p>{{ value.requester.address }}</p>
          <span>持ち物</span>
          <p>{{ value.requester.item }}</p>
        </div>
        <button
          class="px-4 bg-transparent p-3 rounded-lg text-indigo-500 hover:bg-gray-100 hover:text-indigo-400 mr-2"
          @click="
            submit(blankSchedule.id, startAt, endAt, state.selectedOccupationId)
          "
        >
          面接日程をリクエストする
        </button>
      </div>
    </template>
  </modal>
</template>

<script lang="ts">
import Vue from 'vue'
import {
  defineComponent,
  reactive,
  computed,
  PropType
} from '@vue/composition-api'
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
import { Occupation, ScheduleConnection } from 'graphql/types'

export default defineComponent({
  components: { Modal },
  props: {
    value: { type: Boolean as PropType<boolean>, required: true },
    startAt: { type: Date as PropType<Date> },
    endAt: { type: Date as PropType<Date> },
    blankSchedule: { type: Object as PropType<Schedule> }
  },
  setup(props, context) {
    const { mutate, onDone } = useMutation<
      RequestScheduleToIndividualUserMutation,
      RequestScheduleToIndividualUserMutationVariables
    >(RequestScheduleToIndividualUserDocument)

    const { result } = useCurrentUserQuery()

    const state = reactive({
      selectedOccupationId: null
    })

    const submit = (
      blankScheduleId: string,
      startAt: Date,
      endAt: Date,
      occupationId: string
    ) => {
      mutate({
        input: { blankScheduleId, startAt, endAt, occupationId }
      })
    }

    onDone(() => {
      context.emit('input', null)
    })

    return { state, submit, result }
  }
})
</script>

<style></style>
