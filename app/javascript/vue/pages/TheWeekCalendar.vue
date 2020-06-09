<template>
  <div class="flex justify-center items-end">
    <button @click="sample(new Date(), 20, 0)">検証</button>
    <div class="flex flex-col">
      <div
        v-for="(time, t) in times"
        :key="`time-${t}`"
        class="w-3 h-10 flex justify-end items-end border-b-2"
      >
        <span class="-mb-2 mr-4 whitespace-no-wrap">{{ time }}時</span>
      </div>
    </div>
    <div>
      <div class="flex row justify-around items-center my-5">
        <router-link
          :to="`/calendar/week/${state.lastWeek}`"
          class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
        >
          <font-awesome-icon icon="chevron-left" />
          前週
        </router-link>
        {{ state.currentWeek }}
        <router-link
          :to="`/calendar/week/${state.nextWeek}`"
          class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
        >
          翌週
          <font-awesome-icon icon="chevron-right" />
        </router-link>
      </div>
      <schedule-creator />
      <div class="flex row justify-center items-center">
        <div
          v-for="({ day, elementaly }, i) in state.days"
          :key="i"
          class="w-40 h-16 text-center"
        >
          {{ elementaly }}<br />
          {{ day }}
        </div>
      </div>
      <div v-if="loading">Loading...</div>
      <div v-else-if="result" class="flex row justify-center items-center">
        <div
          class="items-center"
          v-for="(day, i) in state.days"
          :key="`day-${i}`"
        >
          <div v-for="(hour, t) in times" :key="`hour-${t}`">
            <div
              :key="minute"
              v-for="minute in [0, 30]"
              class="bg-gray-200 w-40 h-5 schedule-cell relative"
              :class="`day-${day.day} hour-${hour} ${
                minute === 0 ? 'border-b-0' : ''
              }`"
            >
              <div
                v-if="sample(day.day, hour, minute)"
                class="schedule-cell--blank min-w-full min-h-full bg-red-200"
              ></div>
              <div class="schedule-cell--border inset-0 absolute" />
            </div>
          </div>
        </div>
      </div>
    </div>
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
  defineComponent,
  watch,
  reactive,
  computed
} from '@vue/composition-api'
import { useBlankSchedulesQuery } from '@/graphql/types'
import { routes } from 'vue/routes'
import ScheduleCreator from '@/vue/containers/ScheduleCreator.vue'
import { useCalendar } from '@/vue/composition-funcs/calendar'
import { useResult } from '@vue/apollo-composable'

export default defineComponent({
  components: { ScheduleCreator },
  setup(props, context) {
    const { daysOfWeek, elementalies } = useCalendar()
    const state = reactive({
      currentWeek: '',
      lastWeek: new Date().toString(),
      nextWeek: new Date().toString(),
      days: []
    })

    const { result, loading, refetch } = useBlankSchedulesQuery({
      minDate: state.lastWeek,
      maxDate: state.nextWeek
    })

    const schedules = useResult(
      result,
      null,
      (data) => data.blankSchedules.nodes
    )

    const sample = (day, hours, minutes) => {
      //day, timeから時間を再生成して
      let criteriaTime = addHours(day, hours)
      criteriaTime = addMinutes(criteriaTime, minutes)
      //
      const tempdata = result.value.blankSchedules.nodes.find((schedule) => {
        return areIntervalsOverlapping(
          { start: new Date(schedule.startAt), end: new Date(schedule.endAt) },
          { start: criteriaTime, end: addMinutes(criteriaTime, 30) }
        )
      })
      console.log(tempdata)

      return tempdata
      //schedulからstartAtがマッチしたshceduleを返す
    }

    const times = []
    for (let i = 1; i <= 24; i++) {
      times.push(i)
    }

    const load = (year: string, month: string, day: string) => {
      const current = parse(`${year}-${month}-${day}`, 'yyyy-MM-dd', new Date())
      state.lastWeek = format(addWeeks(current, -1), 'yyyy/MM/dd')
      state.nextWeek = format(addWeeks(current, 1), 'yyyy/MM/dd')

      state.days = daysOfWeek(current).map((day, i) => ({
        day,
        elementaly: elementalies[i]
      }))
      state.currentWeek = `${format(current, 'M月')} ${state.days[0].day}～${
        state.days[6].day
      }日`

      refetch({
        minDate: state.lastWeek,
        maxDate: state.nextWeek
      })
    }

    watch(
      () => context.root.$route,
      (r) => {
        const { year, month, day } = r.params
        load(year, month, day)
      }
    )

    return { times, state, loading, result, schedules, sample }
  }
})
</script>
<style scoped></style>
