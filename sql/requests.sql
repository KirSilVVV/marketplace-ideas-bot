-- ============================================================================
-- Таблица запросов на проверку идей цифровых товаров
-- ============================================================================
-- Основная таблица с идеями пользователей, голосами и статусами

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

-- Индексы для производительности
CREATE INDEX IF NOT EXISTS idx_marketplace_requests_user_id ON marketplace_requests(user_id);
CREATE INDEX IF NOT EXISTS idx_marketplace_requests_created_at ON marketplace_requests(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_marketplace_requests_votes_count ON marketplace_requests(votes_count DESC);
CREATE INDEX IF NOT EXISTS idx_marketplace_requests_has_priority ON marketplace_requests(has_priority);
CREATE INDEX IF NOT EXISTS idx_marketplace_requests_message_id ON marketplace_requests(message_id_channel);

-- Комментарии
COMMENT ON TABLE marketplace_requests IS 'Запросы пользователей на валидацию идей товаров для маркетплейсов';
COMMENT ON COLUMN requests.request_type IS 'Тип запроса: marketplace_product';
COMMENT ON COLUMN requests.votes_count IS 'Количество голосов за идею';
COMMENT ON COLUMN requests.has_priority IS 'Флаг приоритета (оплачено 1⭐)';
COMMENT ON COLUMN requests.message_id_channel IS 'ID сообщения в канале @aidevelopersGG';
COMMENT ON COLUMN requests.short_description IS 'Краткое описание для канала';
COMMENT ON COLUMN requests.full_description IS 'Полное описание идеи';

-- Проверка данных
-- SELECT id, user_name, short_description, votes_count, has_priority FROM marketplace_requests ORDER BY created_at DESC LIMIT 10;
