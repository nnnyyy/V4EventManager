<template>
<PageBaseGuildMemberOnly>
    <div class="pda-4" style="max-width: 1000px;">
        <table class="type-1">
            <tr class="top">
                <td style="width: 100px;">SN</td>
                <td style="width: 160px;">시간</td>
                <td style="width: 120px;">유저</td>
                <td>로그</td>
            </tr>
            <tr class="center" :key="idx" v-for="(it,idx) in logs">
                <td>{{it.sn}}</td>
                <td>{{$moment(it.regdate).format('YYYY/MM/DD HH:mm:ss')}}</td>
                <td>{{it.nick}}</td>
                <td>{{it.msg}}</td>
            </tr>
        </table>
        <paginate
            v-show="logs.length > 0"
            :page-count="total"
            :page-range="9"
            :margin-pages="1"
            :click-handler="pageChange"
            :prev-text="'이전'"
            :next-text="'다음'"    
            :container-class="'pagination'"
            :page-class="'pagination-item'"
            >
            </paginate>        
    </div>
</PageBaseGuildMemberOnly>
</template>

<script>
    export default {
        data() {
            return {
                logs: [],                
                total: 10,
            }
        },        
        created () {
            this.loadLogs(0);            
        },
        methods: {
            async loadLogs(page) {
                const p = await this.axios.post('/guild/loadLogs', {page: page});
                
                this.logs = p.data.logs;
                this.total = Math.floor(p.data.total / 20) + 1;
            },
            pageChange(val) {
                const page = Number(Number(val)-1);
                this.loadLogs(page);
            },
        },
    }
</script>

<style lang="scss" scoped>

</style>