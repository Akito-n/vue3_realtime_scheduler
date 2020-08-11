<template>
  <div v-if="!!value">
    <div
      class="fixed w-full h-full top-0 left-0 flex items-center justify-center z-50"
    >
      <div
        class="absolute w-full h-full bg-gray-100 opacity-25"
        @click="close"
      ></div>
      <div class="bg-white w-11/12 md:max-w-md mx-auto rounded shadow-lg z-50">
        <div class="">
          <div class="flex justify-between items-center p-4 mb-4 modal__card">
            <p class="modal__card-title text-lg">
              面接リクエストを送る
            </p>
            <div class="cursor-pointer z-50" @click="close">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                width="18"
                height="18"
                viewBox="0 0 18 18"
                class="fill-current text-black"
              >
                <path
                  d="M14.53 4.53l-1.06-1.06L9 7.94 4.53 3.47 3.47 4.53 7.94 9l-4.47 4.47 1.06 1.06L9 10.06l4.47 4.47 1.06-1.06L10.06 9z"
                ></path>
              </svg>
            </div>
          </div>
          <div v-for="recruitment in recruitments" :key="recruitment.id">
            <div v-if="state.selectedRecruitmentId === recruitment.id">
              <div class="modal__card-body ml-4">
                <div class="modal__content flex items-stretch p-4">
                  <div class="modal__content-heading align-middle">
                    <p class="mt-3">候補者</p>
                  </div>
                  <div class="modal_content-context">
                    <div class="relative">
                      <select
                        class="block appearance-none w-full bg-gray-200 border border-gray-200 text-gray-700 py-3 px-4 pr-8 rounded leading-tight focus:outline-none focus:bg-white focus:border-gray-500"
                        v-model="state.selectedRecruitmentId"
                      >
                        <option
                          :value="recruitment.id"
                          v-for="recruitment in recruitments"
                          :key="'radio-' + recruitment.id"
                          >{{ recruitment.individualUser.name }}/{{
                            recruitment.occupation.name
                          }}</option
                        >
                      </select>
                      <div
                        class="pointer-events-none absolute inset-y-0 right-0 flex items-center px-2 text-gray-700"
                      >
                        <svg
                          class="fill-current h-4 w-4"
                          xmlns="http://www.w3.org/2000/svg"
                          viewBox="0 0 20 20"
                        >
                          <path
                            d="M9.293 12.95l.707.707L15.657 8l-1.414-1.414L10 10.828 5.757 6.586 4.343 8z"
                          />
                        </svg>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="modal__content flex items-start p-4">
                  <span class="modal__content-heading--small mr-6 mt-3"
                    >日時</span
                  >
                  <span class="modal_content-context mt-3 mr-2">{{
                    new Date(state.startDateTime) | date('M月d日(E)')
                  }}</span>
                  <div class="flex ml-4">
                    <div class="mt-2">
                      <vue-timepicker
                        class="modal__request-timeinput"
                        :format="timepickerOptions.format"
                        :placeholder="timepickerOptions.placeholder"
                        :minute-interval="timepickerOptions.interval"
                        :hour-label="timepickerOptions.hourLabel"
                        :minute-label="timepickerOptions.minuteLabel"
                        :default-value="timepickerOptions.defaultValue"
                        :hour-range="timepickerOptions.hourRange"
                        v-model="state.startTime"
                        hide-clear-button
                      />
                      <span class="text-lg font-medium">~</span>
                      <vue-timepicker
                        class="modal__request-timeinput -ml-2"
                        :format="timepickerOptions.format"
                        :placeholder="timepickerOptions.placeholder"
                        :minute-interval="timepickerOptions.interval"
                        :hour-label="timepickerOptions.hourLabel"
                        :minute-label="timepickerOptions.minuteLabel"
                        :default-value="timepickerOptions.defaultValue"
                        :hour-range="timepickerOptions.hourRange"
                        v-model="state.endTime"
                        hide-clear-button
                      />
                    </div>
                  </div>
                </div>
                <div
                  class="modal__content flex items-stretch p-4"
                  v-if="recruitment.occupation"
                >
                  <span class="modal__content-heading pr-6">ポジション</span
                  ><span class="modal_content-context pl-6">{{
                    recruitment.occupation.name
                  }}</span>
                </div>
                <div
                  class="modal__content flex items-stretch p-4"
                  v-if="recruitment.occupation"
                >
                  <span class="modal__content-heading pr-6">面接場所</span
                  ><span class="modal_content-context pl-6">{{
                    recruitment.occupation.address
                  }}</span>
                </div>
                <div
                  class="modal__content flex items-stretch p-4"
                  v-if="recruitment.occupation"
                >
                  <span class="modal__content-heading pr-6">持ち物</span
                  ><span class="modal_content-context pl-6">{{
                    recruitment.occupation.item
                  }}</span>
                </div>
                <div
                  class="modal__content flex items-stretch p-4"
                  v-if="recruitment.occupation"
                >
                  <span class="modal__content-heading pr-6">担当者</span
                  ><span class="modal_content-context pl-6">{{
                    recruitment.occupation.applyFrom
                  }}</span>
                </div>
              </div>
            </div>
            <div
              class="flex justify-center pt-2 pb-4"
              v-if="state.selectedRecruitmentId === recruitment.id"
            >
              <button
                class="px-4 bg-transparent p-3 rounded-md text-gray-400 bg-white boader-gray mr-4"
                @click="close"
              >
                キャンセル
              </button>
              <button
                class="px-4 bg-transparent p-3 rounded-md text-white bg-black mr-2"
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
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import {
  defineComponent,
  reactive,
  PropType,
  computed,
  watch
} from '@vue/composition-api'
import {
  addDays,
  format,
  startOfWeek,
  startOfMonth,
  parse,
  addWeeks,
  addHours,
  addMinutes,
  areIntervalsOverlapping,
  differenceInHours
} from 'date-fns'
import { useMutation, useResult } from '@vue/apollo-composable'
import {
  useCurrentUserQuery,
  Schedule,
  RequestScheduleToIndividualUserMutation,
  RequestScheduleToIndividualUserMutationVariables,
  RequestScheduleToIndividualUserDocument
} from '@/graphql/types'
import Modal from '@/vue/components/Modal.vue'
import VueTimepicker from 'vue2-timepicker'

export default defineComponent({
  components: { Modal, VueTimepicker },
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
      startTime: null,
      endTime: null,
      sceduleDay: null,
      startDateTime: computed(() =>
        settingTime(
          format(new Date(props.startAt), 'yyyy-MM-dd'),
          state.startTime
        )
      ),
      endDateTime: computed(() =>
        settingTime(
          format(new Date(props.startAt), 'yyyy-MM-dd'),
          state.endTime
        )
      ),
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

    const timepickerOptions = {
      format: 'HH:mm',
      interval: '30',
      placeholder: ' ',
      hourRange: [[9, 22]],
      hourLabel: '時間',
      minuteLabel: '分'
    }

    watch(
      () => props.startAt,
      (newStartAt) => {
        const startAt = newStartAt ? newStartAt : new Date()
        state.startTime = {
          HH: format(startAt, 'HH'),
          mm: format(startAt, 'mm')
        }
      }
    )
    watch(
      () => props.endAt,
      (newEndAt) => {
        const endAt = newEndAt ? newEndAt : new Date()
        state.endTime = {
          HH: format(endAt, 'HH'),
          mm: format(endAt, 'mm')
        }
      }
    )

    const settingTime = (
      dateString: string,
      time: { HH: StringConstructor; mm: StringConstructor }
    ) => {
      const _dateTime = parse(
        dateString + '-' + time.HH + time.mm,
        'yyyy-MM-dd-HHmm',
        new Date()
      )
      return _dateTime
    }

    return { state, submit, recruitments, close, timepickerOptions }
  }
})
</script>

<style lang="scss">
.vue__time-picker .dropdown ul li:not([disabled]).active {
  background: black;
}
.modal {
  &__request-timeinput {
    border: none;
    width: 100px !important;
  }
  &__request-timeinput > input {
    border: none !important;
    background-color: #edf2f7;
    width: 100px !important;
  }
}
</style>
