<template>
  <div v-if="schedule">
    <template v-if="!state.isCancelled">
      <div v-if="state.scheduleId">
        <div
          class="fixed w-full h-full top-0 left-0 flex items-center justify-center z-50"
          style=""
        >
          <div
            class="absolute w-full h-full bg-gray-100 opacity-25"
            @click="close"
          ></div>
          <div
            class="bg-white w-11/12 md:max-w-md mx-auto rounded shadow-lg z-50 overflow-y-auto"
          >
            <div class="">
              <div
                class="flex justify-between items-center p-4 mb-4 modal__card"
              >
                <p class="modal__card-title text-base">
                  {{
                    requesterName(schedule) + 'さんからのリクエストがあります。'
                  }}
                </p>
                <div class="cursor-pointer z-50" @click="close">
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    width="18"
                    height="18"
                    viewBox="0 0 18 18"
                    class="fill-current text-black"
                  >
                    <path
                      d="M14.53 4.53l-1.06-1.06L9 7.94 4.53 3.47 3.47 4.53 7.94 9l-4.47 4.47 1.06 1.06L9 10.06l4.47 4.47 1.06-1.06L10.06 9z"
                    ></path>
                  </svg>
                </div>
              </div>
              <div class="modal__card-body ml-4">
                <div class="modal__content flex items-stretch p-4">
                  <div class="modal__content-heading pr-6">候補者</div>
                  <div class="modal_content-context pl-6">
                    {{ schedule | requestIndividualName() }}
                  </div>
                </div>
                <div class="modal__content flex items-stretch p-4">
                  <span class="modal__content-heading pr-6">日時</span
                  ><span class="modal_content-context pl-6"
                    >{{ schedule.startAt | date('yyyy/MM/dd HH:mm') }} ~
                    {{ schedule.endAt | date('HH:mm') }}</span
                  >
                </div>
                <div
                  class="modal__content flex items-stretch p-4"
                  v-if="schedule.occupation"
                >
                  <span class="modal__content-heading pr-6">ポジション</span
                  ><span class="modal_content-context pl-6">{{
                    schedule.occupation.name
                  }}</span>
                </div>
                <div
                  class="modal__content flex items-stretch p-4"
                  v-if="schedule.occupation"
                >
                  <span class="modal__content-heading pr-6">面接場所</span
                  ><span class="modal_content-context pl-6">{{
                    schedule.occupation.address
                  }}</span>
                </div>
                <div
                  class="modal__content flex items-stretch p-4"
                  v-if="schedule.occupation"
                >
                  <span class="modal__content-heading pr-6">持ち物</span
                  ><span class="modal_content-context pl-6">{{
                    schedule.occupation.item
                  }}</span>
                </div>
                <div
                  class="modal__content flex items-stretch p-4"
                  v-if="schedule.occupation"
                >
                  <span class="modal__content-heading pr-6">担当者</span
                  ><span class="modal_content-context pl-6">{{
                    schedule.occupation.applyFrom
                  }}</span>
                </div>
              </div>
              <div class="flex justify-around pt-2 pb-2">
                <button
                  class="px-4 bg-transparent p-3 rounded-md text-gray-400 bg-white boader-gray mr-2"
                  @click="state.confirming = true"
                >
                  非承認
                </button>
                <button
                  class="px-4 bg-transparent p-3 rounded-md text-white bg-black mr-2"
                  @click="submit(schedule.id)"
                >
                  リクエストを承認する
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </template>

    <confirm-dialog v-model="state.confirming" @ok="cancel(schedule.id)" />
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
  Schedule,
  RespondScheduleMutationVariables,
  RespondScheduleDocument,
  RespondScheduleMutation,
  useScheduleQuery,
  useCurrentUserQuery
} from '@/graphql/types'
import Modal from '@/vue/components/Modal.vue'
import ConfirmDialog from '@/vue/components/ConfirmDialog.vue'

const initialState = {
  isCancelled: false,
  confirming: false,
  scheduleId: null
}

export default defineComponent({
  components: { ConfirmDialog, Modal },
  props: {},
  setup(props, context) {
    const state = reactive({ ...initialState })

    const scheduleRef = useScheduleQuery(() => ({
      scheduleId: state.scheduleId
    }))
    const schedule = useResult(scheduleRef.result, {}, (data) => data.schedule)
    const { mutate, loading, error, onDone } = useMutation<
      RespondScheduleMutation,
      RespondScheduleMutationVariables
    >(RespondScheduleDocument)

    const currentUserRef = useCurrentUserQuery()
    const currentUser = useResult(
      currentUserRef.result,
      {},
      (data) => data.currentUser
    )

    const submit = (scheduleId: string) => {
      mutate({ input: { scheduleId: scheduleId } })
    }

    const cancel = (scheduleId: string) => {
      state.isCancelled = true
      mutate({ input: { scheduleId: scheduleId, isAccept: false } })
    }

    const close = () => {
      context.root.$router.push({ query: null })
    }

    const requesterName = (schedule: Schedule) => {
      if (!schedule.isRequest) return ''

      if (schedule.requester.__typename == 'Member') {
        return schedule.requester.name
      } else {
        return schedule.requester.companyName
      }
    }

    onDone(() => {
      if (state.isCancelled) {
        return
      }
      close()
    })

    watch(
      () => context.root.$route.query,
      (query) => {
        state.scheduleId = query.requested_schedule_id
      }
    )

    return {
      currentUser,
      submit,
      cancel,
      state,
      schedule,
      close,
      requesterName
    }
  }
})
</script>

<style></style>
