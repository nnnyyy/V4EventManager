const socketio = require('socket.io');
const sharedsession = require("express-socket.io-session");

class SocketIOManager {
    constructor() {        
    }

    init(http, session) {
        return new Promise((res,rej)=> {
            try {
                this.io = socketio(http);
                if( !this.io ) throw new Error("Socket IO Manager Init Failed..");
                this.io.use(sharedsession(session, {autoSave: true}));
                res();
            } catch (error) {
                rej(error);                
            }            
        })        
    }
}

const _obj = new SocketIOManager();

module.exports = _obj;