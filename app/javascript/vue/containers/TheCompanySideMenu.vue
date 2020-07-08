<template>
  <div>
    <p v-if="loading">loading</p>
    <div v-else>
      <p>load終わり</p>
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

export default defineComponent({
  setup(props, context) {
    const { result, loading } = useCompanyTasksSubscriptionSubscription()

    return { result, loading }
  }
})
</script>
<style scoped></style>
