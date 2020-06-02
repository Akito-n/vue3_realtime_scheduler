<template>
  <div
    class="w-full md:w-1/5 bg-teal-400 md:bg-teal-400 px-2 text-center fixed bottom-0 md:pt-8 md:top-0 md:left-0 h-16 md:h-screen md:border-r-4 md:border-gray-600"
  >
    <div class="md:relative mx-auto lg:float-right lg:px-6">
      <ul class="list-reset flex flex-row md:flex-col text-center md:text-left">
        <side-bar-link path="/admin" linkTitle="Home"></side-bar-link>
      </ul>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from 'vue'
import { defineComponent } from '@vue/composition-api'
import { useResult } from '@vue/apollo-composable'
import { useCurrentUserQuery } from '@/graphql/types'
import SideBarLink from './AdminSideBarButtonLink.vue'

export default defineComponent({
  components: { SideBarLink },
  setup() {
    return {}
  }
})
</script>

<style scoped></style>
