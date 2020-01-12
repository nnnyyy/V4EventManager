<template>
    <div class="f-row f-ac" id="Top">
        <div class="mgl-4 btn" style="font-size: 32px; color: white;" @click="onGoHome">V4 길드 보스 컷 관리기</div>
        <template>
            <div v-if="$store.state.auth" class="f-col guild-info-wnd mgl-6">
                <div>닉 : {{$store.state.nick}}</div>
                <div v-if="isGuildMember()">길드 : {{$store.state.guildname}}</div>
            </div>
        </template>
        <div class="menu-root f-row f-ac mgl-2" style="color: white;">
            <div v-show="isShow(it)" class="item btn" :key="idx" v-for="(it,idx) in menu" @click="onLink(it.link)" :class="[getCls(it.link)]" >{{it.name}}</div>
            <template v-if="$store.state.auth && $store.state.guild != -1 && ( $store.state.state < 3  && $store.state.state > 0 )">
                <div class="item"><CustomBtn bg_cancel @listener="onSecession">길드 탈퇴하기</CustomBtn></div>
            </template>
        </div>
    </div>
</template>

<script>
    export default {  
        data() {
            return {
                menu: [
                    {name: '로그인', link: 'Login', notauth_only: true },
                    {name: '간편 가입', link: 'SignUp', notauth_only: true },
                    {name: '보스컷 현황', link: '', auth_required: true },
                    {name: '길드 로그', link: 'GuildLog', auth_required: true },
                    {name: '길드원 관리', link: 'AccountManage', auth_required: true, master_only: true },
                    {name: '로그아웃', link: 'Logout', auth_required: true },
                ]
            }
        },
        methods: {
            async onLink(link) {
                if( link == 'Logout' ) {
                    if(!confirm('로그아웃 하시겠습니까?')) {
                        return;
                    }
                    await this.axios.post('/api/auth/logout');
                    window.location.href = '/';
                    return;
                }
                window.location.href = '/' + link;
            },
            async onSecession() {
                if( !confirm('정말 탈퇴하시겠습니까?')) return;

                await this.axios.post('/guild/secession');
                window.location.href = '/';
            },
            getCls(link) {
                if( window.location.pathname == `/${link}` ) return "selected";
                return "";
            },
            isShow(item) {
                if( item.notauth_only && !this.$store.state.auth ) return true;

                if( item.auth_required && this.$store.state.auth ) {
                    if( item.master_only ) {
                        return  this.$store.state.state === 3;
                    }
                    else return true;
                }

                return false;
            },
            onGoHome() {
                window.location.href = '/';
            },
            isGuildMember() {      
            return this.$store.state.auth && this.$store.state.guild!=-1 && this.$store.state.state >= 1;
            }
        },
        created () {            
        },
    }
</script>

<style lang="scss" scoped>
.menu-root > .item { @extend .mgw-2; @extend .pda-2; }
.item.selected { color: yellow; }
.guild-info-wnd { background-color:#01579B; color: white; @extend .pdh-1; @extend .pdw-3; border-radius: 5px; font-size: 13.5px; border: 1.5px solid white; }
</style>