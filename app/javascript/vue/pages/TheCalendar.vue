<template>
  <div class="max-w-screen-xl">
    <button @click="setSchedule(new Date(2020, 5, 15))">
      検査 {{ loading }}
    </button>
    <div class="flex row justify-around items-center my-5">
      <router-link
        :to="`/calendar/month/${state.last}`"
        class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
      >
        <font-awesome-icon icon="chevron-left" />
        前月
      </router-link>
      <div>{{ format(state.currentMonth, 'M') }}月</div>
      <router-link
        :to="`/calendar/month/${state.next}`"
        class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
      >
        翌月
        <font-awesome-icon icon="chevron-right" />
      </router-link>
    </div>
    <schedule-creator />
    <div v-if="loading">loading...</div>
    <div class="" v-else-if="result">
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
            <div v-for="(schedule, i) in setSchedule(day)" :key="i">
              <span>{{ scheduleFormatter(schedule) }}</span>
              <span>{{ schedule.user.name }}</span>
            </div>
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
  useBlankSchedulesQuery,
  BlankSchedule
} from '@/graphql/types'
import ScheduleCreator from '@/vue/containers/ScheduleCreator.vue'
import { useCalendar } from '@/vue/composition-funcs/calendar'
import { routes } from 'vue/routes'
import { useResult } from '@vue/apollo-composable'

interface State {
  currentMonth: Date
  nextMonth: Date
  next: string
  last: string
  days: string[]
}

export default defineComponent({
  components: { ScheduleCreator },
  setup(_, context) {
    const state = reactive<State>({
      currentMonth: new Date(),
      nextMonth: addMonths(new Date(), 1),
      next: '',
      last: '',
      days: []
    })

    const { daysOfWeek, elementalies } = useCalendar()

    const load = (year: string, month: string) => {
      const current = parse(`${year}-${month}-01`, 'yyyy-MM-dd', new Date())
      state.currentMonth = current
      state.nextMonth = addMonths(current, 1)
      const monthStart = startOfMonth(current)
      const startDate = startOfWeek(monthStart)
      const endDate = addDays(startDate, 28)
      state.next = format(addMonths(current, 1), 'yyyy/MM/dd')
      state.last = format(addMonths(current, -1), 'yyyy/MM/dd')

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
      maxDate: state.nextMonth
    })

    const schedules = useResult(
      result,
      null,
      (data) => data.blankSchedules.nodes
    )

    //名前変えたい
    const setSchedule = (day) => {
      console.log(state.currentMonth)
      const _day = day
      const scheduleList = []

      result.value.blankSchedules.nodes.forEach((schedule) => {
        if (
          areIntervalsOverlapping(
            {
              start: new Date(schedule.startAt),
              end: new Date(schedule.endAt)
            },
            { start: day, end: addDays(day, 1) }
          )
        ) {
          console.log('あった')
          scheduleList.push(schedule)
        } else {
          console.log('no-hit')
        }
      })
      //console.log(scheduleList)
      return scheduleList
    }
    // 名前
    const scheduleFormatter = (schedule: BlankSchedule) => {
      const startAt = format(Date.parse(schedule.startAt), 'ah:mm', {
        locale: jaLocale
      })
      const endAt = format(Date.parse(schedule.endAt), 'ah:mm', {
        locale: jaLocale
      })
      return startAt + '~' + endAt
    }

    const sample = (date: Date) => {
      console.log(format(new Date(), 'ah:mm', { locale: jaLocale }))
    }

    watch(
      () => context.root.$route,
      (r) => {
        const { year, month } = r.params
        load(year, month)
      }
    )

    return {
      elementalies,
      loading,
      result,
      state,
      format,
      setSchedule,
      scheduleFormatter
    }
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
