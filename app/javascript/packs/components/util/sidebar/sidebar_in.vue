<template>
  <div id='root'>
    <div class='toolbar'>
      <div class='spacer'/>
      <div class='toolbar-button'>
        <div v-on:click='configs()'>
          <cog-icon title='Configurações' rootClass='toolbar-icon' w='30' h='30' />
        </div>
      </div>
      <div class='toolbar-button'>
        <div v-on:click='logout()'>
          <log-out-icon title='Sair' rootClass='toolbar-icon' w='30' h='30' />
        </div>
      </div>
    </div>
    <div class='welcome' v-if='user'>Olá, {{user.name}}!</div>
    <div id='course-selector'>
      <div v-if='!has_any_plans'>Se inscreva em um curso para começar!</div>
      <select v-if='has_any_plans' v-on:input='load_plan($event.target.value)'>
        <option v-for="{course, start_year, id, index} in ordered_plans" v-bind:key="index" :value='id'>{{`${course} - ${start_year}`}}</option>
      </select>
      <!--<custom-selector v-if='has_any_courses' selectClass='course-custom-selector' />-->
    </div>
  </div>
</template>

<script>
import auth from '../auth.js';

import CustomSelector from '../items/selector';

import LogOutIcon from 'vue-ionicons/dist/md-log-out.vue';
import CogIcon from 'vue-ionicons/dist/md-cog.vue';

export default {
  name: 'sidebar-in',
  props: {},
  components: { LogOutIcon, CogIcon, CustomSelector },
  data() {
    return { user: null, plan: null };
  },
  computed: {
    has_any_plans() {
      return this.user && this.user.plans && this.user.plans.length > 0;
    },
    ordered_plans() {
      return this.user.plans
        .concat()
        .sort((a, b) => b.start_year - a.start_year);
    }
  },
  beforeMount() {
    auth.get_user_object().then(result => {
      this.user = result;
      this.load_plan(this.ordered_plans[0].id);
    });
  },
  methods: {
    load_plan(plan_id) {
      window.bus.$emit('plan-changed', { plan_id });
    },
    logout() {
      console.log('Logging out...');
      auth
        .logout()
        .then(() => {
          window.bus.$emit('auth-changed');
          this.load_plan(null);
        })
        .catch(() => {});
    }
  }
};
</script>

<style lang='scss' scoped>
#root {
  height: 100%;
  display: block;
  color: red;
}

// Toolbar container
.toolbar {
  border-bottom: solid 1pt #ddd;
}

// Toolbar button settings
.toolbar-button {
  width: 30px;
  height: 30px;
  padding: 5pt;
}

.toolbar-icon {
  color: #ddd;
  height: 15pt;
  cursor: pointer;
}

.toolbar-icon:hover {
  color: white;
}

// User profile area
.welcome {
  color: white;
  text-align: center;
  font-size: 15pt;
  margin: 15pt;
}

// Course selection list
#course-selector {
  display: flex;
  background-color: #333;
  color: #ddd;
  padding: 10pt;
  font-size: 12pt;
  width: 100%;
  text-align: center;
  border-top: solid 1pt #ddd;
  border-bottom: solid 1pt #ddd;
  cursor: pointer;
}

#course-selector:hover {
  background-color: #292929;
}

.course-custom-selector {
  background-color: red;
  border: none;
  cursor: pointer;
}
</style>