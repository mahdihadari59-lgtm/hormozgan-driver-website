#!/data/data/com.termux/files/usr/bin/bash  
  
# 🚀 اسکریپت نصب خودکار Hormozgan Driver Pro - نسخه موبایل  
# استفاده از ریپوی واقعی: https://github.com/mahdihadari59-lgtm/hormozgan-driver-pro121  
  
set -e  
  
# رنگ‌ها  
RED='\033[0;31m'  
GREEN='\033[0;32m'  
YELLOW='\033[1;33m'  
BLUE='\033[0;34m'  
NC='\033[0m'  
  
echo -e "${BLUE}"  
echo "╔═══════════════════════════════════════════╗"  
echo "║   🚗 Hormozgan Driver Pro Installer      ║"    
echo "║   نسخه مخصوص Termux موبایل               ║"  
echo "╚═══════════════════════════════════════════╝"  
echo -e "${NC}"  
  
# توابع  
log_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }  
log_success() { echo -e "${GREEN}✅ $1${NC}"; }  
log_error() { echo -e "${RED}❌ $1${NC}"; }  
log_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }  
  
# ===== مرحله ۱: بررسی Termux =====  
log_info "بررسی محیط Termux..."  
  
if [ ! -d "/data/data/com.termux/files/usr" ]; then  
    log_error "لطفاً ابتدا Termux را از F-Droid نصب کنید"  
    exit 1  
fi  
  
log_success "محیط Termux تایید شد"  
  
# ===== مرحله ۲: به‌روزرسانی =====  
log_info "به‌روزرسانی پکیج‌ها..."  
pkg update -y && pkg upgrade -y  
  
# ===== مرحله ۳: نصب پیش‌نیازها =====  
log_info "نصب پیش‌نیازها..."  
  
pkg install -y git nodejs wget curl nano -y  
  
log_success "پیش‌نیازها نصب شدند"  
  
# ===== مرحله ۴: دسترسی به حافظه =====  
log_info "درخواست دسترسی به حافظه..."  
if [ ! -d ~/storage/shared ]; then  
    termux-setup-storage  
    sleep 3  
fi  
  
# ===== مرحله ۵: دانلود از GitHub =====  
log_info "دانلود پروژه از GitHub..."  
  
cd ~/storage/shared/  
  
if [ -d "hormozgan-driver-pro121" ]; then  
    log_warning "پروژه از قبل وجود دارد"  
    read -p "آپدیت کنم؟ (y/n): " UPDATE_CHOICE  
    if [ "$UPDATE_CHOICE" = "y" ]; then  
        cd hormozgan-driver-pro121  
        git pull origin main  
    else  
        cd hormozgan-driver-pro121  
    fi  
else  
    git clone https://github.com/mahdihadari59-lgtm/hormozgan-driver-pro121.git  
    cd hormozgan-driver-pro121  
fi  
  
log_success "پروژه دانلود شد"  
  
# ===== مرحله ۶: نصب وابستگی‌ها =====  
log_info "نصب وابستگی‌های Node.js..."  
  
# نصب در پوشه payment  
if [ -d "payment" ]; then  
    cd payment  
    npm install  
    cd ..  
fi  
  
# نصب در پوشه اصلی (اگر package.json وجود دارد)  
if [ -f "package.json" ]; then  
    npm install  
fi  
  
log_success "وابستگی‌ها نصب شدند"  
  
# ===== مرحله ۷: ایجاد فایل‌های ضروری =====  
log_info "ایجاد فایل‌های پیکربندی..."  
  
# ایجاد فایل محیطی اگر وجود ندارد  
if [ ! -f ".env" ]; then  
    cat > .env << 'EOF'  
NODE_ENV=development  
PORT=3000  
JWT_SECRET=hormozgan_driver_pro_secret_key_2025  
EOF  
    log_success "فایل .env ایجاد شد"  
fi  
  
# ایجاد اسکریپت راه‌اندازی  
cat > start-app.sh << 'EOF'  
#!/data/data/com.termux/files/usr/bin/bash  
  
echo "🚀 راه‌اندازی Hormozgan Driver Pro..."  
  
# بررسی پوشه پروژه  
if [ ! -d "payment" ]; then  
    echo "❌ پوشه payment یافت نشد"  
    exit 1  
fi  
  
cd payment  
  
# بررسی node_modules  
if [ ! -d "node_modules" ]; then  
    echo "📦 نصب وابستگی‌ها..."  
    npm install  
fi  
  
echo "🌐 شروع سرویس پرداخت..."  
node server.js  
EOF  
  
chmod +x start-app.sh  
  
# ایجاد اسکریپت تست  
cat > test-app.sh << 'EOF'  
#!/data/data/com.termux/files/usr/bin/bash  
  
echo "🧪 تست سیستم..."  
  
# تست سرور پرداخت  
if curl -s http://localhost:3000/ > /dev/null; then  
    echo "✅ سرور پرداخت فعال"  
else  
    echo "❌ سرور پرداخت غیرفعال"  
fi  
  
# تست صفحات وب  
if [ -f "public/index.html" ]; then  
    echo "✅ صفحات وب موجود"  
else  
    echo "❌ صفحات وب یافت نشد"  
fi  
  
echo ""  
echo "🎉 تست کامل شد!"  
EOF  
  
chmod +x test-app.sh  
  
log_success "اسکریپت‌ها ایجاد شدند"  
  
# ===== مرحله ۸: راه‌اندازی اولیه =====  
log_info "راه‌اندازی اولیه..."  
  
# ایجاد پوشه لاگ  
mkdir -p logs  
  
log_success "پیکربندی کامل شد"  
  
# ===== نتیجه نهایی =====  
echo ""  
echo -e "${GREEN}"  
echo "╔═══════════════════════════════════════════╗"  
echo "║   ✅ نصب با موفقیت انجام شد!            ║"  
echo "╚═══════════════════════════════════════════╝"  
echo -e "${NC}"  
  
echo ""  
echo -e "${BLUE}📍 مسیر پروژه:${NC}"  
echo "   cd ~/storage/shared/hormozgan-driver-pro121"  
echo ""  
echo -e "${BLUE}🚀 اجرای سرویس پرداخت:${NC}"  
echo "   ./start-app.sh"  
echo ""  
echo -e "${BLUE}🧪 تست سیستم:${NC}"  
echo "   ./test-app.sh"  
echo ""  
echo -e "${BLUE}📱 اجرای صفحات وب:${NC}"  
echo "   cd public && python -m http.server 8000"  
echo ""  
echo -e "${YELLOW}📖 راهنمای سریع:${NC}"  
echo "   1. ./start-app.sh    # سرور پرداخت"  
echo "   2. ترمینال جدید: cd public && python -m http.server 8000"  
echo "   3. مرورگر: http://localhost:8000"  
echo ""  
echo "موفق باشید! 🎉"
