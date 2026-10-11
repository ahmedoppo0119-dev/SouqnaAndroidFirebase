# سوقنا - مشروع Android مصحح

المشروع يحتوي على تطبيق Android باسم الحزمة `com.souqna.app`، وملف `index.html` الخاص بسوقنا داخل `project/app/src/main/assets/`، وإعدادات Firebase الموجودة في نسخة المشروع.

## سبب إصلاح البناء

سير العمل السابق كان يحاول تشغيل `chmod gradlew` رغم عدم وجود ملف `gradlew` داخل الأرشيف. سير العمل الجديد يثبت Gradle 8.9 مباشرة ويشغّل `gradle assembleDebug` من مجلد المشروع، ثم يرفع ملف APK كـ artifact باسم `Souqna-APK`.

## الاستخدام

ارفع محتويات هذا المجلد إلى جذر مستودع GitHub، مع الحفاظ على المجلد `.github` و`project`. ثم افتح تبويب Actions وشغّل `Build Souqna APK` عبر `Run workflow`. عند نجاح البناء، نزّل artifact `Souqna-APK` واستخرج منه `app-debug.apk`.

ملاحظة: إعداد FCM في التطبيق وحده لا يكفي لإرسال إشعار جديد عند وصول طلب والتطبيق مغلق؛ يلزم لاحقًا إعداد إرسال آمن من الخادم/ Supabase Edge Function وربط رمز جهاز التاجر. لا تضع مفاتيح Firebase الخاصة بالخادم داخل التطبيق أو GitHub.
