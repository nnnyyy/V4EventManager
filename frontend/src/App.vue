<template>
  <div>
    <router-view/>
  </div>
</template>

<script>
export default {
  name: 'App',
  components: {
  },
  data () {
    return {
    }
  },
  async created() {      
      try {
          window.onresize = ()=> {
              if( window.innerWidth <= 600 ) this.$store.state.isMobileSize = true;
              else this.$store.state.isMobileSize = false;
          }

          window.onresize();
          
          const p = await this.axios.post('/api/auth/check');
          if(p.data.ret != 0 ) throw p.data.ret;
          const userinfo = p.data.info;

          this.$store.state.auth = true;
          this.$store.state.state = userinfo.grade;
          this.$store.state.guild = userinfo.guild;
          this.$store.state.guildname = userinfo.guildname;
          this.$store.state.nick = userinfo.nick;
          this.$store.state.autocut = userinfo.autocut;
          this.$store.state.plv = userinfo.plv;
          this.G.connectTCP();
          
          if( this.$store.state.guild != -1 && 
              this.$store.state.state == 0 && 
              window.location.pathname != '/JoinGuild' ) {
            window.location.href = '/JoinGuild';
            return;
          }

      } catch (e) {
        if( e == -101 || e == -2 ) {
          this.$store.state.auth = false;
          return;
        }
        alert(e);
      }
  }
}
</script>

<style lang="scss">
  * { box-sizing: border-box; margin: 0; padding: 0; }
  body { position: relative; font-family: $ft-noto-sans-kr; }
</style>