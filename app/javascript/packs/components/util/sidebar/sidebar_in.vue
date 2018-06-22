<template>
  <div id='root'>
    <button text='logout' v-on:click='logout()' />
  </div>
</template>

<script>
import auth from '../auth.js';

export default {
  name: 'sidebar-in',
  props: {},
  data() {
    return {};
  },
  methods: {
    logout() {
      auth
        .logout()
        .then(() => {
          this.$emit('auth-update');
        })
        .catch(() => {});
    }
  }
};
</script>

<style scoped>
#root {
  height: 100%;
  align-items: center;
  color: red;
}
</style>