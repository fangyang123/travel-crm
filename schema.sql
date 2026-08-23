-- 旅游客户信息系统 · Supabase 表结构
-- 复用「复盘系统（astock-review）」同一个 Supabase 项目：
--   URL:  https://ulgoozjkbngiqtovhfbf.supabase.co
--   key:  sb_publishable_-ua0XPCaZhI1pgaG7cJdxw_himPm8KI（publishable，公开安全，放前端）
-- 在 Supabase 后台 → SQL Editor 粘贴执行一次即可（与现有 trades/daily_records 表同库）。

CREATE TABLE IF NOT EXISTS public.customers (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name          text NOT NULL,
  id_card       text NOT NULL UNIQUE,           -- 身份证号，唯一（一个身份证只能建一个客户）
  birth         text,                           -- 出生日期 YYYY-MM-DD（从身份证解析）
  gender        text,                           -- 男 / 女
  status        text NOT NULL DEFAULT '跟进中', -- 跟进中 / 成功 / 失败
  auto_failed   boolean DEFAULT false,          -- 是否因超时被系统判失败
  follow_ups    jsonb DEFAULT '[]'::jsonb,      -- 跟进记录数组 [{date, note}]
  created_at    text NOT NULL,                  -- 创建日期 YYYY-MM-DD
  last_follow_at text,                          -- 最后跟进日期 YYYY-MM-DD
  status_at     text                            -- 状态变更日期
);

CREATE INDEX IF NOT EXISTS idx_customers_status ON public.customers(status);

-- RLS：与现有表一致，允许匿名（publishable key）读写，前端直连
ALTER TABLE public.customers ENABLE ROW LEVEL SECURITY;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename='customers' AND policyname='allow all anon'
  ) THEN
    CREATE POLICY "allow all anon" ON public.customers FOR ALL TO anon USING (true) WITH CHECK (true);
  END IF;
END $$;
