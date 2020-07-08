require File.dirname(__FILE__) + '/../lib/routing'
require_relative './plans/plan_manager'

class Routes
  include Routing

  on_message '/start' do |bot, message|
    bot.api.send_message(chat_id: message.chat.id, text: "Hola #{message.from.first_name}, Bienvenido al Bot de Alto Jardin.")
  end

  on_message '/stop' do |bot, message|
    bot.api.send_message(chat_id: message.chat.id, text: "Chau, #{message.from.username}")
  end

  on_message '/plan' do |bot, message|
    plan_manager = PlanManager.new
    available_plans = plan_manager.all_plans
    bot.api.send_message(chat_id: message.chat.id, text: 'Lo sentimos, parece que no hay planes cargados en el momento.') if available_plans.empty?
  end

  default do |bot, message|
    bot.api.send_message(chat_id: message.chat.id, text: 'Uh? No te entiendo! Me repetis la pregunta?')
  end
end
