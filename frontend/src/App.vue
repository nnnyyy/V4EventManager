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
  async beforeCreate () {
      try {
          const p = await this.axios.post('/api/auth/check');
          if(p.data.ret != 0 ) throw p.data.ret;

          this.$store.state.auth = true;
          this.$store.state.state = 0;

      } catch (e) {
          alert(e);                
      }
  },   
  async created () {    
  },
}
</script>

<style lang="scss">
  * { box-sizing: border-box; margin: 0; padding: 0; }
  body { position: relative; font-family: $ft-noto-sans-kr; }
</style>