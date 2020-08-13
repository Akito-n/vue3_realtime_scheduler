<template>
  <div v-if="!loading" class="flex justify-between items-start">
    <template v-if="result.currentUser.isIndividual">
      <div class="mt-56">
        <the-individual-month-calender />
      </div>
    </template>
    <template v-else>
      <the-company-month-calender />
    </template>
  </div>
</template>

<script lang="ts">
import {
  add,
  addDays,
  addMonths,
  format,
  startOfWeek,
  startOfMonth,
  parse,
  areIntervalsOverlapping
} from 'date-fns'
import jaLocale from 'date-fns/locale/ja'
import Vue from 'vue'
import { defineComponent, reactive, watch, ref } from '@vue/composition-api'
import {
  useCompanySchedulesSubscription,
  Schedule,
  useCurrentUserQuery
} from '@/graphql/types'
import ScheduleCreator from '@/vue/containers/ScheduleCreator.vue'
import { useCalendar } from '@/vue/composition-funcs/calendar'
import { routes } from 'vue/routes'
import { useSubscription } from '@vue/apollo-composable'
import TheCompanyMonthCalender from '../containers/TheCompanyMonthCalender.vue'
import TheIndividualMonthCalender from '../containers/TheIndividualMonthCalender.vue'

interface State {
  currentMonth: Date
  nextMonth: Date
  next: string
  last: string
  days: string[]
}

export default defineComponent({
  components: {
    ScheduleCreator,
    TheCompanyMonthCalender,
    TheIndividualMonthCalender
  },
  setup(_, context) {
    const { result, loading } = useCurrentUserQuery()

    return {
      loading,
      result
    }
  }
})
</script>
<style scoped lang="sass">
.calender{
  &__cell {
    height: 100px
  }
  &__schedule-font {
    &--month {
      font-size: 50%
    }
  }
  &__schedule-circle {
    height: 10px;
    width: 10px;
    border-radius: 50%;


    &--inline {
      display: inline-block
    }
  }
}
</style>
