require File.dirname(__FILE__) + '/../../lib/routing'
require_relative './centros_service'
require_relative './centros_presenter'

module CentrosRoutes
  include Routing

  on_message_pattern %r{/consulta(?<parametro>.*)} do |bot, message, args|
    prestacion = args['parametro'].strip

    if prestacion.empty?
      bot.api.send_message(chat_id: message.chat.id, text: 'Comando incorrecto, se necesita nombre de la prestación.') if prestacion.empty?
    else
      response = CentrosService.get_centros(prestacion)
      if response.status == 200
        reply_text = CentrosPresenter.parse_centros(response.body)
        bot.api.send_message(chat_id: message.chat.id, text: reply_text)
      else
        bot.api.send_message(chat_id: message.chat.id, text: 'Perdón, no se encontró ninguna prestación con ese nombre.')
      end
    end
  end
end
