<template>
  <modal :value="!!value" @input="close" title="選択した内容">
    <template v-if="value">
      {{ startAt | date('M/d(E) HH:mm') }}～{{ endAt | date('HH:mm') }}

      <!--Footer-->
      <div class="flex justify-end pt-2">
        <div
          v-for="recruitment in recruitments"
          :key="'radio-' + recruitment.id"
        >
          <label class="ml-3">
            <input
              type="radio"
              :value="recruitment.id"
              v-model="state.selectedRecruitmentId"
            />
            {{ recruitment.occupation.name }}/{{
              recruitment.individualUser.name
            }}
          </label>
        </div>
        <div v-for="recruitment in recruitments" :key="recruitment.id">
          <div v-if="state.selectedRecruitmentId === recruitment.id">
            <span>応募経路</span>
            <p>{{ recruitment.occupation.applyFrom }}</p>
            <span>所要時間</span>
            <p>{{ recruitment.occupation.requiredTime }}時間</p>
            <span>訪問場所</span>
            <p>{{ recruitment.occupation.address }}</p>
            <span>持ち物</span>
            <p>{{ recruitment.occupation.item }}</p>
          </div>
          <div v-if="state.selectedRecruitmentId === recruitment.id">
            <button
              class="px-4 bg-transparent p-3 rounded-lg text-indigo-500 hover:bg-gray-100 hover:text-indigo-400 mr-2"
              @click="
                submit(
                  recruitment.individualUser.id,
                  startAt,
                  endAt,
                  recruitment.occupation.id
                )
              "
            >
              面接日程をリクエストする
            </button>
          </div>
        </div>
      </div>
    </template>
  </modal>
</template>

<script lang="ts">
import {
  defineComponent,
  reactive,
  PropType,
  watch
} from '@vue/composition-api'
import { useMutation, useResult } from '@vue/apollo-composable'
import {
  useCurrentUserQuery,
  Schedule,
  RequestScheduleToIndividualUserMutation,
  RequestScheduleToIndividualUserMutationVariables,
  RequestScheduleToIndividualUserDocument
} from '@/graphql/types'
import Modal from '@/vue/components/Modal.vue'

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
    const recruitments = useResult(result, [], (data) =>
      data.currentUser.recruitements.nodes.filter(
        (it) =>
          !props.blankSchedule ||
          it.individualUser.id === props.blankSchedule.requester.id
      )
    )

    const state = reactive({
      selectedRecruitmentId: null,
      selectedIndividualUserId: null
    })

    watch(recruitments, (data) => {
      state.selectedRecruitmentId = data[0]?.id
    })

    const submit = (
      individualUserId: string,
      startAt: Date,
      endAt: Date,
      occupationId: string
    ) => {
      mutate({
        input: { individualUserId, startAt, endAt, occupationId }
      })
    }

    onDone(() => {
      close()
    })

    const close = () => {
      context.emit('update:blankSchedule', null)
      context.emit('input', false)
    }

    return { state, submit, recruitments, close }
  }
})
</script>

<style></style>
