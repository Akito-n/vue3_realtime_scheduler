<template>
  <div id="app">
    <template v-if="!loading">
      <nav
        class="flex items-center justify-between flex-wrap bg-white-200 p-4 nav"
      >
        <div class="flex items-center flex-shrink-0 text-white mr-6">
          <router-link to="/calendar/week">
            <img src="/images/Logo.svg" />
          </router-link>
        </div>
        <div class="w-full block flex-grow lg:flex lg:items-center lg:w-auto">
          <div class="text-sm lg:flex-grow"></div>
          <div class="relative inline-block flex">
            <div class="hidden">
              <a
                href="#"
                class="inline-block text-sm px-4 py-2 mr-4 items-center leading-none border rounded text-white border-white hover:border-transparent hover:text-teal-500 hover:bg-white mt-4 lg:mt-0"
              ></a>
            </div>
            <div class="flex">
              <span
                ><router-link to="/calendar/month">
                  <img
                    src="/images/calender.svg"
                    class="w-4 h-4 mr-4 inline-block"
                  /> </router-link
              ></span>
              <span class="rounded-md shadow-sm">
                <button
                  type="button"
                  class="inline-flex justify-center mt-1 w-full rounded-md text-sm leading-5 font-medium text-gray-700 hover:text-gray-500 focus:outline-none focus:border-blue-300 focus:shadow-outline-blue active:bg-gray-50 active:text-gray-800 transition ease-in-out duration-150"
                  id="options-menu"
                  @click="state.isShowMenu = !state.isShowMenu"
                  aria-haspopup="true"
                  aria-expanded="true"
                >
                  <svg class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                    <path
                      fill-rule="evenodd"
                      d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z"
                      clip-rule="evenodd"
                    />
                  </svg>
                </button>
              </span>
            </div>
            <div
              class="origin-top-right absolute right-0 mt-5 w-28 rounded-md shadow-lg"
              v-if="state.isShowMenu"
            >
              <div class="rounded-md bg-white shadow-xs">
                <a
                  href="/users/sign_out"
                  data-method="delete"
                  class="inline-block text-sm py-2 text-center w-24 leading-none text-black border-white hover:border-transparent hover:text-teal-500 hover:bg-white mt-4 lg:mt-0"
                  >Sign Out</a
                >
              </div>
            </div>
          </div>
        </div>
      </nav>
    </template>
    <main class="flex justify-center items-start">
      <template v-if="!loading && result.currentUser">
        <router-view />
      </template>
      <div v-else class="mt-20">
        サインインしてください
        <div>
          <a href="/users/sign_in" class="mr-10">Sign in</a>
          <a href="/users/sign_up">Sign up</a>
        </div>
      </div>
    </main>
  </div>
</template>

<script lang="ts">
import Vue from 'vue'
import { defineComponent, reactive } from '@vue/composition-api'
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
  faChevronRight,
  faCalendarPlus
} from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import { CurrentUserQuery } from 'graphql/types'
library.add(faPlus)
library.add(faWindowClose)
library.add(faChevronLeft)
library.add(faChevronRight)
library.add(faCalendarPlus)

Vue.component('font-awesome-icon', FontAwesomeIcon)
Vue.use<VueLoadingOptions>(vueLoading)

export default defineComponent({
  setup() {
    const { result, loading } = useCurrentUserQuery()

    const state = reactive({
      isShowMenu: false
    })
    return { result, loading, state }
  }
})
</script>

<style lang="scss">
.schedule-cell {
  &--border {
    border-right: solid 0.25px #a0aec0;
    border-bottom: solid 0.25px #a0aec0;
    border-top: solid 0.25px #a0aec0;
  }

  &--blank + &--border {
    border: none;
  }
}

.nav {
  box-shadow: 0px 2px 8px rgba(0, 0, 0, 0.1);
  backdrop-filter: blur(27.1828px);
  margin-bottom: 30px;
}
</style>
