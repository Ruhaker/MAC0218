<template>
  <div id='root'>
    <sidebar-in v-if="user" v-on:auth-update='update_user()'/>
    <sidebar-out v-if="!user" v-on:auth-update='update_user()'/>
  </div>
</template>

<script>
import SidebarIn from './sidebar/sidebar_in';
import SidebarOut from './sidebar/sidebar_out';

import auth from './auth.js';

export default {
  name: 'sidebar',
  components: { SidebarIn, SidebarOut },
  props: {},
  data() {
    return { user: null };
  },
  beforeMount() {
    this.update_user();
  },
  methods: {
    update_user() {
      auth
        .get_user_object()
        .then(u => (this.user = u))
        .catch(err => console.error(err));
    }
  }
};
</script>

<style lang="scss" scoped>
#root {
  display: flex;
  flex-direction: columns;
  background: #333;
}

p {
  font-size: 2em;
  text-align: center;
}
</style>