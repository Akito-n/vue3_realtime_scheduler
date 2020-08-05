<template>
  <div>
    <schedule-creator />
    <schedule-updater />
    <schedule-confirmer />
    <week-calendar
      :getSchedules="getSchedules"
      :loading="loading"
      @select="select"
    />
    <request-to-occupation-creator
      v-model="state.isRequested"
      :blankSchedule.sync="state.selectedSchedule"
      :startAt="state.selectedStartAt"
      :endAt="state.selectedEndAt"
    />
    <request-accepter v-model="state.selectedRequestedSchedule" />
  </div>
</template>

<script lang="ts">
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
import jaLocale from 'date-fns/locale/ja'
import Vue from 'vue'
import {
  ref,
  defineComponent,
  watch,
  reactive,
  computed,
  PropType
} from '@vue/composition-api'
import {
  Schedule,
  useIndividualSchedulesSubscription,
  useCurrentUserQuery
} from '@/graphql/types'
import { routes } from 'vue/routes'
import ScheduleCreator from '@/vue/containers/ScheduleCreator.vue'
import ScheduleUpdater from '@/vue/containers/ScheduleUpdater.vue'
import ScheduleConfirmer from '@/vue/containers/ScheduleConfirmer.vue'
import { useCalendar } from '@/vue/composition-funcs/calendar'
import RequestToOccupationCreator from '@/vue/containers/RequestToOccupationCreator.vue'
import RequestAccepter from '@/vue/containers/RequestAccepter.vue'
import { useSubscription } from '@vue/apollo-composable'
import WeekCalendar from '../components/WeekCalendar.vue'

export default defineComponent({
  props: {},
  components: {
    ScheduleCreator,
    ScheduleUpdater,
    ScheduleConfirmer,

    RequestToOccupationCreator,
    RequestAccepter,
    WeekCalendar
  },
  setup(props, context) {
    const currentUserQuery = useCurrentUserQuery()

    const { result, loading } = useIndividualSchedulesSubscription()

    const state = reactive({
      selectedSchedule: null,
      selectedRequestedSchedule: null,
      selectedStartAt: null,
      selectedEndAt: null,
      isRequested: false
    })

    const getSchedules = (day, hours, minutes) => {
      let criteriaTime = addHours(day, hours)
      criteriaTime = addMinutes(criteriaTime, minutes)
      if (!result.value) return []

      return result.value.individualSchedules.schedules.nodes.filter(
        (schedule) => {
          return areIntervalsOverlapping(
            {
              start: new Date(schedule.startAt),
              end: new Date(schedule.endAt)
            },
            { start: criteriaTime, end: addMinutes(criteriaTime, 30) }
          )
        }
      )
    }

    const times = []
    for (let i = 1; i <= 24; i++) {
      times.push(i)
    }

    const select = ({
      schedule,
      dateString,
      hour,
      minute
    }: {
      schedule: Schedule
      dateString: string
      hour: number
      minute: number
    }) => {
      const date = parse(
        `${dateString} ${hour}:${minute}`,
        'yyyy-MM-dd HH:mm',
        new Date()
      )
      state.selectedStartAt = date
      state.selectedEndAt = addHours(date, 1)
      //空き予定をクリックしてない時
      if (!schedule) {
        state.isRequested = true
        return
      } else {
        //自分のスケジュールの場合
        if (schedule.mine) {
          //空き予定の場合
          if (!schedule.isRequest) {
            //自分のリクエストだった場合、編集モーダルを出す
            context.root.$router.push({
              query: { edit_blank_schedule: schedule.id }
            })
            return
          } else {
            //空き予定ではない場合（自分からのリクエスト）
            //確定済みの場合、確認モーダル
            if (schedule.status == '確定済み') {
              context.root.$router.push({
                query: { confirmed_schedule_id: schedule.id }
              })
              return
            } else {
              //未確定のものは編集モーダルを出す
              context.root.$router.push({
                query: { edit_blank_schedule: schedule.id }
              })
              return
            }
          }
        } else {
          //相手のスケジュールの場合

          //空き予定の場合
          if (!schedule.isRequest) {
            state.selectedSchedule = schedule
            //相手のリクエストだった場合、リクエストモーダルを出す
            if (
              differenceInHours(
                new Date(schedule.endAt),
                new Date(schedule.startAt)
              ) < 2
            ) {
              //空き予定が１時間未満の場合、リクエストの終了時間は空き予定に合わせる
              state.selectedEndAt = new Date(schedule.endAt)
            } else {
              //FIXME : ここどうするか
              state.selectedEndAt = new Date(schedule.endAt)
            }
            state.isRequested = true
            return
          } else {
            //空き予定ではない場合（相手からのリクエスト）

            if (schedule.status == '確定済み') {
              context.root.$router.push({
                query: { confirmed_schedule_id: schedule.id }
              })
              return
            } else {
              //未確定のものはアクセプターを出す
              context.root.$router.push({
                query: { requested_schedule_id: schedule.id }
              })
              return
            }
          }
        }
      }
    }

    return {
      times,
      state,
      loading,
      result,
      getSchedules,
      format,
      jaLocale,
      select,
      currentUserQuery
    }
  }
})
</script>
<style scoped></style>
