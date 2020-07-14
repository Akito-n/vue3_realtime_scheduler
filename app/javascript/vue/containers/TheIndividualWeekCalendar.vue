<template>
  <div class="flex justify-center items-end">
    <div v-if="!loading">
      <div class="flex flex-col">
        <div
          v-for="(time, t) in times"
          :key="`time-${t}`"
          class="w-3 h-10 flex justify-end items-end border-b-2"
        >
          <span class="-mb-2 mr-4 whitespace-no-wrap">{{ time }}時</span>
        </div>
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
      <schedule-creator />
      <schedule-updater />
      <div class="flex row justify-center items-center">
        <div
          v-for="(day, i) in state.days"
          :key="i"
          class="w-40 h-10 text-center"
        >
          {{ format(day, 'dd(E)', { locale: jaLocale }) }}
        </div>
      </div>
      <div v-if="loading">
        <div class="mt-20">
          <vue-loading
            type="spiningDubbles"
            color="#40e0d0"
            :size="{ width: '300px', height: '300px' }"
          />
        </div>
      </div>
      <div v-else-if="result" class="flex row justify-center items-center">
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
                  v-for="(blankSchedule, i) in getBlankSchedules(
                    day,
                    hour,
                    minute
                  )"
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
    <request-to-individual-creator
      v-if="currentUserQuery.result.value.currentUser.isCompany"
      v-model="state.isRequested"
      :blankSchedule.sync="state.selectedSchedule"
      :startAt="state.selectedStartAt"
      :endAt="state.selectedEndAt"
    />
    <request-to-occupation-creator
      v-else
      v-model="state.isRequested"
      :blankSchedule.sync="state.selectedSchedule"
      :startAt="state.selectedStartAt"
      :endAt="state.selectedEndAt"
    />
    <request-accepter v-model="state.selectedRequestedSchedule" />
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
import {
  Schedule,
  useIndividualSchedulesSubscription,
  useCompanySchedulesSubscription,
  useCurrentUserQuery
} from '@/graphql/types'
import { routes } from 'vue/routes'
import ScheduleCreator from '@/vue/containers/ScheduleCreator.vue'
import ScheduleUpdater from '@/vue/containers/ScheduleUpdater.vue'
import { useCalendar } from '@/vue/composition-funcs/calendar'
import RequestToIndividualCreator from '@/vue/containers/RequestToIndividualCreator.vue'
import RequestToOccupationCreator from '@/vue/containers/RequestToOccupationCreator.vue'
import RequestAccepter from '@/vue/containers/RequestAccepter.vue'
import { useSubscription } from '@vue/apollo-composable'

export default defineComponent({
  props: {
    occupationIds: {
      type: Array as PropType<any[]>,
      required: false
    }
  },
  components: {
    ScheduleCreator,
    ScheduleUpdater,
    RequestToIndividualCreator,
    RequestToOccupationCreator,
    RequestAccepter
  },
  setup(props, context) {
    const currentUserQuery = useCurrentUserQuery()
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

    const companySchedules = useCompanySchedulesSubscription(() => {
      return {
        occupationIds: props.occupationIds
      }
    })
    const individualSchedules = useIndividualSchedulesSubscription()

    const schedules = ref([])

    const getBlankSchedules = (day, hours, minutes) => {
      let criteriaTime = addHours(day, hours)
      criteriaTime = addMinutes(criteriaTime, minutes)

      return result.value.schedules.schedules.nodes.filter((schedule) => {
        return areIntervalsOverlapping(
          {
            start: new Date(schedule.startAt),
            end: new Date(schedule.endAt)
          },
          { start: criteriaTime, end: addMinutes(criteriaTime, 30) }
        )
      })
    }

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
      () => context.root.$route,
      (r) => {
        const { year, month, day } = r.params
        load(year, month, day)
      }
    )

    watch(
      () => props.occupationIds,
      (newIds) => {
        console.log(newIds)
        restart()
      }
    )

    const select = (
      blankSchedule: Schedule,
      dateString: string,
      hour: number,
      minute: number
    ) => {
      const date = parse(
        `${dateString} ${hour}:${minute}`,
        'yyyy-MM-dd HH:mm',
        new Date()
      )
      state.selectedStartAt = date
      state.selectedEndAt = addMinutes(date, 30)
      if (!blankSchedule) {
        state.isRequested = true
        return
      }
      //自分のリクエストだった場合、編集モーダルを出す
      if (blankSchedule.mine) {
        context.root.$router.push({
          query: { edit_blank_schedule: blankSchedule.id }
        })
        return
      }
      //非承認か確定ずみの場合は
      if (
        blankSchedule.status == '非承認' ||
        blankSchedule.status == '確定済み'
      )
        return

      //予定がリクエストだった場合、アクセプターを出す
      if (blankSchedule.isRequest) {
        context.root.$router.push({
          query: { requested_schedule_id: blankSchedule.id }
        })
        return
        //相手の空き予定の場合は選択したblankScheduleをstateに入れてリクエストモーダルを出す
      } else {
        state.isRequested = true
        state.selectedSchedule = blankSchedule
      }
    }

    return {
      times,
      state,
      loading,
      result,
      schedules,
      getBlankSchedules,
      format,
      jaLocale,
      select,
      currentUserQuery
    }
  }
})
</script>
<style scoped></style>
