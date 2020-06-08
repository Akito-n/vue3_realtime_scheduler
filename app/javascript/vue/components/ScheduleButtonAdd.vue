<template>
  <div>
    <div
      class="fixed bg-gray-300 mx-10 w-3/5 h-64 inset-auto"
      v-if="state.opened"
    >
      <input type="date" v-model="state.startDate" />
      <vue-timepicker
        :format="timepickerOptions.format"
        :minute-interval="timepickerOptions.interval"
        @change="
          (e) => {
            state.startDateTime = settingTime(state.startDate, e.data)
          }
        "
      />
      <vue-timepicker
        :format="timepickerOptions.format"
        :minute-interval="timepickerOptions.interval"
        @change="
          (e) => {
            state.endDateTime = settingTime(state.endDate, e.data)
          }
        "
      />
      <input type="date" v-model="state.endDate" />
      <!-- <input
        type="datetime-local"
        step="3600"
        v-model="state.end_date"
        value="now"
      /> -->

      <button
        class="bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-4"
        @click="mutate"
      >
        登録する
      </button>
      <button
        class="bg-white-500 hover:bg-white-700 text-white font-bold py-2 px-4 rounded-full"
        @click="state.opened = false"
      >
        <font-awesome-icon icon="window-close" />
      </button>
    </div>
    <button
      class="bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-4 rounded-full"
      @click="state.opened = true"
    >
      <font-awesome-icon icon="plus" />
    </button>
  </div>
</template>

<script lang="ts">
import Vue from 'vue'
import { format, parse } from 'date-fns'
import { defineComponent, reactive, computed } from '@vue/composition-api'
import VueTimepicker from 'vue2-timepicker'
import 'vue2-timepicker/dist/VueTimepicker.css'
import VueApollo from 'vue-apollo'
import {
  useCurrentUserQuery,
  useAddBlankScheduleMutation
} from '@/graphql/types'

export default defineComponent({
  components: { VueTimepicker },
  setup() {
    interface TimeProps {
      HH: String
      mm: String
    }
    const state = reactive({
      opened: false,
      startDate: new Date(),
      startTime: { HH: String, mm: String },
      startDateTime: new Date(),
      endDate: new Date(),
      endTime: { HH: String, mm: String },
      endDateTime: new Date()
    })

    const timepickerOptions = {
      format: 'HH:mm',
      interval: '30'
    }

    const change = () => {
      // console.log(state.start_time)
      // console.log(state.start_date)
      // console.log(
      //   parse(
      //     state.start_date + '-' + state.start_time.HH + state.start_time.mm,
      //     'yyyy-MM-dd-HHmm',
      //     new Date()
      //   )
      // )
      // console.log('new Date', new Date(), 'type', typeof new Date())
      // const a = settingTime(state.start_date, state.start_time)
      // console.log(a, typeof a)
      console.log('開始時間', state.start_date_time)
      console.log('終了時間', state.end_date_time)
      console.log(Date.parse(state.start_date_time))
    }
    // methodにしてみる
    const settingTime = function (
      date: any,
      time: { HH: StringConstructor; mm: StringConstructor }
    ) {
      const _dateTime = parse(
        date + '-' + time.HH + time.mm,
        'yyyy-MM-dd-HHmm',
        new Date()
      )
      console.log(_dateTime)
      return _dateTime
    }
    //@ts-ignore
    const { mutate, loading, error, onDone } = useAddBlankScheduleMutation({
      variables: {
        input: {
          startAt: state.startDateTime,
          endAt: state.endDateTime
        }
      }
    })

    return { state, timepickerOptions, open, mutate, change, settingTime }
  }
})
</script>

<style></style>
