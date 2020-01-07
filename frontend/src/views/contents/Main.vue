<template>
    <div class="f-col">
        <Top/>
        <router-view/>
    </div>
</template>

<script>
    import Top from './Top';
    export default {
        components: {
            Top,
        },        
    }
</script>

<style lang="scss" scoped>

</style>