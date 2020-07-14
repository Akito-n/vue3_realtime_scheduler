<template>
  <div class="flex justify-center items-end">
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
      <div class="flex row justify-center items-center">
        <div
          v-for="(day, i) in state.days"
          :key="i"
          class="w-40 h-10 text-center"
        >
          {{ format(day, 'dd(E)', { locale: jaLocale }) }}
        </div>
      </div>
      <div class="flex row justify-center items-center">
        <div
          class="items-center"
          v-for="(day, i) in state.days"
          :key="`day-${i}`"
        >
          <div v-for="(hour, t) in times.map((t) => t - 1)" :key="`hour-${t}`">
            <div
              :key="minute"
              v-for="minute in [0, 30]"
              @click="
                select(
                  null,
                  format(day, 'yyyy-MM-dd', { locale: jaLocale }),
                  hour,
                  minute
                )
              "
              class="bg-gray-200 w-40 h-5 schedule-cell relative"
              :class="`day-${day} hour-${hour} ${
                minute === 0 ? 'border-b-0' : ''
              }`"
            >
              <div class="flex row justify-start">
                <div
                  v-for="(blankSchedule, i) in getSchedules(day, hour, minute)"
                  :key="i"
                  class="schedule-cell--blank min-h-full flex-grow"
                  :class="`bg-${blankSchedule.requester.color}-400`"
                  @click.stop="
                    select(
                      blankSchedule,
                      format(day, 'yyyy-MM-dd', { locale: jaLocale }),
                      hour,
                      minute
                    )
                  "
                >
                  {{ blankSchedule.requester.companyName }}
                  {{
                    blankSchedule.isRequest
                      ? blankSchedule.status
                      : blankSchedule.requester.name
                  }}
                </div>
              </div>
              <div
                class="schedule-cell--border inset-0 absolute pointer-events-none"
              />
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
  ref,
  defineComponent,
  watch,
  reactive,
  computed,
  PropType
} from '@vue/composition-api'
import { Schedule } from '@/graphql/types'
import { routes } from 'vue/routes'
import { useCalendar } from '@/vue/composition-funcs/calendar'

export default defineComponent({
  props: {
    year: { type: String as PropType<string>, required: true },
    month: { type: String as PropType<string>, required: true },
    day: { type: String as PropType<string>, required: true },
    getSchedules: Function as PropType<
      (day: Date, hours: number, minutes: number) => any[]
    >
  },
  components: {},
  setup(props, context) {
    const { daysOfWeek, elementalies } = useCalendar()
    const state = reactive({
      currentWeek: '',
      lastWeek: new Date().toString(),
      nextWeek: new Date().toString(),
      days: [],
      selectedSchedule: null,
      selectedRequestedSchedule: null,
      selectedStartAt: null,
      selectedEndAt: null,
      isRequested: false
    })

    const times = []
    for (let i = 1; i <= 24; i++) {
      times.push(i)
    }

    const load = (year: string, month: string, day: string) => {
      const current = parse(`${year}-${month}-${day}`, 'yyyy-MM-dd', new Date())
      state.lastWeek = format(addWeeks(current, -1), 'yyyy/MM/dd')
      state.nextWeek = format(addWeeks(current, 1), 'yyyy/MM/dd')

      state.days = daysOfWeek(current)
      state.currentWeek = `${format(current, 'M月')} ${format(
        state.days[0],
        'dd'
      )}～${format(state.days[6], 'dd')}日`
    }

    watch(
      () => props,
      (newProps) => {
        const { year, month, day } = newProps
        load(year, month, day)
      }
    )

    const select = (
      blankSchedule: Schedule,
      dateString: string,
      hour: number,
      minute: number
    ) => {
      context.emit('select', { blankSchedule, dateString, hour, minute })
    }

    return {
      times,
      state,
      format,
      jaLocale,
      select
    }
  }
})
</script>
<style scoped></style>
