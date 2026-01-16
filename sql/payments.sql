-- ============================================================================
-- Таблица платежей через Telegram Stars
-- ============================================================================
-- Хранит все транзакции за приоритет товара

CREATE TABLE IF NOT EXISTS marketplace_payments (
    id BIGSERIAL PRIMARY KEY,
    user_id TEXT NOT NULL,
    feature_id TEXT,
    kind TEXT DEFAULT 'priority',
    stars INTEGER NOT NULL,
    telegram_charge_id TEXT UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Индексы
CREATE INDEX IF NOT EXISTS idx_marketplace_payments_user_id ON marketplace_payments(user_id);
CREATE INDEX IF NOT EXISTS idx_marketplace_payments_charge_id ON marketplace_payments(telegram_charge_id);
CREATE INDEX IF NOT EXISTS idx_marketplace_payments_created_at ON marketplace_payments(created_at DESC);

-- Constraints (с IF NOT EXISTS для безопасного повторного запуска)
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'marketplace_check_stars_positive'
    ) THEN
        ALTER TABLE marketplace_payments ADD CONSTRAINT marketplace_check_stars_positive CHECK (stars > 0);
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'marketplace_check_user_id_not_empty'
    ) THEN
        ALTER TABLE marketplace_payments ADD CONSTRAINT marketplace_check_user_id_not_empty CHECK (user_id != '');
    END IF;
END $$;

-- Комментарии
COMMENT ON TABLE marketplace_payments IS 'Платежи через Telegram Stars за приоритет (marketplace bot)';
COMMENT ON COLUMN marketplace_payments.kind IS 'Тип платежа: priority (приоритет)';
COMMENT ON COLUMN marketplace_payments.stars IS 'Количество Telegram Stars (обычно 1)';

-- Проверка
-- SELECT * FROM marketplace_payments ORDER BY created_at DESC LIMIT 10;
