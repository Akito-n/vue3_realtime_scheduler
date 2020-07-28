<template>
  <div>
    <month-calender :getSchedules="getSchedules" :loading="loading" />
  </div>
</template>

<script lang="ts">
import {
  add,
  addDays,
  addMonths,
  format,
  startOfWeek,
  startOfMonth,
  parse,
  areIntervalsOverlapping
} from 'date-fns'
import jaLocale from 'date-fns/locale/ja'
import Vue from 'vue'
import { defineComponent, reactive, watch, ref } from '@vue/composition-api'
import { useIndividualSchedulesSubscription, Schedule } from '@/graphql/types'
import ScheduleCreator from '@/vue/containers/ScheduleCreator.vue'
import { useCalendar } from '@/vue/composition-funcs/calendar'
import { routes } from 'vue/routes'
import { useSubscription } from '@vue/apollo-composable'
import MonthCalender from '../components/MonthCalender.vue'

interface State {
  currentMonth: Date
  nextMonth: Date
  next: string
  last: string
  days: string[]
}

export default defineComponent({
  components: { ScheduleCreator, MonthCalender },
  setup(_, context) {
    const state = reactive<State>({
      currentMonth: new Date(),
      nextMonth: addMonths(new Date(), 1),
      next: '',
      last: '',
      days: []
    })

    const { result, loading, restart } = useIndividualSchedulesSubscription(
      () => {
        return {
          occupationIds: [],
          userIds: []
        }
      }
    )

    const getSchedules = (day) => {
      const _day = day
      const scheduleList = []

      return result.value.individualSchedules.schedules.nodes.filter(
        (schedule) => {
          return areIntervalsOverlapping(
            {
              start: new Date(schedule.startAt),
              end: new Date(schedule.endAt)
            },
            { start: day, end: addDays(day, 1) }
          )
        }
      )
    }

    return {
      loading,
      result,
      state,
      getSchedules
    }
  }
})
</script>
<style scoped lang="sass"></style>
