
const db = require('../Lib/MYSQL');
const Logger = require('../Components/Logger');
const ErrorProc = require('./commonFunc').ErrorProc;
const GetUserInfo = require('./commonFunc').GetUserInfo;

function saveUserInfo(req, userinfo) {
    return new Promise(async (res,rej)=> {
        try {
            req.session.userinfo = userinfo;
            req.session.save(err=>{
                if(!err) res();
                else rej(err);
            });
        } catch (e) {
            rej(e);
        }
    })
}


function _WriteGuildLog(guild_sn, user_sn, msg) {
    return new Promise(async (res,rej)=>{
        try {
            await db.query(`insert into guildlog (guild_sn, user_sn, msg) values (${guild_sn}, ${user_sn}, '${msg}')`);
            res();
        } catch (e) {            
            rej();
        }
    })
}

exports.loadBossEvent = async (req,res)=> {
    try {
        const userinfo = await GetUserInfo(req);
        const guildSN = userinfo.guild;
        if( guildSN == -1 ) throw -1;
        let p = await db.query(`select * from user_guild where user_sn = ${userinfo.sn}`);
        if( p.rows[0].grade == 0 ) throw -2;

        p = await db.query(`select b.*, ifnull(c.boss_sn, -1) boss_sn, ifnull(c.cuttime,0) cuttime, ifnull(c.gaptimemin, 0) gaptimemin from boss b left join (select * from cuttime where guild_sn = ${guildSN}) c on b.sn = c.boss_sn`);

        res.send({ret: 0, list: p.rows});
    } catch (e) {
        ErrorProc(res,e);        
    }
}

exports.cut = async (req,res)=> {
    try {
        // 아무나 컷 시도를 못하게 한다.
        
        const sn = req.body.boss_sn;
        const userinfo = await GetUserInfo(req);
        const guildSN = userinfo.guild;
        const userSN = 1;

        const boss = await db.query(`select * from boss where sn = ${sn}`);
        const bossinfo = boss.rows[0];

        const p = await db.query(`select * from cuttime where guild_sn = ${guildSN} and boss_sn = ${sn}`);
        if( p.rows.length <= 0 ) {
            await db.query(`insert into cuttime (guild_sn, boss_sn, cuttime, gaptimemin) values (${guildSN}, ${sn}, now(), 180)`);
        }
        else {
            await db.query(`update cuttime set cuttime = now() where guild_sn = ${guildSN} and boss_sn = ${sn}`);
        }

        await _WriteGuildLog(guildSN, userSN, `${bossinfo.boss_name} 컷 입력`);

        res.send({ret: 0});
        
    } catch (e) {
        ErrorProc(res,e);        
    }
}

exports.modifyCooltime = async (req, res)=> {
    try {
        const sn = req.body.boss_sn;
        const userinfo = await GetUserInfo(req);
        const guildSN = userinfo.guild;
        const userSN = userinfo.sn;
        const cooltime = req.body.cooltime;

        const boss = await db.query(`select * from boss where sn = ${sn}`);
        const bossinfo = boss.rows[0];

        await db.query(`update cuttime set gaptimemin = ${cooltime} where guild_sn = ${guildSN} and boss_sn = ${sn}`);

        await _WriteGuildLog(guildSN, userSN, `${bossinfo.boss_name} 쿨타임 수정`);

        res.send({ret: 0});
    } catch (e) {
        ErrorProc(res,e);        
    }
}

exports.modifyCutTime = async (req, res)=> {
    try {
        const sn = req.body.boss_sn;
        const userinfo = await GetUserInfo(req);
        const guildSN = userinfo.guild;
        const userSN = userinfo.sn;
        const modifydate = req.body.modifydate;

        const boss = await db.query(`select * from boss where sn = ${sn}`);
        const bossinfo = boss.rows[0];

        await db.query(`update cuttime set cuttime = '${modifydate}' where guild_sn = ${guildSN} and boss_sn = ${sn}`);

        await _WriteGuildLog(guildSN, userSN, `${bossinfo.boss_name} 컷 수정`);

        res.send({ret: 0});
    } catch (e) {
        ErrorProc(res,e);        
    }
}

exports.make = async (req,res)=> {
    let conn = null;
    try {

        const guildname = req.body.guildname;
        const userinfo = await GetUserInfo(req);

        conn = await db.beginTran();

        let p = await db.queryTran(conn, `select * from guild where guildname = '${guildname}'`);
        if( p.rows.length > 0 ) throw -1;

        await db.queryTran(conn, `insert into guild (master_sn, guildname) values ( ${userinfo.sn}, '${guildname}')`);

        p = await db.queryTran(conn, `select sn from guild where guildname = '${guildname}'`);
        const guild_sn = p.rows[0].sn;

        await db.queryTran(conn, `update user_guild set guild_sn = ${guild_sn}, grade = 3 where user_sn = ${userinfo.sn}`);

        await saveUserInfo(req, {sn: userinfo.sn, grade: 3, guild: guild_sn});

        await db.endTran(conn);

        res.send({ret: 0});
    } catch (e) {
        db.rollback(conn);
        ErrorProc(res, e);        
    }
}

exports.checkUserGuildState = async (req, res)=> {
    try {
        const userinfo = await GetUserInfo(req);

        const p = await db.query(`SELECT * FROM guild g right join user_guild u on g.sn = u.guild_sn where user_sn = ${userinfo.sn}`);        

        res.send({ret: 0, grade: p.rows[0].grade, guild_sn: p.rows[0].guild_sn, guildname: p.rows[0].guildname});
    } catch (e) {
        ErrorProc(res,e);        
    }
}

exports.search = async (req, res)=> {

    try {
        const guildname = req.body.guildname;
        const p = await db.query(`SELECT sn guild_sn, guildname, count(*) user_cnt FROM guild g join user_guild u on g.sn = u.guild_sn where grade > 0 and guildname = '${guildname}' group by sn`);

        res.send({ret: 0, list: p.rows});
    } catch (e) {
        ErrorProc(res,e);        
    }
}

exports.joinReq = async (req, res)=> {

    let conn = null;

    try {
        const userinfo = await GetUserInfo(req);
        const guild_sn = req.body.data.guild_sn;

        conn = await db.beginTran();

        let p = await db.queryTran(conn, `select * from user_guild where user_sn = ${userinfo.sn}`);
        if( p.rows[0].guild_sn != -1 ) throw -1;

        await db.queryTran(conn, `update user_guild set guild_sn = ${guild_sn}, grade = 0 where user_sn = ${userinfo.sn}`);

        await saveUserInfo(req, {sn: userinfo.sn, grade: 0, guild: guild_sn});

        db.endTran(conn);

        res.send({ret: 0});
    } catch (e) {
        db.rollback(conn);
        ErrorProc(res,e);        
    }
}

exports.cancelJoin = async (req, res)=> {

    let conn = null;

    try {
        const userinfo = await GetUserInfo(req);

        conn = await db.beginTran();

        let p = await db.queryTran(conn, `select * from user_guild where user_sn = ${userinfo.sn}`);
        if( p.rows[0].grade != 0 ) throw -1;

        await db.queryTran(conn, `update user_guild set guild_sn = -1, grade = 0 where user_sn = ${userinfo.sn}`);

        await saveUserInfo(req, {sn: userinfo.sn, grade: 0, guild: -1});

        db.endTran(conn);

        res.send({ret: 0});
    } catch (e) {
        db.rollback(conn);
        ErrorProc(res,e);        
    }
}

exports.loadGuildMembers = async (req, res)=> {
    try {
        const userinfo = await GetUserInfo(req);

        let q = `SELECT * FROM guild g join 
        (select a.nick, u1.* from account a join user_guild u1 on a.sn = u1.user_sn ) u 
        on g.sn = u.guild_sn where sn = ${userinfo.guild} and grade >= 0`;

        const p = await db.query(q);

        res.send({ret: 0, list: p.rows});
    } catch (e) {
        ErrorProc(res, e);        
    }
}

exports.changeGrade = async (req, res)=> {
    let conn = null;
    try {
        const userinfo = await GetUserInfo(req);
        if( userinfo.grade != 3 ) throw -1;

        const userSNList = req.body.userSNList;
        const grade = req.body.grade;

        conn = await db.beginTran();

        for( let idx in userSNList ) {
            const sn = userSNList[idx];
            await db.queryTran(conn, `update user_guild set grade = ${grade} where guild_sn = ${userinfo.guild} and user_sn = ${sn}`);
        }

        db.endTran(conn);

        res.send({ret: 0});
    } catch (e) {
        db.rollback(conn);
        ErrorProc(res, e);        
    }
}

exports.kickUser = async (req, res)=> {
    let conn = null;
    try {
        const userinfo = await GetUserInfo(req);
        if( userinfo.grade != 3 ) throw -1;

        const userSNList = req.body.userSNList;

        conn = await db.beginTran();

        for( let idx in userSNList ) {
            const sn = userSNList[idx];
            await db.queryTran(conn, `update user_guild set grade = 0, guild_sn = -1 where guild_sn = ${userinfo.guild} and user_sn = ${sn}`);
        }

        db.endTran(conn);

        res.send({ret: 0});        
    } catch (e) {
        ErrorProc(res, e);        
    }
}