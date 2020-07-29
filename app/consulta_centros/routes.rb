require File.dirname(__FILE__) + '/../../lib/routing'
require_relative './centros_service'

module CentrosRoutes
  include Routing

  on_message_pattern %r{/consulta(?<parametro>.*)} do |bot, message, args|
    prestacion = args['parametro'].strip

    if prestacion.empty?
      bot.api.send_message(chat_id: message.chat.id, text: 'Comando incorrecto, se necesita nombre de la prestación.') if prestacion.empty?
    else
      _response = CentrosService.get_centros(prestacion)
      bot.api.send_message(chat_id: message.chat.id, text: 'Perdón, no se encontró ninguna prestación con ese nombre.')
    end
  end
end
