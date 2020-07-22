require File.dirname(__FILE__) + '/../lib/routing'
require_relative './plans/plan_manager'
require_relative './afiliados/afiliados_manager'
require_relative './resumen/resumen_manager'
require_relative './covid/register_covid_service'

class Routes
  include Routing

  on_message '/start' do |bot, message|
    bot.api.send_message(chat_id: message.chat.id, text: "Hola #{message.from.first_name}, Bienvenido al Bot de Alto Jardin.")
  end

  on_message '/stop' do |bot, message|
    bot.api.send_message(chat_id: message.chat.id, text: "Chau, #{message.from.username}")
  end

  on_message '/planes' do |bot, message|
    available_plans = PlanManager.all_plans
    if available_plans.empty?
      bot.api.send_message(chat_id: message.chat.id, text: 'Lo sentimos, parece que no hay planes cargados en el momento.')
    else
      plans_text = 'Estos son nuestros planes disponibles:'
      available_plans.each do |plan|
        plans_text << "\n#{plan['nombre']}"
      end
      bot.api.send_message(chat_id: message.chat.id, text: plans_text)
    end
  end

  on_message_pattern %r{/registracion (?<nombre_plan>.*), (?<nombre>.*)} do |bot, message, args|
    creado = AfiliadosManager.post_afiliados(args['nombre'], args['nombre_plan'], message.from.id)
    if creado
      bot.api.send_message(chat_id: message.chat.id, text: 'Registración exitosa')
    else
      bot.api.send_message(chat_id: message.chat.id, text: "Registración fallida, verifique que el plan exista. Ej: /registracion PlanJuventud, #{args['nombre']}")
    end
  end

  on_message '/diagnostico covid' do |bot, message|
    pregunta = 'Cuál es tu temperatura corporal?'
    kb = [
      Telegram::Bot::Types::InlineKeyboardButton.new(text: '35 o menos', callback_data: '35'),
      Telegram::Bot::Types::InlineKeyboardButton.new(text: '36', callback_data: '36'),
      Telegram::Bot::Types::InlineKeyboardButton.new(text: '37', callback_data: '37'),
      Telegram::Bot::Types::InlineKeyboardButton.new(text: '38 o más', callback_data: '38')
    ]
    markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
    bot.api.send_message(chat_id: message.chat.id, text: pregunta, reply_markup: markup)
  end

  on_response_to 'Cuál es tu temperatura corporal?' do |bot, message|
    if message.data.eql? '38'
      registrado = RegisterCovidService.post_covid(message.message.from.id)
      if registrado
        bot.api.send_message(chat_id: message.message.chat.id, text: 'Sos un caso sospechoso de COVID. Acércate a un centro médico')
      else
        bot.api.send_message(chat_id: message.message.chat.id, text: 'Sos un caso sospechoso de COVID. Acércate a un centro médico. No se pudo registrar el caso correctamente en el centro')
      end
    else
      bot.api.send_message(chat_id: message.message.chat.id, text: 'Gracias por realizar el diagnóstico')
    end
  end

  on_message '/resumen' do |bot, message|
    resumen = ResumenManager.get_resumen(message.from.id)

    bot.api.send_message(chat_id: message.chat.id, text: resumen)
  end

  default do |bot, message|
    bot.api.send_message(chat_id: message.chat.id, text: 'Uh? No te entiendo! Me repetis la pregunta?')
  end
end
