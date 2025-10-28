// server.js
const express = require('express');
const dotenv = require('dotenv');
const path = require('path');

// بارگذاری متغیرهای محیطی
dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// استفاده از public به عنوان پوشه استاتیک
app.use(express.static(path.join(__dirname, 'public')));

// مسیر برای نمایش صفحه اصلی
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// شروع سرور
app.listen(PORT, () => {
  console.log(`🚀 Server is running on http://localhost:${PORT}`);
});
