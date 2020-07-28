require File.dirname(__FILE__) + '/../../lib/routing'

require_relative './afiliados_service'

module RegistrationRoutes
  include Routing

  on_message_pattern %r{/registracion (?<nombre_plan>.*), (?<nombre>.*), (?<edad>.*)} do |bot, message, args|
    response = AfiliadosService.post_afiliados(nombre: args['nombre'],
                                               nombre_plan: args['nombre_plan'],
                                               edad: args['edad'].to_i,
                                               cantidad_hijos: 0,
                                               conyuge: false,
                                               id_telegram: message.from.id)
    if response.status == 201
      bot.api.send_message(chat_id: message.chat.id, text: 'Registración exitosa')
    else
      bot.api.send_message(chat_id: message.chat.id, text: "Registración fallida: #{response.body.force_encoding('UTF-8')}")
    end
  end

  on_message_pattern %r{/registracion (?<parametros>.*)} do |bot, message, _args|
    bot.api.send_message(chat_id: message.chat.id, text: 'Comando incorrecto, se necesita nombre del plan e información personal. Ej: /registracion NombrePlan, Nombre, {edad}')
  end

  on_message '/registracion' do |bot, message|
    bot.api.send_message(chat_id: message.chat.id, text: 'Comando incorrecto, se necesita nombre del plan e información personal. Ej: /registracion NombrePlan, Nombre, {edad}')
  end
end
