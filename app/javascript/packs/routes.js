import Vue from 'vue/dist/vue.js';
import VueRouter from 'vue-router';

Vue.use(VueRouter);

// Import components for router
import HomeIndex from './components/home/index.vue';

// Defines routes
const routes = [{ path: '/', component: HomeIndex, name: 'home_index' }];

const router = new VueRouter({ routes });

export default router;
