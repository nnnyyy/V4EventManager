<template>
    <div class="pda-4">
        <table class="type-1">
            <BossTimer top=true />
        <template v-for="(it,idx) in list">
            <BossTimer :key="idx" :data="it" @onCut="onCut" />
        </template>
        </table>
    </div>
</template>

<script>
import BossTimer from '../components/BossTimer';
    export default {
        components: {
            BossTimer,
        },
        data() {
            return {
                list: []
            }
        },
        created () {
            setInterval(this.update, 100);
            this.loadEvent();            
        },
        methods: {
            update() {
                this.list.forEach(it=> {
                    if( it.cuttime == 0 ) it.remain = 0;
                    else {
                        it.remain = Math.floor((this.$moment(it.cuttime).add(it.gaptimemin, 'minutes').toDate() - Date.now()) / 1000);
                    }
                })
            },
            async loadEvent() {
                try {
                    const p = await this.axios.post('/guild/loadBossEvent');
                    this.list = [];
                    p.data.list.forEach(it=> {
                        if( it.cuttime == 0 ) it.remain = 0;
                        else {
                            it.remain = Math.floor((this.$moment(it.cuttime).add(it.gaptimemin, 'minutes').toDate() - Date.now()) / 1000);
                        }
                    })
                    this.$nextTick(()=>{
                        this.list = p.data.list;
                    })
                } catch (e) {
                    alert(e);
                }
            },
            onCut() {
                this.loadEvent();                
            }
        },
    }
</script>

<style lang="scss" scoped>

</style>