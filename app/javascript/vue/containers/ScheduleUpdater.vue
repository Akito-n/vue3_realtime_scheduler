<template>
  <div>
    <modal :value="state.blankScheduleId" @input="close" title="選択した内容">
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
  EditBlankScheduleMutation,
  EditBlankScheduleDocument,
  EditBlankScheduleMutationVariables,
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
      blankScheduleId: null
    })
    const { mutate, loading, error, onDone } = useMutation<
      EditBlankScheduleMutation,
      EditBlankScheduleMutationVariables
    >(EditBlankScheduleDocument)

    const submit = (
      startAt: Date,
      endAt: Date,
      occupationId: string | null
    ) => {
      mutate({
        input: { blankScheduleId: state.blankScheduleId, startAt, endAt }
      })
    }

    const close = () => {
      context.root.$router.push({ query: null })
    }

    watch(
      () => context.root.$route.query,
      (query) => {
        state.blankScheduleId = query.edit_blank_schedule
      }
    )

    onDone(() => {
      context.root.$router.push({ query: null })
    })

    return { state, submit, loading, error, close, occupations }
  }
})
</script>

<style></style>
