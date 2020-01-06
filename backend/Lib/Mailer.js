const configFile = require('../config/MailerConf.json');
const nodemailer = require('nodemailer');

class MailHelper {
    constructor() {

    }

    sendMail(to, subject, content) {
        let transporter = nodemailer.createTransport({
            service: 'gmail',
            host: 'smtp.gmail.com',
            auth: {
                user: configFile.user,
                pass: configFile.pass
            }
        });

        let mailOptions = {
            from: 'admin@jamlive.net',
            to: to ,                     // 수신 메일 주소
            subject: subject,   // 제목
            html: content  // 내용
        };

        return new Promise((res,rej)=> {
            transporter.sendMail(mailOptions, (error, info) => {
                if (error) {
                    rej({ret: -1, res: null, err: error})
                }
                else {
                    res({ret: 0, res: info.response, err: error})
                }
            });
        })        
    }
}

helper = new MailHelper

module.exports = helper