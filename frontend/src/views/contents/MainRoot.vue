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
        <ModifyCutTimeWnd/>
        <div class="left pda-4" style="flex: auto;">
            <div v-if="!$store.state.isMobileSize" class="f-row f-ac pdb-2">
                <div class="mgr-3">보스 검색</div>
                <input class="type-1" type="text" v-model="ipSearchBoss" @keyup="onChangeSearchBoss">
                <div class="mgw-3">채널</div>
                <select class="type-1" v-model="selChannel" @change="onChannelChange">
                    <option :key="idx" v-for="(it,idx) in 10" :value="it">{{it}}</option>
                </select>
                <div class="mgw-3">지역</div>
                <select class="type-1" v-model="selArea" @change="onFilterChange">
                    <option value="">모두보기</option>
                    <option :key="idx" v-for="(it,idx) in areaList" :value="it">{{it}}</option>
                </select>
                <div class="mgw-3">필드</div>
                <select class="type-1" v-model="selField" @change="onFilterChange">
                    <option value="">모두보기</option>
                    <option :key="idx" v-for="(it,idx) in fieldList" :value="it">{{it}}</option>
                </select>
                <div class="mgw-3">보스</div>
                <select class="type-1" v-model="selBoss" @change="onFilterChange">
                    <option value="">모두보기</option>
                    <option :key="idx" v-for="(it,idx) in bossList" :value="it">{{it}}</option>
                </select>
                <div class="mgw-3">타입</div>
                <select class="type-1" v-model="selType" @change="onFilterChange">
                    <option value="">모두보기</option>
                    <option :key="idx" v-for="(it,idx) in typeList" :value="it">{{getTypeName(it)}}</option>
                </select>
                <div v-if="$store.state.autocut==1" class="mgw-3 autocut table-type-1-fs">오토컷 동작중</div>
                <div>{{guildinfo ? guildinfo.list.length : 0}} 명 접속중</div>
            </div>
            <div v-else>
                <div class="f-row f-ac pdb-2">
                    <div class="mgr-3">채널</div>
                    <select class="type-1" v-model="selChannel" @change="onChannelChange">
                        <option :key="idx" v-for="(it,idx) in 10" :value="it">{{it}}</option>
                    </select>
                    <div class="mgw-3">지역</div>
                    <select class="type-1" v-model="selArea" @change="onFilterChange">
                        <option value="">모두보기</option>
                        <option :key="idx" v-for="(it,idx) in areaList" :value="it">{{it}}</option>
                    </select>
                    <div v-if="$store.state.autocut==1" class="mgw-3 autocut table-type-1-fs">오토컷 동작중</div>                    
                </div>
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
                />
            </template>
            </table>
        </div>
    </div>
</PageBaseGuildMemberOnly>
</template>

<script>
import BossTimer from '../components/BossTimer';
import ModifyCutTimeWnd from '../components/ModifyCutTimeWnd';
let mFilterField = new Map();
let baklist = [];
let reloadTimeIndex = -1;
    export default {
        components: {
            BossTimer,ModifyCutTimeWnd
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
                
                areaList: [],
                fieldList: [],
                bossList: [],
                typeList: [],

                selArea: '',
                selField: '',
                selBoss: '',
                selType: '',
                selChannel: '1',
                guildinfo: null
            }
        },
        beforeCreate() {
        },
        created () {
            setInterval(this.update, 100);
            
            const filter = this.G.getFilter();
            this.selArea = filter.area;
            this.selField = filter.field;
            this.selBoss = filter.boss;
            this.selType = filter.type;

            this.loadEvent();
            window.onresize = ()=> {
                this.list = [];
                clearTimeout(reloadTimeIndex);
                reloadTimeIndex = setTimeout(()=>this.list=baklist, 300);
                if( window.innerWidth <= 600 ) this.$store.state.isMobileSize = true;
                else this.$store.state.isMobileSize = false;
            }
            this.$EventBus.$on('modifyCutComplete', ()=>this.loadEvent());
            this.$EventBus.$on('guildConnInfo', info=>this.guildinfo=info);
        },
        mounted() {
        },
        methods: {
            update() {
                this.list.forEach(async it=> {                    
                    if( it.cuttime == 0 ) it.remain = -1;
                    else {
                        if( this.$store.state.autocut == 1 ) {
                            let _ct = it.cuttime;
                            let _gapmin = it.gaptimemin;
                            let bModify = false;
                            while(this.$moment(_ct).add(_gapmin + 30, 'minutes').toDate() < Date.now()) {
                                _ct = this.$moment(_ct).add(_gapmin, 'minutes').toDate();                                                                
                                bModify = true;
                            }
                            it.cuttime = _ct;
                            if( bModify ) it.autocutted = true;
                        }
                        
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
                    this.selChannel = this.G.getCurrentChannel(this);

                    const p = await this.axios.post('/guild/loadBossEvent', {ch: this.selChannel});
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

                    const stArea = new Set();
                    const stField = new Set();
                    const stBoss = new Set();
                    const stType = new Set();

                    p.data.list.forEach(it=> {
                        baklist.push(it);
                        stArea.add(it.area_name);
                        stField.add(it.field_name);
                        stBoss.add(it.boss_name);
                        stType.add(it.type);
                        if( it.gaptimemin <= 0 ) it.gaptimemin = it.term;
                        mFilterField.set(it.field_name, {name: it.field_name, check: false});
                        it.favorite = mFavorite.has(it.sn) ? true : false;
                        
                        if( it.cuttime == 0 ) it.remain = -1;
                        else {
                            if( this.$store.state.autocut == 1 ) {
                                let _ct = it.cuttime;
                                let _gapmin = it.gaptimemin;
                                let bModify = false;
                                while(this.$moment(_ct).add(_gapmin + 30, 'minutes').toDate() < Date.now()) {
                                    _ct = this.$moment(_ct).add(_gapmin, 'minutes').toDate();                                                                
                                    bModify = true;
                                }
                                it.cuttime = _ct;
                                if( bModify ) it.autocutted = true;
                            }

                            let remain = Math.floor((this.$moment(it.cuttime).add(it.gaptimemin, 'minutes').toDate() - Date.now()) / 1000);
                            if( remain < 0) remain = 0;
                            it.remain = remain;                            
                        }
                    });

                    this.areaList = Array.from(stArea.keys());
                    this.fieldList = Array.from(stField.keys());
                    this.bossList = Array.from(stBoss.keys());
                    this.typeList = Array.from(stType.keys());

                    this.$nextTick(()=>{
                        this.onChangeSearchBoss();
                        
                        this.list = p.data.list;
                        
                        const alignState = this.G.getAlignState();                        

                        this.onFilterChange();

                        this.onAlign(alignState);
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
            onAlign(alignState) {                
                if( !alignState ) {                    
                   alignState = this.G.getAlignState();
                }

                this.G.saveAlignState(alignState);

                switch(alignState.type){
                    case 'remain': 
                    this.list.sort((a,b)=> {
                        if(a.favorite && !b.favorite) return -1;
                        if(!a.favorite && b.favorite) return 1;

                        if(a.remain == -1 ) return alignState.state == 1 ? 1 : -1;
                        if(b.remain == -1 ) return alignState.state == 1 ? -1 : 1;
                        return a.remain -  b.remain;
                    });
                    break;
                    case 'bossname': 
                    this.list.sort((a,b)=> {
                        if(a.favorite && !b.favorite) return -1;
                        if(!a.favorite && b.favorite) return 1;

                        if(a.boss_name > b.boss_name ) return alignState.state == 1 ? 1 : -1;
                        else return alignState.state == 1 ? -1 : 1;
                    });
                    break;
                    case 'field': 
                    this.list.sort((a,b)=> {
                        if(a.favorite && !b.favorite) return -1;
                        if(!a.favorite && b.favorite) return 1;

                        if(a.field_name > b.field_name ) return alignState.state == 1 ? 1 : -1;
                        else return alignState.state == 1 ? -1 : 1;
                    });
                    break;                    
                    case 'area': 
                    this.list.sort((a,b)=> {
                        if(a.favorite && !b.favorite) return -1;
                        if(!a.favorite && b.favorite) return 1;

                        if(a.area_name > b.area_name ) return alignState.state == 1 ? 1 : -1;
                        else return alignState.state == 1 ? -1 : 1;
                    });
                    break;
                    case 'bosstype': 
                    this.list.sort((a,b)=> {
                        if(a.favorite && !b.favorite) return -1;
                        if(!a.favorite && b.favorite) return 1;

                        if( a.type > b.type ) return alignState.state == 1 ? 1 : -1;
                        else return alignState.state == 1 ? -1 : 1;
                    });
                    break;
                    default:
                    this.list.sort((a,b)=> {
                        if(a.favorite && !b.favorite) return -1;
                        if(!a.favorite && b.favorite) return 1;
                        return Number(a.sn) - Number(b.sn);
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

                baklist.forEach(it=> {
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
            onFilterChange() {
                this.G.saveFilter(this.selArea, this.selField, this.selBoss, this.selType);

                let bAll = true;
                let _find = [];

                this.ipSearchBoss = '';

                if( this.selArea == '' && this.selField == '' && this.selBoss == '' && this.selType == '') {
                    this.list = baklist;
                    return;
                }

                baklist.forEach(it=> {
                    const bFind =   ( this.selArea == '' ? true : this.selArea == it.area_name ) &&
                                    ( this.selField == '' ? true : this.selField == it.field_name ) &&
                                    ( this.selBoss == '' ? true : this.selBoss == it.boss_name ) &&
                                    ( this.selType == '' ? true : this.selType == it.type );

                    if( bFind ) {
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
            getTypeName(type) {
                return type == 1 ? "특수 네임드(불완전)" : "일반 네임드"
            },
            onChannelChange() {
                this.G.saveChannel(this, this.selChannel);
                this.list = [];
                this.$nextTick(()=>this.loadEvent());
            }
        },
    }
</script>

<style lang="scss" scoped>
.left { height: calc(#{$lo-bot-height} - 16px); overflow-y: auto; }
.bossArea { @extend .animate-flicker; position: absolute; padding: 4px 8px; background-color: red; color: white; font-weight: bolder; font-size: 15px; border-radius: 4px; border: 1.5px solid black; }
.bossArea-point { position: absolute; width: 10px; height: 10px; background-color: blue; }
.autocut { position: relative; color: blue; font-weight: border; }
.autocut:hover::after { position: absolute; left: 110%; top: 0px; width: 300px; z-index: 1000; @extend .pda-1; background-color: white; border: 2px solid black; content: '예상 젠시간 + 30분이 현재시간보다 이전 시간일 경우 자동으로 시간 보정 해주는 기능. 관리자가 조작 가능.'}
</style>