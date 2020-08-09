<template>
  <div class="h-0">
    <modal :value="state.opened" @input="close" class="sssssss">
      <schedule-form
        :disabled="loading"
        :ocupations="occupations"
        @submit="submit"
      />
      <template v-if="error">
        <template v-for="(errorMessage, i) in error.graphQLErrors">
          <p :key="i">{{ errorMessage.message }}</p>
        </template>
      </template>
    </modal>
    <button
      class="bg-gray-800 hover:bg-gray-700 text-white font-light py-2 px-4 rounded-full -m-10"
      @click="open"
    >
      <font-awesome-icon icon="calendar-plus" />
    </button>
  </div>
</template>

<script lang="ts">
import Vue from 'vue'
import {
  defineComponent,
  reactive,
  computed,
  watch
} from '@vue/composition-api'
import { useMutation, useResult } from '@vue/apollo-composable'
import {
  AddBlankScheduleMutation,
  AddBlankScheduleDocument,
  AddBlankScheduleMutationVariables,
  useCurrentUserQuery
} from '@/graphql/types'
import ScheduleForm from '@/vue/components/ScheduleForm.vue'
import content from '*.gql'
import { routes } from 'vue/routes'
import Modal from '@/vue/components/Modal.vue'

export default defineComponent({
  components: { Modal, ScheduleForm },
  setup(_, context) {
    const { result } = useCurrentUserQuery()
    const occupations = useResult(
      result,
      [],
      (data) => data.currentUser.occupations.nodes
    )

    const state = reactive({
      opened: false
    })
    const { mutate, loading, error, onDone } = useMutation<
      AddBlankScheduleMutation,
      AddBlankScheduleMutationVariables
    >(AddBlankScheduleDocument)

    const submit = (
      startAt: Date,
      endAt: Date,
      occupationId: string | null
    ) => {
      mutate({ input: { startAt, endAt, occupationId } })
    }

    const open = () => {
      context.root.$router.push({ query: { new_blank_schedule: 'open' } })
    }

    const close = () => {
      context.root.$router.push({ query: null })
    }

    watch(
      () => context.root.$route.query,
      (query) => {
        state.opened = query.new_blank_schedule === 'open'
      }
    )

    onDone(() => {
      context.root.$router.push({ query: null })
    })

    return { state, submit, loading, error, open, close, occupations }
  }
})
</script>

<style lang="scss" scoped></style>
