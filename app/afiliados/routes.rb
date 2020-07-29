require File.dirname(__FILE__) + '/../../lib/routing'

require_relative './afiliados_service'

module RegistrationRoutes
  include Routing

  on_message_pattern %r{/registracion(?<parametros>.*)} do |bot, message, args|
    parametros = args['parametros'].split(',')
    if parametros.length >= 3
      nombre_plan = parametros[0].squeeze(' ').strip
      nombre = parametros[1].squeeze(' ').strip
      edad = parametros[2].to_i
      cantidad_hijos = 0
      conyuge = !args['parametros'].match(/conyuge\b/).nil?
      response = AfiliadosService.post_afiliados(nombre: nombre,
                                                 nombre_plan: nombre_plan,
                                                 edad: edad,
                                                 cantidad_hijos: cantidad_hijos,
                                                 conyuge: conyuge,
                                                 id_telegram: message.from.id)
      if response.status == 201
        bot.api.send_message(chat_id: message.chat.id, text: 'Registración exitosa')
      else
        bot.api.send_message(chat_id: message.chat.id, text: "Registración fallida: #{response.body.force_encoding('UTF-8')}")
      end
    else
      bot.api.send_message(chat_id: message.chat.id, text: 'Comando incorrecto, se necesita nombre del plan e información personal. Ej: /registracion NombrePlan, Nombre, {edad}')
    end
  end
end
