const Logger = require('../Components/Logger');
const UserInfo = require('./User');
const db = require('../Lib/MYSQL');
const GuildManager = require('./GuildManager');

class ServerManager {
    constructor() {        
    }

    init(io) {
        return new Promise( async (res,rej)=> {
            try {
                await this.initSvrSettings();                
                
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

    async connUser(sock) {
        try {
            const userinfo = sock.handshake.session.userinfo;
            if( !userinfo ) throw -1;

            const pUser = await db.query(`select nick, permission_level from account where sn = ${userinfo.sn}`);
            const plv = pUser.rows[0].permission_level;

            if( plv == 1 ) {
                sock.join('admin');
            }

            const newConnUser = new UserInfo(sock, userinfo);
            this.mUsers.set(userinfo.sn, newConnUser);
            this.mSockets.set(sock.id);

            this.guildMan.add(newConnUser);

            sock.on('disconnect', ()=>{ this.disconnUser(sock, userinfo.sn) });

        } catch (e) {            
            Logger.error(`wrong connection ( ip: ${this.getIP(sock)} )`);
        }       
    }

    disconnUser(sock, id) {
        try {
            if( this.mUsers.has(id) ) {
                const user = this.mUsers.get(id);
                
                this.guildMan.remove(user);
                this.mUsers.delete(id);                
            };
            this.mSockets.delete(sock.id);
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
        if( tCur - this.tLastAdmin >= 1 * 1000 ) {
            this.tLastAdmin = tCur;
            this.io.to('admin').emit('guildinfo', {info: this.guildMan.getGuildInfo(), sockCnt: this.mSockets.size });
        }

        if( tCur - this.tLastGuildInfo >= 5 * 1000 ) {
            this.tLastGuildInfo = tCur;
            this.mUsers.forEach(user=>{
                const guildinfo = this.guildMan.getUserGuildInfo(user);
                this.sendPacket(user.sock, 'guildConnInfo', guildinfo);
            })
        }

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
                this.mUsers = new Map();
                this.mSockets = new Map();
                this.guildMan = new GuildManager(this);
                this.tLastUpdateAuto = 0;
                this.tLastAdmin = 0;
                this.tLastGuildInfo = 0;
                res();                
            } catch (e) {
                rej();
            }
        })                
    }

    sendPacket( sock, event, packet ) {
        sock.emit(event, packet);
    }
}

const _obj = new ServerManager();

module.exports = _obj;