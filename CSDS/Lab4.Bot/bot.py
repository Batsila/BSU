import telebot

bot = telebot.TeleBot('bot_token')

@bot.message_handler(commands=['start'])
def start_message(message):
    bot.send_message(message.chat.id, 'Привет, ты написал мне /start')

@bot.message_handler(content_types=['text'])
def send_text(message):
    if message.text.lower() == 'привет':
        bot.send_message(message.chat.id, 'Привет, мой создатель')
    elif message.text.lower() == 'пока':
        bot.send_message(message.chat.id, 'Прощай, создатель')

@bot.message_handler(content_types=['sticker'])
def sticker_id(message):
    print(message.sticker.file_id)
    bot.send_sticker(message.chat.id, message.sticker.file_id)

bot.polling()