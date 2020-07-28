require 'spec_helper'
require 'web_mock'

require File.dirname(__FILE__) + '/../app/bot_client'

describe 'BotClientRegistrationCommands' do
  let(:token) { 'fake_token' }

  it 'when user register to plan /registracion with no parameter receives a help' do
    stub_get_updates(token, '/registracion')
    stub_send_message(token, 'Comando incorrecto, se necesita nombre del plan e información personal. Ej: /registracion NombrePlan, Nombre, {edad}')

    app = BotClient.new(token)
    app.run_once
  end

  it 'when user register to plan /registracion with no all parameter receives a help' do
    stub_get_updates(token, '/registracion plan')
    stub_send_message(token, 'Comando incorrecto, se necesita nombre del plan e información personal. Ej: /registracion NombrePlan, Nombre, {edad}')

    app = BotClient.new(token)
    app.run_once
  end

  it 'when user register to plan /registracion is successfull' do # rubocop:disable RSpec/ExampleLength
    stub_get_updates(token, '/registracion PlanJuventud, Juan, 18')

    body = { "id": 1 }
    stub_request(:post, "#{ENV['API_URL']}/afiliados")
      .with(
        body: { 'nombre' => 'Juan', 'nombre_plan' => 'PlanJuventud', 'edad': 18, 'cantidad_hijos': 0, 'conyuge': false, 'id_telegram' => 141_733_544 }
      )
      .to_return(status: 201, body: body.to_json, headers: {})

    stub_send_message(token, 'Registración exitosa')

    app = BotClient.new(token)
    app.run_once
  end

  it 'when user register to plan /registracion and get error' do # rubocop:disable RSpec/ExampleLength
    stub_get_updates(token, '/registracion PlanJuventud, Juan, 18')

    body = { "id": 1 }
    stub_request(:post, "#{ENV['API_URL']}/afiliados")
      .with(
        body: { 'nombre' => 'Juan', 'nombre_plan' => 'PlanJuventud', 'edad': 18, 'cantidad_hijos': 0, 'conyuge': false, 'id_telegram' => 141_733_544 }
      )
      .to_return(status: 400, body: body.to_json, headers: {})

    stub_send_message(token, 'Registración fallida, verifique que el plan exista. Ej: /registracion PlanJuventud, Juan, {edad}')

    app = BotClient.new(token)
    app.run_once
  end
end
