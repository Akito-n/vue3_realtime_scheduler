<template>
  <div>
    <div
      v-if="props.opened"
      class="fixed z-10 bg-gray-100 inset-0 opacity-50"
      @click="close"
    ></div>
    <div
      class="fixed z-10 bg-gray-300 mx-10 my-10 w-3/5 h-64 inset-auto flex justify-center"
      v-if="props.opened"
    >
      <div class="item-center my-5">
        <input type="date" v-model="state.startDate" />
        <vue-timepicker
          :format="timepickerOptions.format"
          :placeholder="timepickerOptions.placeholder"
          :minute-interval="timepickerOptions.interval"
          :hour-label="timepickerOptions.hourLabel"
          :minute-label="timepickerOptions.minuteLabel"
          :default-value="timepickerOptions.defaultValue"
          v-model="state.startTime"
          hide-clear-button
        />
        <vue-timepicker
          :format="timepickerOptions.format"
          :minute-interval="timepickerOptions.interval"
          :placeholder="timepickerOptions.placeholder"
          :hour-label="timepickerOptions.hourLabel"
          :minute-label="timepickerOptions.minuteLabel"
          v-model="state.endTime"
          hide-clear-button
        />
        <input type="date" v-model="state.endDate" />

        <button
          class="bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-4"
          @click="submit"
        >
          登録する
        </button>
        <button
          class="bg-white-500 hover:bg-white-700 text-white font-bold py-2 px-4 rounded-full"
          @click="close"
        >
          <font-awesome-icon icon="window-close" />
        </button>
      </div>
    </div>
    <button
      class="bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-4 rounded-full"
      @click="open"
    >
      <font-awesome-icon icon="plus" />
    </button>
  </div>
</template>

<script lang="ts">
import Vue from 'vue'
import { format, parse, addHours } from 'date-fns'
import { defineComponent, reactive, computed } from '@vue/composition-api'
import VueTimepicker from 'vue2-timepicker'
import 'vue2-timepicker/dist/VueTimepicker.css'

interface Props {
  submit(startAt: Date, endAt: Date)
  open
  opened: boolean
}

export default defineComponent<Props>({
  components: { VueTimepicker },
  props: {
    opened: {
      type: Boolean,
      default: false
    }
  },
  setup(props: Props, context) {
    const state = reactive({
      startDate: format(new Date(), 'yyyy-MM-dd'),
      startTime: {
        HH: format(new Date(), 'HH'),
        mm: '00'
      },
      startDateTime: computed(() =>
        settingTime(state.startDate, state.startTime)
      ),
      endDate: format(new Date(), 'yyyy-MM-dd'),
      endTime: {
        HH: format(addHours(new Date(), 1), 'HH'),
        mm: '00'
      },
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
      interval: '30',
      placeholder: ' ',
      hourLabel: '時間',
      minuteLabel: '分'
    }

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

    const open = () => {
      context.emit('open')
    }

    const close = () => {
      context.emit('close')
    }

    return {
      props,
      state,
      timepickerOptions,
      settingTime,
      submit,
      open,
      close
    }
  }
})
</script>

<style></style>
