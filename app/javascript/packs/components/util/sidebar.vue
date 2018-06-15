<template>
  <div id='root'>
    <div id='main_content'>
    </div>
    <sidebar id='sidebar' />
    <p>{{ message }}</p>

  </div>
</template>

<script>
export default {
  data: function() {
    return {
      message: 'Sidebar'
    };
  }
};
</script>

<style scoped>
#root {
  display: flex;
  flex-direction: row;
  background-color: red;
}

p {
  font-size: 2em;
  text-align: center;
}
</style>