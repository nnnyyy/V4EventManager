<template>
    <div class="f-row">
        <PermanentWnd :show="fullsizeMap" @onClick="onCloseFullSizeMap">
            <div>
                <img @click="onClickFullSizeImage($event)" :src="fullsizeMapSrc"/>
            </div>
        </PermanentWnd>
        <div class="left pda-4" style="flex: 1 0 auto;">
            <table class="type-1">
                <BossTimer top=true @align="onAlign" />
            <template v-for="(it,idx) in list">
                <BossTimer :key="idx" :data="it" @onCut="onCut" @onCooltime="onCooltime" @onSelectField="onSelectField" />
            </template>
            </table>
        </div>
        <div class="pda-4" style="flex: 0 0 600px;">
            <Maps :info="mapinfo" @onFullSizeMap="onFullSizeMap" />
        </div>
    </div>
</template>

<script>
import BossTimer from '../components/BossTimer';
import Maps from '../components/Maps';
    export default {
        components: {
            BossTimer,Maps
        },
        data() {
            return {
                list: [],
                baklist: [],
                align: '',
                mapinfo: {field: '파멸의 범람지'},
                fullsizeMap: false,
                fullsizeMapSrc: ''
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
                    p.data.list.forEach(it=> {
                        if( it.cuttime == 0 ) it.remain = -1;
                        else {
                            let remain = Math.floor((this.$moment(it.cuttime).add(it.gaptimemin, 'minutes').toDate() - Date.now()) / 1000);
                            if( remain < 0) remain = 0;
                            it.remain = remain;
                        }
                    })
                    this.$nextTick(()=>{
                        this.list = p.data.list;
                        this.baklist = p.data.list;
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
            onSelectField(fieldname) {
                this.mapinfo.field = fieldname;
            },
            onAlign(type) {
                if( this.align == type ) type = '';
                this.align = type;
                switch(type){
                    case 'remain': 
                    this.list.sort((a,b)=> {
                        if(a.remain == -1 ) return 1;
                        if(b.remain == -1 ) return -1;
                        return a.remain -  b.remain;
                    });
                    break;
                    default: 
                    this.list.sort((a,b)=> {
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
            }
        },
    }
</script>

<style lang="scss" scoped>
.left { height: calc(#{$lo-bot-height} - 32px); overflow-y: auto; }
</style>