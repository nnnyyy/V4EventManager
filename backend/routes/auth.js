const Logger = require('../Components/Logger');
const db = require('../Lib/MYSQL');
const mailer = require('../Lib/Mailer');
const pwgen = require('generate-password');
const ServerManager = require('../Components/ServerManager');
const ErrorProc = require('./commonFunc').ErrorProc;

exports.check = async (req,res)=> {
    try {


        res.send({ret: 0, state: 1});
    } catch (e) {
        ErrorProc(res, e);
    }
}