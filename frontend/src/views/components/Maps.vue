<template>
    <div>
        <div>
            <img @click="onFullSize" :src="getSrc()" style="max-width: 280px;" />
        </div>        
    </div>
</template>

<script>
import {MapData} from '@/js/MapData';
    export default {
        props: [ 'info' ],
        data() {
            return {
                mapdata: MapData
            }
        },
        methods: {
            getSrc() {
                if( !this.mapdata[this.info.field] ) {
                    return "";
                }

                return this.mapdata[this.info.field].src;
            },
            onFullSize() {
                this.$emit('onFullSizeMap', this.getSrc());
            }
        },
    }
</script>

<style lang="scss" scoped>

</style>