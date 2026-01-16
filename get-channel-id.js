// Скрипт для получения ID канала
import { Telegraf } from 'telegraf';
import dotenv from 'dotenv';

dotenv.config();

const bot = new Telegraf('8512741780:AAEBO9od0aErkq7ds-WopRcbE2I4Jkan6Ds');

async function getChannelId() {
    try {
        // Попробуем получить информацию о канале по username
        const chat = await bot.telegram.getChat('@aidevelopersGG');
        console.log('\n✅ ID канала найден!\n');
        console.log('📋 Информация о канале:');
        console.log('   Username: @' + chat.username);
        console.log('   Title:', chat.title);
        console.log('   ID:', chat.id);
        console.log('\n💡 Скопируй этот ID в .env файл:');
        console.log(`   TELEGRAM_CHANNEL_ID=${chat.id}`);
    } catch (error) {
        console.error('\n❌ Ошибка:', error.message);
        console.log('\n💡 Убедись что:');
        console.log('   1. Бот добавлен в канал @aidevelopersGG');
        console.log('   2. Бот назначен администратором канала');
        console.log('   3. У бота есть права на отправку сообщений');
    } finally {
        process.exit(0);
    }
}

getChannelId();
