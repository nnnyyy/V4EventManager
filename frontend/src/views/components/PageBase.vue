<template>
    <div>
        <template v-if="$store.state.auth===false">
            <div id="PageBase" class="f-row f-jc f-ac pda-2 mgw-2 border-radius">
                <div class="fts-title-1">로그인이 필요합니다.</div>
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