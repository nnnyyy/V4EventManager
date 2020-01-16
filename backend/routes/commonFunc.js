const db = require('../Lib/MYSQL');

exports.ErrorProc = function(res, e) {
    if (e instanceof Error) { res.send({ ret: -99, err: e.message }) }
    else if (typeof (e) == 'number') { res.send({ ret: e }) }
    else {
        Logger.error(e.toString());
        res.send({ ret: -100 });
    }
}

exports.GetUserInfo = function(req) {
    return new Promise(async (res,rej)=> {
        if( !req.session.userinfo ) rej(-101);
        else {
            try {
                const pUserGuild = await db.query(`select * from user_guild u left join guild g on u.guild_sn = g.sn where user_sn = ${req.session.userinfo.sn}`);
                if( pUserGuild.rows.length <= 0 ) throw -2;
                const userGuildInfo = pUserGuild.rows[0];

                const pUser = await db.query(`select nick, permission_level from account where sn = ${req.session.userinfo.sn}`);
                const nick = pUser.rows[0].nick;
                const plv = pUser.rows[0].permission_level;

                let info = {
                    sn: req.session.userinfo.sn,
                    guild: userGuildInfo.guild_sn,
                    guildname: userGuildInfo.guildname ? userGuildInfo.guildname : '',
                    autocut: userGuildInfo.autocut ? userGuildInfo.autocut : 0,
                    nick : nick,
                    plv: plv,
                    grade: userGuildInfo.grade
                }
                res(info);                
            } catch (error) {
                rej(error);                
            }
        }
    })
}

exports.GetUserInfo2 = function(session) {
    return new Promise(async (res,rej)=> {
        if( !session.userinfo ) rej(-101);
        else {
            try {
                const pUserGuild = await db.query(`select * from user_guild u left join guild g on u.guild_sn = g.sn where user_sn = ${session.userinfo.sn}`);
                if( pUserGuild.rows.length <= 0 ) throw -2;
                const userGuildInfo = pUserGuild.rows[0];

                const pUser = await db.query(`select nick, permission_level from account where sn = ${session.userinfo.sn}`);
                const nick = pUser.rows[0].nick;
                const plv = pUser.rows[0].permission_level;

                let info = {
                    sn: session.userinfo.sn,
                    guild: userGuildInfo.guild_sn,
                    guildname: userGuildInfo.guildname ? userGuildInfo.guildname : '',
                    autocut: userGuildInfo.autocut ? userGuildInfo.autocut : 0,
                    nick : nick,
                    plv: plv,
                    grade: userGuildInfo.grade
                }
                res(info);                
            } catch (error) {
                rej(error);                
            }
        }
    })
}