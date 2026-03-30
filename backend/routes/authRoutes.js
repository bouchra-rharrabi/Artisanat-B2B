const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');

// @route   POST api/auth/register
// @desc    Register a user (ARTISAN or ENTREPRISE)
// @access  Public
router.post('/register', authController.register);

module.exports = router;
