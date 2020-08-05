import Vue from 'vue'
import { Schedule, User } from 'graphql/types'
import { differenceInMinutes } from 'date-fns'

export const scheduleFilter = () => {
  Vue.filter('requestIndividualName', (value: Schedule) => {
    if (!value || !value.responder) return ''
    if (value.requester.__typename == 'Member') {
      return value.requester.name
    } else {
      return value.responder.name
    }
  })
  Vue.filter('confirmTitle', (value: Schedule, user: User) => {
    if (!value && !user && value.isRequest) return ''

    if (user.isIndividual) {
      if (value.mine) {
        return value.responder.companyName + 'との面接詳細です'
      } else {
        //FIXME:このifがないと表示は問題ないがコンソールエラーになるの謎
        if (value.requester) {
          return value.requester.companyName + 'との面接詳細です'
        }
      }
    } else {
      if (value.mine) {
        return value.responder.name + '様との面接詳細です'
      } else {
        //FIXME:このifがないと表示は問題ないがコンソールエラーになるの謎
        if (value.requester) {
          return value.requester.name + '様との面接詳細です'
        }
      }
    }
  })
}
