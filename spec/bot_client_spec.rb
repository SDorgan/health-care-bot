require 'spec_helper'
require 'web_mock'

require File.dirname(__FILE__) + '/../app/bot_client'

describe 'BotClient' do
  let(:token) { 'fake_token' }

  it 'should get a /start message and respond with Hola' do
    stub_get_updates(token, '/start')
    stub_send_message(token, 'Hola Alto Jardin, Bienvenido al Bot de Alto Jardin.')

    app = BotClient.new(token)

    app.run_once
  end

  it 'should get a /stop message and respond with Chau' do
    stub_get_updates(token, '/stop')
    stub_send_message(token, 'Chau, altojardin')

    app = BotClient.new(token)

    app.run_once
  end

  it 'should get an unknown message message and respond with Do not understand' do
    stub_get_updates(token, '/unknown')
    stub_send_message(token, 'Uh? No te entiendo! Me repetis la pregunta?')

    app = BotClient.new(token)

    app.run_once
  end
end
