require 'spec_helper'
require 'web_mock'

require File.dirname(__FILE__) + '/../app/bot_client'

def stub_get_updates(token, message_text)
  body = {
    "ok": true,
    "result": [
      {
        "update_id": 693_981_718,
        "message": {
          "message_id": 11,
          "from": {
            "id": 141_733_544, "is_bot": false,
            "first_name": 'Alto Jardin',
            "last_name": 'GOT', "username": 'altojardin', "language_code": 'en'
          },
          "chat": {
            "id": 141_733_544,
            "first_name": 'Alto Jardin',
            "last_name": 'GOT', "username": 'altojardin', "type": 'private'
          },
          "date": 1_557_782_998,
          "text": message_text,
          "entities": [{ "offset": 0, "length": 6, "type": 'bot_command' }]
        }
      }
    ]
  }

  stub_request(:any, "https://api.telegram.org/bot#{token}/getUpdates")
    .to_return(body: body.to_json, status: 200, headers: { 'Content-Length' => 3 })
end

def stub_send_message(token, message_text)
  body = {
    "ok": true,
    "result": {
      "message_id": 12,
      "from": { "id": 715_612_264, "is_bot": true, "first_name": 'fiuba-memo2-prueba', "username": 'fiuba_memo2_bot' },
      "chat": { "id": 141_733_544, "first_name": 'Alto Jardin', "last_name": 'GOT', "username": 'altojardin', "type": 'private' },
      "date": 1_557_782_999, "text": message_text
    }
  }

  stub_request(:post, "https://api.telegram.org/bot#{token}/sendMessage")
    .with(
      body: { 'chat_id' => '141733544', 'text' => message_text }
    )
    .to_return(status: 200, body: body.to_json, headers: {})
end

describe 'BotClientRegistrationCommands' do
  let(:token) { 'fake_token' }

  it 'when user register to plan /registracion with no parameter receives a help' do
    stub_get_updates(token, '/registracion')
    stub_send_message(token, 'Comando incorrecto, se necesita nombre del plan e información personal. Ej: /registracion NombrePlan, Nombre')

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

    stub_send_message(token, 'Registración fallida, verifique que el plan exista. Ej: /registracion PlanJuventud, Juan')

    app = BotClient.new(token)
    app.run_once
  end
end
