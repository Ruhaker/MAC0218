<template>
  <div id='root'>
    <sidebar-in v-if="loaded && user" />
    <sidebar-out v-if="loaded && !user" />
  </div>
</template>

<script>
import SidebarIn from './right_sidebar/sidebar_in';
import SidebarOut from './right_sidebar/sidebar_out';

import auth from './auth.js';

export default {
  name: 'right-sidebar',
  components: { SidebarIn, SidebarOut },
  props: {},
  data() {
    return { user: null, loaded: false };
  },
  beforeMount() {
    this.update_user();
    window.bus.$on('auth-changed', this.update_user);
  },
  methods: {
    update_user() {
      auth
        .get_user_object()
        .then(u => {
          this.user = u;
          this.loaded = true;
        })
        .catch(err => {
          console.error(err);
          this.user = null;
          this.loaded = true;
        });
    }
  }
};
</script>

<style lang="scss" scoped>
#root {
  display: flex;
  flex-direction: column;
  background: #333;
  height: 100%;
}

p {
  font-size: 2em;
  text-align: center;
}
</style>