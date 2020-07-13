<template>
  <div v-if="!loading" class="flex justify-between items-start">
    <occupation-selctor v-model="selectedOccupationIds" />
    <the-individual-side-menu
      v-if="result.currentUser.isIndividual"
      class="mr-20"
    />
    <the-week-calendar :occupationIds="selectedOccupationIds" />
    <the-company-side-menu v-if="result.currentUser.isCompany" class="ml-20" />
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
  computed
} from '@vue/composition-api'
import { useCurrentUserQuery } from '@/graphql/types'
import { routes } from 'vue/routes'
import TheWeekCalendar from '@/vue/containers/TheWeekCalendar.vue'
import TheIndividualSideMenu from '@/vue/containers/TheIndividualSideMenu.vue'
import OccupationSelctor from '@/vue/containers/OccupationSelctor.vue'
import TheCompanySideMenu from '@/vue/containers/TheCompanySideMenu.vue'

export default defineComponent({
  components: {
    TheWeekCalendar,
    TheIndividualSideMenu,
    OccupationSelctor,
    TheCompanySideMenu
  },
  setup(props, context) {
    const selectedOccupationIds = ref([])
    const { result, loading } = useCurrentUserQuery()

    return { result, loading, selectedOccupationIds }
  }
})
</script>
<style scoped></style>
