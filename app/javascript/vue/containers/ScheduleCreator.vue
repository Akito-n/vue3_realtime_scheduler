<template>
  <div>
    <schedule-form @submit="submit" />
    クリエイター
  </div>
</template>

<script lang="ts">
import Vue from 'vue'
import { defineComponent, reactive, computed } from '@vue/composition-api'
import { useMutation } from '@vue/apollo-composable'
import {
  AddBlankScheduleMutation,
  AddBlankScheduleDocument,
  AddBlankScheduleMutationVariables
} from '@/graphql/types'
import ScheduleForm from '@/vue/components/ScheduleForm.vue'

export default defineComponent({
  components: { ScheduleForm },
  setup() {
    const { mutate, loading, error, onDone } = useMutation<
      AddBlankScheduleMutation,
      AddBlankScheduleMutationVariables
    >(AddBlankScheduleDocument)

    const submit = (startAt: Date, endAt: Date) => {
      mutate({ input: { startAt, endAt } })
    }

    return { submit }
  }
})
</script>

<style></style>
