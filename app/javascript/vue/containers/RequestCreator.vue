<template>
  <div class="flex row justify-start">
    <!-- <div v-for="(blankSchedule, i) in blankSchedules" :key="i">
      {{ blankSchedule.id }}
    </div> -->
    <div
      v-for="(blankSchedule, i) in blankSchedules"
      :key="i"
      class="schedule-cell--blank min-h-full flex-grow"
      :class="`bg-${blankSchedule.user.color}-200`"
    >
      &nbsp;
    </div>
  </div>
</template>

<script lang="ts">
import Vue from 'vue'
import { defineComponent, reactive, computed } from '@vue/composition-api'
import { useMutation } from '@vue/apollo-composable'
import { BlankSchedule } from '@/graphql/types'

type Props = {
  blankSchedules: BlankSchedule[]
}

export default defineComponent<Props>({
  components: {},
  props: {
    blankSchedules: Array
  },
  setup(props, context) {
    console.log(props.blankSchedules)
    return { blansSchedules: props.blankSchedules }
  }
})
</script>

<style></style>
