import Example from './Example.vue'
import TheCalendar from './pages/TheCalender.vue'
import TheWeekCalendar from './pages/TheWeekCalendar.vue'
import Protected from './Protected.vue'
import Admin from './Admin.vue'
import AdminDashBoard from './pages/AdminDashBoard.vue'
import { getYear, getMonth, getDate } from 'date-fns'

export const routes = [
  {
    path: '/',
    component: Protected,
    children: [
      { path: 'example', component: Example },
      { path: 'calendar/week/:year/:month/:day', component: TheWeekCalendar },
      {
        path: 'calendar/week',
        redirect: `/calendar/week/${getYear(new Date())}/${
          getMonth(new Date()) + 1
        }/${getDate(new Date())}`
      },
      { path: 'calendar', component: TheCalendar }
    ]
  },
  {
    path: '/admin',
    component: Admin,
    children: [{ path: '/', component: AdminDashBoard }]
  }
]
