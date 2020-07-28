<template>
  <div class="max-w-screen-xl">
    <div class="flex row justify-around items-center my-5">
      <router-link
        :to="`/calendar/month/${state.last}`"
        class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
      >
        <font-awesome-icon icon="chevron-left" />
      </router-link>
      <div>{{ state.currentMonth | date('M') }}月</div>
      <router-link
        :to="`/calendar/month/${state.next}`"
        class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
      >
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
    <div v-else>
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
            {{ day | date('dd') }}
            <div
              v-for="(schedule, i) in getSchedules(day).slice(0, 2)"
              :key="i"
            >
              <span
                class="calender__schedule-circle calender__schedule-circle--inline"
                :class="`bg-${schedule.requester.color}-400`"
              ></span>
              <span class="calender__schedule-font--month">
                {{ schedule.requester.name }}
              </span>
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
import Vue, { PropType } from 'vue'
import { defineComponent, reactive, watch, ref } from '@vue/composition-api'
import { useCompanySchedulesSubscription, Schedule } from '@/graphql/types'
import ScheduleCreator from '@/vue/containers/ScheduleCreator.vue'
import { useCalendar } from '@/vue/composition-funcs/calendar'
import { routes } from 'vue/routes'
import { useSubscription } from '@vue/apollo-composable'
import { Occupation } from 'graphql/types'

interface State {
  currentMonth: Date
  nextMonth: Date
  next: string
  last: string
  days: string[]
}

export default defineComponent({
  props: {
    getSchedules: Function as PropType<(day: Date) => any[]>,
    loading: Boolean as PropType<boolean>
  },
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

    const scheduleFormatter = (schedule: Schedule) => {
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

    return {
      elementalies,
      state,
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
    height: 10px
    width: 10px
    border-radius: 50%


    &--inline {
      display: inline-block
    }
  }
}
</style>
