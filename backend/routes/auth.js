const Logger = require('../Components/Logger');
const db = require('../Lib/MYSQL');
const mailer = require('../Lib/Mailer');
const pwgen = require('generate-password');
const ServerManager = require('../Components/ServerManager');
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

function deleteUserInfo(req) {
    return new Promise(async (res,rej)=> {
        try {
            req.session.userinfo = null;
            req.session.destroy(()=> {
                res();
            });            
        } catch (e) {
            rej(e);
        }
    })
}

exports.check = async (req,res)=> {
    try {
        const userinfo = await GetUserInfo(req);        

        res.send({ret: 0, info: userinfo});
    } catch (e) {
        ErrorProc(res, e);
    }
}

exports.login = async (req,res) => {
    try {
        const id = req.body.id;
        const pw = req.body.pw;
        
        const p = await db.query(`select * from account where nick = '${id}' and pw = password('${pw}')`);
        if( p.rows.length <= 0 ) throw -1;
        const accountInfo = p.rows[0];

        const pUserGuild = await db.query(`select * from user_guild where user_sn = ${accountInfo.sn}`);
        if( pUserGuild.rows.length <= 0 ) throw -2;

        const userGuildInfo = pUserGuild.rows[0];

        await saveUserInfo(req, {sn: accountInfo.sn, grade: userGuildInfo.grade, guild: userGuildInfo.guild_sn});

        res.send({ret: 0});
    } catch (e) {
        ErrorProc(res, e);        
    }
}

exports.logout = async (req,res) => {
    try {       

        await deleteUserInfo(req);

        res.send({ret: 0});
    } catch (e) {
        ErrorProc(res, e);        
    }
}

exports.signup = async (req,res)=> {
    let conn = null;
    try {
        const nick = req.body.id; 
        const pw = req.body.pw;

        conn = await db.beginTran();

        let p = await db.queryTran(conn, `select * from account where nick = '${nick}'`);
        if( p.rows.length > 0 ) throw -1;

        await db.queryTran(conn, `insert into account (nick, pw) values ('${nick}', password('${pw}'))`);
        p = await db.queryTran(conn, `select * from account where nick = '${nick}'`);        
        const user_sn = p.rows[0].sn;
        await db.queryTran(conn, `insert into user_guild (user_sn, guild_sn, grade) values (${user_sn},-1,0)`);

        await db.endTran(conn);

        res.send({ret: 0});
    } catch (e) {
        db.rollback(conn);
        ErrorProc(res, e);        
    }
}