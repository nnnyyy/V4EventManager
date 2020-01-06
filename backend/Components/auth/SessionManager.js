const appConf = require('../../config/AppConf.json');
const session = require('express-session');
const mysqlSessionStore = require('express-mysql-session')(session);
const mysqlConf = require('../../config/MYSQLConf.json')[0];

exports.initSession = function(app) {
    let cookieOption = {}
    if( process.env.NODE_ENV != 'development' ) {
        //cookieOption.sameSite = 'None',
        cookieOption.domain = '.databucket.duckdns.org'
    }

    var _session = session({
        secret: appConf.session.secret,
        resave: false,
        saveUninitialized: true,
        cookie: cookieOption,
        store: new mysqlSessionStore({
            host: mysqlConf.server,
            port: 3306,
            user: mysqlConf.user,
            password: mysqlConf.password,
            database: mysqlConf.database
        }),
        name: 'gamlive'
    })
    app.use(_session);   

    return _session
}