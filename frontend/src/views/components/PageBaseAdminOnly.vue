<template>
    <div>        
        <template v-if="$store.state.plv!=1">
            <div id="PageBase" class="f-base f-jc f-ac pda-2 mgw-2 border-radius">
                <div class="fts-title-1">관리자만 볼 수 있습니다</div>
            </div>
        </template>
        <template v-else>
            <slot></slot>
        </template>        
    </div>
</template>

<script>
    export default {
    }
</script>

<style lang="scss" scoped>
</style>