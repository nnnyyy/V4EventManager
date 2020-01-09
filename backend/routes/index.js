const express = require('express');
const router = express.Router();
const ServerManager = require('../Components/ServerManager');
const auth = require('./auth');
const guild = require('./guild');

module.exports = router;

router.post('/api/auth/check', auth.check);

router.post('/guild/loadBossEvent', guild.loadBossEvent);
router.post('/guild/cut', guild.cut);
router.post('/guild/modifyCutTime', guild.modifyCutTime);
router.post('/guild/modifyCooltime', guild.modifyCooltime);