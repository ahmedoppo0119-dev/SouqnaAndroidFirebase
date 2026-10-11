# تجهيز مستودع سوقنا على GitHub

هذا الأرشيف جاهز للرفع إلى المستودع `ahmedoppo0119-dev/SouqnaAndroidFirebase`.

## البناء التلقائي
- ملفات Android موجودة داخل مجلد `project/`.
- سير العمل موجود في `.github/workflows/build-apk.yml`.
- بعد رفع الملفات إلى الفرع `main`، افتح تبويب Actions وشغّل `Build Souqna APK` أو انتظر تشغيله تلقائيًا.
- عند نجاح البناء، نزّل Artifact باسم `Souqna-APK` من صفحة تشغيل سير العمل.

## تنبيه
هذا الأرشيف يحتوي مشروع المصدر، وليس APK جاهزًا. لا يتم اعتبار البناء ناجحًا حتى تظهر نتيجة GitHub Actions ناجحة ويُنشأ الـ Artifact.
