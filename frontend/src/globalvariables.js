class GlobalVariables {
    constructor(ebus) {
        this.initAds();
        this.ebus = ebus;
    }

    connectTCP() {
        /* eslint-disable */
        this.socket = io({autoConnect: true});
        this.socket.on('guildinfo', packet=> {
            this.ebus.$emit('guildinfo', packet);
        })
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

    isIE() {
        var ua = window.navigator.userAgent;
        var msie = ua.indexOf("MSIE ");

        if (msie > 0 || !!navigator.userAgent.match(/Trident.*rv\:11\./))  // If Internet Explorer, return version number
        {
            //alert(parseInt(ua.substring(msie + 5, ua.indexOf(".", msie))));
            return true;
        }
        else  // If another browser, return 0
        {
            //alert('otherbrowser');
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

    getCurrentChannel(v) {
        return localStorage.getItem(`${v.$store.state.guild}-cur-ch`) || "1";
    }

    saveChannel(v,ch) {
        localStorage.setItem(`${v.$store.state.guild}-cur-ch`, ch);
    }

    saveFilter(area, field, boss, type) {
        localStorage.setItem(`filter`, JSON.stringify({area: area, field: field, boss: boss, type: type}));
    }

    getFilter() {
        const f = localStorage.getItem(`filter`);
        if( !f ) return { area: '', field: '', boss: '', type: '' }
        try {
            const _parse = JSON.parse(f);
            return _parse;
        } catch(e) {
            return { area: '', field: '', boss: '', type: '' }
        }
    }

    getAlignState() {
        const a = localStorage.getItem('align');
        try {            
            const _parse = JSON.parse(a);            
            if( _parse.type == 'undefined' ) throw -1;
            return _parse;
        } catch (e) {
            return { type: 'remain', state: 1 };
        }
    }

    saveAlignState(obj) {
        localStorage.setItem('align', JSON.stringify(obj));
    }
}

export default GlobalVariables;