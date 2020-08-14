<template>
  <div>
    <div v-if="loading">
      <div class="mt-20">
        <vue-loading
          type="spiningDubbles"
          color="#0000cd"
          :size="{ width: '300px', height: '300px' }"
        />
      </div>
    </div>
    <div
      class="flex justify-center items-end bg-white pt-2 pb-10 pl-16 pr-5 rounded week__calender-section"
      v-else
    >
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
        <div class="flex row justify-center items-center my-5">
          <router-link
            :to="`/calendar/week/${state.lastWeek}`"
            class="text-gray-700 font-bold py-2 px-4 mr-4 rounded"
          >
            <font-awesome-icon icon="chevron-left" />
          </router-link>
          <span class="text-2xl">{{ state.currentWeek }}</span>
          <router-link
            :to="`/calendar/week/${state.nextWeek}`"
            class="text-gray-700 ml-5 font-bold py-2 px-4 rounded"
          >
            <font-awesome-icon icon="chevron-right" />
          </router-link>
        </div>
        <div class="flex row justify-center items-center">
          <div
            v-for="(day, i) in state.days"
            :key="i"
            class="w-32 h-14 text-center"
            :class="`week__row--${scheduleIsToday(day)}`"
          >
            {{ format(day, 'E', { locale: jaLocale }) }}
            <br />
            {{ format(day, 'dd', { locale: jaLocale }) }}
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
                class="w-32 h-10 schedule-cell relative"
                :class="`${
                  minute === 0 ? 'border-b-0' : ''
                } week__cell--${dayType(day)}`"
              >
                <div class="flex row justify-start">
                  <template
                    v-for="(schedule, i) in getSchedules(day, hour, minute)"
                  >
                    <div
                      v-if="displayableInformation(schedule, day, hour, minute)"
                      :key="i"
                      class="max-w-3/4 min-h-full flex-grow z-10 items-center justify-center flex mr-2 rounded-md"
                      :class="`bg__${
                        schedule.requester.color
                      } cell-h-${scheduleCellCounts(schedule)}`"
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
                        v-if="
                          displayableInformation(schedule, day, hour, minute)
                        "
                        class="text-sm text-white text-center items-center justify-center flex"
                        :class="`cell-h-${scheduleCellCounts(schedule)}`"
                      >
                        {{ schedule | calenderInformation(currentUser) }}
                      </span>
                    </div>
                  </template>
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
  areIntervalsOverlapping,
  differenceInMinutes,
  isSunday,
  isSaturday,
  isToday
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
import { Schedule, User } from '@/graphql/types'
import { routes } from 'vue/routes'
import { useCalendar } from '@/vue/composition-funcs/calendar'

export default defineComponent({
  props: {
    getSchedules: Function as PropType<
      (day: Date, hours: number, minutes: number) => any[]
    >,
    loading: Boolean as PropType<boolean>,
    currentUser: Object as PropType<User>
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
    for (let i = 9; i <= 23; i++) {
      times.push(i)
    }

    const load = (year: string, month: string, day: string) => {
      const current = parse(`${year}-${month}-${day}`, 'yyyy-MM-dd', new Date())
      state.lastWeek = format(addWeeks(current, -1), 'yyyy/MM/dd')
      state.nextWeek = format(addWeeks(current, 1), 'yyyy/MM/dd')

      state.days = daysOfWeek(current)
      state.currentWeek = format(current, 'yyyy/M')
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
      schedule: Schedule,
      dateString: string,
      hour: number,
      minute: number
    ) => {
      context.emit('select', { schedule, dateString, hour, minute })
    }

    const scheduleCellCounts = (schedule: Schedule) => {
      return (
        differenceInMinutes(
          new Date(schedule.endAt),
          new Date(schedule.startAt)
        ) / 30
      )
    }

    const dayType = (day: Date) => {
      return isSunday(day) || isSaturday(day) ? 'holiday' : 'weekday'
    }

    const scheduleIsToday = (day: Date) => {
      return isToday(day) ? 'today' : 'other'
    }

    return {
      times,
      state,
      format,
      jaLocale,
      select,
      displayableInformation,
      scheduleCellCounts,
      dayType,
      scheduleIsToday
    }
  }
})
</script>
<style lang="scss" scoped>
.week {
  &__calender-section {
    box-shadow: 0px 0px 10px rgba(153, 153, 153, 0.2);
  }
  &__current-week-title {
    /* Today’s Agenda */
    font-family: Roboto;
    font-style: normal;
    font-weight: 500;
    font-size: 22px;
    line-height: 26px;
    /* identical to box height */

    /* Gray 2 */
    color: #4f4f4f;
  }

  &__row--today {
    color: #2d9cdb;
  }

  &__cell--holiday {
    /* Rectangle 5 */
    background-color: #edf0f280;
    mix-blend-mode: normal;
  }
  &__cell--weekday {
    background-color: white;
  }
}

.bg {
  &__sato {
    background-color: #7b86c6;
  }
  &__suzuki {
    background-color: #5bb37e;
  }
  &__takahashi {
    background-color: #eec14b;
  }
  &__nakamura {
    background-color: #d98177;
  }
  &__tozawa {
    &-it {
      background-color: #5285ec;
    }
    &-pm {
      background-color: #e35d33;
    }
    &-sales {
      background-color: #377e49;
    }
  }
  &__kaneko {
    &-infra {
      background-color: #4252af;
    }
    &-sales {
      background-color: #e49735;
    }
  }
  &__sawada {
    &-sales {
      background-color: #4299df;
    }
    &-se {
      background-color: #c5291c;
    }
  }
}
</style>
