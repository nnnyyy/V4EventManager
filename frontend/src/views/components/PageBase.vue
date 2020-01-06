<template>
    <div>
        <template v-if="$store.state.accountInfo===null">
            <div id="PageBase" class="f-base f-jc f-ac pda-2 mgw-2 border-radius">
                <div class="fts-title-1">로그인이 필요합니다.</div>
            </div>
        </template>
        <template v-else-if="$store.state.accountInfo">
            <slot></slot>
        </template>        
    </div>
</template>

<script>
    export default {
        
    }
</script>

<style lang="scss" scoped>
#PageBase { width: $layout-contents-width; min-height: $layout-contents-height-with-padding; background-color: $cr-ft-1; }
</style>