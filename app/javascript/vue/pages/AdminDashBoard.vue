<template>
  <div>
    <div class="flex md:flex-row-reverse flex-wrap">
      <!--Main Content-->
    </div>
  </div>
</template>

<script lang="ts">
import Vue from 'vue'
import { defineComponent } from '@vue/composition-api'
import { useResult } from '@vue/apollo-composable'
import { useCurrentUserQuery } from '@/graphql/types'

export default defineComponent({
  setup() {
    // TODO: mutatioin example
    return {}
  }
})
</script>

<style scoped></style>
