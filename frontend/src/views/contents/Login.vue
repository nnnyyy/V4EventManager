<template>
    <div class="content f-col f-wrap f-ac f-jc">
        <template v-if="$store.state.auth">
            이미 로그인 되어 있습니다
        </template>
        <template v-else>            
            <div style="width:300px; border: 1px solid black; border-radius: 8px; border-right: 2.5px solid; border-bottom: 2.5px solid;">
                <div class="mgb-2 pdl-2 pdh-1 f-row f-jc" style="font-size: 24px; background-color: #004D40; color: white; border-top-left-radius: 4px; border-top-right-radius: 4px;">로그인</div>
                <table class="login-form form-1">
                    <tr>
                        <td>닉네임</td>
                        <td><input class="type-1" type="text" v-model="id" @keyup.13="onLogin"></td>
                    </tr>
                    <tr>
                        <td>비밀번호</td>
                        <td><input class="type-1" type="password" v-model="pw" @keyup.13="onLogin"></td>
                    </tr>
                    <tr>
                        <td colspan="2" >
                            <CustomBtn bg_confirm @listener="onLogin" st=4>로그인</CustomBtn>
                        </td>
                    </tr>
                </table>
            </div>            
        </template>
    </div>
</template>

<script>
    export default {
        data() {
            return {
                id: '',
                pw: ''
            }
        },        
        methods: {
            async onLogin() {
                try {
                    const p = await this.axios.post('/api/auth/login', {id: this.id, pw: this.pw });                    
                    if( p.data.ret != 0 ) throw p.data.ret;

                    window.location.href = '/';

                } catch (e) {
                    if( e == -1 ) {
                        alert('아이디 또는 비밀번호가 잘못 되었습니다');
                        return;
                    }                    
                }                
            }
        },
    }
</script>

<style lang="scss" scoped>
.content {height: $lo-bot-height;}
.alert { color: $cr-cancel; }
.login-form input { width: 120px; }
</style>