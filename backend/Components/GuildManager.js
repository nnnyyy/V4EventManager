const db = require('../Lib/MYSQL');
const GetUserInfo2 = require('../routes/commonFunc').GetUserInfo2;

class GuildManager {
    constructor(sm) {
        this.mGuild = new Map();
        this.ServMan = sm;
    }

    async add(user) {
        try {
            if( user.info.guild == -1 ) return;

            const userinfo = await GetUserInfo2(user.sock.handshake.session);

            if( !this.mGuild.has(userinfo.guild) ) {
                const mGuildUser = new Map();
                const pGuild = await db.query(`select * from guild where sn = ${userinfo.guild}`);
                if( pGuild.rows.length <= 0 ) return;

                mGuildUser.set(user.info.sn, user);
                this.mGuild.set(userinfo.guild, {info: pGuild.rows[0], users: mGuildUser} );
            }
            else {
                this.mGuild.get(userinfo.guild).users.set(user.info.sn, user);
            }            
        } catch (e) {
            console.log(e);            
        }
    }

    remove(user) {
        if( !this.mGuild.has(user.info.guild) ) return;

        const mUsers = this.mGuild.get(user.info.guild).users;
        if( mUsers.has(user.info.sn) ) mUsers.delete(user.info.sn);
    }

    getGuildInfo() {
        const vals = Array.from( this.mGuild.values() );
        const list = [];
        for( let idx in vals ) {
            const it = vals[idx];
            list.push({ guildname: it.info.guildname, users: it.users.size });
        }

        return list;
    }
}

module.exports = GuildManager;