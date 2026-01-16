-- ============================================================================
-- ПОЛНАЯ НАСТРОЙКА БД ДЛЯ MARKETPLACE-IDEAS-BOT
-- ============================================================================
-- Выполните этот файл целиком в Supabase SQL Editor
-- Создаст все таблицы с префиксом marketplace_ для разделения с основным ботом

-- ============================================================================
-- 1. ТАБЛИЦА ГОЛОСОВ
-- ============================================================================
CREATE TABLE IF NOT EXISTS marketplace_votes (
    id BIGSERIAL PRIMARY KEY,
    request_id BIGINT NOT NULL,
    user_id TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(user_id, request_id)
);

CREATE INDEX IF NOT EXISTS idx_marketplace_votes_request_id ON marketplace_votes(request_id);
CREATE INDEX IF NOT EXISTS idx_marketplace_votes_user_id ON marketplace_votes(user_id);
CREATE INDEX IF NOT EXISTS idx_marketplace_votes_created_at ON marketplace_votes(created_at DESC);

COMMENT ON TABLE marketplace_votes IS 'Голоса пользователей за идеи (marketplace bot)';

-- ============================================================================
-- 2. ТАБЛИЦА ПЛАТЕЖЕЙ
-- ============================================================================
CREATE TABLE IF NOT EXISTS marketplace_payments (
    id BIGSERIAL PRIMARY KEY,
    user_id TEXT NOT NULL,
    feature_id TEXT,
    kind TEXT DEFAULT 'priority',
    stars INTEGER NOT NULL,
    telegram_charge_id TEXT UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_marketplace_payments_user_id ON marketplace_payments(user_id);
CREATE INDEX IF NOT EXISTS idx_marketplace_payments_charge_id ON marketplace_payments(telegram_charge_id);
CREATE INDEX IF NOT EXISTS idx_marketplace_payments_created_at ON marketplace_payments(created_at DESC);

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

COMMENT ON TABLE marketplace_payments IS 'Платежи через Telegram Stars за приоритет (marketplace bot)';

-- ============================================================================
-- 3. ТАБЛИЦА AI ДИАЛОГОВ
-- ============================================================================
CREATE TABLE IF NOT EXISTS marketplace_conversations (
    id BIGSERIAL PRIMARY KEY,
    user_id TEXT NOT NULL,
    user_name TEXT,
    session_id TEXT NOT NULL,
    message_number INTEGER NOT NULL,
    message_text TEXT NOT NULL,
    ai_response TEXT,
    ready_to_publish BOOLEAN DEFAULT FALSE,
    published BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_marketplace_conversations_user_id ON marketplace_conversations(user_id);
CREATE INDEX IF NOT EXISTS idx_marketplace_conversations_session_id ON marketplace_conversations(session_id);
CREATE INDEX IF NOT EXISTS idx_marketplace_conversations_created_at ON marketplace_conversations(created_at DESC);

COMMENT ON TABLE marketplace_conversations IS 'AI диалоги Customer Development для аналитики (marketplace bot)';

-- ============================================================================
-- 4. ТАБЛИЦА ЗАПРОСОВ (ИДЕЙ ТОВАРОВ)
-- ============================================================================
CREATE TABLE IF NOT EXISTS marketplace_requests (
    id BIGSERIAL PRIMARY KEY,
    user_id TEXT NOT NULL,
    user_name TEXT,
    short_description TEXT NOT NULL,
    full_description TEXT,
    request_type TEXT DEFAULT 'marketplace_product',
    votes_count INTEGER DEFAULT 0,
    has_priority BOOLEAN DEFAULT FALSE,
    message_id_channel BIGINT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_marketplace_requests_user_id ON marketplace_requests(user_id);
CREATE INDEX IF NOT EXISTS idx_marketplace_requests_created_at ON marketplace_requests(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_marketplace_requests_votes_count ON marketplace_requests(votes_count DESC);
CREATE INDEX IF NOT EXISTS idx_marketplace_requests_has_priority ON marketplace_requests(has_priority);
CREATE INDEX IF NOT EXISTS idx_marketplace_requests_message_id ON marketplace_requests(message_id_channel);

COMMENT ON TABLE marketplace_requests IS 'Запросы пользователей на валидацию идей товаров для маркетплейсов';

-- ============================================================================
-- 5. ТАБЛИЦА СИСТЕМНЫХ СООБЩЕНИЙ
-- ============================================================================
CREATE TABLE IF NOT EXISTS marketplace_system_messages (
    id BIGSERIAL PRIMARY KEY,
    message_type TEXT NOT NULL UNIQUE,
    message_id_channel BIGINT,
    last_updated TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_marketplace_system_messages_type ON marketplace_system_messages(message_type);

COMMENT ON TABLE marketplace_system_messages IS 'Системные сообщения бота в канале (marketplace bot)';

-- Инициализация записи для топ-10
INSERT INTO marketplace_system_messages (message_type, message_id_channel)
VALUES ('top_10_ideas', NULL)
ON CONFLICT (message_type) DO NOTHING;

-- ============================================================================
-- ПРОВЕРКА СОЗДАННЫХ ТАБЛИЦ
-- ============================================================================
SELECT 
    table_name,
    (SELECT COUNT(*) FROM information_schema.columns WHERE table_name = t.table_name) as columns_count
FROM information_schema.tables t
WHERE table_schema = 'public' 
AND table_name LIKE 'marketplace_%'
ORDER BY table_name;

-- Должно вывести 5 таблиц:
-- marketplace_conversations
-- marketplace_payments
-- marketplace_requests
-- marketplace_system_messages
-- marketplace_votes
