<template>
  <div>
    <div class="flex md:flex-row-reverse flex-wrap">
      <!--Main Content-->
      <div class="w-full md:w-4/5 bg-gray-100">
        <div class="container bg-gray-100 pt-16 px-6"></div>
      </div>
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
