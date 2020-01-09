<template>
<PageBaseGuildMemberOnly>
    <div class="f-row">
        <PermanentWnd :show="fullsizeMap" @onClick="onCloseFullSizeMap">
            <div>
                <img @click="onClickFullSizeImage($event)" :src="fullsizeMapSrc"/>
            </div>
        </PermanentWnd>
        <div class="left pda-4" style="flex: auto;">
            <div v-show="false" class="f-row f-wrap">
                <div class="pda-1" style="width: 160px;" v-for="it in filter_field"><input type="checkbox" v-model="it.check" @change="onChangeFieldFilter">{{it.name}}</div>
            </div>
            <table class="type-1">
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
                filter_field: []
            }
        },
        created () {
            setInterval(this.update, 100);
            this.loadEvent();            
        },
        methods: {
            update() {
                this.list.forEach(it=> {                    
                    if( it.cuttime == 0 ) it.remain = -1;
                    else {
                        let remain = Math.floor((this.$moment(it.cuttime).add(it.gaptimemin, 'minutes').toDate() - Date.now()) / 1000);
                        if( remain < 0) remain = 0;
                        it.remain = remain;
                    }
                })
            },
            async loadEvent() {
                try {
                    const p = await this.axios.post('/guild/loadBossEvent');
                    this.list = [];           
                    this.filter_field = [];
                    baklist = [];
                    mFilterField = new Map();

                    let _f = localStorage.getItem("favorite");
                    if( !_f ) _f = [];
                    else _f = JSON.parse(_f);
                    const mFavorite = new Map();
                    _f.forEach(sn=>mFavorite.set(sn));

                    p.data.list.forEach(it=> {
                        baklist.push(it);
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
                        this.onAlign(this.align);
                    })
                } catch (e) {
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
                this.onFullSizeMap(mapdata.src);
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
            },
            onFullSizeMap(src) {
                this.fullsizeMapSrc = src;
                this.fullsizeMap = true;
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
                let _f = localStorage.getItem("favorite");                
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

                localStorage.setItem('favorite', JSON.stringify(_f));
                this.onAlign();
            }
        },
    }
</script>

<style lang="scss" scoped>
.left { height: calc(#{$lo-bot-height} - 16px); overflow-y: auto; }
</style>