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

  it 'when user register to plan /registracion is successful' do # rubocop:disable RSpec/ExampleLength
    stub_get_updates(token, '/registracion PlanJuventud, Juan, 18')

    body = { "id": 1 }
    stub_request(:post, "#{ENV['API_URL']}/afiliados")
      .with(
        body: { 'nombre' => 'Juan', 'nombre_plan' => 'PlanJuventud', 'edad': 18, 'cantidad_hijos': 0, 'conyuge': false, 'id_telegram' => 141_733_544 },
        headers: { 'API_KEY': API_KEY }
      )
      .to_return(status: 201, body: body.to_json, headers: {})

    stub_send_message(token, 'Registración exitosa')

    app = BotClient.new(token)
    app.run_once
  end

  it 'when user register to plan /registracion without minimum age should get error' do # rubocop:disable RSpec/ExampleLength
    stub_get_updates(token, '/registracion PlanJuventud, Juan, 7')

    body = 'no alcanza el límite mínimo de edad'
    stub_request(:post, "#{ENV['API_URL']}/afiliados")
      .with(
        body: { 'nombre' => 'Juan', 'nombre_plan' => 'PlanJuventud', 'edad': 7, 'cantidad_hijos': 0, 'conyuge': false, 'id_telegram' => 141_733_544 },
        headers: { 'API_KEY': API_KEY }
      )
      .to_return(status: 400, body: body, headers: {})

    stub_send_message(token, "Registración fallida: #{body}")

    app = BotClient.new(token)
    app.run_once
  end

  it 'when user register to plan /registracion with age more than limit should get error' do # rubocop:disable RSpec/ExampleLength
    stub_get_updates(token, '/registracion PlanJuventud, Juan, 80')

    body = 'supera el límite máximo de edad'
    stub_request(:post, "#{ENV['API_URL']}/afiliados")
      .with(
        body: { 'nombre' => 'Juan', 'nombre_plan' => 'PlanJuventud', 'edad': 80, 'cantidad_hijos': 0, 'conyuge': false, 'id_telegram' => 141_733_544 },
        headers: { 'API_KEY': API_KEY }
      )
      .to_return(status: 400, body: body, headers: {})

    stub_send_message(token, "Registración fallida: #{body}")

    app = BotClient.new(token)
    app.run_once
  end

  it 'when user register to plan /registracion with spouse is successful' do # rubocop:disable RSpec/ExampleLength
    stub_get_updates(token, '/registracion PlanJuventud, Juan, 18, conyuge')

    body = { "id": 1 }
    stub_request(:post, "#{ENV['API_URL']}/afiliados")
      .with(
        body: { 'nombre' => 'Juan', 'nombre_plan' => 'PlanJuventud', 'edad': 18, 'cantidad_hijos': 0, 'conyuge': true, 'id_telegram' => 141_733_544 },
        headers: { 'API_KEY': API_KEY }
      )
      .to_return(status: 201, body: body.to_json, headers: {})

    stub_send_message(token, 'Registración exitosa')

    app = BotClient.new(token)
    app.run_once
  end

  it 'when user register to plan /registracion with children is successful' do # rubocop:disable RSpec/ExampleLength
    stub_get_updates(token, '/registracion PlanJuventud, Juan, 18, hijos-1')

    body = { "id": 1 }
    stub_request(:post, "#{ENV['API_URL']}/afiliados")
      .with(
        body: { 'nombre' => 'Juan', 'nombre_plan' => 'PlanJuventud', 'edad': 18, 'cantidad_hijos': 1, 'conyuge': false, 'id_telegram' => 141_733_544 },
        headers: { 'API_KEY': API_KEY }
      )
      .to_return(status: 201, body: body.to_json, headers: {})

    stub_send_message(token, 'Registración exitosa')

    app = BotClient.new(token)
    app.run_once
  end

  it 'when user register to plan /registracion with children and spouse is successful' do # rubocop:disable RSpec/ExampleLength
    stub_get_updates(token, '/registracion PlanJuventud, Juan, 18, hijos-10, conyuge')

    body = { "id": 1 }
    stub_request(:post, "#{ENV['API_URL']}/afiliados")
      .with(
        body: { 'nombre' => 'Juan', 'nombre_plan' => 'PlanJuventud', 'edad': 18, 'cantidad_hijos': 10, 'conyuge': true, 'id_telegram' => 141_733_544 },
        headers: { 'API_KEY': API_KEY }
      )
      .to_return(status: 201, body: body.to_json, headers: {})

    stub_send_message(token, 'Registración exitosa')

    app = BotClient.new(token)
    app.run_once
  end

  it 'when user register to plan /registracion with children more than limit should get error' do # rubocop:disable RSpec/ExampleLength
    stub_get_updates(token, '/registracion PlanJuventud, Juan, 20, hijos-1')

    body = 'este plan no admite hijos'
    stub_request(:post, "#{ENV['API_URL']}/afiliados")
      .with(
        body: { 'nombre' => 'Juan', 'nombre_plan' => 'PlanJuventud', 'edad': 20, 'cantidad_hijos': 1, 'conyuge': false, 'id_telegram' => 141_733_544 },
        headers: { 'API_KEY': API_KEY }
      )
      .to_return(status: 400, body: body, headers: {})

    stub_send_message(token, "Registración fallida: #{body}")

    app = BotClient.new(token)
    app.run_once
  end

  it 'when user register to plan require no spouse /registracion with spouse should get error' do # rubocop:disable RSpec/ExampleLength
    stub_get_updates(token, '/registracion PlanJuventud, Juan, 20, conyuge')

    body = 'este plan no admite conyuge'
    stub_request(:post, "#{ENV['API_URL']}/afiliados")
      .with(
        body: { 'nombre' => 'Juan', 'nombre_plan' => 'PlanJuventud', 'edad': 20, 'cantidad_hijos': 0, 'conyuge': true, 'id_telegram' => 141_733_544 },
        headers: { 'API_KEY': API_KEY }
      )
      .to_return(status: 400, body: body, headers: {})

    stub_send_message(token, "Registración fallida: #{body}")

    app = BotClient.new(token)
    app.run_once
  end

  it 'when user register to plan require children /registracion with no children should get error' do # rubocop:disable RSpec/ExampleLength
    stub_get_updates(token, '/registracion PlanFamiliar, Juan, 20')

    body = 'este plan requiere tener hijos'
    stub_request(:post, "#{ENV['API_URL']}/afiliados")
      .with(
        body: { 'nombre' => 'Juan', 'nombre_plan' => 'PlanFamiliar', 'edad': 20, 'cantidad_hijos': 0, 'conyuge': false, 'id_telegram' => 141_733_544 },
        headers: { 'API_KEY': API_KEY }
      )
      .to_return(status: 400, body: body, headers: {})

    stub_send_message(token, "Registración fallida: #{body}")

    app = BotClient.new(token)
    app.run_once
  end

  it 'when user register to plan require children /registracion with spouse and no children should get error' do # rubocop:disable RSpec/ExampleLength
    stub_get_updates(token, '/registracion PlanFamiliar, Juan, 20, conyuge')

    body = 'este plan requiere tener hijos'
    stub_request(:post, "#{ENV['API_URL']}/afiliados")
      .with(
        body: { 'nombre' => 'Juan', 'nombre_plan' => 'PlanFamiliar', 'edad': 20, 'cantidad_hijos': 0, 'conyuge': true, 'id_telegram' => 141_733_544 },
        headers: { 'API_KEY': API_KEY }
      )
      .to_return(status: 400, body: body, headers: {})

    stub_send_message(token, "Registración fallida: #{body}")

    app = BotClient.new(token)
    app.run_once
  end

  it 'when user register to plan not allow children /registracion with spouse and children should get error' do # rubocop:disable RSpec/ExampleLength
    stub_get_updates(token, '/registracion PlanPareja, Miriam Perez, 28, hijos-1, conyuge')

    body = 'este plan no admite hijos'
    stub_request(:post, "#{ENV['API_URL']}/afiliados")
      .with(
        body: { 'nombre' => 'Miriam Perez', 'nombre_plan' => 'PlanPareja', 'edad': 28, 'cantidad_hijos': 1, 'conyuge': true, 'id_telegram' => 141_733_544 },
        headers: { 'API_KEY': API_KEY }
      )
      .to_return(status: 400, body: body, headers: {})

    stub_send_message(token, "Registración fallida: #{body}")

    app = BotClient.new(token)
    app.run_once
  end

  it 'when user register to plan not allow children and require spouse /registracion with children should get error' do # rubocop:disable RSpec/ExampleLength
    stub_get_updates(token, '/registracion PlanPareja, Miriam Perez, 28, hijos-1')

    body = 'este plan no admite hijos'
    stub_request(:post, "#{ENV['API_URL']}/afiliados")
      .with(
        body: { 'nombre' => 'Miriam Perez', 'nombre_plan' => 'PlanPareja', 'edad': 28, 'cantidad_hijos': 1, 'conyuge': false, 'id_telegram' => 141_733_544 },
        headers: { 'API_KEY': API_KEY }
      )
      .to_return(status: 400, body: body, headers: {})

    stub_send_message(token, "Registración fallida: #{body}")

    app = BotClient.new(token)
    app.run_once
  end
end
