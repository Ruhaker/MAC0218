<template>
  <div id='root'>
    <div>
      <button class='logout' v-on:click='logout()' />
    </div>
    <div class='welcome' v-if='user'>Olá, {{user.name}}</div>
    <select>
    </select>
  </div>
</template>

<script>
import auth from '../auth.js';

export default {
  name: 'sidebar-in',
  props: {},
  data() {
    return { user: null };
  },
  beforeMount() {
    auth.get_user_object().then(result => {
      this.user = result;
    });
  },
  methods: {
    logout() {
      auth
        .logout()
        .then(() => this.$emit('auth-update'))
        .catch(() => {});
    }
  }
};
</script>

<style scoped>
#root {
  height: 100%;
  display: block;
  color: red;
}

.welcome {
  color: white;
  text-align: center;
  font-size: 15pt;
}

button.logout {
  width: 15pt;
  height: 15pt;
  float: right;
}
</style>