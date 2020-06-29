<template>
  <div>
    <modal :value="state.opened" @input="close" title="選択した内容">
      <schedule-form :disabled="loading" @submit="submit" />
      <template v-if="error">
        <template v-for="(errorMessage, i) in error.graphQLErrors">
          <p :key="i">{{ errorMessage.message }}</p>
        </template>
      </template>
    </modal>
    <button
      class="bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-4 rounded-full"
      @click="open"
    >
      <font-awesome-icon icon="plus" />
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
import { useMutation } from '@vue/apollo-composable'
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

    const state = reactive({
      opened: false
    })
    const { mutate, loading, error, onDone } = useMutation<
      AddBlankScheduleMutation,
      AddBlankScheduleMutationVariables
    >(AddBlankScheduleDocument)

    const submit = (startAt: Date, endAt: Date) => {
      mutate({ input: { startAt, endAt } })
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

    onDone((result) => {
      context.root.$router.push({ query: null })
    })

    return { state, submit, loading, error, open, close }
  }
})
</script>

<style></style>
