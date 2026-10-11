# مشروع سوقنا Android + Firebase

هذه نسخة منفصلة عن نسخة سوقنا الآمنة الحالية.

الموجود في المشروع:
- تطبيق Android بالحزمة `com.souqna.app`
- ملف `google-services.json` الخاص بمشروع Firebase
- نسخة HTML الحالية داخل `app/src/main/assets/index.html`
- Firebase Cloud Messaging (FCM)
- طلب إذن إشعارات Android
- قناة إشعارات لطلبات سوقنا
- استقبال إشعارات FCM في الخلفية
- حفظ FCM token محلياً لإكمال ربطه مع Supabase في الخطوة التالية

## ملاحظة مهمة
هذا المشروع هو مصدر Android وليس APK جاهزاً. يحتاج فتحه في Android Studio ثم Build/Run.

الخطوة التالية بعد فتحه: ربط FCM token بحساب/محل التاجر في Supabase، ثم إنشاء الجزء الذي يرسل إشعاراً عند إنشاء طلب جديد.
