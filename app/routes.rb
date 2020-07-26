require File.dirname(__FILE__) + '/../lib/routing'
require File.dirname(__FILE__) + '/covid/routes'
require File.dirname(__FILE__) + '/afiliados/routes'

require_relative './plans/plan_service'
require_relative './resumen/resumen_service'

class Routes
  include Routing

  include CovidRoutes
  include RegistrationRoutes

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
end
