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
  async created () {    
  },
}
</script>

<style lang="scss">
  * { box-sizing: border-box; margin: 0; padding: 0; }
  body { position: relative; font-family: $ft-noto-sans-kr; color: $cr-ft-1; background-color: $cr-home-back; }
</style>