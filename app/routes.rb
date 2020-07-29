require File.dirname(__FILE__) + '/../lib/routing'

require File.dirname(__FILE__) + '/plans/routes'
require File.dirname(__FILE__) + '/covid/routes'
require File.dirname(__FILE__) + '/resumen/routes'
require File.dirname(__FILE__) + '/afiliados/routes'
require File.dirname(__FILE__) + '/consulta_centros/routes'

class Routes
  include Routing

  include PlansRoutes
  include CovidRoutes
  include ResumenRoutes
  include RegistrationRoutes
  include CentrosRoutes

  on_message '/start' do |bot, message|
    bot.api.send_message(chat_id: message.chat.id, text: "Hola #{message.from.first_name}, Bienvenido al Bot de Alto Jardin.")
  end

  on_message '/stop' do |bot, message|
    bot.api.send_message(chat_id: message.chat.id, text: "Chau, #{message.from.username}")
  end

  default do |bot, message|
    bot.api.send_message(chat_id: message.chat.id, text: 'Uh? No te entiendo! Me repetis la pregunta?')
  end
end
