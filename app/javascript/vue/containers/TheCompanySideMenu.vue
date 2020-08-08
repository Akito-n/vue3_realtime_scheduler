<template>
  <div>
    <p v-if="loading"></p>
    <div v-else>
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

      <div class="mr-5">
        <p>応募者一覧</p>
        <table
          class="table-auto"
          v-if="result.companyTasks.recruitements.nodes"
        >
          <thead>
            <tr>
              <th class="px-4 py-2"></th>
              <th class="px-4 py-2">候補者指名</th>
              <th class="px-4 py-2">職種</th>
              <th class="px-4 py-2">次の選考に進める</th>
            </tr>
          </thead>
          <tbody>
            <tr
              v-for="recruitement in result.companyTasks.recruitements.nodes"
              :key="recruitement.id"
            >
              <td class="border px-4 py-2">
                <input
                  type="checkbox"
                  :value="recruitement.individualUser.id"
                  v-model="selected"
                  @change="change"
                />
              </td>
              <td class="border px-4 py-2">
                {{ recruitement.individualUser.name }}
              </td>
              <td class="border px-4 py-2">
                {{ recruitement.occupation.name }}
              </td>
              <td class="border px-4 py-2" v-if="recruitement.isFixed">
                <button
                  class="bg-transparent hover:bg-blue-500 text-blue-700 font-semibold hover:text-white py-2 px-4 border border-blue-500 hover:border-transparent rounded"
                  @click="proceed(recruitement.id)"
                >
                  {{ recruitement.stageCount + 1 }}次面接の調整を開始する
                </button>
              </td>
              <td class="border px-4 py-2" v-else>
                まだ面談予定が確定していません
              </td>
            </tr>
          </tbody>
        </table>
        <p>アクションを取っていない人一覧（双方未リクエストである）</p>
        <table
          class="table-auto"
          v-if="result.companyTasks.nonactiveRecruitements.nodes"
        >
          <thead>
            <tr>
              <th class="px-4 py-2">候補者指名</th>
              <th class="px-4 py-2">応募日</th>
              <th class="px-4 py-2">職種</th>
            </tr>
          </thead>
          <tbody>
            <tr
              v-for="nonActiveRecruitement in result.companyTasks
                .nonactiveRecruitements.nodes"
              :key="nonActiveRecruitement.id"
            >
              <td class="border px-4 py-2">
                {{ nonActiveRecruitement.individualUser.name }}
              </td>
              <td class="border px-4 py-2">
                {{ nonActiveRecruitement.createdAt | date('yyyy/MM/dd') }}
              </td>
              <td class="border px-4 py-2">
                {{ nonActiveRecruitement.occupation.name }}
              </td>
            </tr>
          </tbody>
        </table>
        <p v-else>まだありません</p>
        <p>リクエストを送ってきている個人一覧</p>
        <table
          class="table-auto"
          v-if="result.companyTasks.hasRespondSchedules.nodes.length != 0"
        >
          <thead>
            <tr>
              <th class="px-4 py-2">候補者指名</th>
              <th class="px-4 py-2">リクエスト日</th>
              <th class="px-4 py-2">職種</th>
            </tr>
          </thead>
          <tbody>
            <tr
              v-for="requestedSchedule in result.companyTasks
                .hasRespondSchedules.nodes"
              :key="requestedSchedule.id"
            >
              <td class="border px-4 py-2">
                {{ requestedSchedule.requester.name }}
              </td>
              <td class="border px-4 py-2">
                {{ requestedSchedule.startAt | date('yyyy/MM/dd') }}
              </td>
              <td class="border px-4 py-2">
                {{ requestedSchedule.occupation.name }}
              </td>
            </tr>
          </tbody>
        </table>
        <p v-else>まだありません</p>
        <p>対応が不要なもの（リクエスト送信済み）個人一覧</p>
        <table
          class="table-auto"
          v-if="result.companyTasks.waitingSchedules.nodes.length != 0"
        >
          <thead>
            <tr>
              <th class="px-4 py-2">候補者指名</th>
              <th class="px-4 py-2">面接希望日</th>
              <th class="px-4 py-2">職種</th>
            </tr>
          </thead>
          <tbody>
            <tr
              v-for="waitingSchedule in result.companyTasks.waitingSchedules
                .nodes"
              :key="waitingSchedule.id"
            >
              <td class="border px-4 py-2">
                {{ displayEntryUser(waitingSchedule) }}
              </td>
              <td class="border px-4 py-2">
                {{ waitingSchedule.startAt | date('yyyy/MM/dd') }}
              </td>
              <td class="border px-4 py-2">
                {{ waitingSchedule.occupation.name }}
              </td>
            </tr>
          </tbody>
        </table>
        <p v-else>まだありません</p>
        <p>確定した予定一覧</p>
        <table
          class="table-auto"
          v-if="result.companyTasks.confirmedScheduleTasks.nodes.length != 0"
        >
          <thead>
            <tr>
              <th class="px-4 py-2">候補者指名</th>
              <th class="px-4 py-2">面接日</th>
              <th class="px-4 py-2">職種</th>
            </tr>
          </thead>
          <tbody>
            <tr
              v-for="confirmedSchedule in result.companyTasks
                .confirmedScheduleTasks.nodes"
              :key="confirmedSchedule.id"
            >
              <td class="border px-4 py-2">
                {{ displayEntryUser(confirmedSchedule) }}
              </td>
              <td class="border px-4 py-2">
                {{ confirmedSchedule.startAt | date('yyyy/MM/dd') }}
              </td>
              <td class="border px-4 py-2">
                {{ confirmedSchedule.occupation.name }}
              </td>
            </tr>
          </tbody>
        </table>
        <p v-else>まだありません</p>
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
import { Recruitement } from 'graphql/types'
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
<style scoped></style>
