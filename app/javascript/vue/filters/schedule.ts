import Vue from 'vue'
import { Schedule, User, Occupation } from 'graphql/types'
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
  Vue.filter('calenderInformation', (value: Schedule, user: User) => {
    if (!value && !user) return ''
    if (user.isIndividual) {
      if (value.isRequest && value.status == '確定済み') {
        return '【面接】' + value.occupation.companyName
      } else if (value.isRequest && value.mine) {
        return '【リクエスト送信】' + value.occupation.companyName
      } else if (value.isRequest && !value.mine) {
        return '【リクエスト受信】' + value.occupation.companyName
      } else {
        return '【面接可能】'
      }
    } else {
      const name =
        value.requester.__typename == 'Member'
          ? value.requester.name
          : value.responder.name
      if (value.isRequest && value.status == '確定済み') {
        return '【面接】' + name + '様'
      } else if (value.isRequest && value.mine) {
        return '【リクエスト送信】' + value.occupation.name
      } else if (value.isRequest && !value.mine) {
        return '【リクエスト受信】' + name + '様'
      } else {
        return '【面接可能】' + name + '様'
      }
    }
  })
}
