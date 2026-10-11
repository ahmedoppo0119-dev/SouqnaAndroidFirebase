-- تم تطبيق هذه الدالة على مشروع Supabase المرتبط بسوقنا بالفعل.
-- تنشئ الطلب وعناصره داخل معاملة واحدة بدون كشف طلبات العملاء عبر سياسة SELECT عامة.
CREATE OR REPLACE FUNCTION public.souqna_create_order(
 p_customer_name text, p_customer_phone text, p_customer_address text,
 p_shop_id bigint, p_total_amount numeric, p_status text, p_items jsonb
) RETURNS jsonb LANGUAGE plpgsql SECURITY DEFINER SET search_path=public SET row_security=off AS $$
DECLARE v_order_id bigint; v_item jsonb; v_product_id bigint; v_quantity bigint; v_unit_price numeric; v_subtotal numeric;
BEGIN
 IF p_shop_id IS NULL OR NOT EXISTS (SELECT 1 FROM public.shops WHERE id=p_shop_id) THEN RAISE EXCEPTION 'INVALID_SHOP_ID'; END IF;
 IF p_items IS NULL OR jsonb_typeof(p_items)<>'array' OR jsonb_array_length(p_items)=0 THEN RAISE EXCEPTION 'EMPTY_ORDER_ITEMS'; END IF;
 INSERT INTO public.orderc(customer_name,customer_phone,customer_address,shop_id,status,total_amount)
 VALUES(p_customer_name,p_customer_phone,p_customer_address,p_shop_id,COALESCE(NULLIF(p_status,''),'جديد'),p_total_amount) RETURNING id INTO v_order_id;
 FOR v_item IN SELECT value FROM jsonb_array_elements(p_items) LOOP
  v_product_id := (v_item->>'product_id')::bigint; v_quantity := (v_item->>'quantity')::bigint;
  v_unit_price := (v_item->>'unit_price')::numeric; v_subtotal := (v_item->>'subtotal')::numeric;
  IF v_quantity IS NULL OR v_quantity<1 OR NOT EXISTS(SELECT 1 FROM public.products p WHERE p.id=v_product_id AND p.shop_id=p_shop_id) THEN RAISE EXCEPTION 'INVALID_ORDER_ITEM'; END IF;
  INSERT INTO public.order_items(order_id,product_id,quantity,unit_price,subtotal) VALUES(v_order_id,v_product_id,v_quantity,v_unit_price,v_subtotal);
 END LOOP;
 RETURN jsonb_build_object('id',v_order_id,'shop_id',p_shop_id,'status',COALESCE(NULLIF(p_status,''),'جديد'));
END; $$;
REVOKE ALL ON FUNCTION public.souqna_create_order(text,text,text,bigint,numeric,text,jsonb) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.souqna_create_order(text,text,text,bigint,numeric,text,jsonb) TO anon,authenticated;
