<template>
    <div class="f-col">
        <Top/>
        <router-view/>
    </div>
</template>

<script>
    import Top from './contents/Top';
    export default {
        components: {
            Top,
        },        
    }
</script>

<style lang="scss" scoped>

</style>