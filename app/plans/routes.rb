require File.dirname(__FILE__) + '/../../lib/routing'

require_relative './plan_service'

module PlansRoutes
  include Routing

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

  on_message_pattern %r{/plan (?<nombre>.*)} do |bot, message, args|
    plan = PlanService.get_plan(args['nombre'])

    bot.api.send_message(chat_id: message.chat.id, text: plan)
  end
end
