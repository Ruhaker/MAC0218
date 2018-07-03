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
    <div v-if='is_student'>
      <draggable>
        <div class='progress-viewer' v-for='(progress, index) in progresses' :key='index'>
          <div>
            <move-icon title='Mover' rootClass='handle header-icon' w='20' h='20' />
            {{progress.name}}
          </div>
          <div v-if="progress.target_credits">
            <div class='progress-bar'>
              <div class='label'>Créditos</div>
              <div class='progress-bar-done left-rounded right-rounded-on-full' :full='progress.current_credits >= progress.target_credits'
                  :style='`flex-grow: ${progress.current_credits / progress.target_credits}`' />
              <div class='progress-bar-todo right-rounded left-rounded-on-full' :full='progress.current_credits <= 0'
                  :style='`flex-grow: ${1 - progress.current_credits / progress.target_credits}`' />
              <div class='label perc'>{{`${Math.round(progress.current_credits / progress.target_credits * 100)} %`}}</div>
            </div>
          </div>

          <div v-if="progress.target_children">
            <div class='progress-bar'>
              <div class='label'>Filhos</div>
              <div class='progress-bar-done left-rounded right-rounded-on-full' :full='progress.current_children >= progress.target_children'
                  :style='`flex-grow: ${progress.current_children / progress.target_children}`' />
              <div class='progress-bar-todo right-rounded left-rounded-on-full' :full='progress.current_children <= 0'
                  :style='`flex-grow: ${1 - progress.current_children / progress.target_children}`' />
              <div class='label perc'>{{`${Math.round(progress.current_children / progress.target_children * 100)} %`}}</div>
            </div>
          </div>
        </div>
      </draggable>
    </div>
    <div class='spacer'/>
  </div>
</template>

<script>
import auth from '../auth.js';

import PlanChooser from './sidebar_in/plan_chooser';
import CourseChooser from './sidebar_in/course_chooser';
import CourseCreator from './sidebar_in/course_creator';

import LogOutIcon from 'vue-ionicons/dist/md-log-out.vue';
import CogIcon from 'vue-ionicons/dist/md-cog.vue';
import MoveIcon from 'vue-ionicons/dist/md-move.vue';

import draggable from 'vuedraggable';

export default {
  name: 'sidebar-in',
  props: {},
  components: {
    LogOutIcon,
    CogIcon,
    MoveIcon,
    PlanChooser,
    CourseChooser,
    CourseCreator,
    draggable
  },
  data() {
    return {
      user: null,
      progresses: [],
      draggable_props: {
        animation: 200,
        group: 'progress',
        handle: '.handle'
      }
    };
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
    window.bus.$on('update-progress', this.update_progress);
    window.bus.$on('remove-progress', this.remove_progress);
  },
  methods: {
    update_progress(data) {
      console.log(data);
      let new_value = {};
      new_value.gid = data.id;
      new_value.name = data.name;
      if (data.min_credits != null) {
        new_value.current_credits = data.done_credits;
        new_value.target_credits = data.min_credits;
      }
      if (data.min_subjects != null) {
        new_value.current_children = data.done_subjects;
        new_value.target_children = data.min_subjects;
      }

      let old = this.progresses.findIndex(progress => progress.gid == data.id);
      if (old >= 0) this.$set(this.progresses, old, new_value);
      else this.progresses.push(new_value);
    },
    remove_progress(data) {
      this.progresses = this.progresses.filter(val => val.gid != data.id);
    },
    configs() {},
    logout() {
      console.log('Logging out...');
      auth
        .logout()
        .then(() => {
          window.bus.$emit('auth-changed');
          window.bus.$emit('reload-groups');
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

.progress-viewer {
  padding: 8pt;
  vertical-align: middle;
  color: #ddd;
  border-top: solid #ddd 1px;
  border-bottom: solid #ddd 1px;
  font-weight: bold;
}

.label {
  min-width: 60pt;
  padding: 5pt;
  font-weight: 400;
}

.label.perc {
  min-width: 0;
  max-width: 40pt;
  width: 40pt;
}

.progress-bar {
  display: flex;
  margin: 10pt;
  vertical-align: middle;
}

.left-rounded,
.left-rounded-on-full[full='true'] {
  border-top-left-radius: 5pt;
  border-bottom-left-radius: 5pt;
}

.right-rounded,
.right-rounded-on-full[full='true'] {
  border-top-right-radius: 5pt;
  border-bottom-right-radius: 5pt;
}

.handle {
  cursor: pointer;
}

.handle:hover {
  color: white;
}

.progress-bar-done {
  margin: 0;
  height: 10pt;
  align-self: center;
  background-color: green;
}
.progress-bar-todo {
  margin: 0;
  height: 10pt;
  align-self: center;
  background-color: #aaa;
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