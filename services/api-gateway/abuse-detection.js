const express = require("express");
const rateLimit = require("express-rate-limit");
const slowDown = require("express-slow-down");

// Rate limiting for abusive patterns
const apiLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 min
  max: 100, // Max 100 requests per window per IP
  message: "Too many requests. Please try again later.",
  standardHeaders: true,
  legacyHeaders: false,
});

// Progressive slowdown for suspicious activity
const speedLimiter = slowDown({
  windowMs: 15 * 60 * 1000,
  delayAfter: 20,
  delayMs: 500,
});

module.exports = { apiLimiter, speedLimiter };