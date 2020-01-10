<template>
    <div class="f-row f-ac" id="Top">
        <div class="mgl-4" style="font-size: 32px; color: white;">V4 보스 컷 관리기</div>
        <div class="menu-root f-row f-afe mgl-6" style="height: 56px; color: white;">
            <div v-show="isShow(it)" class="item btn" :key="idx" v-for="(it,idx) in menu" @click="onLink(it.link)" :class="[getCls(it.link)]" >{{it.name}}</div>
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
            }
        },
        created () {            
        },
    }
</script>

<style lang="scss" scoped>
.menu-root > .item { @extend .mgw-2; @extend .pda-2; }
.item.selected { color: yellow; }
</style>