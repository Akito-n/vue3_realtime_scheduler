import Vue from 'vue'
import { Schedule, User, Occupation } from 'graphql/types'

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
      } else if (!value.isRequest && value.mine) {
        return '【面接可能】'
      } else if (!value.isRequest && !value.mine) {
        return '【面接枠】' + value.requester.name
      }
    } else {
      if (!value.isRequest) {
        if (value.mine) {
          return '【面接枠】' + value.requester.name
        } else {
          //MEMO: 表示数の制限をかけたいとの希望でsliceしている。ダミーデータは二文字の苗字しかないので対応可能だが、それ以外のケースを存在させる場合はsliceは取る必要がある
          return '【面接可能】' + value.requester.name.slice(0, 2) + '様'
        }
      } else {
        const name =
          value.requester.__typename == 'Member'
            ? value.requester.name.slice(0, 2)
            : value.responder.name.slice(0, 2)
        if (value.status == '確定済み') {
          return '【面接】' + name + '様'
        } else if (value.mine) {
          return '【リクエスト送信】' + name + '様'
        } else {
          return '【リクエスト受信】' + name + '様'
        }
      }
    }
  })
}
