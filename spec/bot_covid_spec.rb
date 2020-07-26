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

def stub_get_updates_callback_query(token, message_text, inline_keyboard, inline_selection)
  body = {
    "ok": true,
    "result": [{
      "update_id": 866_033_907,
      "callback_query": {
        "from": {
          "id": 141_733_544, "is_bot": false,
          "first_name": 'Alto Jardin', "last_name": 'GOT', "username": 'altojardin', "language_code": 'en'
        },
        "message": {
          "message_id": 626,
          "from": { "id": 715_612_264, "is_bot": true, "first_name": 'fiuba-memo2-prueba', "username": 'fiuba_memo2_bot' },
          "chat": { "id": 141_733_544, "first_name": 'Alto Jardin', "last_name": 'GOT', "username": 'altojardin', "type": 'private' },
          "date": 1_595_282_006,
          "text": message_text,
          "reply_markup": { "inline_keyboard": inline_keyboard }
        },
        "chat_instance": '2671782303129352872',
        "data": inline_selection
      }
    }]
  }

  stub_request(:any, "https://api.telegram.org/bot#{token}/getUpdates")
    .to_return(body: body.to_json, status: 200, headers: { 'Content-Length' => 3 })
end

def stub_edit_message_callback_query(token, message_text)
  stub_request(:post, "https://api.telegram.org/bot#{token}/editMessageText")
    .with(
      body: {
        "chat_id": '141733544',
        "message_id": '626',
        "reply_markup": '{"inline_keyboard":[[{"text":"Sí","callback_data":"si"}],[{"text":"No","callback_data":"no"}]]}',
        "text": message_text
      },
      headers: {
        'Accept': '*/*',
        'Accept-Encoding': 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Content-Type': 'application/x-www-form-urlencoded',
        'User-Agent': 'Faraday v1.0.1'
      }
    )
    .to_return(status: 200, body: '', headers: {})
end

def stub_send_keyboard_message(token, message_text)
  # rubocop:disable Layout/LineLength
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
      body: {
        'chat_id' => '141733544',
        'reply_markup' => '{"inline_keyboard":[[{"text":"35 o menos","callback_data":"35"}],[{"text":"36","callback_data":"36"}],[{"text":"37","callback_data":"37"}],[{"text":"38 o más","callback_data":"38"}]]}',
        'text' => message_text
      }
    )
    .to_return(status: 200, body: body.to_json, headers: {})
  # rubocop:enable Layout/LineLength
end

describe 'BotClientCovidCommands' do
  let(:token) { 'fake_token' }

  it 'should get a /diagnostico covid message and respond with an inline keyboard' do
    token = 'fake_token'

    stub_get_updates(token, '/diagnostico covid')
    stub_send_keyboard_message(token, 'Cuál es tu temperatura corporal?')

    app = BotClient.new(token)

    app.run_once
  end

  it 'should receive temp, smell and taste questions when is no suspect' do # rubocop:disable RSpec/ExampleLength, Metrics/BlockLength
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
                                    'No')

    stub_edit_message_callback_query(token,
                                     'Percibiste una marcada pérdida del gusto de manera repentina?')
    stub_get_updates_callback_query(token,
                                    'Percibiste una marcada pérdida del gusto de manera repentina?',
                                    options_yes_no_questions,
                                    'No')

    stub_send_message(token, 'Gracias por realizar el diagnóstico')

    app = BotClient.new(token)
    app.run_once
  end

  it 'when user test covid diagnosis with temperature suspicious recibe covid suspicious' do # rubocop:disable RSpec/ExampleLength
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

  it 'when user test covid diagnosis with temperature suspicious recibe covid suspicious and get error' do # rubocop:disable RSpec/ExampleLength
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
