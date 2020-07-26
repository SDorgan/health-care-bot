require File.dirname(__FILE__) + '/../../lib/routing'

require_relative './resumen_service'

module ResumenRoutes
  include Routing

  on_message '/resumen' do |bot, message|
    resumen = ResumenService.get_resumen(message.from.id)

    bot.api.send_message(chat_id: message.chat.id, text: resumen)
  end
end
