<template>
  <div>
    <div class="fixed bg-gray-600 w-3/5 h-64 inset-auto" v-if="state.opened">
      開いた
      <input type="datetime-local" step="3600" v-model="state.date" />
      <button
        class="bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-4"
        @click="mutate"
      >
        登録する
      </button>
      <button
        class="bg-white-500 hover:bg-white-700 text-white font-bold py-2 px-4 rounded-full"
        @click="state.opened = false"
      >
        <font-awesome-icon icon="window-close" />
      </button>
    </div>
    <button
      class="bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-4 rounded-full"
      @click="state.opened = true"
    >
      <font-awesome-icon icon="plus" />
    </button>
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
import { addDays, format, startOfWeek, startOfMonth } from 'date-fns'
import jaLocale from 'date-fns/locale/ja'
import Vue from 'vue'
import { defineComponent, reactive } from '@vue/composition-api'
import {
  useCurrentUserQuery,
  useAddBlankScheduleMutation
} from '@/graphql/types'

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
