<template>
  <div class="max-w-screen-xl">
    <div class="flex row justify-around items-center my-5">
      <router-link
        :to="`/calendar/month/${state.lastMonth}`"
        class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
      >
        <font-awesome-icon icon="chevron-left" />
        前月
      </router-link>
      <div>{{ format(state.currentMonth, 'M') }}月</div>
      <router-link
        :to="`/calendar/month/${state.nextMonth}`"
        class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
      >
        翌月
        <font-awesome-icon icon="chevron-right" />
      </router-link>
    </div>
    <schedule-creator />
    <div class="">
      <div class="flex row justify-around items-center">
        <div v-for="(elementaly, i) in elementalies" :key="i">
          <div class="border-l border-t border-r text-center pt-2 w-40 h-10">
            {{ elementaly }}
          </div>
        </div>
      </div>
      <div
        class="flex row justify-around items-center"
        v-for="(week, i) in state.days"
        :key="`week-${i}`"
      >
        <div v-for="(day, j) in week" :key="`day-${j}`">
          <div class="border text-center w-40 h-20">
            {{ format(day, 'dd') }}
          </div>
        </div>
      </div>
    </div>
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
import { defineComponent, reactive, watch } from '@vue/composition-api'
import {
  useCurrentUserQuery,
  useAddBlankScheduleMutation,
  useBlankSchedulesQuery
} from '@/graphql/types'
import ScheduleCreator from '@/vue/containers/ScheduleCreator.vue'
import { useCalendar } from '@/vue/composition-funcs/calendar'
import { routes } from 'vue/routes'
import { useResult } from '@vue/apollo-composable'

interface State {
  currentMonth: string
  nextMonth: string
  lastMonth: string
  days: string[]
}

export default defineComponent({
  components: { ScheduleCreator },
  setup(_, context) {
    const state = reactive<State>({
      currentMonth: new Date(),
      nextMonth: '',
      lastMonth: '',
      days: []
    })

    const { daysOfWeek, elementalies } = useCalendar()

    const load = (year: string, month: string) => {
      const current = parse(`${year}-${month}-01`, 'yyyy-MM-dd', new Date())
      state.currentMonth = current
      const monthStart = startOfMonth(current)
      const startDate = startOfWeek(monthStart)
      const endDate = addDays(startDate, 28)
      state.nextMonth = format(addMonths(current, 1), 'yyyy/MM/dd')
      state.lastMonth = format(addMonths(current, -1), 'yyyy/MM/dd')

      //funcsに分ける startDateだけあれば行ける気がする
      let day = startDate
      const tempdays = []
      while (day <= endDate) {
        const _days = daysOfWeek(day)
        day = addDays(day, 7)
        tempdays.push(_days)
      }
      state.days = tempdays
    }

    const { result, loading, refetch } = useBlankSchedulesQuery({
      minDate: state.currentMonth,
      maxDate: state.currentMonth
    })

    const schedules = useResult(
      result,
      null,
      (data) => data.blankSchedules.nodes
    )

    const setSchedule = (day) => {
      const _day = day
      const scheduleList = []

      return result.value.blankSchedules.nodes.forEach((schedule) => {
        if (
          areIntervalsOverlapping(
            {
              start: new Date(schedule.startAt),
              end: new Date(schedule.endAt)
            },
            { start: day, end: addDays(day, 1) }
          )
        ) {
          scheduleList.push(schedule)
        }
      })
    }

    watch(
      () => context.root.$route,
      (r) => {
        const { year, month } = r.params
        load(year, month)
      }
    )

    return { elementalies, state, format }
  }
})
</script>
<style scoped lang="sass">
.calender{
  &__cell {
    height: 100px
  }
}
</style>
