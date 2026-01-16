-- ============================================================================
-- Таблица системных сообщений с топ-10
-- ============================================================================
-- Хранит ID сообщений с топ-10 идей для ежедневного обновления

CREATE TABLE IF NOT EXISTS marketplace_system_messages (
    id BIGSERIAL PRIMARY KEY,
    message_type TEXT NOT NULL UNIQUE,
    message_id_channel BIGINT,
    last_updated TIMESTAMP DEFAULT NOW()
);

-- Индексы
CREATE INDEX IF NOT EXISTS idx_marketplace_system_messages_type ON marketplace_system_messages(message_type);

-- Комментарии
COMMENT ON TABLE marketplace_system_messages IS 'Системные сообщения бота в канале (marketplace bot)';
COMMENT ON COLUMN system_messages.message_type IS 'Тип сообщения: top_10_ideas';
COMMENT ON COLUMN system_messages.message_id_channel IS 'ID сообщения в канале для редактирования';
COMMENT ON COLUMN system_messages.last_updated IS 'Время последнего обновления';

-- Инициализация записи для топ-10
INSERT INTO marketplace_system_messages (message_type, message_id_channel)
VALUES ('top_10_ideas', NULL)
ON CONFLICT (message_type) DO NOTHING;

-- Проверка
-- SELECT * FROM marketplace_system_messages;
