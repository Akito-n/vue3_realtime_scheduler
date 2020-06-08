import Example from './Example.vue'
import TheCalendar from './pages/TheCalender.vue'
import TheWeekCalendar from './pages/TheWeekCalendar.vue'
import Protected from './Protected.vue'
import Admin from './Admin.vue'
import AdminDashBoard from './pages/AdminDashBoard.vue'
import { format, addMonths, parse } from 'date-fns'

//funcsに分ける？
const today = new Date()
const year = format(today, 'yyyy')
const month = format(addMonths(today, 1), 'MM')
const day = format(today, 'dd')

export const routes = [
  {
    path: '/',
    component: Protected,
    children: [
      { path: 'example', component: Example },
      { path: 'calendar/week/:year/:month/:day', component: TheWeekCalendar },
      {
        path: 'calendar/week',
        redirect: `/calendar/week/${year}/${month}/${day}`
      },
      { path: 'calender/month/:year/:month', component: TheCalendar },
      {
        path: 'calendar',
        redirect: `/calender/month/${year}/${month}`
      }
    ]
  },
  {
    path: '/admin',
    component: Admin,
    children: [{ path: '/', component: AdminDashBoard }]
  }
]
