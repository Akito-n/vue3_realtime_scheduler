<template>
  <div class="my-5">
    <div class="justify-around items-center">
      開始
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
    </div>
    <div class="justify-around items-center">
      終了
      <input type="date" v-model="state.endDate" />
      <vue-timepicker
        :format="timepickerOptions.format"
        :minute-interval="timepickerOptions.interval"
        :placeholder="timepickerOptions.placeholder"
        :hour-label="timepickerOptions.hourLabel"
        :minute-label="timepickerOptions.minuteLabel"
        v-model="state.endTime"
        hide-clear-button
      />
    </div>

    <div class="flex justify-end items-center pt-20 mt-10">
      <div v-for="occupation in ocupations || []" :key="occupation.id">
        <label class="ml-3">
          <input
            type="radio"
            :value="occupation.id"
            v-model="state.selectedOccupationId"
          />
          {{ occupation.subject }}
        </label>
      </div>
      <button
        class="bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-4 ml-5"
        @click="submit"
        :disabled="props.disabled"
      >
        登録する
      </button>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from 'vue'
import { format, parse, addHours } from 'date-fns'
import {
  defineComponent,
  reactive,
  computed,
  watch
} from '@vue/composition-api'
import VueTimepicker from 'vue2-timepicker'
import 'vue2-timepicker/dist/VueTimepicker.css'

interface Props {
  defaultStartAt: Date
  defaultEndAt: Date
  disabled: boolean
  ocupations: Array<{ id: string; subject: string }>
}

export default defineComponent<Props>({
  components: { VueTimepicker },
  props: {
    defaultStartAt: Date,
    defaultEndAt: Date,
    disabled: Boolean,
    ocupations: Array
  },
  setup(props: Props, context) {
    const state = reactive({
      startDate: format(props.defaultStartAt || new Date(), 'yyyy-MM-dd'),
      startTime: {
        HH: format(props.defaultStartAt || new Date(), 'HH'),
        mm: '00'
      },
      startDateTime: computed(() =>
        settingTime(state.startDate, state.startTime)
      ),
      endDate: format(props.defaultEndAt || new Date(), 'yyyy-MM-dd'),
      endTime: {
        HH: format(addHours(props.defaultEndAt || new Date(), 1), 'HH'),
        mm: '00'
      },
      endDateTime: computed(() => settingTime(state.endDate, state.endTime)),
      selectedOccupationId: null
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
      context.emit(
        'submit',
        state.startDateTime,
        state.endDateTime,
        state.selectedOccupationId
      )
    }

    watch(
      () => props.ocupations,
      (newOccupations) => {
        if (newOccupations.length > 0) {
          state.selectedOccupationId = newOccupations[0].id
        }
      }
    )

    return {
      props,
      state,
      timepickerOptions,
      settingTime,
      submit
    }
  }
})
</script>

<style></style>
