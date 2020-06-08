<template>
  <div>
    <schedule-creator />
    <div class="flex row justify-around items-center">
      <div v-for="(day, i) in elementalies" :key="i">
        <div
          class="border-l border-t border-r text-center pt-2"
          style="width: 200px; height: 50px;"
        >
          {{ day }}
        </div>
      </div>
    </div>
    <div
      class="flex row justify-around items-center"
      v-for="(week, i) in days"
      :key="`week-${i}`"
    >
      <div v-for="(day, j) in week" :key="`day-${j}`">
        <div class="border text-center" style="width: 200px; height: 100px;">
          {{ day }}
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { add, addDays, format, startOfWeek, startOfMonth } from 'date-fns'
import jaLocale from 'date-fns/locale/ja'
import Vue from 'vue'
import { defineComponent, reactive } from '@vue/composition-api'
import {
  useCurrentUserQuery,
  useAddBlankScheduleMutation
} from '@/graphql/types'
import ScheduleCreator from '@/vue/containers/ScheduleCreator.vue'
import { useCalendar } from '@/vue/composition-funcs/calendar'

export default defineComponent({
  components: { ScheduleCreator },
  setup() {
    const monthStart = startOfMonth(new Date())
    const displayMonth = add(monthStart, { months: 0 })
    const startDate = startOfWeek(displayMonth)
    const endDate = addDays(startDate, 7 * 4)

    const { daysOfWeek, elementalies } = useCalendar()

    let day = startDate
    const days = []
    while (day <= endDate) {
      const _days = daysOfWeek(day)
      day = addDays(day, 7)
      days.push(_days)
    }

    const state = reactive({
      opened: false,
      date: new Date()
    })

    const { mutate, loading, error, onDone } = useAddBlankScheduleMutation({
      variables: {
        input: {
          startAt: new Date(),
          endAt: new Date()
        }
      }
    })

    return { elementalies, days, state, open, mutate }
  }
})
</script>
<style scoped></style>
