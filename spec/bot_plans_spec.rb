require 'spec_helper'
require 'web_mock'

require File.dirname(__FILE__) + '/../app/bot_client'

describe 'BotClientPlansCommands' do
  let(:token) { 'fake_token' }

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
end
