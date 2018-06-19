<template>
  <div id='root'>
    <div id='main_content'>
      <h1>{{message}}</h1>
    </div>
    <sidebar id='sidebar' />
  </div>
</template>

<script>
import Sidebar from '../util/sidebar';

export default {
  components: { Sidebar },
  data: function() {
    return {
      message: 'Welcome to Cinematranix!'
    };
  },
  methods: {}
};
</script>

<style scoped>
div#root {
  display: flex;
  flex-direction: row;
  background-color: red;
  height: 100%;
  padding: 0;
  margin: 0;
}

div#main_content {
  flex: 4;
  background-color: green;
}

div#sidebar {
  flex: 1;
  background-color: blue;
}

p {
  font-size: 2em;
  text-align: center;
}
</style>