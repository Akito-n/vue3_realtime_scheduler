<template>
  <div id="app">
    <template v-if="!loading">
      <ul
        v-if="result.currentUser"
        class="flex items-center justify-end p-6 bg-teal-500"
      >
        <li class="mr-6">
          <router-link
            to="/protected/example"
            class="text-white hover:text-yellow-800"
          >
            {{ result.currentUser.email }}({{ result.currentUser.role }})/{{
              result.currentUser.name
            }}
          </router-link>
        </li>
        <li class="mr-6">
          <router-link
            to="/protected/calendar"
            class="text-white hover:text-yellow-800"
          >
            calendar
          </router-link>
        </li>
        <li class="mr-6">
          <router-link
            to="/protected/calendar/week"
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
    <router-view />
  </div>
</template>

<script lang="ts">
import Vue from 'vue'
import { defineComponent } from '@vue/composition-api'
import { useResult } from '@vue/apollo-composable'
import { useCurrentUserQuery } from '@/graphql/types'
import { library } from '@fortawesome/fontawesome-svg-core'
import {
  faUserSecret,
  faAd,
  faPlus,
  faWindowClose
} from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import { CurrentUserQuery } from 'graphql/types'
library.add(faPlus)
library.add(faWindowClose)

Vue.component('font-awesome-icon', FontAwesomeIcon)

export default defineComponent({
  setup() {
    const { result, loading } = useCurrentUserQuery()
    return { result, loading }
  }
})
</script>

<style scoped></style>
