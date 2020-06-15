<template>
  <div>
    <schedule-form
      @submit="submit"
      @open="open"
      @close="close"
      :opened="state.opened"
    />
    <template v-if="error">
      <template v-for="(errorMessage, i) in error.graphQLErrors">
        <p :key="i">{{ errorMessage.message }}</p>
      </template>
    </template>
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
import content from '*.gql'
import { routes } from 'vue/routes'

export default defineComponent({
  components: { ScheduleForm },
  setup(_, context) {
    const state = reactive({
      opened: false
    })
    const { mutate, loading, error, onDone } = useMutation<
      AddBlankScheduleMutation,
      AddBlankScheduleMutationVariables
    >(AddBlankScheduleDocument)

    const submit = (startAt: Date, endAt: Date) => {
      mutate({ input: { startAt, endAt } })
      context.root.$router.push({ query: null })
      state.opened = false
    }

    const open = () => {
      context.root.$router.push({ query: { status: 'open' } })
      state.opened = true
    }

    const close = () => {
      context.root.$router.push({ query: null })
      state.opened = false
    }

    console.log(error)

    return { state, submit, error, open, close }
  }
})
</script>

<style></style>
