-- ============================================================================
-- Таблица AI диалогов для аналитики
-- ============================================================================
-- Хранит все сообщения пользователей и ответы AI

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

-- Индексы
CREATE INDEX IF NOT EXISTS idx_marketplace_conversations_user_id ON marketplace_conversations(user_id);
CREATE INDEX IF NOT EXISTS idx_marketplace_conversations_session_id ON marketplace_conversations(session_id);
CREATE INDEX IF NOT EXISTS idx_marketplace_conversations_created_at ON marketplace_conversations(created_at DESC);

-- Комментарии
COMMENT ON TABLE marketplace_conversations IS 'AI диалоги Customer Development для аналитики (marketplace bot)';
COMMENT ON COLUMN conversations.session_id IS 'Уникальный ID сессии диалога';
COMMENT ON COLUMN conversations.message_number IS 'Номер вопроса в сессии';
COMMENT ON COLUMN conversations.ready_to_publish IS 'Готова ли идея к публикации (7+ вопросов)';
COMMENT ON COLUMN conversations.published IS 'Была ли идея опубликована';

-- Проверка
-- SELECT * FROM marketplace_conversations ORDER BY created_at DESC LIMIT 10;
