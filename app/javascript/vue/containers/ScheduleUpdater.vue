<template>
  <div v-if="blankSchedule">
    <modal :value="!!state.blankScheduleId" @input="close" title="予定の編集">
      <schedule-form
        :disabled="loading"
        :ocupations="[]"
        :defaultStartAt="blankSchedule.startAt"
        :defaultEndAt="blankSchedule.endAt"
        :defaultOccupationId="
          isCompany && blankSchedule.requester
            ? blankSchedule.requester.id
            : null
        "
        @submit="submit"
      >
        <template v-slot:delete>
          <button
            class="bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 ml-5"
            @click="destroySchedule"
          >
            削除する
          </button>
        </template>
      </schedule-form>
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
  DestroyBlankScheduleMutation,
  DestroyBlankScheduleDocument,
  DestroyBlankScheduleMutationVariables,
  useCurrentUserQuery,
  useBlankScheduleQuery
} from '@/graphql/types'
import ScheduleForm from '@/vue/components/ScheduleForm.vue'
import content from '*.gql'
import { routes } from 'vue/routes'
import Modal from '@/vue/components/Modal.vue'

export default defineComponent({
  components: { Modal, ScheduleForm },
  setup(_, context) {
    const currentUserRef = useCurrentUserQuery()
    const isCompany = useResult(
      currentUserRef.result,
      false,
      (data) => data.currentUser.isCompany
    )

    const state = reactive({
      blankScheduleId: null
    })

    const blankScheduleRef = useBlankScheduleQuery(() => ({
      blankScheduleId: state.blankScheduleId
    }))
    const blankSchedule = useResult(
      blankScheduleRef.result,
      {},
      (data) => data.blankSchedule
    )

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
        input: {
          blankScheduleId: state.blankScheduleId,
          startAt,
          endAt,
          occupationId
        }
      })
    }

    const destroyMutate = useMutation<
      DestroyBlankScheduleMutation,
      DestroyBlankScheduleMutationVariables
    >(DestroyBlankScheduleDocument)

    const destroySchedule = () => {
      destroyMutate.mutate({
        input: { blankScheduleId: state.blankScheduleId }
      })
      context.root.$router.push({ query: null })
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

    return {
      state,
      submit,
      loading,
      error,
      close,
      blankSchedule,
      blankScheduleRef,
      destroySchedule,
      isCompany
    }
  }
})
</script>

<style></style>
