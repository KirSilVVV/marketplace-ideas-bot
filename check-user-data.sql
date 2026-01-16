-- ============================================================================
-- ПРОВЕРКА ОПЛАТЫ И ДИАЛОГОВ ПОЛЬЗОВАТЕЛЯ 83436260
-- ============================================================================

-- 1. Проверка платежей пользователя
SELECT 
    id,
    user_id,
    user_name,
    stars,
    telegram_charge_id,
    created_at
FROM marketplace_payments
WHERE user_id = '83436260'
ORDER BY created_at DESC;

-- 2. Проверка опубликованных идей пользователя
SELECT 
    id,
    user_id,
    user_name,
    short_description,
    full_description,
    votes_count,
    has_priority,
    message_id_channel,
    created_at
FROM marketplace_requests
WHERE user_id = '83436260'
ORDER BY created_at DESC;

-- 3. История AI диалогов пользователя
SELECT 
    session_id,
    message_number,
    message_text,
    ai_response,
    ready_to_publish,
    published,
    created_at
FROM marketplace_conversations
WHERE user_id = '83436260'
ORDER BY session_id, message_number;

-- 4. Полная статистика пользователя
SELECT 
    'Платежей' as type, COUNT(*) as count 
FROM marketplace_payments 
WHERE user_id = '83436260'
UNION ALL
SELECT 
    'Идей товаров' as type, COUNT(*) as count 
FROM marketplace_requests 
WHERE user_id = '83436260'
UNION ALL
SELECT 
    'Сообщений в AI' as type, COUNT(*) as count 
FROM marketplace_conversations 
WHERE user_id = '83436260';
