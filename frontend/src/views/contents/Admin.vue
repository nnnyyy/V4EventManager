<template>
<PageBaseAdminOnly>
    <div class="pda-4">        
        관리 페이지
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
                list: []                
            }
        },
        created () {
            this.$EventBus.$on('guildinfo', p=> {                
                this.list = [];
                this.list = p.sort((a,b)=>{return b.users - a.users})
            });
        },
        methods: {
            
        },
    }
</script>

<style lang="scss" scoped>

</style>