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
      .to_return(status: 404, body: body.to_json, headers: {})

    stub_send_message(token, 'Perdón, no se encontró ninguna prestación con ese nombre.')

    app = BotClient.new(token)
    app.run_once
  end

  it 'when benefit has no centers ' do # rubocop:disable RSpec/ExampleLength
    stub_get_updates(token, '/consulta Traumatologia')

    body = { 'centros': [] }
    stub_request(:get, "#{ENV['API_URL']}/centros?prestacion=Traumatologia")
      .to_return(status: 200, body: body.to_json, headers: {})

    stub_send_message(token, 'Lo sentimos, no hay hospitales disponibles para esa prestación.')

    app = BotClient.new(token)
    app.run_once
  end

  it 'when benefit has one center' do # rubocop:disable RSpec/ExampleLength
    stub_get_updates(token, '/consulta Traumatologia')

    body = { 'centros': [{
      'id': 1,
      'nombre': 'Hospital Alemán',
      'latitud': -37.54,
      'longitud': -36.40
    }] }
    stub_request(:get, "#{ENV['API_URL']}/centros?prestacion=Traumatologia")
      .to_return(status: 200, body: body.to_json, headers: {})

    stub_send_message(token, "Hospital Alemán - Coordenadas(-37.54, -36.4)\n")

    app = BotClient.new(token)
    app.run_once
  end

  it 'when benefit has multiple centers' do # rubocop:disable RSpec/ExampleLength
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
      .to_return(status: 200, body: body.to_json, headers: {})

    stub_send_message(token, "Hospital Alemán - Coordenadas(-37.54, -36.4)\nHospital Suizo - Coordenadas(-39.54, -46.45)\n")

    app = BotClient.new(token)
    app.run_once
  end

  it 'should get keyboard require location when send /centros cercano' do
    stub_get_updates(token, '/centros cercano')
    stub_send_message_get_location(token, 'Ver centros cercanos', 'Activar localización')

    app = BotClient.new(token)
    app.run_once
  end

  it 'when send /centros cercano should get message no centros when dont have nearest' do # rubocop:disable RSpec/ExampleLength
    latitude = -34.617559
    longitude = -58.368413
    stub_get_location_updates(token, latitude, longitude)
    body = { 'centros': [] }
    stub_request(:get, "http://192.168.33.10:3000/centros?latitud=#{latitude}&longitud=#{longitude}")
      .to_return(status: 200, body: body.to_json, headers: {})
    stub_send_message_remove_keyboard(token, 'No hay hospitales disponibles')

    app = BotClient.new(token)
    app.run_once
  end
end
