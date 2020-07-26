require File.dirname(__FILE__) + '/../../lib/routing'

require_relative './afiliados_service'

module RegistrationRoutes
  include Routing

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
