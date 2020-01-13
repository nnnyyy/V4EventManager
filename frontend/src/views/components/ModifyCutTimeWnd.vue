<template>
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
</template>

<script>
    export default {        
        data() {
            return {
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
        created () {
            this.$EventBus.$on('modifyCut', this.onModifyCut);
        },
        methods: {            
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

                    this.$EventBus.$emit('modifyCutComplete');
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
            } 
        },    
    }
</script>

<style lang="scss" scoped>

</style>