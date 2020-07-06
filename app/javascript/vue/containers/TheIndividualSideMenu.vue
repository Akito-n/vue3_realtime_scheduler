<template>
  <div>
    <p>自分の空き予定を入力する</p>
    <div
      v-for="occupation in result.individualTasks.blankScheduleTasks.nodes"
      :key="occupation.id"
    >
      {{ occupation.companyName }}: {{ occupation.name }}
    </div>
    <p>確定した面接一覧 A株式会社　〇/〇(曜日)開始時間～終了時間</p>
    <div
      v-for="confirmedScheduleTasks in result.individualTasks
        .confirmedScheduleTasks.nodes"
      :key="confirmedScheduleTasks.id"
    >
      {{ confirmedScheduleTasks.requester.companyName }}:
      {{ confirmedScheduleTasks.startAt | date('MM/dd(E)') }}
      {{ confirmedScheduleTasks }}
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
