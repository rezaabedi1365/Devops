```
GithubRepo-title_project/
│── Dockerfile                # فایل Dockerfile برای ساخت ایمیج
│── docker-compose.yml        # فایل docker-compose برای اجرای سرویس‌ها (اختیاری)
│── requirements.txt          # لیست کتابخونه‌های پایتون
│── address_book.py           # کد اصلی Flask
│── README.md                 # توضیحات پروژه
│
└── .github/
    └── workflows/
        └── deploy.yml        # فایل GitHub Actions برای بیلد و دیپلوی
```
🔑 توضیحات:

Dockerfile → از همون چیزی که اول نوشتی (با base image python:3.11-slim).

docker-compose.yml → اگه خواستی لوکال تست کنی یا چند سرویس (مثل DB) داشتی.

.github/workflows/deploy.yml → همون workflow که نوشتیم (برای build و push و release).

requirements.txt → کتابخونه‌های مورد نیاز Flask (مثلاً flask و هرچی لازم داشتی).

address_book.py → اپ Flask.


