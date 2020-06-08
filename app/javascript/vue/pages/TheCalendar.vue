<template>
  <div>
    <div class="flex row justify-around items-center my-5">
      <router-link
        :to="`/calendar/month/${state.lastMonth}`"
        class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
      >
        <font-awesome-icon icon="chevron-left" />
        前月
      </router-link>
      <router-link
        :to="`/calendar/month/${state.nextMonth}`"
        class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
      >
        翌月
        <font-awesome-icon icon="chevron-right" />
      </router-link>
    </div>
    <schedule-creator />
    <div class="flex row justify-around items-center">
      <div v-for="(elementaly, i) in elementalies" :key="i">
        <div
          class="border-l border-t border-r text-center pt-2"
          style="width: 200px; height: 50px;"
        >
          {{ elementaly }}
        </div>
      </div>
    </div>
    <div class="flex row justify-around items-center">
      <div v-for="(day, i) in state.days" :key="`day-${i}`">
        <div class="border text-center" style="width: 200px; height: 100px;">
          {{ day }}
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
  parse
} from 'date-fns'
import jaLocale from 'date-fns/locale/ja'
import Vue from 'vue'
import { defineComponent, reactive, watch } from '@vue/composition-api'
import {
  useCurrentUserQuery,
  useAddBlankScheduleMutation
} from '@/graphql/types'
import ScheduleCreator from '@/vue/containers/ScheduleCreator.vue'
import { useCalendar } from '@/vue/composition-funcs/calendar'

export default defineComponent({
  components: { ScheduleCreator },
  setup(_, context) {
    const state = reactive({
      nextMonth: '',
      lastMonth: '',
      days: []
    })

    const { daysOfWeek, elementalies } = useCalendar()

    // const monthStart = startOfMonth(new Date())
    // const startDate = startOfWeek(monthStart)
    // const endDate = addDays(startDate, 7 * 4)
    // console.log(monthStart, startDate, endDate)

    // let day = startDate
    // const days = []
    // while (day <= endDate) {
    //   const _days = daysOfWeek(day)
    //   day = addDays(day, 7)
    //   days.push(_days)
    // }

    const load = (year: string, month: string) => {
      const current = parse(`${year}-${month}-01`, 'yyyy-MM-dd', new Date())
      const monthStart = startOfMonth(current)
      const startDate = startOfWeek(monthStart)
      const endDate = addDays(startDate, 28)
      let day = startDate
      const tempdays = []
      state.nextMonth = format(addMonths(current, 1), 'yyyy/MM/dd')
      state.lastMonth = format(addMonths(current, -1), 'yyyy/MM/dd')

      while (day <= endDate) {
        const _days = daysOfWeek(day)
        day = addDays(day, 7)
        tempdays.push(..._days)
      }
      state.days = tempdays
    }

    watch(
      () => context.root.$route,
      (r) => {
        const { year, month } = r.params
        console.log(year, month)
        load(year, month)
      }
    )

    return { elementalies, state }
  }
})
</script>
<style scoped></style>
