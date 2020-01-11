<template>
    <div style="text-align: center;">
        <div class="mgt-8 mgb-4" style="font-size: 40px; font-weight: bolder; text-align: center;">V4 길드 보스 컷 관리기</div>
        <div class="mgh-4">여러 사람과 V4 보스 몬스터 컷 시간을 관리 해 보세요</div>
        <div class="mgh-4">이 서비스는 최소한의 가입 절차가 필요합니다</div>
        <div class="f-row f-jc mgh-4">
            <div class="mgw-1"><CustomBtn st=4 @listener="login">로그인</CustomBtn></div>
            <div class="mgw-1"><CustomBtn st=4 @listener="signup">간편 가입</CustomBtn></div>
        </div>
        <div style="width: 70vw; position: relative;">
            <img style="width: 100%;" src="/images/v4boss.jpg"/>
        </div>
    </div>
</template>

<script>
    export default {
        methods: {
            login() {
                window.location.href = '/Login';
            },
            signup() {
                window.location.href = '/SignUp';
            }
        },        
    }
</script>

<style lang="scss" scoped>

</style>