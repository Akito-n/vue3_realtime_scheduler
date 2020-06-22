<template>
  <div id="app">
    <template v-if="!loading">
      <ul
        v-if="result.currentUser"
        class="flex items-center justify-end p-6"
        :class="`bg-${result.currentUser.color}-400`"
      >
        <li class="mr-6">
          <router-link to="/example" class="text-white hover:text-yellow-800">
            {{ result.currentUser.email }}({{ result.currentUser.role }})/{{
              result.currentUser.name
            }}{{ result.currentUser.companyName }}
          </router-link>
        </li>
        <li class="mr-6">
          <router-link
            to="/calendar/month"
            class="text-white hover:text-yellow-800"
          >
            calendar
          </router-link>
        </li>
        <li class="mr-6">
          <router-link
            to="/calendar/week"
            class="text-white hover:text-yellow-800"
          >
            week calendar
          </router-link>
        </li>
        <li>
          <a href="/users/sign_out" data-method="delete">
            Sign out
          </a>
        </li>
      </ul>
      <ul v-else class="flex items-center justify-end p-6 bg-teal-500">
        <li class="mr-6">
          <a href="/users/sign_in">Sign in</a>
        </li>
        <li>
          <a href="/users/sign_up">Sign up</a>
        </li>
      </ul>
    </template>
    <main class="flex justify-center items-start">
      <router-view />
    </main>
  </div>
</template>

<script lang="ts">
import Vue from 'vue'
import { defineComponent } from '@vue/composition-api'
import { useResult } from '@vue/apollo-composable'
import { useCurrentUserQuery } from '@/graphql/types'
import vueLoading, { VueLoadingOptions } from 'vue-loading-template'
import { library } from '@fortawesome/fontawesome-svg-core'
import {
  faUserSecret,
  faAd,
  faPlus,
  faWindowClose,
  faChevronLeft,
  faChevronRight
} from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import { CurrentUserQuery } from 'graphql/types'
library.add(faPlus)
library.add(faWindowClose)
library.add(faChevronLeft)
library.add(faChevronRight)

Vue.component('font-awesome-icon', FontAwesomeIcon)
Vue.use<VueLoadingOptions>(vueLoading)

export default defineComponent({
  setup() {
    const { result, loading } = useCurrentUserQuery()
    return { result, loading }
  }
})
</script>

<style lang="scss">
.schedule-cell {
  &--border {
    border: solid 1px #a0aec0;
  }
  &--blank + &--border {
    border: none;
  }
}
</style>
