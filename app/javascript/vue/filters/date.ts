import Vue from 'vue'
import { format } from 'date-fns'
import jaLocale from 'date-fns/locale/ja'

export const dateFilter = () => {
  Vue.filter('date', (value: Date | string, formatTo: string) => {
    if (!value) return ''
    return format(new Date(value), formatTo, { locale: jaLocale })
  })
}
