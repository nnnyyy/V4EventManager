<template>    
        <tr v-if="top" class="boss-timer root top">
            <td>대륙명</td>
            <td>지역명</td>
            <td>필드</td>
            <td>보스 이름</td>
            <td>타입</td>
            <td>쿨타임(분)</td>
            <td>컷 시간</td>
            <td>예상 젠 시간</td>
            <td>남은 시간</td>
            <td>컷</td>
        </tr>
        <tr v-else class="boss-timer root">
            <td>{{data.dimention_name}}</td>
            <td>{{data.area_name}}</td>
            <td>{{data.field_name}}</td>
            <td>{{data.boss_name}}</td>
            <td>{{getTypeName(data.type)}}</td>
            <td>{{cooltime(data.gaptimemin)}}</td>
            <td>{{cutTime(data.cuttime)}}</td>
            <td>{{predictGenTime(data.cuttime, data.gaptimemin)}}</td>
            <td>{{getRemainTime(data.remain)}}</td>
            <td><CustomBtn bg-confirm @listener="onCut">컷</CustomBtn></td>
        </tr>    
</template>

<script>
    export default {
        props: ['data', 'top'],
        data() {
            return {
            }
        },
        created () {
        },
        methods: {
            getTypeName(type) {
                return type == 1 ? '특수 네임드(불완전)' : '일반 네임드';
            },
            cutTime(cuttime) {
                if( cuttime == 0 ) return '정보없음';
                
                let bSameDay = this.$moment(Date.now()).format('YYYYMMDD') == this.$moment(cuttime).format('YYYYMMDD');
                
                return bSameDay ? this.$moment(cuttime).format('HH:mm:ss') : this.$moment(cuttime).format('MM/DD HH:mm:ss');
            },
            async onCut() {
                try {
                    await this.axios.post('/guild/cut', {boss_sn: this.data.sn});
                    this.$emit('onCut');
                } catch (e) {
                    alert(e);                    
                }
            },
            predictGenTime(cuttime, gaptimemin) {
                if( cuttime == 0 || gaptimemin == 0 ) return '정보없음';
                let bSameDay = this.$moment(Date.now()).format('YYYYMMDD') == this.$moment(cuttime).add(gaptimemin, 'minutes').format('YYYYMMDD');

                return bSameDay ? this.$moment(cuttime).add(gaptimemin, 'minutes').format('HH:mm:ss') : this.$moment(cuttime).add(gaptimemin, 'minutes').format('DD일 HH:mm:ss');
            },
            cooltime(gaptimemin) {
                if( gaptimemin == 0 ) return '미설정';
                return gaptimemin;
            },
            getRemainTime(remainSec) {
                if( remainSec == 0 ) return '정보없음';

                const hour = Math.floor(remainSec / 60 / 60);
                const min = Math.floor(remainSec / 60 % 60);
                const sec = Math.floor(remainSec % 60);                

                return  ( (hour > 0 ? `${this.G.pad(hour, 2)}:`:``) + `${this.G.pad(min, 2)}:${this.G.pad(sec, 2)}`);
            }
        },
    }
</script>

<style lang="scss" scoped>
</style>