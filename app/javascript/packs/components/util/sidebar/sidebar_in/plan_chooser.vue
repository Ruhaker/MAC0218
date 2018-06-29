<template>
  <div id='root'>
    <div v-if='!has_any_plans'>Se inscreva em um curso para começar!</div>
    <select v-if='has_any_plans' v-on:input='load_plan($event.target.value)'>
      <option v-for="{course, start_year, id, index} in ordered_plans" v-bind:key="index" :value='id'>{{`${course} - ${start_year}`}}</option>
    </select>
    <!--<custom-selector v-if='has_any_courses' selectClass='course-custom-selector' />-->
  </div>
</template>

<script>
import auth from '../../auth.js';

export default {
  name: 'plan-chooser',
  data() {
    return { user: null };
  },
  computed: {
    has_any_plans() {
      return this.user && this.user.plans && this.user.plans.length > 0;
    },
    ordered_plans() {
      if (!this.user) return [];
      return this.user.plans
        .concat()
        .sort((a, b) => b.start_year - a.start_year);
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
        if (!this.has_any_plans) this.load_plan(null);
        else this.load_plan(this.ordered_plans[0].id);
      });
    },
    load_plan(plan_id) {
      window.bus.$emit('plan-changed', { plan_id });
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
