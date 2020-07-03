<template>
  <div
    v-show="value"
    class="modal fixed w-full h-full top-0 left-0 flex items-center justify-center z-50"
  >
    <div
      class="modal-overlay absolute w-full h-full bg-gray-900 opacity-50"
      @click.prevent="close"
    ></div>

    <div
      class="modal-container bg-white w-11/12 md:max-w-md mx-auto rounded shadow-lg z-50 overflow-y-auto"
    >
      <!-- Add margin if you want to see some of the overlay behind the modal-->
      <div class="modal-content py-4 text-left px-6">
        <!--Title-->
        <div class="flex justify-between items-center pb-3">
          <p class="text-2xl font-bold">
            {{ title || '本当によろしいですか' }}
          </p>
          <div class="modal-close cursor-pointer z-50" @click.prevent="close">
            <svg
              class="fill-current text-black"
              xmlns="http://www.w3.org/2000/svg"
              width="18"
              height="18"
              viewBox="0 0 18 18"
            >
              <path
                d="M14.53 4.53l-1.06-1.06L9 7.94 4.53 3.47 3.47 4.53 7.94 9l-4.47 4.47 1.06 1.06L9 10.06l4.47 4.47 1.06-1.06L10.06 9z"
              ></path>
            </svg>
          </div>
        </div>

        <div class="flex justify-end pt-2">
          <button
            class="px-4 bg-transparent p-3 rounded-lg text-indigo-500 hover:bg-gray-100 hover:text-indigo-400 mr-2"
            @click="close"
          >
            キャンセル
          </button>
          <button
            class="px-4 bg-transparent p-3 rounded-lg text-indigo-500 hover:bg-gray-100 hover:text-indigo-400 mr-2"
            @click="ok"
          >
            OK
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from 'vue'
import { defineComponent, reactive, computed } from '@vue/composition-api'

export default defineComponent({
  components: {},
  props: {
    value: Boolean,
    title: String
  },
  setup(props, context) {
    const ok = () => {
      context.emit('ok')
      context.emit('input', false)
    }
    const close = () => {
      context.emit('input', false)
    }
    return { ok, close }
  }
})
</script>

<style></style>
