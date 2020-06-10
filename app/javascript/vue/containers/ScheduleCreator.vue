<template>
  <div>
    <schedule-form @submit="submit" />
    <p v-if="error">{{ error.message }}</p>
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
      // .then((data) => {
      //   console.log('data', data)
      // })
      // .catch((e) => console.log(typeof e.message))
    }

    return { submit, error }
  }
})
</script>

<style></style>
