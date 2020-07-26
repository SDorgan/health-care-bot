require 'spec_helper'
require 'web_mock'

require File.dirname(__FILE__) + '/../app/bot_client'

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
