<template>
  <div>
    <div class="flex row justify-around items-center my-5">
      <router-link
        :to="`/calendar/week/${state.lastWeek}`"
        class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
      >
        <font-awesome-icon icon="chevron-left" />
        前月
      </router-link>
      <router-link
        :to="`/calendar/week/${state.nextWeek}`"
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
      <div
        class="items-center"
        v-for="(day, i) in state.days"
        :key="`day-${i}`"
      >
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
import {
  defineComponent,
  watch,
  reactive,
  computed
} from '@vue/composition-api'
import { useCurrentUserQuery } from '@/graphql/types'
import { routes } from 'vue/routes'

export default defineComponent({
  setup(props, context) {
    const state = reactive({
      route: context.root.$route,
      current: computed(() => {
        const { year, month, day } = state.route.params
        const _current = parse(
          `${year}-${month}-${day}`,
          'yyyy-MM-dd',
          new Date()
        )
        return _current
      }),
      lastWeek: computed(() =>
        format(addWeeks(state.current, -1), 'yyyy/MM/dd')
      ),
      nextWeek: computed(() =>
        format(addWeeks(state.current, 1), 'yyyy/MM/dd')
      ),
      days: computed(() => {
        let _day = startOfWeek(state.current)
        const _days = []
        for (let i = 0; i < 7; i++) {
          _days.push(format(_day, 'dd'))
          _day = addDays(_day, 1)
        }
        return _days
      })
    })
    const elementalies = [0, 1, 2, 3, 4, 5, 6].map((i) =>
      format(addDays(startOfWeek(new Date()), i), 'E', { locale: jaLocale })
    )

    const times = []
    for (let i = 1; i < 25; i++) {
      times.push(i)
    }

    watch(
      () => context.root.$route,
      (r) => {
        state.route = context.root.$route
      }
    )

    return { elementalies, times, state }
  }
})
</script>
<style scoped></style>
