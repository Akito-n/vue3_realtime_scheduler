<template>
  <div v-if="!loading" class="flex justify-between items-start">
    <template v-if="result.currentUser.isIndividual">
      <the-individual-week-calendar />
      <the-individual-side-menu class="mr-20" />
    </template>
    <template v-else>
      <occupation-selctor v-model="selectedOccupationIds" />
      <the-company-week-calendar :occupationIds="selectedOccupationIds" />
      <the-company-side-menu
        v-if="result.currentUser.isCompany"
        class="ml-20"
      />
    </template>
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
import TheIndividualWeekCalendar from '@/vue/containers/TheIndividualWeekCalendar.vue'
import TheCompanyWeekCalendar from '@/vue/containers/TheCompanyWeekCalendar.vue'
import TheIndividualSideMenu from '@/vue/containers/TheIndividualSideMenu.vue'
import OccupationSelctor from '@/vue/containers/OccupationSelctor.vue'
import TheCompanySideMenu from '@/vue/containers/TheCompanySideMenu.vue'

export default defineComponent({
  components: {
    TheIndividualWeekCalendar,
    TheCompanyWeekCalendar,
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
