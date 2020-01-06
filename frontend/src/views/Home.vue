<template>
<div>
  <template v-if="$store.state.isMobile">    
      <router-view/>    
</template>
<template v-else>
  <div id="Home" class="f-base f-col f-ac pc">
    <div class="inner f-base f-jsb">
      <LeftWnd/>
      <div id="main-contents">
        <router-view/>
      </div>
      <RightWnd/>
    </div>
    <div class="mgh-2"><Bottom/></div>
  </div>
</template>  
</div>
</template>

<script>
  export default {
    data() {
      return {       
      }
    },
    components: {      
    },    
  }
</script>

<style lang="scss" scoped>
</style>