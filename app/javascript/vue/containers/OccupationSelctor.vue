<template>
  <div v-if="!loading">
    <div class="bg-white task__card--requestbox mb-20 max-w-sm">
      <p class="task__card-title mb-4">ポジション</p>
      <label
        class="block ml-2 p-2 leading-normal cursor-pointer"
        v-for="occupation in result.currentUser.occupations.nodes"
        :key="occupation.id"
      >
        <input
          class="form-checkbox text-gray-900 mr-2"
          type="checkbox"
          :value="occupation.id"
          v-model="selected"
          @change="change"
        />
        {{ occupation.name }}
      </label>
    </div>
  </div>
</template>

<script lang="ts">
import { ref, defineComponent, PropType } from '@vue/composition-api'
import { useCurrentUserQuery } from '@/graphql/types'

export default defineComponent({
  components: {},
  props: {
    value: Array as PropType<string[]>
  },
  setup(props, context) {
    const { result, loading } = useCurrentUserQuery()
    const selected = ref(props.value)

    const change = () => {
      context.emit('input', selected.value)
    }

    return { result, loading, selected, change }
  }
})
</script>
<style lang="scss"></style>
