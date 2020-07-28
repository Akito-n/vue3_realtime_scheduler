<template>
  <div>
    <div v-if="loading">
      <div class="mt-20">
        <vue-loading
          type="spiningDubbles"
          color="#40e0d0"
          :size="{ width: '300px', height: '300px' }"
        />
      </div>
    </div>
    <div class="flex justify-center items-end" v-else>
      <div class="flex flex-col">
        <div
          v-for="(time, t) in times"
          :key="`time-${t}`"
          class="w-3 h-20 flex justify-end items-end border-b-2"
        >
          <span class="-mb-2 mr-4 whitespace-no-wrap">{{ time }}:00</span>
        </div>
      </div>
      <div>
        <div class="flex row justify-around items-center my-5">
          <router-link
            :to="`/calendar/week/${state.lastWeek}`"
            class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
          >
            <font-awesome-icon icon="chevron-left" />
          </router-link>
          {{ state.currentWeek }}
          <router-link
            :to="`/calendar/week/${state.nextWeek}`"
            class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
          >
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
            <div
              v-for="(hour, t) in times.map((t) => t - 1)"
              :key="`hour-${t}`"
            >
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
                class="bg-gray-100 w-40 h-10 schedule-cell relative"
                :class="`day-${day} hour-${hour} ${
                  minute === 0 ? 'border-b-0' : ''
                }`"
              >
                <div class="flex row justify-start">
                  <div
                    v-for="(schedule, i) in getSchedules(day, hour, minute)"
                    :key="i"
                    class="schedule-cell--blank max-w-3/4 min-h-full flex-grow h-10 z-10 overflow-visible"
                    :class="`bg-${schedule.requester.color}-400`"
                    @click.stop="
                      select(
                        schedule,
                        format(day, 'yyyy-MM-dd', { locale: jaLocale }),
                        hour,
                        minute
                      )
                    "
                  >
                    <span
                      v-if="displayableInformation(schedule, day, hour, minute)"
                      class="text-sm"
                    >
                      {{ schedule.requester.companyName }}
                      {{ schedule.isRequest ? schedule.status : '面接可能' }}
                    </span>
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
    getSchedules: Function as PropType<
      (day: Date, hours: number, minutes: number) => any[]
    >,
    loading: Boolean as PropType<boolean>
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

    const displayableInformation = (
      schedule: Schedule,
      day: number | Date,
      hours: number,
      minutes: number
    ) => {
      if (!schedule && !day && !hours && !minutes) return ''

      let criteriaTime = addHours(day, hours)
      criteriaTime = addMinutes(criteriaTime, minutes)
      const endTime = addMinutes(new Date(schedule.startAt), 10)

      return areIntervalsOverlapping(
        {
          start: new Date(schedule.startAt),
          end: endTime
        },
        { start: criteriaTime, end: addMinutes(criteriaTime, 30) }
      )
    }

    watch(
      () => context.root.$route,
      (r) => {
        const { year, month, day } = r.params
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
      select,
      displayableInformation
    }
  }
})
</script>
<style scoped></style>
