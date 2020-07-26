require File.dirname(__FILE__) + '/../lib/routing'
require File.dirname(__FILE__) + '/covid/routes'

require_relative './plans/plan_service'
require_relative './afiliados/afiliados_service'
require_relative './resumen/resumen_service'

class Routes
  include Routing

  include CovidRoutes

  on_message '/start' do |bot, message|
    bot.api.send_message(chat_id: message.chat.id, text: "Hola #{message.from.first_name}, Bienvenido al Bot de Alto Jardin.")
  end

  on_message '/stop' do |bot, message|
    bot.api.send_message(chat_id: message.chat.id, text: "Chau, #{message.from.username}")
  end

  default do |bot, message|
    bot.api.send_message(chat_id: message.chat.id, text: 'Uh? No te entiendo! Me repetis la pregunta?')
  end

  on_message '/planes' do |bot, message|
    available_plans = PlanService.all_plans
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

  on_message '/resumen' do |bot, message|
    resumen = ResumenService.get_resumen(message.from.id)

    bot.api.send_message(chat_id: message.chat.id, text: resumen)
  end

  on_message_pattern %r{/registracion (?<nombre_plan>.*), (?<nombre>.*)} do |bot, message, args|
    creado = AfiliadosService.post_afiliados(args['nombre'], args['nombre_plan'], message.from.id)
    if creado
      bot.api.send_message(chat_id: message.chat.id, text: 'Registración exitosa')
    else
      bot.api.send_message(chat_id: message.chat.id, text: "Registración fallida, verifique que el plan exista. Ej: /registracion PlanJuventud, #{args['nombre']}")
    end
  end

  on_message '/registracion' do |bot, message|
    bot.api.send_message(chat_id: message.chat.id, text: 'Comando incorrecto, se necesita nombre del plan e información personal. Ej: /registracion NombrePlan, Nombre')
  end
end
