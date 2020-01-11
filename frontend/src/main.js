import 'es6-promise/auto'
import Vue from 'vue'
import './plugins/axios'
import App from './App.vue'
import router from './router'
import store from './store'
import G from './globalvariables'
import 'expose-loader?$!expose-loader?jQuery!jquery'

import CustomBtn from './views/components/CustomBtn'
import PermanentWnd from './views/components/PermanentWnd'
Vue.component('CustomBtn', CustomBtn)
Vue.component('PermanentWnd', PermanentWnd)
Vue.config.productionTip = false

import VueAdsense from './views/components/Ads/VueAdsense.vue'
import VueAdfit from './views/components/Ads/VueAdfit'
Vue.component('adsense', VueAdsense);
Vue.component('adfit', VueAdfit);

import PageBase from './views/components/PageBase'
Vue.component('PageBase', PageBase);
import PageBaseGuildMasterOnly from './views/components/PageBaseGuildMasterOnly'
Vue.component('PageBaseGuildMasterOnly', PageBaseGuildMasterOnly);
import PageBaseGuildMemberOnly from './views/components/PageBaseGuildMemberOnly'
Vue.component('PageBaseGuildMemberOnly', PageBaseGuildMemberOnly);
import PageBaseNoGuildOnly from './views/components/PageBaseNoGuildOnly'
Vue.component('PageBaseNoGuildOnly', PageBaseNoGuildOnly);
import NeedLogin from './views/components/NeedLogin'
Vue.component('NeedLogin', NeedLogin);

import Paginate from 'vuejs-paginate'
Vue.component('paginate', Paginate);

Vue.use(require('vue-moment'));

import Datetime from 'vue-datetime';
import 'vue-datetime/dist/vue-datetime.css';
Vue.use(Datetime);

//import CKEditor from '@ckeditor/ckeditor5-vue';
//Vue.use( CKEditor );

Vue.prototype.$EventBus = new Vue();
Vue.prototype.G = G;

new Vue({
  router,
  store,
  render: h => h(App)
}).$mount('#app')