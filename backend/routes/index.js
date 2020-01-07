const express = require('express');
const router = express.Router();
const ServerManager = require('../Components/ServerManager');
const moment = require('moment');
const guild = require('./guild');

module.exports = router;


router.post('/guild/loadBossEvent', guild.loadBossEvent);
router.post('/guild/cut', guild.cut);