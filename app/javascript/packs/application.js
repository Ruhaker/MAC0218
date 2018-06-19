import Vue from 'vue';
import router from './routes.js';
import Resource from 'vue-resource';
import App from './App.vue';

Vue.use(Resource);

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '#app',
    router,
    render: h => h(App)
  });
});
