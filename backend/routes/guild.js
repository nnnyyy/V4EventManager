
const db = require('../Lib/MYSQL');
const Logger = require('../Components/Logger');
const ErrorProc = require('./commonFunc').ErrorProc;

exports.loadBossEvent = async (req,res)=> {
    try {
        let p = await db.query(`select b.*, ifnull(c.boss_sn, -1) boss_sn, ifnull(c.cuttime,0) cuttime, ifnull(c.gaptimemin, 0) gaptimemin from boss b left join (select * from cuttime where guild_sn = 1) c on b.sn = c.boss_sn`);

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

        const p = await db.query(`select * from cuttime where guild_sn = ${guildSN} and boss_sn = ${sn}`);
        if( p.rows.length <= 0 ) {
            await db.query(`insert into cuttime (guild_sn, boss_sn, cuttime, gaptimemin) values (${guildSN}, ${sn}, now(), 180)`);
        }
        else {
            await db.query(`update cuttime set cuttime = now() where guild_sn = ${guildSN} and boss_sn = ${sn}`);
        }

        res.send({ret: 0});
        
    } catch (e) {
        ErrorProc(res,e);        
    }
}