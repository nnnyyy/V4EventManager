const express = require('express');
const router = express.Router();
const auth = require('./auth');
const guild = require('./guild');

module.exports = router;

router.post('/api/auth/check', auth.check);
router.post('/api/auth/login', auth.login);
router.post('/api/auth/logout', auth.logout);
router.post('/api/auth/signup', auth.signup);

router.post('/guild/loadBossEvent', guild.loadBossEvent);
router.post('/guild/cut', guild.cut);
router.post('/guild/modifyCutTime', guild.modifyCutTime);
router.post('/guild/modifyCooltime', guild.modifyCooltime);
router.post('/guild/make', guild.make);
router.post('/guild/search', guild.search);
router.post('/guild/joinReq', guild.joinReq);
router.post('/guild/cancelJoin', guild.cancelJoin);
router.post('/guild/checkUserGuildState', guild.checkUserGuildState);
router.post('/guild/loadGuildMembers', guild.loadGuildMembers);
router.post('/guild/changeGrade', guild.changeGrade);
router.post('/guild/kickUser', guild.kickUser);
router.post('/guild/loadLogs', guild.loadLogs);
router.post('/guild/secession', guild.secession);
router.post('/guild/destroy', guild.destroyGuild);
router.post('/guild/deleteCutTime', guild.deleteCutTime);
router.post('/guild/setAutoCut', guild.setAutoCut);