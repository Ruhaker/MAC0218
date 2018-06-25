<template>
  <div class='root'>
    <group :groupid='course_group_id' />
    <group :groupid='plan_group_id' />
  </div>
</template>

<script>
import Vue from 'vue';
import auth from './auth';

import group from '../util/group';

export default {
  name: 'main-content',
  components: { group },
  props: {},
  data() {
    return { course_group_id: null, plan_group_id: null };
  },
  beforeMount() {
    // Listen to events
    window.bus.$on('plan-changed', this.plan_changed);
  },
  methods: {
    plan_changed(data) {
      if (!data.plan_id) {
        this.plan_group_id = this.course_group_id = null;
        return;
      }

      auth
        .request('plan/fetch', data)
        .then(response => {
          let data = response.data.plan;
          this.plan_group_id = data.group_id;
          this.course_group_id = data.c_group_id;
        })
        .catch(error => {});
    }
  }
};
</script>

<style scoped>
</style>
