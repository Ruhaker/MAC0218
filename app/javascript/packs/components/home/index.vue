<template>
  <div id='root'>
    <left-sidebar id='left-sidebar'/>
    <link rel="stylesheet"
          href="https://fonts.googleapis.com/css?family=Encode+Sans+Condensed">
    <main-content id='main_content' :groupids='groups' v-on:change-plan='changed_plan($event)'/>
    <right-sidebar id='right-sidebar'/>
  </div>
</template>

<script>
import auth from '../util/auth.js';
document.auth = auth;

import MainContent from '../util/main_content';
import RightSidebar from '../util/right_sidebar';
import LeftSidebar from '../util/left_sidebar';
import 'vue-ionicons/ionicons.css';

export default {
  components: { MainContent, RightSidebar, LeftSidebar },
  data: function() {
    return { groups: [] };
  },
  methods: {}
};
</script>

<style lang="scss">
// Toolbar utilities
.toolbar {
  display: flex;
  vertical-align: middle;
  align-items: center;
}
.spacer {
  flex-grow: 1;
}

.ghost {
  opacity: 0.5;
}

.chosen {
  opacity: 0.2;
}
</style>


<style lang='scss' scoped>
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
  font-family: 'Encode Sans Condensed', sans-serif;
  overflow: auto;
}

div#right-sidebar {
  flex: 1;
  background: inherit;
}
div#left-sidebar {
  flex: 1;
  background: inherit;
}

// Removes blue outline for input fields
input:focus {
  outline: none;
}

select:focus {
  outline: none;
}

p {
  font-size: 2em;
  text-align: center;
}
</style>
