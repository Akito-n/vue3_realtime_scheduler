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
        v-model="state.startTime"
      />
      <vue-timepicker
        :format="timepickerOptions.format"
        :minute-interval="timepickerOptions.interval"
        v-model="state.endTime"
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
        @click="submit"
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

interface Props {
  submit(startAt: Date, endAt: Date)
}

interface TimeProps {
  HH: String
  mm: String
}

export default defineComponent<Props>({
  components: { VueTimepicker },
  setup(props, context) {
    const state = reactive({
      opened: false,
      startDate: new Date(),
      startTime: { HH: String, mm: String },
      startDateTime: computed(() =>
        settingTime(state.startDate, state.startTime)
      ),
      endDate: new Date(),
      endTime: { HH: String, mm: String },
      endDateTime: computed(() => settingTime(state.endDate, state.endTime))
    })
    const variables = computed(() => ({
      input: {
        startAt: state.startDateTime,
        endAt: state.endDateTime
      }
    }))

    const timepickerOptions = {
      format: 'HH:mm',
      interval: '30'
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
      return _dateTime
    }

    const submit = () => {
      context.emit('submit', state.startDateTime, state.endDateTime)
    }

    return { state, timepickerOptions, open, settingTime, submit }
  }
})
</script>

<style></style>
