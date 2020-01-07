<template>
    <div>
        <div class="v-col" v-for="it in list">
            <BossTimer :data="it" />
        </div>
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
            this.list.push({group: '데커드 화산', field: '배반자의 소굴', name: '라빌린', cuttime: '2020-01-07 12:00:00', genterm: 3 * 60 * 60 * 1000, type: 0 });            
            this.list.push({group: '데커드 화산', field: '배반자의 소굴', name: '라빌린', cuttime: '2020-01-07 12:00:00', genterm: 3 * 60 * 60 * 1000, type: 1 });
            this.list.push({group: '데커드 화산', field: '배반자의 소굴', name: '라빌린', cuttime: '2020-01-07 12:00:00', genterm: 3 * 60 * 60 * 1000, type: 1 });
            this.list.push({group: '데커드 화산', field: '배반자의 소굴', name: '라빌린', cuttime: '2020-01-07 12:00:00', genterm: 3 * 60 * 60 * 1000, type: 1 });
            this.list.push({group: '데커드 화산', field: '배반자의 소굴', name: '라빌린', cuttime: '2020-01-07 12:00:00', genterm: 3 * 60 * 60 * 1000, type: 1 });
        },
    }
</script>

<style lang="scss" scoped>

</style>