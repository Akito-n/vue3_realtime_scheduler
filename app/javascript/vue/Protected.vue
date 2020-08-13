<template>
  <div>
    <router-view />
  </div>
</template>

<script lang="ts">
import Vue from 'vue'
import { defineComponent, watch } from '@vue/composition-api'
import { useCurrentUserQuery } from '@/graphql/types'

export default defineComponent({
  setup(_, context) {
    const { result, loading } = useCurrentUserQuery()

    watch(result, () => {
      if (context.root.$route.path == '/') {
        context.root.$router.push('/calendar/week')
      }
    })
    return { result, loading }
  }
})
</script>

<style lang="scss">
.body {
  background-color: #ebf2f7;
}
nav {
  background-color: white;
}
</style>
