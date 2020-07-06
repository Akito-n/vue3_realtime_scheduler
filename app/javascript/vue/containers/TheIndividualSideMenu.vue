<template>
  <div>
    <p>自分の空き予定を入力する</p>
    <div
      v-for="occupation in result.individualTasks.blankScheduleTasks.nodes"
      :key="occupation.id"
    >
      {{ occupation.companyName }}: {{ occupation.name }}
    </div>
    <p>面接日を調整する</p>
    <div
      v-for="respondingTask in result.individualTasks.respondingTasks.nodes"
      :key="respondingTask.id"
    >
      {{ respondingTask.occupation.companyName }}:
      {{ respondingTask.occupation.name }}
      {{ respondingTask.startAt | date('MM/dd(E)HH:mm') }}~
      {{ respondingTask.endAt | date('HH:mm') }}
    </div>
    <p>確定した面接一覧</p>
    <div
      v-for="confirmedScheduleTasks in result.individualTasks
        .confirmedScheduleTasks.nodes"
      :key="confirmedScheduleTasks.id"
    >
      {{ confirmedScheduleTasks.occupation.companyName }}:
      {{ confirmedScheduleTasks.startAt | date('MM/dd(E)HH:mm') }}~
      {{ confirmedScheduleTasks.endAt | date('HH:mm') }}
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
import { useIndividualTasksSubscriptionSubscription } from '@/graphql/types'
import { useAddBlankScheduleMutation } from 'graphql/types'

export default defineComponent({
  components: {},
  setup(props, context) {
    const { result, loading } = useIndividualTasksSubscriptionSubscription()
    console.log(result?.value?.individualTasks)

    return { result, loading }
  }
})
</script>
<style scoped></style>
