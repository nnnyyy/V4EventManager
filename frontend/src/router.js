import Vue from 'vue'
import Router from 'vue-router'
import Home from './views/Home.vue'

Vue.use(Router)

export default new Router({
  mode: 'history',
  base: process.env.BASE_URL,
  routes: [
    {
      path: '/', component: Home, children: [
        { path: '', name: '', component: ()=> import('./views/contents/MainRoot')},
        { path: 'AccountManage', name: '', component: ()=> import('./views/contents/AccountManage')},
        { path: 'MakeGuild', name: '', component: ()=> import('./views/contents/MakeGuild')},
        { path: 'JoinGuild', name: '', component: ()=> import('./views/contents/JoinGuild')},
        { path: 'Login', name: '', component: ()=> import('./views/contents/Login')},
        { path: 'SignUp', name: '', component: ()=> import('./views/contents/SignUp')},
        { path: 'GuildLog', name: '', component: ()=> import('./views/contents/GuildLog')},
      ]
    },
    {
      path: '*',
      name: 'e404',
      component: () => import('./views/E404.vue')
    }
  ]
})
