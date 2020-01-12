<template>
    <PageBaseNoGuildOnly>        
            <div class="content f-col f-wrap f-ac f-jc">
                <template v-if="mode==0">
                    <div class="mgb-2" style="font-size: 24px;">길드 가입</div>
                    <div class="mgb-4" style="max-width: 400px; font-size: 14px; text-align: center;">
                        <div>길드 가입 요청 후에 페이지 관리자의 승인이 필요합니다</div>
                        <div class="alert">장기간 미사용시는 삭제 됩니다</div>
                    </div>
                    <div style="width:300px;">            
                        <table class="signup-form form-1">
                            <tr>
                                <td>길드 찾기</td>
                                <td><input type="text" v-model="guildname" @keyup.13="onBtnSearch"></td>
                                <td><CustomBtn bg_confirm @listener="onBtnSearch">찾기</CustomBtn></td>
                            </tr>                    
                        </table>
                        <div v-if="searchData" class="f-row f-jc f-wrap mgt-6">
                            <div class="pda-2">{{searchData.guildname}} ({{searchData.user_cnt}}/50)</div>
                            <div class="pda-2"><CustomBtn @listener="onJoinReq">가입신청</CustomBtn></div>
                        </div>
                    </div>            
                </template>
                <template v-else>
                    <div>
                        "{{guildname}}" 길드에 가입 대기 중입니다
                    </div>
                    <div class="mgt-2">
                        <CustomBtn bg_cancel @listener="onCancelJoin">대기 취소</CustomBtn>
                    </div>
                </template>
            </div>
    </PageBaseNoGuildOnly>
</template>

<script>
    export default {
        data() {
            return {
                mode: -1,
                guildname: '',
                searchData: null
            }
        },
        async created () {
            const p = await this.axios.post('/guild/checkUserGuildState');
            if( p.data.guild_sn == -1 ) this.mode = 0;
            else {
                this.mode = 1;
                this.guildname = p.data.guildname;
            }
        },
        methods: {
            getTextLength(str) {
                var len = 0;
                for (var i = 0; i < str.length; i++) {
                    if (escape(str.charAt(i)).length == 6) {
                        len++;
                    }
                    len++;
                }
                return len;
            },
            validation() {
                /* eslint-disable */
                const special = /[`~!@#$%^&*|\\\'\";:\/?]/gi;
                const space = /\s/g;

                if( this.guildname == '' ) {
                    alert('길드명이 비어있습니다');
                    return false;
                }

                if( special.test(this.guildname) || space.test(this.guildname) ) {
                    alert('길드명에 특수문자나 공백이 존재합니다');
                    return false;
                }

                if( this.getTextLength(this.guildname) > 12 || this.getTextLength(this.guildname) < 2 ) {
                    alert('2자 미만, 6자 초과 길드명 사용이 불가능합니다');
                    return false;
                }

                return true;
                /* eslint-enable */                
            },
            async onBtnSearch() {
                try {
                    if( !this.validation() ) {
                        return;
                    }

                    const p = await this.axios.post('/guild/search', { guildname: this.guildname });
                    if( p.data.ret != 0 ) throw p.data.ret;

                    this.searchData = null;

                    if( p.data.list.length <= 0 ) {
                        alert('존재하지 않는 길드입니다');
                        return;
                    }

                    const info = p.data.list[0];
                    this.searchData = info;
                    
                } catch (e) {
                    if( e == -1 ) {
                        alert('길드를 찾을 수 없습니다');
                        return;
                    }
                    
                    alert(e);
                }
            },
            async onJoinReq() {
                try {
                    const p = await this.axios.post('/guild/joinReq', { data: this.searchData });
                    if( p.data.ret != 0 ) throw p.data.ret;

                    alert('가입 신청을 완료 했습니다');

                    window.location.reload();
                } catch (e) {
                    alert(e);                    
                }
            },
            async onCancelJoin() {
                try {
                    const p = await this.axios.post('/guild/cancelJoin');
                    if( p.data.ret != 0 ) throw p.data.ret;

                    alert('가입 신청을 취소했습니다');

                    window.location.reload();
                    
                } catch (e) {
                    alert(e);
                }
            }
        },
    }
</script>

<style lang="scss" scoped>
.content {height: $lo-bot-height;}
.alert { color: $cr-cancel; }
.signup-form input { width: 120px; }
</style>