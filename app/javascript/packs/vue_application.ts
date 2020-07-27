import Vue from 'vue'
import VueApollo from 'vue-apollo'
import { apolloClient } from '@/graphql/apollo'
import App from '@/vue/App.vue'
import VueCompositionApi, { provide } from '@vue/composition-api'
import { DefaultApolloClient } from '@vue/apollo-composable'
import VueRouter from 'vue-router'
import { routes } from '@/vue/routes'
import { dateFilter } from '@/vue/filters/date'
import { scheduleFilter } from '@/vue/filters/schedule'

Vue.use(VueApollo)
Vue.use(VueCompositionApi)
Vue.use(VueRouter)

dateFilter()
scheduleFilter()

const router = new VueRouter({
  mode: 'history',
  routes
})

Vue.filter('capitalize', function (value) {
  if (!value) return ''
  value = value.toString()
  return value.charAt(0).toUpperCase() + value.slice(1)
})

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    setup() {
      provide(DefaultApolloClient, apolloClient)
      return {}
    },
    router,
    render: (h) => h(App)
  }).$mount()
  document.body.appendChild(app.$el)
})
