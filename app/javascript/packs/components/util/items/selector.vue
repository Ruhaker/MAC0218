<template>
  <div :class="selectClass">
    <div :class="itemClassN" v-for="(value, label, id, index) in options" v-bind:key="index">{{option.label}}</div>
  </div>
</template>

<script>
export default {
  name: 'custom-selector',
  props: {
    selectClass: { default: '' },
    itemClassN: { default: '' },
    itemClassS: { default: '' },
    selectedOption: null,
    options: {}
  }
};
</script>

<style lang="scss" scoped>
</style>
