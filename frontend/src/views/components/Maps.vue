<template>
    <div>
        <div>
            <img @click="onFullSize" :src="getSrc()" style="max-width: 500px;" />
        </div>        
    </div>
</template>

<script>    
    export default {
        props: [ 'info' ],
        data() {
            return {
                mapdata: {
                    "파멸의 범람지": { src: "/images/maps/파멸의범람지.jpg" },
                    "파멸폐광": { src: "/images/maps/파멸폐광.jpg" },
                    "파멸 폭포": { src: "/images/maps/파멸폭포.jpg" },
                    "파멸요새": { src: "/images/maps/파멸요새.jpg" },
                    "파멸 그루터기": { src: "/images/maps/파멸그루터기.jpg" },
                    "허상의고원": { src: "/images/maps/허상.jpg" },
                }
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