<template>
  <!-- <div v-if="blankSchedule" class="flex row justify-start">
    {{ blankSchedule.user.name }}
  </div> -->
  <div>aaa</div>
</template>

<script lang="ts">
import Vue from 'vue'
import { defineComponent, reactive, computed } from '@vue/composition-api'
import { useMutation } from '@vue/apollo-composable'
import { BlankSchedule } from '@/graphql/types'

type Props = {
  blankSchedule?: BlankSchedule | null
}

export default defineComponent<Props>({
  components: {},
  props: {
    blankSchedule: Object
  },
  setup(props, context) {
    console.log(props.blankSchedule)
    // return { blansSchedule: props.blankSchedule }
    return {}
  }
})
</script>

<style></style>
