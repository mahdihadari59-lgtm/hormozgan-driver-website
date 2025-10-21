// 🚀 Hormozgan Driver API - Production Ready
require('dotenv').config();
const express = require('express');
const cors = require('cors');
const path = require('path');

const app = express();

// ====================================
// Middleware
// ====================================
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// CORS Configuration
app.use(cors({
  origin: process.env.ALLOWED_ORIGINS || '*',
  credentials: true
}));

// Logging
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.path}`);
  next();
});

// ====================================
// Serve Static Files (Dashboard)
// ====================================
app.use(express.static(path.join(__dirname, 'public')));

// ====================================
// Routes
// ====================================

// Dashboard - Serve HTML
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// Health Check Endpoint
app.get('/health', (req, res) => {
  res.json({
    status: 'ok',
    message: 'سرور فعال است ✅',
    timestamp: new Date().toISOString(),
    uptime: Math.floor(process.uptime()) + ' seconds',
    environment: process.env.NODE_ENV || 'development',
    node_version: process.version
  });
});

// API Info
app.get('/api', (req, res) => {
  res.json({
    status: 'running',
    message: 'API فعال است',
    version: '2.0.0-beta1',
    services: {
      auth: 'active',
      driver: 'active',
      payment: 'active'
    },
    endpoints: {
      health: '/health',
      dashboard: '/',
      api: '/api'
    }
  });
});

// ====================================
// Error Handling
// ====================================

// 404 Handler
app.use((req, res) => {
  res.status(404).json({
    error: 'Not Found',
    message: 'مسیر مورد نظر یافت نشد',
    path: req.path
  });
});

// Global Error Handler
app.use((err, req, res, next) => {
  console.error('❌ خطا:', err.stack);
  res.status(err.status || 500).json({
    error: 'Server Error',
    message: err.message || 'خطای سرور',
    ...(process.env.NODE_ENV === 'development' && { stack: err.stack })
  });
});

// ====================================
// Server Configuration
// ====================================
const PORT = process.env.PORT || 3000;
const HOST = process.env.HOST || '0.0.0.0';

const server = app.listen(PORT, HOST, () => {
  console.log('\n🚀 سرور با موفقیت راه‌اندازی شد!');
  console.log(`📍 آدرس: http://localhost:${PORT}`);
  console.log(`🏥 Health Check: http://localhost:${PORT}/health`);
  console.log(`🎨 Dashboard: http://localhost:${PORT}`);
  console.log(`🌍 محیط: ${process.env.NODE_ENV || 'development'}`);
  console.log(`⏰ زمان: ${new Date().toLocaleString('fa-IR')}\n`);
});

// ====================================
// Graceful Shutdown
// ====================================
const gracefulShutdown = (signal) => {
  console.log(`\n⚠️  دریافت سیگنال ${signal}`);
  console.log('🔄 در حال خاموش کردن سرور...');
  
  server.close(() => {
    console.log('✅ سرور با موفقیت خاموش شد');
    process.exit(0);
  });
  
  setTimeout(() => {
    console.error('⛔ خاموش کردن اجباری سرور');
    process.exit(1);
  }, 10000);
};

process.on('SIGTERM', () => gracefulShutdown('SIGTERM'));
process.on('SIGINT', () => gracefulShutdown('SIGINT'));

// Unhandled Promise Rejection
process.on('unhandledRejection', (reason, promise) => {
  console.error('❌ Unhandled Rejection:', reason);
  server.close(() => process.exit(1));
});

// Uncaught Exception
process.on('uncaughtException', (error) => {
  console.error('❌ Uncaught Exception:', error);
  server.close(() => process.exit(1));
});

module.exports = app;
