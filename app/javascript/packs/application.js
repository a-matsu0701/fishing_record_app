import Vue from 'vue'
import App from './App.vue'
import Store from '../store/store.js'
import axios from '../axios/axios.js'
import Toasted from 'vue-toasted'

Vue.prototype.$http = axios
Vue.use(Toasted)
Vue.config.productionTip = false

const app = new Vue({
  el: '#app',
  store: Store,
  render: h => h(App)
})
