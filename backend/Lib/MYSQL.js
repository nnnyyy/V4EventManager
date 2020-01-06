const configFile = require('../config/MYSQLConf.json');
const sql = require('mysql');

class MYSQLHelper {
    constructor() {        
    }

    init() {
        this.mPools = new Map();
        for(const idx in configFile) {
            const config = configFile[idx];
            this.connectPool(config);
        }
    }

    connectPool(config) {
        const pool = sql.createPool({
            connectionLimit: ( config.connectionLimit || 60 ),
            host: config.server,
            user: config.user,
            password: config.password,
            database: config.database,
            multipleStatements: true,
            waitForConnections:true
        });

        const alias = config.alias ? config.alias : 'default'

        this.mPools.set(alias, pool);
    }

    pm_getConnection(dbalias) {
        return new Promise((res,rej)=> {

            const _pool = this.mPools.get(dbalias);
             if( !_pool ) {
                rej(err);
                return;
            }

            _pool.getConnection((err,conn)=> {
                if(err) {
                    //conn.release();
                    rej(err);
                }
                else {
                    res(conn);
                }
            });
        });
    }
    query(query, dbalias) {
        if( !dbalias ) dbalias = 'default';
         
        return new Promise( async (res,rej)=> {
            try {
                const conn = await this.pm_getConnection(dbalias);
                conn.query(query, (err,rows)=> {
                    conn.release();
                    if( err != null ) 
                        rej(new Error(`[mysql error] ${err}`));
                    else 
                        res({rows: rows, err: err})                        
                });
            }catch(e) {
                rej(new Error(`[mysql error] ${e}`));
            }
        })
    }

    queryTran(conn, query, dbalias) {
        if( !dbalias ) dbalias = 'default';
         
        return new Promise( async (res,rej)=> {
            try {
                conn.query(query, (err,rows)=> {                    
                    if( err != null ) {
                        conn.rollback();
                        rej(new Error(`[mysql error] ${err}`));
                    }
                    else 
                        res({rows: rows, err: err})                        
                });
            }catch(e) {
                rej(new Error(`[mysql error] ${e}`));
            }
        })
    }

    proc(procname, params, dbalias) {
        if( !dbalias ) dbalias = 'default';
        if( !params ) params = [];
         
        return new Promise((res,rej)=> {
            try {
                let paramQ = '';
                for( let i = 0 ; i < params.length ; ++i ) {
                    paramQ += '?';
                    if( i + 1 < params.length) {
                        paramQ +=',';
                    }
                }

                this.pm_getConnection(dbalias)
                .then(conn=> {
                    conn.query(`CALL ${procname}(${paramQ})`, params, (err,rows)=> {
                        conn.release();
                        res({rows: rows, err: err})                        
                    })
                });
            }catch(e) {
                res({rows: null, err: e});
            }
        })
    }

    beginTran(dbalias) {
        if( !dbalias ) dbalias = 'default';
        return new Promise( async (res,rej)=> {
            let conn = await this.pm_getConnection(dbalias);
            conn.beginTransaction(err=> {
                if( err ) { conn.rollback(); rej(); }
                res(conn)
            })
        })
    }

    rollback(conn, dbalias) {
        if( !dbalias ) dbalias = 'default';
        return new Promise( async (res,rej)=> {
            conn.rollback();
            res();
        })
    }
    
    endTran(conn, dbalias) {
        if( !dbalias ) dbalias = 'default';
        return new Promise(async (res,rej)=> {
            conn.commit(err=> {
                if( err ) { conn.rollback(); rej(); }
                res(err)
            })
        })
    }
}

helper = new MYSQLHelper();

module.exports = helper;