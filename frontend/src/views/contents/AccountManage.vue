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
                    <option value="4">매니저</option>
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
                    <option value="4">매니저</option>
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
        <div class="mgt-4 f-row f-ac">
            <div class="mgr-4">자동 컷시간 설정</div>
            <select class="type-1" v-model="selAutoCut" @change="onChangeAutoCut">
                <option value="1">사용</option>
                <option value="0">사용안함</option>
            </select>
        </div>
        <div class="mgt-2" style="font-size: 14px;">예상 젠 시간이 30분이상 지난 보스를 대상으로 일정 시간마다 서버에서 체크해서 자동으로 쿨타임만큼 더해줍니다</div>

        <div class="mgt-4">
            <CustomBtn bg_cancel st=5 @listener="onDestroyGuild">길드 삭제</CustomBtn>
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
                selWaitToJoinGrade: "1",
                selAutoCut: "0"
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
                    this.selAutoCut = p.data.autocut;

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
                    case 4: return '매니져';
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
            },
            async onDestroyGuild() {
                if( !confirm('길드를 삭제하시겠습니까?') ) return;

                if( !confirm('정말 삭제하시겠습니까? 모든 데이터가 지워집니다') ) return;

                await this.axios.post('/guild/destroy');

                window.location.href = '/';
            },
            async onChangeAutoCut() {
                try {
                    const p = await this.axios.post('/guild/setAutoCut', {value: this.selAutoCut});
                    if( p.data.ret != 0 ) throw p.data.ret;
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