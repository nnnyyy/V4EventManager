const express = require('express');
const router = express.Router();
const ServerManager = require('../Components/ServerManager');
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