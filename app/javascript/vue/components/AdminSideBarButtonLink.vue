<template>
  <li class="mr-3 flex-1">
    <router-link
      :to="props.path"
      class="block py-1 md:py-3 pl-1 align-middle text-white no-underline hover:text-white border-b-2 border-pink-600"
      ><font-awesome-icon icon="user-secret" />
      <span
        class="pb-1 md:pb-0 text-xs md:text-base text-white md:font-bold block md:inline-block"
        >{{ props.linkTitle }}</span
      >
    </router-link>
  </li>
</template>

<script lang="ts">
import Vue from 'vue'
import { defineComponent } from '@vue/composition-api'
import { useResult } from '@vue/apollo-composable'
import { library } from '@fortawesome/fontawesome-svg-core'
import { faUserSecret } from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import { useCurrentUserQuery } from '@/graphql/types'

library.add(faUserSecret)

Vue.component('font-awesome-icon', FontAwesomeIcon)

type Props = {
  path: string
  linkTitle: string
}

export default defineComponent({
  props: {
    path: {
      type: String,
      default: '/'
    },
    linkTitle: {
      type: String,
      default: 'Top'
    }
  },
  setup(props: Props) {
    return { props }
  }
})
</script>

<style scoped></style>
