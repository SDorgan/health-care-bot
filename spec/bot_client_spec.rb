require 'spec_helper'
require 'web_mock'
# Uncomment to use VCR
# require 'vcr_helper'

require File.dirname(__FILE__) + '/../app/bot_client'

def stub_get_updates(token, message_text)
  body = { "ok": true, "result": [{ "update_id": 693_981_718,
                                    "message": { "message_id": 11,
                                                 "from": { "id": 141_733_544, "is_bot": false, "first_name": 'Alto Jardin', "last_name": 'GOT', "username": 'altojardin', "language_code": 'en' },
                                                 "chat": { "id": 141_733_544, "first_name": 'Alto Jardin', "last_name": 'GOT', "username": 'altojardin', "type": 'private' },
                                                 "date": 1_557_782_998, "text": message_text,
                                                 "entities": [{ "offset": 0, "length": 6, "type": 'bot_command' }] } }] }

  stub_request(:any, "https://api.telegram.org/bot#{token}/getUpdates")
    .to_return(body: body.to_json, status: 200, headers: { 'Content-Length' => 3 })
end

def stub_send_message(token, message_text)
  body = { "ok": true,
           "result": { "message_id": 12,
                       "from": { "id": 715_612_264, "is_bot": true, "first_name": 'fiuba-memo2-prueba', "username": 'fiuba_memo2_bot' },
                       "chat": { "id": 141_733_544, "first_name": 'Alto Jardin', "last_name": 'GOT', "username": 'altojardin', "type": 'private' },
                       "date": 1_557_782_999, "text": message_text } }

  stub_request(:post, "https://api.telegram.org/bot#{token}/sendMessage")
    .with(
      body: { 'chat_id' => '141733544', 'text' => message_text }
    )
    .to_return(status: 200, body: body.to_json, headers: {})
end

def stub_send_keyboard_message(token, message_text)
  body = { "ok": true,
           "result": { "message_id": 12,
                       "from": { "id": 715_612_264, "is_bot": true, "first_name": 'fiuba-memo2-prueba', "username": 'fiuba_memo2_bot' },
                       "chat": { "id": 141_733_544, "first_name": 'Alto Jardin', "last_name": 'GOT', "username": 'altojardin', "type": 'private' },
                       "date": 1_557_782_999, "text": message_text } }

  stub_request(:post, "https://api.telegram.org/bot#{token}/sendMessage")
    .with(
      body: { 'chat_id' => '141733544',
              'reply_markup' => '{"inline_keyboard":[[{"text":"Jon Snow","callback_data":"1"}],[{"text":"Daenerys Targaryen","callback_data":"2"}],[{"text":"Ned Stark","callback_data":"3"}]]}',
              'text' => message_text }
    )
    .to_return(status: 200, body: body.to_json, headers: {})
end

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

  it 'when no plans, should get a /planes message and respond with no plan' do # rubocop:disable RSpec/ExampleLength
    stub_get_updates(token, '/planes')

    body = { "planes": [] }
    stub_request(:get, "#{ENV['API_URL']}/planes")
      .to_return(status: 200, body: body.to_json, headers: {})

    stub_send_message(token, 'Lo sentimos, parece que no hay planes cargados en el momento.')

    app = BotClient.new(token)
    app.run_once
  end

  it 'When plans, should get a /planes message and respond with plans' do # rubocop:disable RSpec/ExampleLength
    stub_get_updates(token, '/planes')
    body = { "planes": [
      { id: 1, 'nombre': 'plan1' },
      { id: 2, 'nombre': 'plan2' }
    ] }
    stub_request(:get, "#{ENV['API_URL']}/planes")
      .to_return(status: 200, body: body.to_json, headers: {})
    stub_send_message(token, "Estos son nuestros planes disponibles:\nplan1\nplan2")

    app = BotClient.new(token)

    app.run_once
  end

  it 'when user register to plan /registracion is successfull' do # rubocop:disable RSpec/ExampleLength
    stub_get_updates(token, '/registracion PlanJuventud, Juan')

    body = { "id": 1 }
    stub_request(:post, "#{ENV['API_URL']}/afiliados")
      .with(
        body: { 'nombre' => 'Juan', 'nombre_plan' => 'PlanJuventud', 'id_telegram' => 141_733_544 }
      )
      .to_return(status: 201, body: body.to_json, headers: {})

    stub_send_message(token, 'Registración exitosa')

    app = BotClient.new(token)
    app.run_once
  end

  it 'when user register to plan /registracion and get error' do # rubocop:disable RSpec/ExampleLength
    stub_get_updates(token, '/registracion PlanJuventud, Juan')

    body = { "id": 1 }
    stub_request(:post, "#{ENV['API_URL']}/afiliados")
      .with(
        body: { 'nombre' => 'Juan', 'nombre_plan' => 'PlanJuventud', 'id_telegram' => 141_733_544 }
      )
      .to_return(status: 400, body: body.to_json, headers: {})

    stub_send_message(token, 'Registración fallida, verifique que el plan exista. Ej: /registracion PlanJuventud, Pepe')

    app = BotClient.new(token)
    app.run_once
  end
end
