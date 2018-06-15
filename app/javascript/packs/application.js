import Vue from 'vue/dist/vue.js';
import router from './routes.js';

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    template: '<router-view></router-view>',
    router
  }).$mount('#app');
  console.log(app);
});
