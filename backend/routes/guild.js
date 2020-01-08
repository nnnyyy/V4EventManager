
const db = require('../Lib/MYSQL');
const Logger = require('../Components/Logger');
const ErrorProc = require('./commonFunc').ErrorProc;

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
        const guildSN = 1;
        let p = await db.query(`select b.*, ifnull(c.boss_sn, -1) boss_sn, ifnull(c.cuttime,0) cuttime, ifnull(c.gaptimemin, 0) gaptimemin from boss b left join (select * from cuttime where guild_sn = ${guildSN}) c on b.sn = c.boss_sn`);

        res.send({ret: 0, list: p.rows});
    } catch (e) {
        ErrorProc(res,e);        
    }
}

exports.cut = async (req,res)=> {
    try {
        // 아무나 컷 시도를 못하게 한다.
        
        const sn = req.body.boss_sn;
        const guildSN = 1;
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
        const guildSN = 1;
        const userSN = 1;
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
        const guildSN = 1;
        const userSN = 1;
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