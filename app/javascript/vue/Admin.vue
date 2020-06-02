<template>
  <div>
    <p>This is Admin page!</p>
    {{ !loading && email ? email : 'loading' }}
    <side-bar />
    <router-view />
  </div>
</template>

<script lang="ts">
import Vue from 'vue'
import { defineComponent } from '@vue/composition-api'
import { useResult } from '@vue/apollo-composable'
import { useCurrentUserQuery } from '@/graphql/types'
import SideBar from './components/TheAdminSideBar.vue'

export default defineComponent({
  components: { SideBar },
  setup() {
    const { result, loading } = useCurrentUserQuery()
    const email = useResult(result, null, (data) => data.currentUser.email)

    // TODO: mutatioin example
    return { email, loading }
  }
})
</script>

<style scoped></style>
