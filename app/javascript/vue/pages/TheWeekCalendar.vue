<template>
  <div>
    <div class="flex row justify-around items-center">
      <div v-for="(day, i) in elementalies" :key="i">
        {{ day }}
      </div>
    </div>
    <div class="flex row justify-around items-center">
      <div class="items-center" v-for="(day, i) in days" :key="`day-${i}`">
        <p class="text-center">{{ day }}</p>
        <div v-for="(time, t) in times" :key="`time-${t}`">
          <div
            class="border bg-gray-200"
            :class="`day-${day} time-${time}`"
            style="width: 150px; height: 50px;"
          >
            <span v-if="i === 0">{{ time }}</span>
          </div>
        </div>
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
    const startDate = startOfWeek(new Date())
    const endDate = addDays(startDate, 6)
    const elementalies = [0, 1, 2, 3, 4, 5, 6].map((i) =>
      format(addDays(startOfWeek(new Date()), i), 'E', { locale: jaLocale })
    )

    let day = startDate
    const days = []
    for (let i = 0; i < 7; i++) {
      days.push(format(day, 'dd'))
      day = addDays(day, 1)
    }

    const times = []
    for (let i = 1; i < 25; i++) {
      times.push(i)
    }

    return { elementalies, days, times }
  }
})
</script>
<style scoped></style>
