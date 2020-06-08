<template>
  <div>
    <div class="flex row justify-around items-center my-5">
      <router-link
        :to="`/calendar/week/${lastWeek}`"
        class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
      >
        <font-awesome-icon icon="chevron-left" />
        前月
      </router-link>
      <router-link
        :to="`/calendar/week/${nextWeek}`"
        class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
      >
        翌月
        <font-awesome-icon icon="chevron-right" />
      </router-link>
    </div>
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
import { defineComponent } from '@vue/composition-api'
import { useCurrentUserQuery } from '@/graphql/types'

export default defineComponent({
  setup(props, context) {
    const { year, month, day } = context.root.$route.params
    const current = parse(`${year}-${month}-${day}`, 'yyyy-MM-dd', new Date())
    const lastWeek = format(addWeeks(current, -1), 'yyyy/MM/dd')
    const nextWeek = format(addWeeks(current, 1), 'yyyy/MM/dd')
    const startDate = startOfWeek(current)
    const endDate = addDays(startDate, 6)
    const elementalies = [0, 1, 2, 3, 4, 5, 6].map((i) =>
      format(addDays(startOfWeek(new Date()), i), 'E', { locale: jaLocale })
    )

    let _day = startDate
    const days = []
    for (let i = 0; i < 7; i++) {
      days.push(format(_day, 'dd'))
      _day = addDays(_day, 1)
    }

    const times = []
    for (let i = 1; i < 25; i++) {
      times.push(i)
    }

    return { elementalies, days, times, lastWeek, nextWeek }
  }
})
</script>
<style scoped></style>
