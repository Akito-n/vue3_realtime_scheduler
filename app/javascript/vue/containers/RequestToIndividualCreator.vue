<template>
  <modal :value="!!value" @input="close" title="選択した内容">
    <template v-if="value">
      <vue-timepicker
        :format="timepickerOptions.format"
        :placeholder="timepickerOptions.placeholder"
        :minute-interval="timepickerOptions.interval"
        :hour-label="timepickerOptions.hourLabel"
        :minute-label="timepickerOptions.minuteLabel"
        :default-value="timepickerOptions.defaultValue"
        v-model="state.startTime"
        hide-clear-button
      />
      <vue-timepicker
        :format="timepickerOptions.format"
        :placeholder="timepickerOptions.placeholder"
        :minute-interval="timepickerOptions.interval"
        :hour-label="timepickerOptions.hourLabel"
        :minute-label="timepickerOptions.minuteLabel"
        :default-value="timepickerOptions.defaultValue"
        v-model="state.endTime"
        hide-clear-button
      />

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
                  state.startDateTime,
                  state.endDateTime,
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

<style></style>
