<template>
<PageBaseGuildMasterOnly>
    <div class="pda-4">
        <div>길드원 목록</div>
        <div class="f-row f-ac table-type-1-fs t1" v-show="cbList.length > 0">
            <div>선택한 유저들 등급을</div>
            <div>
                <select v-model="selList">                    
                    <option value="1">일반 회원</option>
                    <option value="2">컷 가능 회원</option>
                </select>
            </div>
            <div>으로</div>
            <div><CustomBtn st=1 @listener="changeListGrade">변경</CustomBtn></div>
            <div> / </div>
            <div><CustomBtn st=1 bg_cancel @listener="kickUser(false)">내쫒기</CustomBtn></div>
        </div>
        <div class="mgt-2 mgb-4" style="max-width: 400px;">
            <table class="type-1">
                <tr class="top">
                    <td><input type="checkbox" v-model="cbListAll" @change="onChangeList"/></td>
                    <td>닉네임</td>
                    <td>권한</td>
                </tr>
                <tr class="center" :key="idx" v-for="(it,idx) in list">
                    <td><input type="checkbox" :disabled="it.grade==3" v-model="cbList" :value="it.user_sn"/></td>
                    <td>{{it.nick}}</td>
                    <td>{{getGradeStr(it.grade)}}</td>
                </tr>
            </table>
        </div>

        <div>승인 대기자 목록</div>
        <div class="f-row f-ac table-type-1-fs t1" v-show="cbWaitToJoin.length > 0">
            <div>선택한 유저들 등급을</div>
            <div>
                <select v-model="selWaitToJoinGrade">                    
                    <option value="1">일반 회원</option>
                    <option value="2">컷 가능 회원</option>
                </select>
            </div>
            <div>으로</div>
            <div><CustomBtn st=1 @listener="changeWaitToJoinGrade">승급하기</CustomBtn></div>
            <div> / </div>
            <div><CustomBtn st=1 bg_cancel @listener="kickUser(true)">내쫒기</CustomBtn></div>
        </div>
        <div class="mgt-2" style="max-width: 400px;">
            <table v-if="waitToJoinList.length > 0" class="type-1">
                <tr class="top">
                    <td><input type="checkbox" v-model="cbWaitToJoinAll" @change="onChangeWaitToJoin"/></td>
                    <td>닉네임</td>
                    <td>권한</td>
                </tr>
                <tr class="center" :key="idx" v-for="(it,idx) in waitToJoinList">
                    <td><input type="checkbox" v-model="cbWaitToJoin" :value="it.user_sn" /></td>
                    <td>{{it.nick}}</td>
                    <td>{{getGradeStr(it.grade)}}</td>
                </tr>
            </table>
            <div v-else>
                <div class="table-type-1-fs">승인 대기자가 없습니다</div>
            </div>
        </div>
    </div>
</PageBaseGuildMasterOnly>    
</template>

<script>
    export default {
        data() {
            return {
                list: [],
                cbList: [],
                cbListAll: false,
                selList: "1",
                waitToJoinList: [],
                cbWaitToJoin: [],
                cbWaitToJoinAll: false,
                selWaitToJoinGrade: "1"
            }
        },
        created () {            
            this.loadMembers();
        },        
        methods: {
            async loadMembers() {
                try {
                    const p = await this.axios.post('/guild/loadGuildMembers');
                    this.list = p.data.list.filter(it=>it.grade > 0);
                    this.waitToJoinList = p.data.list.filter(it=>it.grade == 0);

                } catch (e) {
                    alert(e);                    
                }                
            },
            getGradeStr(grade) {
                switch(grade) {
                    case 0: return '승인 대기';
                    case 1: return '일반 회원';
                    case 2: return '컷 가능 회원';
                    case 3: return '길드마스터';
                    default: 
                    break;
                }
            },
            onChangeList() {
                if( this.cbListAll ) {
                    this.cbList = this.list.filter(it=>it.grade!=3).map(it=>it.user_sn);
                }
                else {
                    this.cbList = [];
                }
            },
            async changeListGrade() {
                try {
                    const p = await this.axios.post('/guild/changeGrade', {userSNList: this.cbList, grade: this.selList});
                    if( p.data.ret != 0 ) throw p.data.ret;

                    alert('등급 변경이 완료 되었습니다');

                    window.location.reload();
                } catch (e) {
                    alert(e);                    
                }
            },
            async kickUser(isWait) {
                try {
                    if( !confirm('정말 내쫒으시겠습니까?') ) return;

                    const p = await this.axios.post('/guild/kickUser', {userSNList: isWait ? this.cbWaitToJoin : this.cbList});
                    if( p.data.ret != 0 ) throw p.data.ret;

                    alert('처리가 완료 되었습니다');

                    window.location.reload();
                } catch (e) {
                    alert(e);                    
                }
            },
            onChangeWaitToJoin() {
                if( this.cbWaitToJoinAll ) {
                    this.cbWaitToJoin = this.waitToJoinList.map(it=>it.user_sn);
                }
                else {
                    this.cbWaitToJoin = [];
                }
            },
            async changeWaitToJoinGrade() {
                try {
                    const p = await this.axios.post('/guild/changeGrade', {userSNList: this.cbWaitToJoin, grade: this.selWaitToJoinGrade});
                    if( p.data.ret != 0 ) throw p.data.ret;

                    alert('등급 변경이 완료 되었습니다');

                    window.location.reload();
                } catch (e) {
                    alert(e);                    
                }
            }
        },        
    }
</script>

<style lang="scss" scoped>
.t1 > div { @extend .mgw-1; }
</style>