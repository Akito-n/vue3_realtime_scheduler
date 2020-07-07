<template>
  <div>
    <p v-if="loading">sssss</p>
    <div v-else>
      {{ result }}
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
import { useCompanyTasksSubscriptionSubscription } from '@/graphql/types'
import { useAddBlankScheduleMutation } from 'graphql/types'

export default defineComponent({
  components: {},
  setup(props, context) {
    const { result, loading } = useCompanyTasksSubscriptionSubscription()

    const select = (scheduleId: string) => {
      context.root.$router.push({
        query: { requested_schedule_id: scheduleId }
      })
    }
    return { result, loading, select }
  }
})
</script>
<style scoped></style>
