<template>
  <div id='root'>
    <div id='main_content'>
      <group :user='user' />
    </div>
    <sidebar id='sidebar' :user='user' />
  </div>
</template>

<script>
import Group from '../util/group';
import Sidebar from '../util/sidebar';

export default {
  components: { Group, Sidebar },
  data: function() {
    return { user: undefined };
  },
  methods: {}
};
</script>

<style scoped>
div#root {
  display: flex;
  flex-direction: row;
  height: 100%;
  padding: 0;
  margin: 0;
  background-attachment: fixed;
}

div#main_content {
  flex: 3;
  background-color: #0000;
}

div#sidebar {
  flex: 1;
  background: inherit;
}

p {
  font-size: 2em;
  text-align: center;
}
</style>