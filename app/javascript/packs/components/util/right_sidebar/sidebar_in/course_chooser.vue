<template>
  <div id='root'>
    <div id='header' class='toolbar'>
      <div v-if='!has_any_courses'>Você não gerencia nenhum curso!</div>
      <form>
      <select v-if='has_any_courses' v-on:change='load_course' v-model='selected_course'>
        <option v-for="(course, index) in user_courses" v-bind:key="index" :value='course.id'>{{course.name}}</option>
      </select>
      </form>
      <div class='spacer'/>
      <div class='toolbar-button'>
        <div v-if='user && user.admin' v-on:click='open = !open'>
          <transition name='plus-to-x'>
            <add-icon rootClass='toolbar-icon' w='30' h='30'/>
          </transition>
        </div>
      </div>
    </div>
    <transition name='fade-shrink'>
      <div v-if='open' id='form_area'>
        <form v-on:submit.prevent='assign'>
            <select v-model="teaching_unit" v-on:change='load_course'>
              <option :value='null'>Unidade</option>
              <option value="IME">IME - Instituto de Matemática e Estatística</option>
              <option value="FAU">FAU - Faculdade de Arquitetura e Urbanismo</option>
            </select>
            <select v-model="course_id">
              <option :value='null'>{{'Curso' + (courses.length == 0 ? '- Escolha uma unidade' : '')}}</option>
              <option :value='course.id' v-for='(course, index) in courses' v-bind:key="index">{{course.name}}</option>
            </select>
            <select v-model='supervisor_id'>
              <option :value='null'>Supervisor</option>
              <option :value='supervisor.id' v-for='(supervisor, index) in supervisors' v-bind:key="index">{{supervisor.name}}</option>
            </select>
            <input type="submit" text='test' value='Conceder gerência'/>
        </form>
      </div>
    </transition>
    <!--<custom-selector v-if='has_any_courses' selectClass='course-custom-selector' />-->
  </div>
</template>

<script>
import auth from '../../auth.js';

import regeneratorRuntime from 'regenerator-runtime';

import AddIcon from 'vue-ionicons/dist/md-add.vue';

export default {
  name: 'course-chooser',
  data() {
    return {
      user: null,
      teaching_unit: null,
      courses: [],
      supervisors: [],
      open: false,
      course_id: null,
      supervisor_id: null,
      selected_course: null
    };
  },
  components: {
    AddIcon
  },
  computed: {
    has_any_courses() {
      return this.user && this.user.courses && this.user.courses.length > 0;
    },
    user_courses() {
      if (!this.user) return [];
      return this.user.courses;
    }
  },
  watch: {
    user_courses() {
      if (this.user.courses.length == 0) this.selected_course = null;
      this.selected_course = this.user.courses[0].id;
      this.load_course();
    }
  },
  mounted() {
    this.update();
    this.load_supervisors();
    window.bus.$on('auth-changed', () => this.update());
  },
  methods: {
    assign() {
      auth
        .request('supervisor/assign', {
          supervisor_id: this.supervisor_id,
          course_id: this.course_id
        })
        .then(result => {
          auth.update();
          this.load_course(result.data.id);
        });
    },
    async update() {
      try {
        this.user = await auth.get_user_object();
      } catch (ignore) {}
      if (this.courses.length > 0) this.load_course(this.courses[0].id);
    },
    load_course() {
      window.bus.$emit('course-changed', { course_id: this.selected_course });
    },
    load_courses() {
      if (!this.teaching_unit) this.courses = [];
      auth
        .request('course/list', {
          filter: { teaching_unit: this.teaching_unit }
        })
        .then(result => {
          this.courses = result.data.courses;
        });
    },
    load_supervisors() {
      auth.request('supervisor/list').then(result => {
        this.supervisors = result.data.supervisors;
      });
    }
  }
};
</script>

<style lang="scss" scoped>
// Course selection list
#root {
  display: flex;
  flex-direction: column;
  background-color: #333;
  color: #ddd;
  font-size: 12pt;
  width: 100%;
  text-align: center;
  border-top: solid 1pt #ddd;
  border-bottom: solid 1pt #ddd;

  height: fit-content;

  transition-duration: 1s;
}

#root > #header {
  padding: 10pt;
}

.title {
  text-align: start;
  margin: 10pt;
  width: 100%;
}

/*************
 * Formulary *
 *************/
form {
  grid-area: form;
  display: flex;
  flex-direction: column;
}

#form_area {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr;
  grid-template-areas: '. . form form form form form .. ';
  vertical-align: middle;
  width: 100%;
  margin-top: 10pt;
  margin-bottom: 10pt;
}

#course-selector:hover {
  background-color: #292929;
}

/********************
 * Formulary inputs *
 ********************/

$input-field-padding: 5pt;
$input-field-margin: 5pt;
$input-field-border-radius: 8pt;

// Text input styling
form {
  display: flex;
  flex-direction: column;
}

form input {
  padding: $input-field-padding;
  margin: $input-field-margin;
  border-radius: $input-field-border-radius;
  border: none;
}

// Select input styling
form select {
  padding: $input-field-padding;
  margin: $input-field-margin;
  border-radius: $input-field-border-radius;
  border: none;
  cursor: pointer;
}

form select .select-items {
  border-top-left-radius: 5pt;
  border-top-right-radius: 5pt;
}

// Remove arrows from number input
input[type='number']::-webkit-inner-spin-button {
  -webkit-appearance: none;
  margin: 0;
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

/***************
 * Transitions *
 ***************/

// Animation
$section-height: 200px;
$anim-time: 0.15s;

.fade-shrink-enter-active {
  max-height: $section-height;
  transition: max-height $anim-time, opacity $anim-time $anim-time;
}

.fade-shrink-leave-active {
  max-height: $section-height;
  transition: opacity $anim-time, max-height $anim-time $anim-time;
}

.fade-shrink-enter,
.fade-shrink-leave-to {
  opacity: 0;
  max-height: 0;
}

@keyframes fade-shrink-in {
  0% {
    max-height: 0;
  }
  50% {
    opacity: 1;
    max-height: scale(1);
  }
  100% {
    opacity: 1;
  }
}
//
.plus-to-x-enter-active {
  animation: plus-to-x ease-in-out 0.3s;
}
.plus-to-x-leave-active {
  animation: plus-to-x ease-in-out 0.3s reverse;
}

.plus-to-x-leave,
.plus-to-x-enter-to {
  transform: rotate(405);
}

.plus-to-x-enter,
.plus-to-x-leave-to {
  transform: rotate(0);
}

@keyframes plus-to-x {
  0% {
    transform: rotate(0);
  }
  100% {
    transform: rotate(405);
  }
}
</style>
