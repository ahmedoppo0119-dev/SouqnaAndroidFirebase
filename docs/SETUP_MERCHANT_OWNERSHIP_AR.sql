-- سوقنا: تجهيز ربط كل متجر بحساب التاجر
-- هذا الملف يضيف عمود الربط فقط ولا يحذف أو يغيّر أي سياسة موجودة.
-- مهم: بعد تشغيله يجب تعيين owner_id للمتجر الصحيح، ثم مراجعة سياسات RLS
-- الحالية على shops وproducts وorders قبل اعتبار عزل البيانات مكتملاً.

alter table public.shops
  add column if not exists owner_id uuid references auth.users(id) on delete set null;

create index if not exists shops_owner_id_idx on public.shops(owner_id);

-- فحص المتاجر وربطها الحالي:
select id, name, owner_id from public.shops order by id;

-- لمعرفة أسماء وسياسات RLS الحالية قبل تعديلها:
select schemaname, tablename, policyname, permissive, roles, cmd, qual, with_check
from pg_policies
where schemaname = 'public'
  and tablename in ('shops','products','orders','order_items')
order by tablename, policyname;

-- لمعرفة UUID لحساب التاجر: افتح Supabase > Authentication > Users
-- انسخ User UID للحساب الصحيح، ثم نفّذ بعد التأكد من رقم المتجر:
-- update public.shops set owner_id = 'ضع-UUID-حساب-التاجر-هنا' where id = رقم_المتجر;
-- لا تنفذ هذا السطر قبل التأكد من الحساب والمتجر الصحيحين.
