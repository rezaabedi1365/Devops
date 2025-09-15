# استفاده از نسخه سبک پایتون
FROM python:3.11-slim

# پوشه اصلی پروژه داخل کانتینر
WORKDIR /app

# کپی کردن فایل‌های پروژه
COPY requirements.txt requirements.txt
COPY address_book.py address_book.py

# نصب کتابخانه‌ها
RUN pip install --no-cache-dir -r requirements.txt

# باز کردن پورت Flask
EXPOSE 5000

# اجرای برنامه
CMD ["python", "address_book.py"]
