exports.ErrorProc = function(res, e) {
    if (e instanceof Error) { res.send({ ret: -99, err: e.message }) }
    else if (typeof (e) == 'number') { res.send({ ret: e }) }
    else {
        Logger.error(e.toString());
        res.send({ ret: -100 });
    }
}

exports.GetUserInfo = function(req) {
    return new Promise((res,rej)=> {
        if( !req.session.userinfo ) rej(-101);
        else res(req.session.userinfo);
    })
}