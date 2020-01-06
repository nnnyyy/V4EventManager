<template>
    <div id="ads-area">
        <ins class="kakao_ad_area" style="display:none;width:100%;height:auto;"
             :data-ad-unit    = "info.unitId"
             :data-ad-width   = "info.width"
             :data-ad-height  = "info.height"></ins>
        <div v-el:scriptHolder></div>
    </div>
</template>

<script>
    import $ from 'jquery';
    export default {
        props: ['info'],
        data: function () {
            return {
                
            };
        },
        methods: {},
        created() {            
        },
        mounted() {            
            $(document).ready(() => {
                let scriptEl = document.createElement('script');
                scriptEl.setAttribute('src', '//t1.daumcdn.net/adfit/static/ad.min.js');
                scriptEl.async = true;
                document.head.appendChild(scriptEl);
                document.body.appendChild(scriptEl);
            });
        },
        components: {}
    }
</script>

<style>
</style>

<style scoped>
    #ads-area { padding: 0; }
</style>