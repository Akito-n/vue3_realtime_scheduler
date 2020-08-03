import Vue from 'vue'
import { Schedule } from 'graphql/types'
import { differenceInMinutes } from 'date-fns'

export const scheduleFilter = () => {
  Vue.filter('requestIndividualName', (value: Schedule) => {
    if (!value) return ''
    if (value.requester.__typename == 'Member') {
      return value.requester.name
    } else {
      return value.responder.name
    }
  })
  Vue.filter('sample', (value: Schedule) => {
    if (!value) return ''
    return (
      differenceInMinutes(new Date(value.endAt), new Date(value.startAt)) / 30
    )
  })
}
