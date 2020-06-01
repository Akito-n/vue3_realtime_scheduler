<template>
  <div>
    <div class="flex row justify-around items-center">
      <div v-for="(day, i) in elementalies" :key="i">
        {{ day }}
      </div>
    </div>
    <div
      class="flex row justify-around items-center"
      v-for="(week, i) in days"
      :key="`week-${i}`"
    >
      <div v-for="(day, j) in week" :key="`day-${j}`">
        {{ day }}
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { addDays, format, startOfWeek, startOfMonth } from 'date-fns'
import jaLocale from 'date-fns/locale/ja'
import Vue from 'vue'
import { defineComponent } from '@vue/composition-api'
import { useCurrentUserQuery } from '@/graphql/types'

export default defineComponent({
  setup() {
    const monthStart = startOfMonth(new Date())
    const startDate = startOfWeek(monthStart)
    const endDate = addDays(startDate, 7 * 6)
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

    return { elementalies, days }
  }
})
</script>
<style scoped></style>
