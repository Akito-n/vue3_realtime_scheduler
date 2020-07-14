<template>
  <div>
    <p v-if="loading"></p>
    <div v-else>
      <div class="mr-5">
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
              v-for="recruitement in result.companyTasks.nonactiveRecruitements
                .nodes"
              :key="recruitement.id"
            >
              <td class="border px-4 py-2">
                {{ recruitement.individualUser.name }}
              </td>
              <td class="border px-4 py-2">
                {{ recruitement.createdAt | date('yyyy/MM/dd') }}
              </td>
              <td class="border px-4 py-2">
                {{ recruitement.occupation.name }}
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
  computed
} from '@vue/composition-api'
import { useSubscription } from '@vue/apollo-composable'
import {
  useCompanyTasksSubscriptionSubscription,
  Schedule
} from '@/graphql/types'
export default defineComponent({
  setup(props, context) {
    const { result, loading } = useCompanyTasksSubscriptionSubscription()
    const displayEntryUser = (schedule: Schedule) => {
      if (schedule.requester.__typename == 'Occupation') {
        return schedule.responder.name
      } else {
        return schedule.requester.name
      }
    }
    return { result, loading, displayEntryUser }
  }
})
</script>
<style scoped></style>
