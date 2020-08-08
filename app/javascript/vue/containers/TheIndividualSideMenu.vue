<template>
  <div v-if="!loading">
    <div class="bg-white task__card--dayschedule mb-20 max-w-sm">
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
              {{ schedule.occupation.companyName }}
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
                      {{ schedule.occupation.companyName }}
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
        <p class="task__no-schedule-comment m-4 pb-4">本日の予定はありません</p>
      </div>
    </div>

    <div class="bg-white task__card--requestbox mb-20 max-w-sm">
      <p class="task__card-title mb-4">リクエストボックス</p>
      <template v-if="currentUser.companyUsers.nodes.length > 0">
        <div
          v-for="company in currentUser.companyUsers.nodes"
          :key="company.id"
        >
          <div class="ml-5">
            <p class="task__schedule-name mb-2">{{ company.companyName }}</p>
            <div
              class="pb-2"
              v-for="schedule in requestSchedulesGroupingByCompany(
                result.individualTasks.respondingTasks.nodes,
                company.companyName
              )"
              :key="schedule.id"
            >
              <span
                class="task__schedule-circle task__schedule-circle--inline"
                :class="`bg-${schedule.occupation.color}-400`"
              ></span>
              <span>{{ schedule.occupation.name }}</span>
              <button
                @click="select(schedule.id)"
                class="bg-gray-700 hover:bg-gray-900 text-white font-bold ml-2 py-1 px-1 rounded-full"
              >
                <img src="/images/mail.svg" class="w-4 h-4" />
              </button>
            </div>
          </div>
        </div>
      </template>
    </div>
  </div>
</template>

<script lang="ts">
import {
  ref,
  defineComponent,
  watch,
  reactive,
  computed
} from '@vue/composition-api'
import { isToday } from 'date-fns'
import { useSubscription, useResult } from '@vue/apollo-composable'
import {
  useIndividualTasksSubscriptionSubscription,
  Schedule
} from '@/graphql/types'
import {
  useAddBlankScheduleMutation,
  Occupation,
  useCurrentUserQuery
} from 'graphql/types'
import { PropType } from '@vue/composition-api'

export default defineComponent({
  components: {},
  setup(props, context) {
    const { result, loading } = useIndividualTasksSubscriptionSubscription()

    const currentUserQuery = useCurrentUserQuery()
    const currentUser = useResult(
      currentUserQuery.result,
      null,
      (data) => data.currentUser
    )

    const state = reactive({
      isCheckedDayAfterFlag: false,
      todayConfirmedSchedules: computed(() => {
        return result.value.individualTasks.confirmedScheduleTasks.nodes
          .filter((task) => {
            return isToday(new Date(task.startAt))
          })
          .sort((a, b) => {
            return new Date(a.startAt) > new Date(b.startAt) ? 1 : -1
          })
      }),
      afterTomollowSchedules: computed(() => {
        return result.value.individualTasks.confirmedScheduleTasks.nodes
          .filter((task) => {
            return !isToday(new Date(task.startAt))
          })
          .sort((a, b) => {
            return new Date(a.startAt) > new Date(b.startAt) ? 1 : -1
          })
      })
    })

    const requestSchedulesGroupingByCompany = (
      schedules: [Schedule],
      companyName: String
    ): Schedule[] => {
      return schedules.filter((schedule: Schedule) => {
        return (
          schedule.isRequest &&
          !schedule.mine &&
          schedule.status != '確定済み' &&
          schedule.requester.companyName == companyName
        )
      })
    }
    const select = (scheduleId: string) => {
      context.root.$router.push({
        query: { requested_schedule_id: scheduleId }
      })
    }
    return {
      state,
      result,
      requestSchedulesGroupingByCompany,
      loading,
      select,
      currentUser
    }
  }
})
</script>
<style lang="scss">
.task {
  &__card-title {
    font-family: Hiragino Sans;
    font-style: normal;
    font-weight: bold;
    font-size: 16px;
    line-height: 24px;
    margin-top: 1.5rem;
    margin-left: 1rem;

    display: flex;
    align-items: flex-end;
    letter-spacing: -0.293333px;

    color: #babcbf;
  }

  &__card--dayschedule {
    border-top: 3px solid #2d9cdb;
  }

  &__card--requestbox {
    border-top: 3px solid #3e3f40;
  }

  &__schedule-circle {
    height: 12px;
    width: 12px;
    border-radius: 50%;

    &--inline {
      display: inline-block;
    }
  }
  &__schedule-time {
    font-family: Roboto;
    font-style: normal;
    font-weight: normal;
    font-size: 14px;
    line-height: 14px;
    letter-spacing: -0.22px;

    color: #888a8c;

    mix-blend-mode: normal;
    opacity: 0.5;
  }
  &__schedule-name {
    font-family: Hiragino Sans;
    font-style: normal;
    font-weight: 600;
    line-height: 18px;
    /* identical to box height */

    display: flex;
    align-items: flex-end;
    letter-spacing: -0.256667px;

    color: #3e3f40;
  }
  &__after-tomorrow-title {
    font-family: Hiragino Sans;

    color: #babcbf;

    &::after {
      margin-left: 0.5rem;
      color: #3e3f40;
      margin-top: -6px;
    }
  }
  &__year-month-day {
    font-family: Roboto;
    font-style: normal;
    font-size: 12px;
    font-weight: bold;
    line-height: 14px;
    color: #888a8c;
    /* identical to box height */

    display: flex;
    align-items: flex-end;
    letter-spacing: -0.256667px;
  }
  &__no-schedule-comment {
    font-family: Hiragino Sans;
    color: #babcbf;
  }
}

/* Tab content - closed */
.tab-content {
  max-height: 0;
  -webkit-transition: max-height 0.35s;
  -o-transition: max-height 0.35s;
  transition: max-height 0.35s;
}
/* :checked - resize to full height */
.tab input:checked ~ .tab-content {
  max-height: 100vh;
}
/* Label formatting when open */
.tab input:checked + label {
  font-family: Hiragino Sans;

  color: #babcbf;
}
/* Icon */
.tab label::after {
  float: right;
  right: 0;
  top: 0;
  display: block;
  width: 1.5em;
  height: 1.5em;
  line-height: 1.5;
  font-size: 1.25rem;
  text-align: center;
  -webkit-transition: all 0.35s;
  -o-transition: all 0.35s;
  transition: all 0.35s;
}
/* Icon formatting - closed */
.tab input[type='checkbox'] + label::after {
  content: '\25BE';
  font-weight: bold; /*.font-bold*/
  border-width: 1px; /*.border*/
  line-height: 25px;
  border-radius: 9999px; /*.rounded-full */
  border-color: #b8c2cc; /*.border-grey*/
}
.tab input[type='radio'] + label::after {
  content: '\25BE';
  font-weight: bold; /*.font-bold*/
  border-width: 1px; /*.border*/
  border-radius: 9999px; /*.rounded-full */
  border-color: #b8c2cc; /*.border-grey*/
}
/* Icon formatting - open */
.tab input[type='checkbox']:checked + label::after {
  transform: rotate(180deg);
  line-height: 25px;
  background-color: #6574cd; /*.bg-indigo*/
  color: #f8fafc; /*.text-grey-lightest*/
  margin-top: -5px;
}
</style>
