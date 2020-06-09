<template>
  <div>
    <div class="flex row justify-around items-center my-5">
      <router-link
        :to="`/calendar/week/${state.lastWeek}`"
        class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
      >
        <font-awesome-icon icon="chevron-left" />
        前週
      </router-link>
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
      <div v-for="(elementaly, i) in elementalies" :key="i" class="w-40 h-20">
        <div class="text-center">
          {{ elementaly }}
        </div>
      </div>
    </div>
    <div class="flex row justify-center items-center">
      <div class="flex flex-col">
        <template v-for="(time, t) in times">
          <div
            :key="`time-${t}`"
            class="w-40 h-20 flex justify-end items-center"
          >
            <span>{{ time }}</span>
          </div>
        </template>
      </div>

      <div
        class="items-center"
        v-for="(day, i) in state.days"
        :key="`day-${i}`"
      >
        <p class="text-center">{{ day }}</p>
        <div v-for="(time, t) in times" :key="`time-${t}`">
          <div
            class="border bg-gray-200 w-40 h-20"
            :class="`day-${day} time-${time}`"
          ></div>
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
  addWeeks
} from 'date-fns'
import jaLocale from 'date-fns/locale/ja'
import Vue from 'vue'
import {
  defineComponent,
  watch,
  reactive,
  computed
} from '@vue/composition-api'
import { useCurrentUserQuery } from '@/graphql/types'
import { routes } from 'vue/routes'
import ScheduleCreator from '@/vue/containers/ScheduleCreator.vue'
import { useCalendar } from '@/vue/composition-funcs/calendar'

export default defineComponent({
  components: { ScheduleCreator },
  setup(props, context) {
    const state = reactive({
      lastWeek: '',
      nextWeek: '',
      days: []
    })

    const { daysOfWeek, elementalies } = useCalendar()

    const times = []
    for (let i = 1; i < 25; i++) {
      times.push(i)
    }

    const load = (year: string, month: string, day: string) => {
      const current = parse(`${year}-${month}-${day}`, 'yyyy-MM-dd', new Date())
      state.lastWeek = format(addWeeks(current, -1), 'yyyy/MM/dd')
      state.nextWeek = format(addWeeks(current, 1), 'yyyy/MM/dd')

      state.days = daysOfWeek(current)
    }

    watch(
      () => context.root.$route,
      (r) => {
        const { year, month, day } = r.params
        load(year, month, day)
      }
    )

    return { elementalies, times, state }
  }
})
</script>
<style scoped></style>
