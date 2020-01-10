<template>
    <PageBaseNoGuildOnly>
        <div class="content f-col f-wrap f-ac f-jc">
            <div class="mgb-2" style="font-size: 24px;">길드 생성</div>
            <div class="mgb-4" style="width: 400px; font-size: 14px;">
                <div>길드 생성을 하고 나면 컷 관리 페이지를 운영할 수 있습니다. 길드명은 중복 불가입니다</div>
                <div class="alert">장기간 미사용시는 삭제 됩니다</div>
            </div>
            <div style="width:300px;">            
                <table class="signup-form form-1">
                    <tr>
                        <td>길드명</td>
                        <td><input type="text" v-model="guildname" placeholder="중복불가"></td>
                    </tr>
                    <tr>
                        <td colspan="2" >
                            <CustomBtn bg_confirm @listener="onBtnMakeGuild">길드 생성</CustomBtn>
                        </td>
                    </tr>
                </table>
            </div>            
        </div>
    </PageBaseNoGuildOnly>
</template>

<script>
    export default {
        data() {
            return {
                guildname: ''
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
                    alert('닉네임에 특수문자나 공백이 존재합니다');
                    return false;
                }

                if( this.getTextLength(this.guildname) > 12 || this.getTextLength(this.guildname) < 2 ) {
                    alert('2자 미만, 6자 초과 닉네임 사용이 불가능합니다');
                    return false;
                }

                return true;
                /* eslint-enable */                
            },
            async onBtnMakeGuild() {
                try {
                    if( !this.validation() ) {
                        return;
                    }

                    const p = await this.axios.post('/guild/make', { guildname: this.guildname });
                    if( p.data.ret != 0 ) throw p.data.ret;

                    alert('길드 생성을 축하합니다');

                    window.location.href = '/';
                    
                } catch (e) {
                    if( e == -1 ) {
                        alert('길드명이 존재합니다');
                        return;
                    }
                    
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