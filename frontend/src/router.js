import Vue from 'vue'
import Router from 'vue-router'
import Home from './views/Home.vue'
import Main from './views/contents/Main'

Vue.use(Router)

export default new Router({
  mode: 'history',
  base: process.env.BASE_URL,
  routes: [
    {
      path: '/', component: Home, children: [
        { path: '', name: '', component: ()=> import('./views/contents/MainRoot')},
        { path: 'AccountManage', name: '', component: ()=> import('./views/contents/AccountManage')}
      ]
    },
    {
      path: '*',
      name: 'e404',
      component: () => import('./views/E404.vue')
    }
  ]
})
