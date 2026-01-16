-- ============================================================================
-- Таблица голосований для идей маркетплейс-товаров
-- ============================================================================
-- Каждый пользователь может проголосовать за/против каждую идею только 1 раз

CREATE TABLE IF NOT EXISTS votes (
    id BIGSERIAL PRIMARY KEY,
    user_id TEXT NOT NULL,
    user_name TEXT,
    request_id INTEGER NOT NULL,
    vote_type TEXT NOT NULL CHECK (vote_type IN ('up', 'down')),
    created_at TIMESTAMP DEFAULT NOW(),
    
    -- Ограничение: 1 голос на пользователя на идею
    UNIQUE(user_id, request_id)
);

-- Индексы для быстрого поиска
CREATE INDEX IF NOT EXISTS idx_votes_request_id ON votes(request_id);
CREATE INDEX IF NOT EXISTS idx_votes_user_id ON votes(user_id);
CREATE INDEX IF NOT EXISTS idx_votes_created_at ON votes(created_at DESC);

-- Комментарии
COMMENT ON TABLE votes IS 'Голоса пользователей за/против идеи товаров';
COMMENT ON COLUMN votes.vote_type IS 'Тип голоса: up (за) или down (против)';
COMMENT ON COLUMN votes.request_id IS 'ID идеи товара из таблицы requests';

-- Проверка
-- SELECT * FROM marketplace_votes ORDER BY created_at DESC LIMIT 10;
