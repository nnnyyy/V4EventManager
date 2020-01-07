class GlobalVariables {
    constructor() {
        this.initAds();
    }

    connectTCP() {
        /* eslint-disable */
        this.socket = io();
        /* eslint-enable */
    }

    initAds() {
        this.adfitAds320x50 = [
            { unitId: 'DAN-s1b3jz67qqm0', width: '320', height: '50' },
            { unitId: 'DAN-t87e91n4i053', width: '320', height: '50' },
            { unitId: 'DAN-uvjqvmlqkb3k', width: '320', height: '50' },
            { unitId: 'DAN-1ib0ex8crqnvq', width: '320', height: '50' },
        ]

        this.adfitAds320x100 = [
            { unitId: 'DAN-s4univ46zz1w', width: '320', height: '100' },
            { unitId: 'DAN-urpo5nnk32w6', width: '320', height: '100' },
            { unitId: 'DAN-r1aju9ruxxdf', width: '320', height: '100' },
        ]

        this.adfitAds300x250 = [
            { unitId: 'DAN-toa38tjxzs4z', width: '300', height: '250' },
        ]

        this.adfitAds728x90 = [
            { unitId: 'DAN-u7zlx6cgdt81', width: '728', height: '90' },
        ]

        this.adsense320x50 = [
            { adSlot: '2474065421', adStyle: 'display:inline-block;width:320px;height:50px;', fullWidthResponsive: 'false' },
        ]

        this.adsense320x100 = [
            { adSlot: '2407753256', adStyle: 'display:inline-block;width:320px;height:100px;', adFormat: 'auto', fullWidthResponsive: 'false' },
            { adSlot: '5013925241', adStyle: 'display:inline-block;width:320px;height:100px;', adFormat: 'auto', fullWidthResponsive: 'false' },
            { adSlot: '5230481818', adStyle: 'display:inline-block;width:320px;height:100px;', adFormat: 'auto', fullWidthResponsive: 'false' },
        ]

        this.adsenseLinkAuto = [
            { adSlot: '1290232183', adStyle: 'display:block; height: 100%;', adFormat: 'link', fullWidthResponsive: 'true' },
        ];
    }

    isMobile() {
        if (/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)) {
            // is mobile..
            return true;
        }

        return false;
    }

    numberFormat(inputNumber) {
        return inputNumber.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }

    pad(n, width, z) {
        z = z || '0';
        n = n + '';
        return n.length >= width ? n : new Array(width - n.length + 1).join(z) + n;
    }
}

const _obj = new GlobalVariables();

export default _obj;