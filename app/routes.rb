require File.dirname(__FILE__) + '/../lib/routing'
require_relative './plans/plan_manager'
require_relative './afiliados/afiliados_manager'

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

  default do |bot, message|
    bot.api.send_message(chat_id: message.chat.id, text: 'Uh? No te entiendo! Me repetis la pregunta?')
  end
end
