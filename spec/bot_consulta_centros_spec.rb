require 'spec_helper'
require 'web_mock'

require File.dirname(__FILE__) + '/../app/bot_client'

describe 'BotClientCentersCommands' do
  let(:token) { 'fake_token' }

  it 'when benefit is not sent' do
    stub_get_updates(token, '/consulta')
    stub_send_message(token, 'Comando incorrecto, se necesita nombre de la prestación.')

    app = BotClient.new(token)
    app.run_once
  end

  it 'when benefit doesnt exist' do # rubocop:disable RSpec/ExampleLength
    stub_get_updates(token, '/consulta PrestacionFalsa')

    body = 'La prestación pedida no existe'
    stub_request(:get, "#{ENV['API_URL']}/centros?prestacion=PrestacionFalsa")
      .to_return(status: 400, body: body.to_json, headers: {})

    stub_send_message(token, 'Perdón, no se encontró ninguna prestación con ese nombre.')

    app = BotClient.new(token)
    app.run_once
  end

  xit 'when benefit has no centers ' do # rubocop:disable RSpec/ExampleLength
    stub_get_updates(token, '/consulta Traumatologia')

    body = { 'centros': [] }
    stub_request(:get, "#{ENV['API_URL']}/centros?prestacion=Traumatologia")
      .to_return(status: 200, body: body.to_json, headers: {})

    stub_send_message(token, 'Lo sentimos, no hay hospitales disponibles para esa prestación.')

    app = BotClient.new(token)
    app.run_once
  end

  xit 'when benefit has one center' do # rubocop:disable RSpec/ExampleLength
    stub_get_updates(token, '/consulta Traumatologia')

    body = { 'centros': [{
      'id': 1,
      'nombre': 'Hospital Alemán',
      'latitud': -37.54,
      'longitud': -36.40
    }] }
    stub_request(:get, "#{ENV['API_URL']}/centros?prestacion=Traumatologia")
      .to_return(status: 400, body: body.to_json, headers: {})

    stub_send_message(token, 'Hospital Alemán - Coordenadas (-37.54, -36.40)')

    app = BotClient.new(token)
    app.run_once
  end

  xit 'when benefit has multiple centers' do # rubocop:disable RSpec/ExampleLength
    stub_get_updates(token, '/consulta Traumatologia')

    body = { 'centros': [{
      'id': 1,
      'nombre': 'Hospital Alemán',
      'latitud': -37.54,
      'longitud': -36.40
    },
                         {
                           'id': 1,
                           'nombre': 'Hospital Suizo',
                           'latitud': -39.54,
                           'longitud': -46.45
                         }] }
    stub_request(:get, "#{ENV['API_URL']}/centros?prestacion=Traumatologia")
      .to_return(status: 400, body: body.to_json, headers: {})

    stub_send_message(token, "Hospital Alemán - Coordenadas (-37.54, -36.40)\nHospital Suizo - Coordenadas (-39.54, -46.45)")

    app = BotClient.new(token)
    app.run_once
  end
end
