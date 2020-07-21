<template>
  <div v-if="!loading">
    <label
      v-for="occupation in result.currentUser.occupations.nodes"
      :key="occupation.id"
    >
      <input
        type="checkbox"
        :value="occupation.id"
        v-model="selected"
        @change="change"
      />
      {{ occupation.name }}
    </label>
  </div>
</template>

<script lang="ts">
import {
  ref,
  defineComponent,
  watch,
  reactive,
  computed,
  PropType
} from '@vue/composition-api'
import { useCurrentUserQuery } from '@/graphql/types'
import { useAddBlankScheduleMutation } from 'graphql/types'

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
<style scoped></style>
