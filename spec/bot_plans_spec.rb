require 'spec_helper'
require 'web_mock'

require File.dirname(__FILE__) + '/../app/bot_client'

describe 'BotClientPlansCommands' do
  let(:token) { 'fake_token' }
  let(:cobertura_infinita) { 1000 }

  it 'when no plans, should get a /planes message and respond with no plan' do # rubocop:disable RSpec/ExampleLength
    stub_get_updates(token, '/planes')

    body = { "planes": [] }
    stub_request(:get, "#{ENV['API_URL']}/planes")
      .with(headers: { 'API_KEY': API_KEY })
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
      .with(headers: { 'API_KEY': API_KEY })
      .to_return(status: 200, body: body.to_json, headers: {})
    stub_send_message(token, "Estos son nuestros planes disponibles:\nplan1\nplan2")

    app = BotClient.new(token)

    app.run_once
  end

  it 'should get plan data with name /plan message and respond with the plan info' do # rubocop:disable RSpec/ExampleLength, Metrics/BlockLength
    stub_get_updates(token, '/plan PlanJuventud')
    body = { "plan": {
      "id": 1,
      "nombre": 'PlanJuventud',
      "costo": 200,
      "limite_cobertura_visitas": 2,
      "copago": 100,
      "cobertura_medicamentos": 30,
      "edad_minima": 10,
      "edad_maxima": 30,
      "cantidad_hijos_maxima": 0,
      "conyuge": 'NO_ADMITE_CONYUGE'
    } }
    stub_request(:get, "#{ENV['API_URL']}/planes?nombre=PlanJuventud")
      .with(headers: { 'API_KEY': API_KEY })
      .to_return(status: 200, body: body.to_json, headers: {})

    stub_send_message(token,
                      "Nombre Plan: PlanJuventud\n" \
                      "Costo: $200\n" \
                      "Límite cobertura visitas: 2\n" \
                      "Copago: $100\n" \
                      "Cobertura Medicamentos: 30%\n" \
                      "Edad mínima: 10\n" \
                      "Edad máxima: 30\n" \
                      "Cantidad hijos máxima: 0\n" \
                      'Conyuge: No admite conyuge')
    app = BotClient.new(token)

    app.run_once
  end

  it 'should get plan data with name /plan message and respond with the plan info coverage infinite' do # rubocop:disable RSpec/ExampleLength, Metrics/BlockLength
    stub_get_updates(token, '/plan PlanFamiliar')
    body = { "plan": {
      "id": 1,
      "nombre": 'PlanFamiliar',
      "costo": 4000,
      "limite_cobertura_visitas": cobertura_infinita,
      "copago": 100,
      "cobertura_medicamentos": 30,
      "edad_minima": 20,
      "edad_maxima": 60,
      "cantidad_hijos_maxima": 2,
      "conyuge": 'ADMITE_CONYUGE'
    } }
    stub_request(:get, "#{ENV['API_URL']}/planes?nombre=PlanFamiliar")
      .with(headers: { 'API_KEY': API_KEY })
      .to_return(status: 200, body: body.to_json, headers: {})

    stub_send_message(token,
                      "Nombre Plan: PlanFamiliar\n" \
                      "Costo: $4000\n" \
                      "Límite cobertura visitas: Infinito\n" \
                      "Copago: $100\n" \
                      "Cobertura Medicamentos: 30%\n" \
                      "Edad mínima: 20\n" \
                      "Edad máxima: 60\n" \
                      "Cantidad hijos máxima: 2\n" \
                      'Conyuge: Admite conyuge')
    app = BotClient.new(token)

    app.run_once
  end

  it 'should get plan data with name /plan message and respond with error the plan not exist' do # rubocop:disable RSpec/ExampleLength
    stub_get_updates(token, '/plan NoExiste')
    body = 'El plan ingresado no existe'
    stub_request(:get, "#{ENV['API_URL']}/planes?nombre=NoExiste")
      .with(headers: { 'API_KEY': API_KEY })
      .to_return(status: 400, body: body, headers: {})

    stub_send_message(token, body)
    app = BotClient.new(token)

    app.run_once
  end
end
