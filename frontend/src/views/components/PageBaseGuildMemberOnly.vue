<template>
    <div>
        <template v-if="$store.state.auth===false">
            <div id="PageBase" class="f-base f-jc f-ac pda-2 mgw-2 border-radius">
                <NeedLogin/>
            </div>
        </template>
        <template v-else-if="$store.state.guild===-1">
            <div id="PageBase" class="f-col f-jc f-ac pda-2 mgw-2 border-radius">
                <div class="fts-title-1">길드에 소속되어야 볼 수 있습니다</div>
                <div class="f-row f-jc mgt-4">
                    <div class="btn mbox pda-4 mgw-4" @click="onLink('MakeGuild')">길드마스터 하기</div>
                    <div class="btn mbox pda-4 mgw-4" @click="onLink('JoinGuild')">길드가입</div>
                </div>
            </div>
        </template>
        <template v-else-if="$store.state.guild!==-1 && $store.state.state===0">
            <div id="PageBase" class="f-col f-jc f-ac pda-2 mgw-2 border-radius">
                <div class="fts-title-1">길드 가입을 신청한 상태 입니다.</div>
                <div class="f-row f-jc mgt-4">
                </div>
            </div>
        </template>
        <template v-else>
            <slot></slot>
        </template>        
    </div>
</template>

<script>
    export default {      
        methods: {
            onLink(link) {
                window.location.href = `/${link}`;
            }
        },       
    }
</script>

<style lang="scss" scoped>
.mbox  { width: 200px; height: 100px; @extend .f-row; @extend .f-jc; @extend .f-ac; border: 1.5px solid black; background-color: $cr-primary-1; color: white; }
</style>