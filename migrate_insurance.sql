-- 旅游客户信息系统 · 字段迁移（2026-08-24）
-- 用途：新增「失败原因 / 成功出游信息 / 保险提醒」所需字段。
-- 执行方式：Supabase 后台 → SQL Editor → 粘贴本文件 → Run。
-- 可重复运行，安全。

ALTER TABLE public.customers ADD COLUMN IF NOT EXISTS fail_reason      text;
ALTER TABLE public.customers ADD COLUMN IF NOT EXISTS travel_date      text;   -- 出游日期 YYYY-MM-DD
ALTER TABLE public.customers ADD COLUMN IF NOT EXISTS travel_location  text;   -- 出游地点
ALTER TABLE public.customers ADD COLUMN IF NOT EXISTS insurance_bought boolean DEFAULT false;  -- 是否已购保险
