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
                <BossTimer :key="idx" :data="it" @onFavorite="onFavorite(it)" @onCut="onCut" @onCooltime="onCooltime" @onSelectField="onSelectField" />
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
                ipSearchBoss: ''
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
                            const ret = await Notification.requestPermission();
                            if( ret == 'granted') {
                                let noti = new Notification("v4 보스 관리기 알람", {body: `[${it.boss_name}] 보스가 뜰 시간이에요!`});
                                setTimeout(()=>noti.close(),10000);
                            }                            
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

                    Array.from(mFilterField.keys()).forEach(it=>{
                        this.filter_field.push(mFilterField.get(it));
                    })

                    this.$nextTick(()=>{
                        this.list = p.data.list;
                        this.align = localStorage.getItem('align') || '';
                        this.onAlign(this.align);

                        this.onChangeSearchBoss();
                    });                    

                    const ret = await Notification.requestPermission();
                    if( ret == 'denied') return;
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
            onAlign(type) {
                if( this.align == type ) type = '';
                else if(!type) type = this.align;
                this.align = type;
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

                localStorage.setItem('align', this.align);
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
            }
        },
    }
</script>

<style lang="scss" scoped>
.left { height: calc(#{$lo-bot-height} - 16px); overflow-y: auto; }
.bossArea { @extend .animate-flicker; position: absolute; padding: 4px 8px; background-color: red; color: white; font-weight: bolder; font-size: 15px; border-radius: 4px; border: 1.5px solid black; }
.bossArea-point { position: absolute; width: 10px; height: 10px; background-color: blue; }
</style>