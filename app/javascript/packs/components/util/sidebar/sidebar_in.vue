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
    <course-chooser v-if='is_supervisor'/>
    <plan-chooser v-if='is_student'/>
    <div v-if='is_admin'>
      <course-creator/>
    </div>
  </div>
</template>

<script>
import auth from '../auth.js';

import PlanChooser from './sidebar_in/plan_chooser';
import CourseChooser from './sidebar_in/course_chooser';
import CourseCreator from './sidebar_in/course_creator';

import LogOutIcon from 'vue-ionicons/dist/md-log-out.vue';
import CogIcon from 'vue-ionicons/dist/md-cog.vue';

export default {
  name: 'sidebar-in',
  props: {},
  components: {
    LogOutIcon,
    CogIcon,
    PlanChooser,
    CourseChooser,
    CourseCreator
  },
  data() {
    return { user: null };
  },
  computed: {
    is_student() {
      return this.user && this.user.type == 'Student';
    },
    is_supervisor() {
      return this.user && this.user.type == 'Supervisor';
    },
    is_admin() {
      return this.user && this.user.admin;
    }
  },
  beforeMount() {
    auth.get_user_object().then(result => {
      this.user = result;
    });
  },
  methods: {
    configs() {},
    logout() {
      console.log('Logging out...');
      auth
        .logout()
        .then(() => {
          window.bus.$emit('auth-changed');
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
</style>