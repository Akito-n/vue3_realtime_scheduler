<template>
  <div>
    <p v-if="loading"></p>
    <div v-else>
      <div class="bg-white task__card--dayschedule mb-10 max-w-sm">
        <p class="task__card-title mb-4">本日の予定</p>
        <template v-if="state.todayConfirmedSchedules.length != 0">
          <div
            v-for="schedule in state.todayConfirmedSchedules"
            :key="schedule.id"
          >
            <div class="task__schedule--info ml-4 mb-4">
              <span
                class="task__schedule-circle task__schedule-circle--inline"
                :class="`bg-${schedule.occupation.color}-400`"
              ></span>
              <span class="task__schedule-time"
                >{{ schedule.startAt | date('HH:mm') }} ~
                {{ schedule.endAt | date('HH:mm') }}</span
              >
              <p class="task__schedule-name mt-2">
                {{ schedule | requestIndividualName() }}
              </p>
            </div>
          </div>
          <div class="shadow-md">
            <div class="tab w-full overflow-hidden border-t boader-b">
              <input
                class="absolute opacity-0"
                id="tab-single-one"
                type="checkbox"
                v-model="state.isCheckedDayAfterFlag"
              />
              <label
                class="block p-5 leading-normal cursor-pointer task__after-tomorrow-title"
                for="tab-single-one"
                >明日以降の予定をみる</label
              >
              <template v-if="state.afterTomollowSchedules.length != 0">
                <div
                  class="tab-content overflow-hidden border-l-2 border-indigo-500 leading-normal bg-white"
                >
                  <div
                    v-for="schedule in state.afterTomollowSchedules"
                    :key="schedule.id"
                  >
                    <p class="task__year-month-day ml-4">
                      {{ schedule.startAt | date('yyyy/MM/dd') }}
                    </p>
                    <div class="task__schedule--info ml-4 mb-4">
                      <span
                        class="task__schedule-circle task__schedule-circle--inline"
                        :class="`bg-${schedule.occupation.color}-400`"
                      ></span>
                      <span class="task__schedule-time"
                        >{{ schedule.startAt | date('HH:mm') }} ~
                        {{ schedule.endAt | date('HH:mm') }}</span
                      >
                      <p class="task__schedule-name mt-2">
                        {{ schedule | requestIndividualName() }}
                      </p>
                    </div>
                  </div>
                </div>
              </template>
              <div
                v-else
                class="tab-content overflow-hidden border-l-2 border-indigo-500 leading-normal bg-white justify-center"
              >
                <p class="task__no-schedule-comment m-4">
                  予定はありません
                </p>
              </div>
            </div>
          </div>
        </template>
        <div v-else>
          <p class="task__no-schedule-comment m-4 pb-4">
            本日の予定はありません
          </p>
        </div>
      </div>

      <slot name="occupation"></slot>

      <div class="bg-white task__card--requestbox mb-10 max-w-sm">
        <p class="task__card-title mb-4">未マッチング</p>
        <template
          v-if="result.companyTasks.nonactiveRecruitements.nodes.length > 0"
        >
          <div class="ml-5">
            <div
              class="pb-2"
              v-for="nonActiveRecruitement in result.companyTasks
                .nonactiveRecruitements.nodes"
              :key="nonActiveRecruitement.id"
            >
              <span
                class="task__schedule-circle task__schedule-circle--inline mr-2"
                :class="`bg-${nonActiveRecruitement.individualUser.color}-400`"
              ></span>
              <label class="task__custom-input--eye">
                <input
                  type="checkbox"
                  :value="nonActiveRecruitement.individualUser.id"
                  v-model="selected"
                  @change="change"
                />
                <span class="task__schedule-individual-username">{{
                  nonActiveRecruitement.individualUser.name
                }}</span>
              </label>
            </div>
          </div>
        </template>
        <p v-else class="task__no-schedule-comment m-4 pb-4">
          マッチングしていない候補者はいません
        </p>

        <p class="task__card-title mb-4">リクエスト中</p>
        <template v-if="result.companyTasks.waitingSchedules.nodes.length > 0">
          <div class="ml-2">
            <div
              class="pb-2"
              v-for="waitingSchedule in result.companyTasks.waitingSchedules
                .nodes"
              :key="waitingSchedule.id"
            >
              <span
                class="task__schedule-circle task__schedule-circle--inline mr-2"
                :class="`bg-${waitingSchedule.responder.color}-400`"
              ></span>
              <label class="task__custom-input--eye">
                <input
                  type="checkbox"
                  :value="waitingSchedule.responder.id"
                  v-model="selected"
                  @change="change"
                />
                <span class="task__schedule-individual-username"
                  >{{ waitingSchedule.responder.name }}/{{
                    waitingSchedule.occupation.name
                  }}</span
                >
              </label>
            </div>
          </div>
        </template>
        <p v-else class="task__no-schedule-comment m-4 pb-4">
          リクエストを送信していません
        </p>

        <p class="task__card-title mb-4">リクエスト受信</p>
        <template
          v-if="result.companyTasks.hasRespondSchedules.nodes.length > 0"
        >
          <div class="ml-2">
            <div
              class="pb-2"
              v-for="requestedSchedule in result.companyTasks
                .hasRespondSchedules.nodes"
              :key="requestedSchedule.id"
            >
              <span
                class="task__schedule-circle task__schedule-circle--inline mr-2"
                :class="`bg-${requestedSchedule.requester.color}-400`"
              ></span>
              <label class="task__custom-input--eye">
                <input
                  type="checkbox"
                  :value="requestedSchedule.requester.id"
                  v-model="selected"
                  @change="change"
                />
                <span class="task__schedule-individual-username"
                  >{{ requestedSchedule.requester.name }}/{{
                    requestedSchedule.occupation.name
                  }}</span
                >
              </label>
            </div>
          </div>
        </template>
        <p v-else class="task__no-schedule-comment m-4 pb-4">
          リクエストを受信していません
        </p>
      </div>

      <div class="shadow-md bg-white mb-20">
        <div class="tab w-full overflow-hidden border-t boader-b">
          <input
            class="absolute opacity-0"
            id="tab-recruitment"
            type="checkbox"
            v-model="state.isFullOpenRecruitment"
          />
          <label
            class="block p-5 leading-normal cursor-pointer task__after-tomorrow-title"
            for="tab-recruitment"
            >応募者一覧</label
          >
          <template v-if="result.companyTasks.recruitements.nodes.length != 0">
            <div
              class="tab-content overflow-hidden border-l-2 border-indigo-500 leading-normal bg-white"
            >
              <div
                v-for="recruitement in result.companyTasks.recruitements.nodes"
                :key="recruitement.id"
              >
                <div class="p-2">
                  <span
                    class="task__schedule-circle task__schedule-circle--inline mr-2"
                    :class="`bg-${recruitement.individualUser.color}-400`"
                  ></span>
                  <label class="task__custom-input--eye">
                    <input
                      type="checkbox"
                      :value="recruitement.individualUser.id"
                      v-model="selected"
                      @change="change"
                    />
                    <span class="task__schedule-individual-username"
                      >{{ recruitement.individualUser.name }}/{{
                        recruitement.occupation.name
                      }}</span
                    >
                  </label>
                  <span v-if="recruitement.isFixed">
                    <button
                      class="bg-transparent hover:bg-blue-500 text-blue-700 font-semibold hover:text-white py-2 px-2 border border-blue-500 hover:border-transparent rounded"
                      @click="proceed(recruitement.id)"
                    >
                      {{ recruitement.stageCount + 1 }}次通過
                    </button>
                  </span>
                </div>
              </div>
            </div>
          </template>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import {
  ref,
  defineComponent,
  watch,
  reactive,
  computed,
  PropType
} from '@vue/composition-api'
import { isToday } from 'date-fns'
import { useSubscription, useMutation } from '@vue/apollo-composable'
import { Recruitement, Occupation } from 'graphql/types'
import {
  useCompanyTasksSubscriptionSubscription,
  ProceedRecruitementDocument,
  ProceedRecruitementMutationVariables,
  ProceedRecruitementMutation,
  Schedule
} from '@/graphql/types'
export default defineComponent({
  props: {
    value: Array as PropType<string[]>
  },
  setup(props, context) {
    const { result, loading } = useCompanyTasksSubscriptionSubscription()

    const state = reactive({
      isFullOpenRecruitment: false,
      isCheckedDayAfterFlag: false,
      todayConfirmedSchedules: computed(() => {
        return result.value.companyTasks.confirmedScheduleTasks.nodes
          .filter((task) => {
            return isToday(new Date(task.startAt))
          })
          .sort((a, b) => {
            return new Date(a.startAt) > new Date(b.startAt) ? 1 : -1
          })
      }),
      afterTomollowSchedules: computed(() => {
        return result.value.companyTasks.confirmedScheduleTasks.nodes
          .filter((task) => {
            return !isToday(new Date(task.startAt))
          })
          .sort((a, b) => {
            return new Date(a.startAt) > new Date(b.startAt) ? 1 : -1
          })
      })
    })
    const selected = ref(props.value)
    const displayEntryUser = (schedule: Schedule) => {
      if (schedule.requester.__typename == 'Occupation') {
        return schedule.responder.name
      } else {
        return schedule.requester.name
      }
    }

    const { mutate } = useMutation<
      ProceedRecruitementMutation,
      ProceedRecruitementMutationVariables
    >(ProceedRecruitementDocument)

    const proceed = (recruitementId: string) => {
      mutate({ input: { recruitementId } })
    }

    const change = () => {
      context.emit('input', selected.value)
    }
    return {
      result,
      loading,
      displayEntryUser,
      proceed,
      selected,
      change,
      state
    }
  }
})
</script>
<style lang="scss" scoped>
.task {
  &__custom-input--eye input[type='checkbox'] {
    opacity: 0;
    -webkit-appearance: none;
    appearance: none;
    position: absolute;

    + span::after {
      background-image: url('/images/eye.svg');
      display: inline-block;
      content: '';
      margin-left: 3px;
      width: 14px;
      height: 14px;
    }
  }

  &__schedule-individual-username {
    font-family: Hiragino Sans;

    color: #babcbf;
  }

  &__custom-input--eye input[type='checkbox']:checked {
    opacity: 0;
    -webkit-appearance: none;
    appearance: none;
    position: absolute;

    + span {
      color: #3e3f40;
    }

    + span::after {
      background-image: url('/images/checked-eye.svg');
      display: inline-block;
      content: '';
      margin-left: 3px;
      width: 14px;
      height: 14px;
    }
  }
}
</style>
