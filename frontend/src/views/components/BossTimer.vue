<template>
        <tr v-if="top" class="boss-timer root top">
            <template v-if="!$store.state.isMobileSize">
                <td style="width: 150px;">지역명</td>            
                <td style="width: 180px;">필드</td>
                <td style="width: 130px;">보스 이름</td>
                <td style="width: 150px;">타입</td>
                <td style="min-width: 100px;">쿨타임(분)</td>
                <td style="min-width: 150px;">컷 시간</td>
                <td style="width: 150px;">예상 젠 시간</td>
                <td style="width: 130px;" class="btn" @click="$emit('align', 'remain')">남은 시간</td>
                <td style="width: 100px;">컷</td>
                <td style="width: 100px;">즐겨찾기</td>
            </template>            
            <template v-else>
                <td>보스 이름</td>                
                <td>컷 시간</td>                
                <td style="width: 130px;" class="btn" @click="$emit('align', 'remain')">남은 시간</td>
                <td style="width: 100px;">컷</td>
                <td style="width: 100px;">즐겨찾기</td>                
            </template>
        </tr>
        <tr v-else class="boss-timer root">
            <PermanentWnd v-show="true">dfdf</PermanentWnd>
            <td v-if="!$store.state.isMobileSize">{{data.area_name}} <i v-show="hasAreaData()" @click="onSelectArea" class="btn mgl-1 material-icons">insert_photo</i></td>
            <td v-if="!$store.state.isMobileSize" :class="[getFieldCls()]">{{data.field_name}} <i v-show="hasFieldData()" @click="onSelectField" class="btn mgl-1 material-icons">insert_photo</i></td>
            <td>{{data.boss_name}} <i v-show="hasBossData()" @click="onSelectBoss" class="btn mgl-1 material-icons" style="font-size: 14px;">my_location</i></td>
            <td v-if="!$store.state.isMobileSize" :class="[getTypeCls()]">{{getTypeName(data.type)}}</td>
            <td v-if="!$store.state.isMobileSize" style="text-align: center;">
                <div class="f-row" v-if="modifyCooltime">
                    <input type="text" style="width: 50px;" v-model="cooltime" placeholder="분 단위" />
                    <div class="mgl-1"><CustomBtn bg_confirm @listener="onModifyCooltime">수정</CustomBtn></div>
                    <div class="mgl-1"><CustomBtn bg_cancel @listener="onCancelModifyCooltime">취소</CustomBtn></div> 
                </div>
                <div v-else class="btn" @click="onMode('modifyCooltime')">{{getCooltime(data.gaptimemin)}}</div>                
            </td>
            <td style="text-align: center;">                
                <div>{{cutTime(data.cuttime)}} <i class="material-icons btn table-type-1-fs" @click="onMode('modifyCuttime')">create</i></div>
            </td>
            <td v-if="!$store.state.isMobileSize" style="text-align: center;">{{predictGenTime(data.cuttime, data.gaptimemin)}}</td>
            <td style="text-align: center;" :class="[getRemainCls(data.remain)]">{{getRemainTime(data.remain)}}</td>
            <td style="text-align: center;"><CustomBtn bg_confirm @listener="onCut">지금 컷</CustomBtn></td>
            <td class="btn" style="text-align: center;" @click="onFavorite" ><i style="color: black;" class="material-icons">{{data.favorite?'star':'star_border'}}</i></td>
        </tr>    
</template>

<script>
import { MapData } from '@/js/MapData';

    export default {
        components: {            
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
                cooltime: '',
                bossMarker: null
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
                    if( this.$store.state.state < 2 ) {
                        alert('권한이 없습니다. 길드마스터에게 문의하세요.');
                        return;
                    }

                    if( !confirm('현재 시간으로 컷을 입력하시겠습니까? 입력 후 수정 가능합니다.') ) return;

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
            hasAreaData() {
                return !!MapData[this.data.area_name];
            },
            hasFieldData() {
                return !!MapData[this.data.field_group];
            },
            hasBossData() {
                if( !this.hasAreaData() && !this.hasFieldData() ) return false;
                let marker = [];
                if( this.hasAreaData() ) {
                    marker = MapData[this.data.area_name].marker;
                }

                if( this.hasFieldData() ) {
                    marker = MapData[this.data.field_group].marker;
                }

                for( let idx in marker ) {
                    const info = marker[idx];
                    if( info.name == this.data.boss_name )  {
                        this.bossMarker = info;
                        return true;
                    }
                }

                return false;
            },
            getFieldCls() {
                if( !this.hasFieldData() ) return;

                return "hasImage";
            },
            getTypeCls() {
                if( this.data.type == 1) return "type-2";
                return "type-1";
            },
            onMode(mode) {
                if( this.$store.state.state < 2 ) {
                    alert('권한이 없습니다. 길드마스터에게 문의하세요.');
                    return;
                }

                if( mode == 'modifyCuttime') {
                    if(this.data.cuttime == 0) {
                        alert('지금 컷을 한번 실행 후 수정해주세요.');
                        return;
                    }

                    this.$emit('modifyCut', this.data);                                        
                }

                if( mode == 'modifyCooltime') {
                    if(this.data.cuttime == 0) {
                        alert('지금 컷을 한번 실행 후 수정해주세요.');
                        return;
                    }
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
                    if( this.$store.state.state < 2 ) {
                        alert('수정 권한이 없습니다');
                        return;
                    }
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
            onSelectField() {
                this.$emit('onSelectField', {mapdata: MapData[this.data.field_group], boss: null });
            },
            onSelectArea() {
                this.$emit('onSelectField', {mapdata: MapData[this.data.area_name], boss: null});
            },
            onSelectBoss() {
                this.$emit('onSelectField', {mapdata: MapData[this.data.area_name], boss: this.bossMarker});
            },
            onFavorite() {
                this.$emit('onFavorite');
            }
        },
    }
</script>

<style lang="scss" scoped>
.boss-timer.root td.alert { background-color: $cr-cancel; color: white; }
.boss-timer.root:hover { background-color: #B2DFDB; }
.type-1 { color: blue; }
.type-2 { color: purple; }
</style>