<template>
    <div>        
        <table class="mgt-2 mgl-4 type-3 row border">
            <tr>
                <td>아이디</td>
                <td><input type="text" v-model="id" /></td>
            </tr>   
            <tr>
                <td>비밀번호</td>
                <td><input type="password" v-model="pw" /></td>
            </tr>
            <tr>
                <td colspan=2>
                    <CustomBtn st=3 :manual_disabled="processing" bg_confirm @listener="login" >로그인</CustomBtn>
                </td>
            </tr>
        </table>
    </div>    
</template>

<script>    
    export default {
        props: {
        },
        data() {
            return {
                processing: false,
                id: '',
                pw: ''
            }
        },
        async created () {
            
        },
        methods: {
            async login() {
                if( this.id == '' || this.pw == '') {
                    alert('아이디와 비번을 입력 해주세요');
                    return;
                }

                try {
                    if(this.processing) return;
                    this.processing = true;
                    const p = await this.axios.post('/api/auth/login', {id: this.id, pw: this.pw});
                    if( p.data.ret != 0 ) throw p.data.ret;

                    window.location.reload();

                } catch (e) {
                    if( e == -1 ) {
                        alert('아이디 또는 비번이 잘못되었습니다');
                    }

                    if( e == -2 ) {
                        alert('영구밴 이력으로 인해 로그인이 불가능합니다.');
                    }
                } finally {
                    this.processing = false;
                }
            }
        },
    }
</script>

<style lang="scss" scoped>
</style>