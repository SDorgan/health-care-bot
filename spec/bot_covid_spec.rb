require 'spec_helper'
require 'web_mock'

require_relative '../app/covid/last_selection_question'

require File.dirname(__FILE__) + '/../app/bot_client'

describe 'BotClientCovidCommands' do
  let(:token) { 'fake_token' }

  it 'should get a /diagnostico covid message and respond with an inline keyboard' do
    token = 'fake_token'

    stub_get_updates(token, '/diagnostico covid')
    stub_send_keyboard_message(token, 'Cuál es tu temperatura corporal?')

    app = BotClient.new(token)

    app.run_once
  end

  it 'should receive temp, smell, taste, cough, sore throat, breath and last selection questions when is no suspect' do # rubocop:disable RSpec/ExampleLength, Metrics/BlockLength
    options_temp_qustion = [
      [{ "text": '35 o menos', "callback_data": '35' }],
      [{ "text": '36', "callback_data": '36' }],
      [{ "text": '37', "callback_data": '37' }],
      [{ "text": '38 o más', "callback_data": '38' }]
    ]

    options_yes_no_questions = [
      [{ "text": 'Sí', "callback_data": 'si' }],
      [{ "text": 'No', "callback_data": 'no' }]
    ]

    options_last_question = [
      [{ "text": CovidLastSelectionQuestion::OPT_CONVIVIR[:text],
         "callback_data": CovidLastSelectionQuestion::OPT_CONVIVIR[:id] }],
      [{ "text": CovidLastSelectionQuestion::OPT_14_DIAS_CERCA[:text],
         "callback_data": CovidLastSelectionQuestion::OPT_14_DIAS_CERCA[:id] }],
      [{ "text": CovidLastSelectionQuestion::OPT_EMBARAZADA[:text],
         "callback_data": CovidLastSelectionQuestion::OPT_EMBARAZADA[:id] }],
      [{ "text": CovidLastSelectionQuestion::OPT_CANCER[:text],
         "callback_data": CovidLastSelectionQuestion::OPT_CANCER[:id] }],
      [{ "text": CovidLastSelectionQuestion::OPT_DIAB[:text],
         "callback_data": CovidLastSelectionQuestion::OPT_DIAB[:id] }],
      [{ "text": CovidLastSelectionQuestion::OPT_HEPA[:text],
         "callback_data": CovidLastSelectionQuestion::OPT_HEPA[:id] }],
      [{ "text": CovidLastSelectionQuestion::OPT_RENAL[:text],
         "callback_data": CovidLastSelectionQuestion::OPT_RENAL[:id] }],
      [{ "text": CovidLastSelectionQuestion::OPT_RESP[:text],
         "callback_data": CovidLastSelectionQuestion::OPT_RESP[:id] }],
      [{ "text": CovidLastSelectionQuestion::OPT_CARD[:text],
         "callback_data": CovidLastSelectionQuestion::OPT_CARD[:id] }],
      [{ "text": CovidLastSelectionQuestion::OPT_NINGUNA[:text],
         "callback_data": CovidLastSelectionQuestion::OPT_NINGUNA[:id] }]
    ]

    stub_get_updates_callback_query(token,
                                    'Cuál es tu temperatura corporal?',
                                    options_temp_qustion,
                                    '37')

    stub_edit_message_callback_query(token,
                                     'Percibiste una marcada pérdida de olfato de manera repentina?')
    stub_get_updates_callback_query(token,
                                    'Percibiste una marcada pérdida de olfato de manera repentina?',
                                    options_yes_no_questions,
                                    'No')

    stub_edit_message_callback_query(token,
                                     'Percibiste una marcada pérdida del gusto de manera repentina?')
    stub_get_updates_callback_query(token,
                                    'Percibiste una marcada pérdida del gusto de manera repentina?',
                                    options_yes_no_questions,
                                    'No')

    stub_edit_message_callback_query(token, 'Tenés tos?')
    stub_get_updates_callback_query(token, 'Tenés tos?',
                                    options_yes_no_questions,
                                    'No')

    stub_edit_message_callback_query(token, 'Tenés dolor de garganta?')
    stub_get_updates_callback_query(token, 'Tenés dolor de garganta?',
                                    options_yes_no_questions,
                                    'No')

    stub_edit_message_callback_query(token, 'Tenés dificultad respiratoria?')
    stub_get_updates_callback_query(token, 'Tenés dificultad respiratoria?',
                                    options_yes_no_questions,
                                    'No')

    stub_edit_message_callback_query(token, 'Última: elija una opción')
    stub_get_updates_callback_query(token, 'Última: elija una opción',
                                    options_last_question,
                                    'Ninguna')

    stub_send_message(token, 'Gracias por realizar el diagnóstico')

    app = BotClient.new(token)
    app.run_once
  end

  it 'when user test covid diagnosis with temperature suspicious receives covid suspicious' do # rubocop:disable RSpec/ExampleLength
    options_temp = [
      [{ "text": '35 o menos', "callback_data": '35' }],
      [{ "text": '36', "callback_data": '36' }],
      [{ "text": '37', "callback_data": '37' }],
      [{ "text": '38 o más', "callback_data": '38' }]
    ]

    stub_get_updates_callback_query(token,
                                    'Cuál es tu temperatura corporal?',
                                    options_temp,
                                    '38')

    body = { "sospechoso": true }
    stub_request(:post, "#{ENV['API_URL']}/covid")
      .with(
        body: { 'id_telegram' => '141733544' }
      )
      .to_return(status: 200, body: body.to_json, headers: {})
    stub_send_message(token, 'Sos un caso sospechoso de COVID. Acércate a un centro médico')

    app = BotClient.new(token)
    app.run_once
  end

  it 'when user test covid diagnosis with smell suspicious receives covid suspicious' do # rubocop:disable RSpec/ExampleLength, Metrics/BlockLength
    options_temp = [
      [{ "text": '35 o menos', "callback_data": '35' }],
      [{ "text": '36', "callback_data": '36' }],
      [{ "text": '37', "callback_data": '37' }],
      [{ "text": '38 o más', "callback_data": '38' }]
    ]

    options_yes_no_questions = [
      [{ "text": 'Sí', "callback_data": 'si' }],
      [{ "text": 'No', "callback_data": 'no' }]
    ]

    stub_get_updates_callback_query(token,
                                    'Cuál es tu temperatura corporal?',
                                    options_temp,
                                    '37')

    stub_edit_message_callback_query(token,
                                     'Percibiste una marcada pérdida de olfato de manera repentina?')
    stub_get_updates_callback_query(token,
                                    'Percibiste una marcada pérdida de olfato de manera repentina?',
                                    options_yes_no_questions,
                                    'si')

    body = { "sospechoso": true }
    stub_request(:post, "#{ENV['API_URL']}/covid")
      .with(
        body: { 'id_telegram' => '141733544' }
      )
      .to_return(status: 200, body: body.to_json, headers: {})
    stub_send_message(token, 'Sos un caso sospechoso de COVID. Acércate a un centro médico')

    app = BotClient.new(token)
    app.run_once
  end

  it 'when user test covid diagnosis with taste suspicious receives covid suspicious' do # rubocop:disable RSpec/ExampleLength, Metrics/BlockLength
    options_temp = [
      [{ "text": '35 o menos', "callback_data": '35' }],
      [{ "text": '36', "callback_data": '36' }],
      [{ "text": '37', "callback_data": '37' }],
      [{ "text": '38 o más', "callback_data": '38' }]
    ]

    options_yes_no_questions = [
      [{ "text": 'Sí', "callback_data": 'si' }],
      [{ "text": 'No', "callback_data": 'no' }]
    ]

    stub_get_updates_callback_query(token,
                                    'Cuál es tu temperatura corporal?',
                                    options_temp,
                                    '37')

    stub_edit_message_callback_query(token,
                                     'Percibiste una marcada pérdida de olfato de manera repentina?')
    stub_get_updates_callback_query(token,
                                    'Percibiste una marcada pérdida de olfato de manera repentina?',
                                    options_yes_no_questions,
                                    'no')

    stub_edit_message_callback_query(token,
                                     'Percibiste una marcada pérdida del gusto de manera repentina?')
    stub_get_updates_callback_query(token,
                                    'Percibiste una marcada pérdida del gusto de manera repentina?',
                                    options_yes_no_questions,
                                    'si')

    body = { "sospechoso": true }
    stub_request(:post, "#{ENV['API_URL']}/covid")
      .with(
        body: { 'id_telegram' => '141733544' }
      )
      .to_return(status: 200, body: body.to_json, headers: {})
    stub_send_message(token, 'Sos un caso sospechoso de COVID. Acércate a un centro médico')

    app = BotClient.new(token)
    app.run_once
  end

  it 'when user test covid diagnosis with cough suspicious receives covid suspicious' do # rubocop:disable RSpec/ExampleLength, Metrics/BlockLength
    options_temp = [
      [{ "text": '35 o menos', "callback_data": '35' }],
      [{ "text": '36', "callback_data": '36' }],
      [{ "text": '37', "callback_data": '37' }],
      [{ "text": '38 o más', "callback_data": '38' }]
    ]

    options_yes_no_questions = [
      [{ "text": 'Sí', "callback_data": 'si' }],
      [{ "text": 'No', "callback_data": 'no' }]
    ]

    stub_get_updates_callback_query(token,
                                    'Cuál es tu temperatura corporal?',
                                    options_temp,
                                    '37')

    stub_edit_message_callback_query(token,
                                     'Percibiste una marcada pérdida de olfato de manera repentina?')
    stub_get_updates_callback_query(token,
                                    'Percibiste una marcada pérdida de olfato de manera repentina?',
                                    options_yes_no_questions,
                                    'no')

    stub_edit_message_callback_query(token,
                                     'Percibiste una marcada pérdida del gusto de manera repentina?')
    stub_get_updates_callback_query(token,
                                    'Percibiste una marcada pérdida del gusto de manera repentina?',
                                    options_yes_no_questions,
                                    'no')

    stub_edit_message_callback_query(token, 'Tenés tos?')
    stub_get_updates_callback_query(token, 'Tenés tos?',
                                    options_yes_no_questions,
                                    'si')

    body = { "sospechoso": true }
    stub_request(:post, "#{ENV['API_URL']}/covid")
      .with(
        body: { 'id_telegram' => '141733544' }
      )
      .to_return(status: 200, body: body.to_json, headers: {})
    stub_send_message(token, 'Sos un caso sospechoso de COVID. Acércate a un centro médico')

    app = BotClient.new(token)
    app.run_once
  end

  it 'when user test covid diagnosis with sore throat suspicious receives covid suspicious' do # rubocop:disable RSpec/ExampleLength, Metrics/BlockLength
    options_temp = [
      [{ "text": '35 o menos', "callback_data": '35' }],
      [{ "text": '36', "callback_data": '36' }],
      [{ "text": '37', "callback_data": '37' }],
      [{ "text": '38 o más', "callback_data": '38' }]
    ]

    options_yes_no_questions = [
      [{ "text": 'Sí', "callback_data": 'si' }],
      [{ "text": 'No', "callback_data": 'no' }]
    ]

    stub_get_updates_callback_query(token,
                                    'Cuál es tu temperatura corporal?',
                                    options_temp,
                                    '37')

    stub_edit_message_callback_query(token,
                                     'Percibiste una marcada pérdida de olfato de manera repentina?')
    stub_get_updates_callback_query(token,
                                    'Percibiste una marcada pérdida de olfato de manera repentina?',
                                    options_yes_no_questions,
                                    'no')

    stub_edit_message_callback_query(token,
                                     'Percibiste una marcada pérdida del gusto de manera repentina?')
    stub_get_updates_callback_query(token,
                                    'Percibiste una marcada pérdida del gusto de manera repentina?',
                                    options_yes_no_questions,
                                    'no')

    stub_edit_message_callback_query(token, 'Tenés tos?')
    stub_get_updates_callback_query(token, 'Tenés tos?',
                                    options_yes_no_questions,
                                    'no')

    stub_edit_message_callback_query(token, 'Tenés dolor de garganta?')
    stub_get_updates_callback_query(token, 'Tenés dolor de garganta?',
                                    options_yes_no_questions,
                                    'si')

    body = { "sospechoso": true }
    stub_request(:post, "#{ENV['API_URL']}/covid")
      .with(
        body: { 'id_telegram' => '141733544' }
      )
      .to_return(status: 200, body: body.to_json, headers: {})
    stub_send_message(token, 'Sos un caso sospechoso de COVID. Acércate a un centro médico')

    app = BotClient.new(token)
    app.run_once
  end

  it 'when user test covid diagnosis with temperature suspicious receives covid suspicious and get error' do # rubocop:disable RSpec/ExampleLength
    options_temp = [
      [{ "text": '35 o menos', "callback_data": '35' }],
      [{ "text": '36', "callback_data": '36' }],
      [{ "text": '37', "callback_data": '37' }],
      [{ "text": '38 o más', "callback_data": '38' }]
    ]

    stub_get_updates_callback_query(token,
                                    'Cuál es tu temperatura corporal?',
                                    options_temp,
                                    '38')

    body = { "sospechoso": true }
    stub_request(:post, "#{ENV['API_URL']}/covid")
      .with(
        body: { 'id_telegram' => '141733544' }
      )
      .to_return(status: 400, body: body.to_json, headers: {})
    stub_send_message(token, 'Sos un caso sospechoso de COVID. Acércate a un centro médico. No se pudo registrar el caso correctamente en el centro')

    app = BotClient.new(token)
    app.run_once
  end
end
