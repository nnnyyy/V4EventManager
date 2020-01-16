const Logger = require('../Components/Logger');
const UserInfo = require('./User');
const db = require('../Lib/MYSQL');

class ServerManager {
    constructor() {        
    }

    init(io) {
        return new Promise( async (res,rej)=> {
            try {
                await this.initSvrSettings();
                
                this.mUsers = new Map();
                this.io = io;
                this.io.on('connection', sock=> { this.connUser(sock) });                

                setInterval(()=>{ this.update(new Date()); }, 400);

                res();
            }catch(e) {
                Logger.error(`server init error - ${e.toString()}`);
                rej(e);
            }            
        })        
    }

    connUser(sock) {
        try {
            const userinfo = sock.handshake.session.userinfo;
            if( !userinfo ) throw -1;

            const newConnUser = new UserInfo(sock, userinfo);
            this.mUsers.set(userinfo.sn, newConnUser);

            sock.on('disconnect', ()=>{ this.disconnUser(sock, userinfo.sn) });

        } catch (e) {            
            Logger.error(`wrong connection ( ip: ${this.getIP(sock)} )`);
        }       
    }

    disconnUser(sock, id) {
        try {
            if( this.mUsers.has(id) ) this.mUsers.delete(id);
        } catch (e) {
            Logger.error(`wrong disconnect ( ip: ${this.getIP(sock)} )`);
        }
    }

    getIP(socket) {
        let ip = socket.handshake.address.substr(7);
        if( socket.handshake.headers['x-real-ip'] != null ) {
            ip = socket.handshake.headers['x-real-ip'];
        }
        return ip;
    }

    async update(tCur) {
        if( tCur - this.tLastUpdateAuto >= 10 * 60 * 1000 ) {
            this.tLastUpdateAuto = tCur;
            try {
                await db.query(`insert into connectors (regdate, conn) values (now(), ${this.mUsers.size})`, "stats");
            } catch (e) {
                console.log(e);
            }            
        }
    }

    initListener(io) {
        return new Promise((res,req)=> {                        
        })        
    }

    initSvrSettings() {
        return new Promise(async (res,rej)=> {
            try {
                this.tLastUpdateAuto = 0;
                res();                
            } catch (e) {
                rej();
            }
        })                
    }    
}

const _obj = new ServerManager();

module.exports = _obj;