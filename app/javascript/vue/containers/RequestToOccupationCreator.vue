<template>
  <modal :value="!!value" @input="close" title="リクエストする">
    <template v-if="value">
      {{ startAt | date('M/d(E) HH:mm') }}～{{ endAt | date('HH:mm') }}

      <!--Footer-->
      <div class="flex justify-end pt-2">
        <div v-if="!blankSchedule">
          <div v-for="entry in entries" :key="entry.id">
            <label class="ml-3">
              <input
                type="radio"
                :value="entry.id"
                v-model="state.selectedOccupationId"
              />
              {{ entry.companyName }}:{{ entry.name }}
            </label>
          </div>
          <div v-if="state.selectedOccupation">
            <span>応募経路</span>
            <p>{{ state.selectedOccupation.applyFrom }}</p>
            <span>所要時間</span>
            <p>{{ state.selectedOccupation.requiredTime }}時間</p>
            <span>訪問場所</span>
            <p>{{ state.selectedOccupation.address }}</p>
            <span>持ち物</span>
            <p>{{ state.selectedOccupation.item }}</p>
          </div>
        </div>
        <div v-else>
          <div>
            <span>応募経路</span>
            <p>{{ blankSchedule.requester.applyFrom }}</p>
            <span>所要時間</span>
            <p>{{ blankSchedule.requester.requiredTime }}時間</p>
            <span>訪問場所</span>
            <p>{{ blankSchedule.requester.address }}</p>
            <span>持ち物</span>
            <p>{{ blankSchedule.requester.item }}</p>
          </div>
        </div>
        <button
          class="px-4 bg-transparent p-3 rounded-lg text-indigo-500 hover:bg-gray-100 hover:text-indigo-400 mr-2"
          @click="
            submit(
              startAt,
              endAt,
              state.selectedOccupationId || blankSchedule.requester.id
            )
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
import { useMutation, useResult } from '@vue/apollo-composable'
import {
  useCurrentUserQuery,
  Schedule,
  RequestScheduleToOccupationMutation,
  RequestScheduleToOccupationMutationVariables,
  RequestScheduleToOccupationDocument
} from '@/graphql/types'
import Modal from '@/vue/components/Modal.vue'
import {
  Occupation,
  ScheduleConnection,
  BlankScheduleDocument
} from 'graphql/types'

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
      RequestScheduleToOccupationMutation,
      RequestScheduleToOccupationMutationVariables
    >(RequestScheduleToOccupationDocument)

    const { result } = useCurrentUserQuery()

    const entries = useResult(
      result,
      null,
      (data) => data.currentUser.companyOccupations.nodes
    )

    const state = reactive({
      selectedOccupationId: null,
      selectedOccupation: computed(() => {
        if (state.selectedOccupationId) {
          return result.value.currentUser.companyOccupations.nodes.find(
            (e) => e.id == state.selectedOccupationId
          )
        }
      })
    })

    const submit = (startAt: Date, endAt: Date, occupationId: string) => {
      mutate({
        input: { startAt, endAt, occupationId }
      })
    }
    onDone(() => {
      close
    })

    const close = () => {
      context.emit('update:blankSchedule', null)
      context.emit('input', false)
    }

    return { state, submit, result, close, entries }
  }
})
</script>

<style></style>
