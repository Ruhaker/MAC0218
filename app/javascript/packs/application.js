import Vue from 'vue';
import router from './routes.js';
import App from './App.vue';

import Resource from 'vue-resource';
Vue.use(Resource);

// Create event bus
window.bus = new Vue();

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '#app',
    router,
    render: h => h(App)
  });
});
