<template>
  <div id='root'>
    <div v-if='!has_any_courses'>
      <div id='no_course'>Você não gerencia nenhum curso!</div>
    </div>
    <select v-if='has_any_courses' v-on:input='load_course($event.target.value)'>
      <option v-for="{course, id, index} in courses" v-bind:key="index" :value='id'>{{course}}</option>
    </select>
    <!--<custom-selector v-if='has_any_courses' selectClass='course-custom-selector' />-->
  </div>
</template>

<script>
import auth from '../../auth.js';

export default {
  name: 'course-chooser',
  data() {
    return { user: null };
  },
  computed: {
    has_any_courses() {
      return this.user && this.user.courses && this.user.courses.length > 0;
    }
  },
  beforeMount() {
    window.bus.$on('auth-changed', () => this.update());
    this.update();
  },
  methods: {
    update() {
      auth.get_user_object().then(result => {
        this.user = result;
        console.log(result);
        if (!this.has_any_plans) this.load_course(null);
        else this.load_course(this.ordered_plans[0].id);
      });
    },
    load_course(course_id) {
      window.bus.$emit('course-changed', { course_id });
    }
  }
};
</script>

<style lang="scss" scoped>
// Course selection list
#root {
  display: flex;
  background-color: #333;
  color: #ddd;
  padding: 10pt;
  font-size: 12pt;
  width: 100%;
  text-align: center;
  border-top: solid 1pt #ddd;
  border-bottom: solid 1pt #ddd;
  height: 17pt;
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
