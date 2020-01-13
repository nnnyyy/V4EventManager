<template>
<PageBaseGuildMemberOnly>
    <div class="f-row">
        <PermanentWnd :show="fullsizeMap" @onClick="onCloseFullSizeMap">
            <div :style="mapDivStyle" class="pos-rel f-row f-jc f-ac">
                <img :style="mapDivStyle" @click="onClickFullSizeImage($event)" :src="fullsizeMapSrc"/>   
                <div v-if="bossData" class="bossArea" :style="getBossDataStyle(bossData)">{{bossData.name}}</div>
                <div v-if="bossData" class="bossArea-point" :style="getBossDataStyle(bossData)"></div>             
            </div>
        </PermanentWnd>
        <PermanentWnd :show="modifying" @onClick="modifying=!modifying">
            <div @click="$event.stopPropagation()" class="pda-3" style="width: 600px; height: auto; background-color: white; color: black; border-radius: 4px; border: 1px solid black;">                
                <div class="mgb-2" style="font-size: 24px;">컷 타임 수정</div>
                <div>{{modifyData.dimention_name}} > {{modifyData.area_name}} > {{modifyData.field_group}} > <span style="font-size: 20px;">{{modifyData.boss_name}}</span></div>
                <div class="mgt-2">
                    <div>기존 컷 예상시간 : {{$moment(modifyData.cuttime).format("YYYY년 MM월 DD일 HH시 mm분")}}</div>
                    <div>수정 컷 시간 : {{$moment(modifyData.cuttime).format("YYYY년")}} 
                        <input type="text" style="width:30px; text-align: right;" v-model="dateModify.MM" @change="onChangeCutTime"/>월 
                        <input type="text" style="width:30px; text-align: right;" v-model="dateModify.DD" @change="onChangeCutTime"/>일 
                        <input type="text" style="width:30px; text-align: right;" v-model="dateModify.HH" @change="onChangeCutTime"/>시 
                        <input type="text" style="width:30px; text-align: right;" v-model="dateModify.mm" @change="onChangeCutTime"/>분
                    </div>
                </div>
                <div class="mgh-3" style="font-size: 20px">수정 후 예상 젠 시간 : {{getPredictGenTime()}}</div>
                <div class="mgt-2 f-row f-wrap">
                    <div><CustomBtn bg_confirm @listener="onModifyCutTime">수정하기</CustomBtn></div>
                </div>
            </div>
        </PermanentWnd>
        <div class="left pda-4" style="flex: auto;">
            <div v-if="!$store.state.isMobileSize" class="f-row f-ac pdb-2">
                <div class="mgr-3">보스 검색</div>
                <input class="type-1" type="text" v-model="ipSearchBoss" @keyup="onChangeSearchBoss">
            </div>
            <div v-show="false" class="f-row f-wrap">
                <div class="pda-1" style="width: 160px;" :key="idx" v-for="(it,idx) in filter_field"><input type="checkbox" v-model="it.check" @change="onChangeFieldFilter">{{it.name}}</div>
            </div>
            <table class="type-1" style="width: auto;">
                <BossTimer top=true @align="onAlign" />
            <template v-for="(it,idx) in list">
                <BossTimer :key="idx" :data="it" 
                @onFavorite="onFavorite(it)" 
                @onCut="onCut" 
                @onCooltime="onCooltime" 
                @onSelectField="onSelectField" 
                @modifyCut="onModifyCut"
                />
            </template>
            </table>
        </div>
    </div>
</PageBaseGuildMemberOnly>
</template>

<script>
import BossTimer from '../components/BossTimer';
let mFilterField = new Map();
let baklist = [];
let reloadTimeIndex = -1;
    export default {
        components: {
            BossTimer
        },
        data() {
            return {
                list: [],                
                align: '',
                mapinfo: {field: '파멸의 범람지'},
                fullsizeMap: false,
                fullsizeMapSrc: '',
                bossData: null,
                filter_field: [],
                mapDivStyle: {},
                ipSearchBoss: '',
                modifyData: {},
                modifying: false,
                dateModify: {
                    MM: '1',
                    DD: '1',
                    HH: '0',
                    mm: '0'
                },
                predictGenTime: ''
            }
        },
        beforeCreate() {
        },
        created () {
            setInterval(this.update, 100);
            this.loadEvent();
            window.onresize = ()=> {
                this.list = [];
                clearTimeout(reloadTimeIndex);
                reloadTimeIndex = setTimeout(()=>this.list=baklist, 300);
                if( window.innerWidth <= 600 ) this.$store.state.isMobileSize = true;
                else this.$store.state.isMobileSize = false;
            }
        },
        mounted() {
        },
        methods: {
            update() {
                this.list.forEach(async it=> {                    
                    if( it.cuttime == 0 ) it.remain = -1;
                    else {
                        let remain = Math.floor((this.$moment(it.cuttime).add(it.gaptimemin, 'minutes').toDate() - Date.now()) / 1000);
                        if( remain < 0)  {
                            remain = 0;
                        }
                        
                        if( it.remain != 0 && remain == 0 ) {
                            /*
                            const ret = await Notification.requestPermission();
                            if( ret == 'granted') {
                                let noti = new Notification("v4 보스 관리기 알람", {body: `[${it.boss_name}] 보스가 뜰 시간이에요!`});
                                setTimeout(()=>noti.close(),10000);
                            } 
                            */                           
                        }
                        it.remain = remain;
                    }
                })
            },
            async loadEvent() {
                try {
                    const p = await this.axios.post('/guild/loadBossEvent');
                    if(p.data.ret != 0) throw p.data.ret;
                    this.list = [];           
                    this.filter_field = [];
                    baklist = [];
                    mFilterField = new Map();

                    let _f = localStorage.getItem(`favorite${this.$store.state.guild}`);
                    if( !_f ) _f = [];
                    else _f = JSON.parse(_f);
                    const mFavorite = new Map();
                    _f.forEach(sn=>mFavorite.set(sn));

                    p.data.list.forEach(it=> {
                        baklist.push(it);
                        if( it.gaptimemin <= 0 ) it.gaptimemin = it.term;
                        mFilterField.set(it.field_name, {name: it.field_name, check: false});
                        it.favorite = mFavorite.has(it.sn) ? true : false;
                        
                        if( it.cuttime == 0 ) it.remain = -1;
                        else {
                            let remain = Math.floor((this.$moment(it.cuttime).add(it.gaptimemin, 'minutes').toDate() - Date.now()) / 1000);
                            if( remain < 0) remain = 0;
                            it.remain = remain;
                        }
                    });

                    this.$nextTick(()=>{
                        this.onChangeSearchBoss();
                        
                        this.list = p.data.list;
                        
                        this.align = localStorage.getItem('align') || '';

                        this.onAlign(this.align, true);
                    });                    

                    //const ret = await Notification.requestPermission();
                    //if( ret == 'denied') return;
                } catch (e) {
                    if( e == -1 || e == -2 || e == -101 ) return;
                    alert(e);
                }
            },
            onCut() {
                this.loadEvent();                
            },
            onCooltime() {
                this.loadEvent();
            },
            onSelectField(mapdata) {
                this.bossData = null;
                this.onFullSizeMap(mapdata.mapdata.src, mapdata.boss);
            },
            getBossDataStyle(boss) {
                return {
                    "left": `${boss.x}%`,
                    "top": `${boss.y}%`
                }
            },
            onAlign(type, bInit) {
                if( !bInit && this.align == type ) type = '';
                else if(!type) type = this.align;
                this.align = type;

                localStorage.setItem('align', this.align);

                switch(type){
                    case 'remain': 
                    this.list.sort((a,b)=> {
                        if(a.favorite && !b.favorite) return -1;
                        if(!a.favorite && b.favorite) return 1;

                        if(a.remain == -1 ) return 1;
                        if(b.remain == -1 ) return -1;
                        return a.remain -  b.remain;
                    });
                    break;
                    default:                   
                    this.list.sort((a,b)=> {
                        if(a.favorite && !b.favorite) return -1;
                        if(!a.favorite && b.favorite) return 1;
                        return a.sn - b.sn;
                    })
                    break;
                }                
            },
            onFullSizeMap(src, boss) {
                const _img = new Image();
                _img.onload = ()=> {
                    const v = _img.width / _img.height;
                    _img.height = window.innerHeight * 0.85;
                    _img.width = _img.height * v;
                    this.mapDivStyle = {
                        width: `${_img.width}px`,
                        height: `${_img.height}px`
                    }
                    this.fullsizeMapSrc = src;
                    this.fullsizeMap = true;
                    this.bossData = boss;
                };
                _img.src = src;
                
            },
            onCloseFullSizeMap() {
                this.fullsizeMap = false;
            },
            onClickFullSizeImage(e) {                
                e.stopPropagation();
            },
            onChangeFieldFilter() {
                let bAll = true;
                this.filter_field.forEach(it=>{
                    if( it.check ) bAll = false;
                });

                if( bAll )  {
                    this.list = baklist;
                    return;
                }

                this.list = baklist.filter(it=> {
                    if(!mFilterField.get(it.field_name).check) return false;

                    return true;
                })
            },
            onFavorite(item) {
                let _f = localStorage.getItem(`favorite${this.$store.state.guild}`);                
                if( !_f ) _f = [];                        
                else _f = JSON.parse(_f);        
                if( _f.indexOf(item.sn) != -1 ) {
                    _f.splice(_f.indexOf(item.sn), 1);
                    item.favorite = false;
                }
                else {
                    _f.push(item.sn);
                    item.favorite = true;
                }

                localStorage.setItem(`favorite${this.$store.state.guild}`, JSON.stringify(_f));
                this.onAlign();
            },
            getMapDivStyle() {
                
            },
            onChangeSearchBoss() {
                let bAll = true;
                let _find = [];

                if( this.ipSearchBoss.trim() == '') {
                    this.list = baklist;
                    return;
                }

                this.list.forEach(it=> {
                    if( it.boss_name.indexOf(this.ipSearchBoss.trim()) != -1 ) {
                        _find.push(it);
                        bAll = false;
                    }
                })

                if( bAll )  {
                    this.list = baklist;
                    return;
                }

                this.list = _find;
            },
            onModifyCut(data) {         
                this.modifying = true;       
                this.modifyData = data;
                var md = this.$moment(this.modifyData.cuttime);
                this.dateModify.MM = md.format("MM");
                this.dateModify.DD = md.format("DD");
                this.dateModify.HH = md.format("HH");
                this.dateModify.mm = md.format("mm");
                this.onChangeCutTime();
            },
            async onModifyCutTime() {
                try {
                    var md = this.$moment(this.modifyData.cuttime);
                    let YYYY = md.format('YYYY');
                    let MM = this.G.pad(Number(this.dateModify.MM),2);
                    let DD = this.G.pad(Number(this.dateModify.DD),2);
                    let HH = this.G.pad(Number(this.dateModify.HH),2);
                    let mm = this.G.pad(Number(this.dateModify.mm),2);

                    let d = new Date(`${YYYY}-${MM}-${DD} ${HH}:${mm}`);
                    if( d == 'Invalid Date') {
                        this.predictGenTime = d;
                        alert('시간이 잘못 되었습니다');
                        return;
                    }

                    const modifyDate = this.$moment(d).format('YYYY-MM-DD HH:mm:ss');
                    const p = await this.axios.post('/guild/modifyCutTime', {boss_sn: this.modifyData.sn, modifydate: modifyDate });
                    if( p.data.ret != 0 ) throw p.data.ret;

                    this.loadEvent();
                    this.modifying = false;
                } catch (e) {
                    alert(e);                    
                    this.modifying = false;
                }
            },
            onChangeCutTime() {
                var md = this.$moment(this.modifyData.cuttime);
                let YYYY = md.format('YYYY');
                let MM = this.G.pad(Number(this.dateModify.MM),2);
                let DD = this.G.pad(Number(this.dateModify.DD),2);
                let HH = this.G.pad(Number(this.dateModify.HH),2);
                let mm = this.G.pad(Number(this.dateModify.mm),2); 

                let d = new Date(`${YYYY}-${MM}-${DD} ${HH}:${mm}`);
                if( d == 'Invalid Date') {
                    this.predictGenTime = d;
                    return;
                }
                
                this.predictGenTime = this.$moment(d).add(this.modifyData.gaptimemin, 'minutes').format('YYYY년 MM월 DD일 HH시 mm분');
            },
            getPredictGenTime() {
                return this.predictGenTime;
            }
        },
    }
</script>

<style lang="scss" scoped>
.left { height: calc(#{$lo-bot-height} - 16px); overflow-y: auto; }
.bossArea { @extend .animate-flicker; position: absolute; padding: 4px 8px; background-color: red; color: white; font-weight: bolder; font-size: 15px; border-radius: 4px; border: 1.5px solid black; }
.bossArea-point { position: absolute; width: 10px; height: 10px; background-color: blue; }
</style>