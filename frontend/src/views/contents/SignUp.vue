<template>
    <div class="content f-col f-wrap f-ac f-jc">
        <div class="mgb-2" style="font-size: 24px;">간편 회원가입</div>
        <div class="mgb-4" style="width: 400px; font-size: 14px;">
            <div>개인정보를 수집하지 않으므로 비밀번호를 잃어버릴 경우에는 찾기가 불가능합니다. 신중하게 설정 해주세요.</div>
            <div class="alert">장기간 미사용시는 계정이 자동 삭제 됩니다</div>
        </div>
        <div style="width:300px;">            
            <table class="signup-form form-1">
                <tr>
                    <td>닉네임</td>
                    <td><input type="text" v-model="id"></td>
                </tr>
                <tr>
                    <td>비밀번호</td>
                    <td><input type="password" v-model="pw"></td>
                </tr>
                <tr>
                    <td>비밀번호 재입력</td>
                    <td><input type="password" v-model="pwre"></td>
                </tr>
                <tr>
                    <td colspan="2" >
                        <CustomBtn bg_confirm @listener="onBtnSignUp">가입하기</CustomBtn>
                    </td>
                </tr>
            </table>
        </div>
    </div>
</template>

<script>
    export default {
        data() {
            return {
                id: '',
                pw: '',
                pwre: ''
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

                if( this.id == '' ) {
                    alert('닉네임이 비어있습니다');
                    return false;
                }

                if( special.test(this.id) || space.test(this.id) ) {
                    alert('닉네임에 특수문자나 공백이 존재합니다');
                    return false;
                }

                if( this.getTextLength(this.id) > 12 || this.getTextLength(this.id) < 2 ) {
                    alert('2자 미만, 6자 초과 닉네임 사용이 불가능합니다');
                    return false;
                }

                if( this.getTextLength(this.id) > 14 || this.getTextLength(this.id) < 2 ) {
                    alert('2자 미만, 14자 초과 비밀번호 사용은 불가능합니다');
                    return false;
                }

                if( this.pw !== this.pwre ) {
                    alert('비밀번호 재입력이 동일하지 않습니다');
                    return false;
                }

                return true;
                /* eslint-enable */                
            },
            async onBtnSignUp() {
                try {
                    if( !this.validation() ) {
                        return;
                    }

                    const p = await this.axios.post('/api/auth/signup', {id: this.id, pw: this.pw });
                    if( p.data.ret != 0 ) throw p.data.ret;

                    alert('가입을 축하합니다');

                    window.location.href = '/Login';
                    
                } catch (e) {
                    if( e == -1 ) {
                        alert('닉네임이 존재합니다');
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