<template>
  <div class="my-5">
    <div class="justify-around items-center mt-5">
      開始
      <input type="date" v-model="state.startDate" class="" />
      <vue-timepicker
        :format="timepickerOptions.format"
        :placeholder="timepickerOptions.placeholder"
        :minute-interval="timepickerOptions.interval"
        :hour-label="timepickerOptions.hourLabel"
        :minute-label="timepickerOptions.minuteLabel"
        :hour-range="timepickerOptions.hourRange"
        :default-value="timepickerOptions.defaultValue"
        v-model="state.startTime"
        hide-clear-button
      />
    </div>
    <div class="justify-around items-center mt-4">
      終了
      <input type="date" v-model="state.endDate" />
      <vue-timepicker
        :format="timepickerOptions.format"
        :minute-interval="timepickerOptions.interval"
        :placeholder="timepickerOptions.placeholder"
        :hour-label="timepickerOptions.hourLabel"
        :hour-range="timepickerOptions.hourRange"
        :minute-label="timepickerOptions.minuteLabel"
        v-model="state.endTime"
        hide-clear-button
      />
    </div>

    <div class="flex justify-around items-center pt-10">
      <div class="relative" v-if="ocupations.length > 0">
        <select
          class="block appearance-none w-full bg-gray-200 border border-gray-200 text-gray-700 py-3 px-4 pr-8 rounded leading-tight focus:outline-none focus:bg-white focus:border-gray-500"
          v-model="state.selectedOccupationId"
        >
          <option
            :value="occupation.id"
            v-for="occupation in ocupations || []"
            :key="occupation.id"
            >{{ occupation.name }}</option
          >
        </select>
        <div
          class="pointer-events-none absolute inset-y-0 right-0 flex items-center px-2 text-gray-700"
        >
          <svg
            class="fill-current h-4 w-4"
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 20 20"
          >
            <path
              d="M9.293 12.95l.707.707L15.657 8l-1.414-1.414L10 10.828 5.757 6.586 4.343 8z"
            />
          </svg>
        </div>
      </div>
      <slot name="delete"></slot>
      <button
        class="bg-black hover:bg-gray-800 text-white font-bold py-2 px-4 ml-5 rounded-md"
        @click="submit"
        :disabled="props.disabled"
      >
        登録する
      </button>
    </div>
  </div>
</template>

<script lang="ts">
import Vue, { PropType } from 'vue'
import { format, parse, addHours } from 'date-fns'
import {
  defineComponent,
  reactive,
  computed,
  watch,
  onMounted
} from '@vue/composition-api'
import VueTimepicker from 'vue2-timepicker'
import 'vue2-timepicker/dist/VueTimepicker.css'

export default defineComponent<Props>({
  components: { VueTimepicker },
  props: {
    defaultStartAt: String as PropType<string>,
    defaultEndAt: String as PropType<string>,
    defaultOccupationId: String as PropType<string>,
    disabled: Boolean as PropType<boolean>,
    ocupations: Array as PropType<Array<{ id: string; subject: string }>>
  },
  setup(props, context) {
    const state = reactive({
      startDate: null,
      startTime: null,
      startDateTime: computed(() =>
        settingTime(state.startDate, state.startTime)
      ),
      endDate: null,
      endTime: null,
      endDateTime: computed(() => settingTime(state.endDate, state.endTime)),
      selectedOccupationId: null
    })
    const variables = computed(() => ({
      input: {
        startAt: state.startDateTime,
        endAt: state.endDateTime
      }
    }))

    watch(
      () => props.defaultStartAt,
      (newStartAt) => {
        const startAt = newStartAt ? new Date(newStartAt) : new Date()
        state.startDate = format(startAt, 'yyyy-MM-dd')
        state.startTime = {
          HH: format(startAt, 'HH'),
          mm: '00'
        }
      }
    )
    watch(
      () => props.defaultEndAt,
      (newEndAt) => {
        const endAt = newEndAt ? new Date(newEndAt) : addHours(new Date(), 1)
        state.endDate = format(endAt, 'yyyy-MM-dd')
        state.endTime = {
          HH: format(endAt, 'HH'),
          mm: '00'
        }
      }
    )
    watch(
      () => props.defaultOccupationId,
      (newOccupationId) => {
        state.selectedOccupationId = newOccupationId
      }
    )

    const timepickerOptions = {
      format: 'HH:mm',
      interval: '30',
      placeholder: ' ',
      hourRange: [[9, 22]],
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

<style lang="scss" scoped>
.modal-content div p {
  font-size: 1.125rem;
  font-weight: bold;
  color: #4f4f4f;
}
</style>
