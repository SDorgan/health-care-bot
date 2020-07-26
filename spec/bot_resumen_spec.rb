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

describe 'BotClientResumenCommands' do
  let(:token) { 'fake_token' }

  it 'when user looks up resume with a plan but no visits' do # rubocop:disable RSpec/ExampleLength
    stub_get_updates(token, '/resumen')
    body = { "resumen": { "afiliado": 'Nombre de Afiliado',
                          "plan": {
                            "nombre": 'Nombre de Plan',
                            "costo": 5000
                          },
                          "adicional": 0,
                          "total": 5000 } }
    stub_request(:get, "#{ENV['API_URL']}/resumen?id=141733544&from=telegram").to_return(status: 200, body: body.to_json, headers: {})

    stub_send_message(token,
                      "Nombre: Nombre de Afiliado\n" \
                      "Plan: Nombre de Plan\n" \
                      "Costo plan: $5000\n" \
                      "Saldo adicional: $0\n" \
                      'Total a pagar: $5000')

    app = BotClient.new(token)
    app.run_once
  end

  it 'when user looks up resume with a plan after visits' do # rubocop:disable RSpec/ExampleLength
    stub_get_updates(token, '/resumen')
    body = { "resumen": { "afiliado": 'Nombre de Afiliado',
                          "plan": {
                            "nombre": 'Nombre de Plan',
                            "costo": 5000
                          },
                          "adicional": 1200,
                          "total": 6200 } }
    stub_request(:get, "#{ENV['API_URL']}/resumen?id=141733544&from=telegram").to_return(status: 200, body: body.to_json, headers: {})

    stub_send_message(token,
                      "Nombre: Nombre de Afiliado\n" \
                      "Plan: Nombre de Plan\n" \
                      "Costo plan: $5000\n" \
                      "Saldo adicional: $1200\n" \
                      'Total a pagar: $6200')

    app = BotClient.new(token)
    app.run_once
  end

  it 'when user non afiliated looks for his resume' do # rubocop:disable RSpec/ExampleLength
    stub_get_updates(token, '/resumen')
    body = 'El ID no pertenece a un afiliado'
    stub_request(:get, "#{ENV['API_URL']}/resumen?id=141733544&from=telegram").to_return(status: 401, body: body, headers: {})

    stub_send_message(token, 'Parece que no estás afiliado a ningún plan, por lo que no podemos mandarte un resumen en este momento.')

    app = BotClient.new(token)
    app.run_once
  end

  it 'when API fails looking up the resume' do # rubocop:disable RSpec/ExampleLength
    stub_get_updates(token, '/resumen')
    body = 'Error obteniendo el resumen'
    stub_request(:get, "#{ENV['API_URL']}/resumen?id=141733544&from=telegram").to_return(status: 500, body: body, headers: {})

    stub_send_message(token, 'Error obteniendo el resumen')

    app = BotClient.new(token)
    app.run_once
  end
end
