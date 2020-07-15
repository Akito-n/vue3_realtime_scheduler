<template>
  <div>
    <schedule-creator />
    <schedule-updater />
    <week-calendar
      :getSchedules="getSchedules"
      :loading="loading"
      @select="select"
    />
    <request-to-individual-creator
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
  areIntervalsOverlapping
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
  useCompanySchedulesSubscription,
  useCurrentUserQuery
} from '@/graphql/types'
import { routes } from 'vue/routes'
import ScheduleCreator from '@/vue/containers/ScheduleCreator.vue'
import ScheduleUpdater from '@/vue/containers/ScheduleUpdater.vue'
import { useCalendar } from '@/vue/composition-funcs/calendar'
import RequestToIndividualCreator from '@/vue/containers/RequestToIndividualCreator.vue'
import RequestAccepter from '@/vue/containers/RequestAccepter.vue'
import { useSubscription } from '@vue/apollo-composable'
import WeekCalendar from '../components/WeekCalendar.vue'

export default defineComponent({
  props: {
    occupationIds: {
      type: Array as PropType<any[]>,
      required: false
    }
  },
  components: {
    ScheduleCreator,
    ScheduleUpdater,
    RequestToIndividualCreator,
    RequestAccepter,
    WeekCalendar
  },
  setup(props, context) {
    const currentUserQuery = useCurrentUserQuery()

    const { result, loading, restart } = useCompanySchedulesSubscription(() => {
      return {
        occupationIds: props.occupationIds
      }
    })

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

      return result.value.companySchedules.schedules.nodes.filter(
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

    watch(
      () => props.occupationIds,
      (newIds) => {
        console.log(newIds)
        restart()
      }
    )

    const select = ({
      blankSchedule,
      dateString,
      hour,
      minute
    }: {
      blankSchedule: Schedule
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
      state.selectedEndAt = addMinutes(date, 30)
      if (!blankSchedule) {
        state.isRequested = true
        return
      }
      //自分のリクエストだった場合、編集モーダルを出す
      if (blankSchedule.mine) {
        context.root.$router.push({
          query: { edit_blank_schedule: blankSchedule.id }
        })
        return
      }
      //非承認か確定ずみの場合は
      if (
        blankSchedule.status == '非承認' ||
        blankSchedule.status == '確定済み'
      )
        return

      //予定がリクエストだった場合、アクセプターを出す
      if (blankSchedule.isRequest) {
        context.root.$router.push({
          query: { requested_schedule_id: blankSchedule.id }
        })
        return
        //相手の空き予定の場合は選択したblankScheduleをstateに入れてリクエストモーダルを出す
      } else {
        state.isRequested = true
        state.selectedSchedule = blankSchedule
      }
    }

    return {
      times,
      loading,
      result,
      state,
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
