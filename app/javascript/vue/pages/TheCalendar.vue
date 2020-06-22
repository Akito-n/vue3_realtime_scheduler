<template>
  <div class="max-w-screen-xl">
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
    <div v-if="loading">
      <div class="mt-20">
        <vue-loading
          type="spiningDubbles"
          color="#40e0d0"
          :size="{ width: '300px', height: '300px' }"
        />
      </div>
    </div>
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
            <div v-for="(schedule, i) in setSchedule(day).slice(0, 2)" :key="i">
              <span
                class="calender__schedule-circle calender__schedule-circle--inline"
                :class="`bg-${schedule.user.color}-200`"
              ></span>
              <span class="calender__schedule-font--month">{{
                scheduleFormatter(schedule)
              }}</span>
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
import { defineComponent, reactive, watch, ref } from '@vue/composition-api'
import {
  useCurrentUserQuery,
  useAddBlankScheduleMutation,
  //useBlankSchedulesQuery,
  BlankSchedule
  //BlankSchedulesSubscriptionDocument
} from '@/graphql/types'
import ScheduleCreator from '@/vue/containers/ScheduleCreator.vue'
import { useCalendar } from '@/vue/composition-funcs/calendar'
import { routes } from 'vue/routes'
import { useResult, useSubscription } from '@vue/apollo-composable'

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

    // const { result, loading } = useSubscription(
    //   BlankSchedulesSubscriptionDocument
    // )

    const schedules = ref([])

    //名前変えたい
    const setSchedule = (day) => {
      const _day = day
      const scheduleList = []

      return result.value.blankSchedules.blankSchedules.nodes.filter(
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

    watch(
      () => context.root.$route,
      (r) => {
        const { year, month } = r.params
        load(year, month)
      }
    )

    const loading = true

    return {
      elementalies,
      loading,
      //result,
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
  &__schedule-font {
    &--month {
      font-size: 50%
    }
  }
  &__schedule-circle {
    height: 10px;
    width: 10px;
    border-radius: 50%;


    &--inline {
      display: inline-block
    }
  }
}
</style>
