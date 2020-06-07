<template>
  <div>
    <schedule-add-button />
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
import ScheduleAddButton from '../components/ScheduleButtonAdd.vue'

export default defineComponent({
  components: { ScheduleAddButton },
  setup() {
    const monthStart = startOfMonth(new Date())
    const displayMonth = add(monthStart, { months: 0 })
    const startDate = startOfWeek(displayMonth)
    const endDate = addDays(startDate, 7 * 4)
    const elementalies = [0, 1, 2, 3, 4, 5, 6].map((i) =>
      format(addDays(startOfWeek(new Date()), i), 'E', { locale: jaLocale })
    )

    let day = startDate
    const days = []
    while (day <= endDate) {
      const _days = []
      for (let i = 0; i < 7; i++) {
        _days.push(format(day, 'dd'))
        day = addDays(day, 1)
      }
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
