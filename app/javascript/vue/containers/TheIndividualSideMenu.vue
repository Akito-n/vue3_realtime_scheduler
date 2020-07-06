<template>
  <div>{{ result }}</div>
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
