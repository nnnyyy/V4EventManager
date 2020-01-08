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
            <td class="btn" @click="$emit('align', 'remain')">남은 시간</td>
            <td>컷</td>
        </tr>
        <tr v-else class="boss-timer root">
            <td>{{data.dimention_name}}</td>
            <td class="btn" @click="onSelectField(data.area_name)">{{data.area_name}}</td>
            <td class="btn" @click="onSelectField(data.field_name)">{{data.field_name}}</td>
            <td>{{data.boss_name}}</td>
            <td>{{getTypeName(data.type)}}</td>
            <td style="text-align: center;">
                <div class="f-row" v-if="modifyCooltime">
                    <input type="text" v-model="cooltime" placeholder="분 단위" />
                    <CustomBtn bg_confirm @listener="onModifyCooltime">수정</CustomBtn>                    
                    <CustomBtn bg_cancel @listener="onCancelModifyCooltime">취소</CustomBtn> 
                </div>
                <div v-else class="btn" @click="onMode('modifyCooltime')">{{getCooltime(data.gaptimemin)}}</div>                
            </td>
            <td style="text-align: center;">
                <div class="f-row" v-if="modifyCuttime">
                    <vue-timepicker format="HH:mm" v-model="cuttime"></vue-timepicker>
                    <CustomBtn bg_confirm @listener="onModifyCutTime">수정</CustomBtn>                    
                    <CustomBtn bg_cancel @listener="onCancelModifyCutTime">취소</CustomBtn> 
                </div>
                <div v-else class="btn" @click="onMode('modifyCuttime')">{{cutTime(data.cuttime)}}</div>
            </td>
            <td style="text-align: center;">{{predictGenTime(data.cuttime, data.gaptimemin)}}</td>
            <td style="text-align: center;" :class="[getRemainCls(data.remain)]">{{getRemainTime(data.remain)}}</td>
            <td style="text-align: center;"><CustomBtn bg_confirm @listener="onCut">지금 컷</CustomBtn></td>
        </tr>    
</template>

<script>
import VueTimepicker from 'vue2-timepicker';
import 'vue2-timepicker/dist/VueTimepicker.css';

    export default {
        components: {
            VueTimepicker,
        },
        props: ['data', 'top'],
        data() {
            return {
                modifyCuttime: false,
                cuttime: {
                    HH: '03',
                    mm: '05'
                },
                modifyCooltime: false,
                cooltime: ''
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
            getCooltime(gaptimemin) {
                if( gaptimemin == 0 ) return '미설정';
                return gaptimemin;
            },
            getRemainTime(remainSec) {
                if( this.data.cuttime == 0 && remainSec == -1 ) return '정보없음';

                const hour = Math.floor(remainSec / 60 / 60);
                const min = Math.floor(remainSec / 60 % 60);
                const sec = Math.floor(remainSec % 60);                

                return  ( (hour > 0 ? `${this.G.pad(hour, 2)}:`:``) + `${this.G.pad(min, 2)}:${this.G.pad(sec, 2)}`);
            },
            getRemainCls(remainSec) {
                if( this.data.cuttime == 0 && remainSec == -1 ) return '';

                if( remainSec < 300 ) return 'alert';
            },
            onMode(mode) {
                if( mode == 'modifyCuttime') {
                    if(this.data.cuttime == 0) {
                        alert('지금 컷을 한번 실행 후 수정해주세요.');
                        return;
                    }
                    this.modifyCuttime = true;
                    this.$nextTick(()=> {
                        this.cuttime.HH = this.$moment(this.data.cuttime).format('HH');
                        this.cuttime.mm = this.$moment(this.data.cuttime).format('mm');
                    })                    
                }

                if( mode == 'modifyCooltime') {
                    this.modifyCooltime = true;
                    this.$nextTick(()=> {
                        this.cooltime = this.data.gaptimemin;
                    })                    
                }
            },
            async onModifyCutTime() {
                try {
                    const yesterday = Number(this.$moment(Date.now()).format('HH')) < Number(this.cuttime.HH);
                    let now = new Date();
                    if( yesterday ) now.setDate(now.getDate() - 1);

                    now.setHours(this.cuttime.HH);
                    now.setMinutes(this.cuttime.mm);
                    console.log(this.$moment(now).format('YYYY-MM-DD HH:mm'));
                    await this.axios.post('/guild/modifyCutTime', {boss_sn: this.data.sn, modifydate: this.$moment(now).format('YYYY-MM-DD HH:mm') });
                    this.$emit('onCut');
                } catch (e) {
                    alert(e);                    
                } finally {
                    this.modifyCuttime = false;
                }
            },
            onCancelModifyCutTime() {
                this.modifyCuttime = false;
            },
            async onModifyCooltime() {
                try {
                    await this.axios.post('/guild/modifyCooltime', {boss_sn: this.data.sn, cooltime: this.cooltime});
                    this.$emit('onCooltime');
                } catch (e) {
                    alert(e);                    
                } finally {
                    this.modifyCooltime = false;
                }
            },
            onCancelModifyCooltime() {
                this.modifyCooltime = false;
            },
            onSelectField(name) {
                this.$emit('onSelectField', name);
            }
        },
    }
</script>

<style lang="scss" scoped>
.boss-timer.root td.alert { background-color: $cr-cancel; color: white; }
</style>