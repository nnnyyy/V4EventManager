<template>
        <tr v-if="top" class="boss-timer root top">
            <template v-if="!$store.state.isMobileSize">
                <td :class="[getAlignCls('area')]" style="width: 150px;" class="btn" @click="onAlign('area')">지역</td>
                <td :class="[getAlignCls('field')]" style="width: 180px;" class="btn" @click="onAlign('field')">필드</td>
                <td :class="[getAlignCls('bossname')]" style="width: 130px;" class="btn" @click="onAlign('bossname')">보스</td>
                <td :class="[getAlignCls('bosstype')]" style="width: 150px;" class="btn" @click="onAlign('bosstype')">타입</td>
                <td style="min-width: 100px;">쿨타임(분)</td>
                <td style="min-width: 170px;">컷 시간</td>
                <td style="width: 150px;">예상 젠 시간</td>
                <td :class="[getAlignCls('remain')]" style="width: 130px;" class="btn" @click="onAlign('remain')">남은 시간</td>
                <td style="width: 100px;">컷</td>
                <td style="width: 100px;">즐겨찾기</td>
            </template>            
            <template v-else>
                <td :class="[getAlignCls('area')]" class="btn" @click="onAlign('area')">지역</td>
                <td :class="[getAlignCls('bossname')]" class="btn" @click="onAlign('bossname')">보스</td>                
                <td :class="[getAlignCls('remain')]" style="width: 160px;" class="btn" @click="onAlign('remain')">컷 시간 <br/> 남은 시간</td>
                <td style="width: 80px;">컷</td>
                <td style="width: 50px;">즐겨찾기</td>                
            </template>
        </tr>
        <tr v-else class="boss-timer root">
            <td>{{data.area_name}} <i v-show="hasAreaData()" @click="onSelectArea" class="btn mgl-1 material-icons">insert_photo</i></td>
            <td v-if="!$store.state.isMobileSize" :class="[getFieldCls()]">{{data.field_name}} <i v-show="hasFieldData()" @click="onSelectField" class="btn mgl-1 material-icons">insert_photo</i></td>
            <td>{{data.boss_name}} <i v-show="hasBossData()" @click="onSelectBoss" class="btn mgl-1 material-icons" style="font-size: 16px;">my_location</i></td>
            <td v-if="!$store.state.isMobileSize" :class="[getTypeCls()]">{{getTypeName(data.type)}}</td>
            <td v-if="!$store.state.isMobileSize" style="text-align: center;">
                <div class="f-row" v-if="modifyCooltime">
                    <input type="text" style="width: 50px;" v-model="cooltime" placeholder="분 단위" />
                    <div class="mgl-1"><CustomBtn bg_confirm @listener="onModifyCooltime">수정</CustomBtn></div>
                    <div class="mgl-1"><CustomBtn bg_cancel @listener="onCancelModifyCooltime">취소</CustomBtn></div> 
                </div>
                <div v-else class="btn" @click="onMode('modifyCooltime')">{{getCooltime(data.gaptimemin)}}</div>                
            </td>
            <template v-if="!$store.state.isMobileSize">
                <td style="text-align: right;">                
                    <div><span v-if="data.autocutted"><i class="material-icons btn table-type-1-fs  autocut">autorenew</i></span>{{cutTime(data.cuttime)}} <i class="material-icons btn table-type-1-fs" @click="onMode('modifyCuttime')">create</i><i @click="onDeleteCutTime" class="btn mgl-1 material-icons alert" style="font-size: 14px;">delete</i></div>
                </td>
                <td style="text-align: center;">{{predictGenTime(data.cuttime, data.gaptimemin)}}</td>
                <td style="text-align: center;" :class="[getRemainCls(data.remain)]">{{getRemainTime(data.remain)}}</td>
            </template>            
            <template v-else>
                <td :class="[getRemainCls(data.remain)]">
                    <div class="f-col">
                        <div class="pdh-1">{{cutTime(data.cuttime)}} <i class="material-icons btn table-type-1-fs" style="color: black;" @click="onMode('modifyCuttime')">create</i><i @click="onDeleteCutTime" class="btn mgl-1 material-icons alert" style="font-size: 14px;">delete</i></div>
                        <div class="pdh-1">{{getRemainTime(data.remain)}}</div>
                    </div>
                </td>
            </template>
            <td style="text-align: center;"><CustomBtn bg_confirm @listener="onCut" :st="$store.state.isMobileSize ? '1' : '2'">지금 컷</CustomBtn></td>
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
                alignState: {
                    type: '',
                    state: 0
                },
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
            this.alignState = this.G.getAlignState();
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

                    await this.axios.post('/guild/cut', {boss_sn: this.data.sn, ch: this.G.getCurrentChannel(this)});
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

                if( remainSec <= 0 ) return 'over';

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

                    this.$EventBus.$emit('modifyCut', this.data);
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
            },
            onAlign(type) {
                if( this.alignState.type == type ) {
                    this.alignState.state++;
                    if( this.alignState.state % 3 == 0 ) {
                        this.alignState.type = '';
                        this.alignState.state = 0;
                    }
                }
                else {
                    this.alignState.type = type;
                    this.alignState.state = 1;
                }
                this.$emit('align', this.alignState)
            },
            getAlignCls(type) {
                if( type == this.alignState.type )  {                    
                    if( this.alignState.state == 1 ) return 'aligned';
                    else return 'aligned-reverse';
                }

                return '';
            },
            async onDeleteCutTime() {
                try {
                    if( this.$store.state.state < 2 ) {
                        alert('권한이 없습니다. 길드마스터에게 문의하세요.');
                        return;
                    }

                    if(this.data.cuttime == 0) {
                        alert('삭제할 컷 기록이 없습니다');
                        return;
                    }

                    if( !confirm('컷 시간을 삭제하시겠습니까?') ) return;

                    const p = await this.axios.post('/guild/deleteCutTime', {boss_sn: this.data.sn, ch: this.G.getCurrentChannel(this)})
                    if( p.data.ret != 0 ) throw p.data.ret;

                    this.$emit('onCut');
                } catch (e) {
                    alert(e);                    
                }                
            }
        },
    }
</script>

<style lang="scss" scoped>
.boss-timer.root td.alert { background-color: #F9A825; color: white; }
.boss-timer.root td.over { background-color: #FFCDD2; color: white; }
.boss-timer.root:hover { background-color: #B2DFDB; }
.type-1 { color: blue; }
.type-2 { color: purple; }
.boss-timer.root td.aligned { background-color: $cr-primary-3; }
.boss-timer.root td.aligned::after { content: ' ▼' }
.boss-timer.root td.aligned-reverse { background-color: $cr-primary-3; }
.boss-timer.root td.aligned-reverse::after { content: ' ▲' }
.autocut { position: relative; }
.autocut:hover::after { position: absolute; left:0; top: -20px; background-color: white; border: 2px solid black; @extend .pda-1; content: '오토컷에 의해 보정됨' }
</style>