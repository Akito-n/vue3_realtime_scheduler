import { addDays, format, startOfWeek } from 'date-fns'
import jaLocale from 'date-fns/locale/ja'

export const useCalendar = () => {
  const elementalies = [0, 1, 2, 3, 4, 5, 6].map((i) =>
    format(addDays(startOfWeek(new Date()), i), 'E', { locale: jaLocale })
  )
  const daysOfWeek = (day: Date) => {
    let _day = day
    const days = []
    for (let i = 0; i < 7; i++) {
      days.push(format(_day, 'dd'))
      _day = addDays(_day, 1)
    }
    return days
  }

  return { daysOfWeek, elementalies }
}
