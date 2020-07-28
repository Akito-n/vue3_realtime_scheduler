import Vue from 'vue'
import { Schedule } from 'graphql/types'

export const scheduleFilter = () => {
  Vue.filter('requestIndividualName', (value: Schedule) => {
    if (!value) return ''
    if (value.requester.__typename == 'Member') {
      return value.requester.name
    } else {
      return value.responder.name
    }
  })
  Vue.filter('excludeMySchedules', (value: Schedule) => {
    if (!value) return ''
    return value.mine
  })
}
