'use strict'

class UserInfo {
    constructor(sock, userinfo) {
        this.sock = sock;
        this.info = userinfo;
    }
}

module.exports = UserInfo;