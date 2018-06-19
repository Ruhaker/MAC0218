<template>
  <div id='root'>
    <sidebar-in v-if="logged_in()" />
    <sidebar-out v-if="!logged_in()" />
  </div>
</template>

<script>
import SidebarIn from './sidebar/sidebar_in';
import SidebarOut from './sidebar/sidebar_out';

export default {
  name: 'sidebar',
  components: { SidebarIn, SidebarOut },
  props: { message: { default: 'Sidebar' } },
  data() {
    return {};
  },
  methods: {
    logged_in() {
      // TODO: MAKE THIS THING
      return false;
    }
  }
};
</script>

<style scoped>
#root {
  display: flex;
  flex-direction: row;
  background-color: red;
}

p {
  font-size: 2em;
  text-align: center;
}
</style>