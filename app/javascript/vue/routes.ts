import Example from './Example.vue'
import TheCalendar from './pages/TheCalender.vue'
import Protected from './Protected.vue'

export const routes = [
  {
    path: '/protected',
    component: Protected,
    children: [
      { path: 'example', component: Example },
      { path: 'calendar', component: TheCalendar }
    ]
  }
]
