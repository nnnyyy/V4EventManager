<template>
<PageBaseAdminOnly>
    <div class="pda-4">        
        <div class="mgh-2 fsize-title">관리페이지</div>
        <div class="mgh-2">총 접속 유저 : {{users}}</div>
        <div class="mgh-2">총 소켓 : {{socketCnt}}</div>
        <table class="type-1" style="max-width: 400px;">
            <tr class="top">
                <td>길드명</td>
                <td>접속 유저수</td>
            </tr>
            <tr :key="idx" v-for="(it,idx) in list">
                <td>{{it.guildname}}</td>
                <td>{{it.users}}</td>
            </tr>
        </table>
    </div>
</PageBaseAdminOnly>
</template>

<script>
    export default {
        data() {
            return {
                list: [],
                users: 0,
                socketCnt: 0
            }
        },
        created () {
            this.$EventBus.$on('guildinfo', p=> {                
                this.list = [];
                this.list = p.info.sort((a,b)=>{return b.users - a.users})
                this.users = this.list.reduce((acc,val)=> acc + val.users, 0);
                this.socketCnt = p.sockCnt;
            });
        },
        methods: {
            
        },
    }
</script>

<style lang="scss" scoped>

</style>