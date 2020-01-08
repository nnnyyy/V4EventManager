<template>  
<div v-if="show" @click="onClick($event)" class="f-base f-jc f-ac" style="position: absolute; left: 0;top:0; width: 100vw; height: 100vh; background: rgba(0,0,0,0.4); z-index: 100000;">
    <slot></slot>
</div>  
</template>

<script>

export default {
    props: {
        show: {
            type: Boolean,
            default: false
        }
    },
    data() {
        return {            
        }
    },
    components: {
        
    },
    methods: {        
        onClick(e) {
            e.preventDefault();
            this.$emit('onClick');
        }
    },
    created() {        
    }
}
</script>

<style lang="scss">
</style>