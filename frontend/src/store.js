import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    auth: false,  // 인증여부
    state: 0, /* 0 일반유저 1 마스터 */
    guild: -1, // -1 면 길드가입 안함
    guildname: '',
    nick: '',
    isMobileSize: false,
    autocut: 0,
    plv: 0
  },
  mutations: {    
  },
  actions: {
  }
})
