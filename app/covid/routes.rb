require File.dirname(__FILE__) + '/../../lib/routing'

require_relative './register_covid_service'
require_relative '../afiliados/afiliados_service'
require_relative './suspect_response'
require_relative './question_processor'
require_relative './smell_question'
require_relative './cough_question'
require_relative './sore_throat_question'
require_relative './breath_problem_question'
require_relative './last_selection_question'
require_relative './taste_question'
require_relative './temp_question'
require_relative './temp_rule'
require_relative './yes_no_rule'
require_relative './last_selection_rule'

module CovidRoutes
  include Routing

  on_message '/diagnostico covid' do |bot, message|
    if AfiliadosService.check_afiliado(message.from.id)
      question = CovidTempQuestion.new

      bot.api.send_message(
        chat_id: message.chat.id,
        text: question.text,
        reply_markup: question.body
      )
    else
      bot.api.send_message(
        chat_id: message.chat.id,
        text: 'Disculple, esta funcionalidad solo está disponible para afiliados.'
      )
    end
  end

  on_response_to CovidTempQuestion::TEXT do |bot, message|
    question_proc = CovidQuestionProcessor.new(CovidTemperatureRule.new, CovidSmellQuestion.new)

    question_proc.run(bot, message)
  end

  on_response_to CovidSmellQuestion::TEXT do |bot, message|
    question_proc = CovidQuestionProcessor.new(YesNoRule.new, CovidTasteQuestion.new)

    question_proc.run(bot, message)
  end

  on_response_to CovidTasteQuestion::TEXT do |bot, message|
    question_proc = CovidQuestionProcessor.new(YesNoRule.new, CovidCoughQuestion.new)

    question_proc.run(bot, message)
  end

  on_response_to CovidCoughQuestion::TEXT do |bot, message|
    question_proc = CovidQuestionProcessor.new(YesNoRule.new, CovidSoreThroatQuestion.new)

    question_proc.run(bot, message)
  end

  on_response_to CovidSoreThroatQuestion::TEXT do |bot, message|
    question_proc = CovidQuestionProcessor.new(YesNoRule.new, CovidBreathProblemQuestion.new)

    question_proc.run(bot, message)
  end

  on_response_to CovidBreathProblemQuestion::TEXT do |bot, message|
    question_proc = CovidQuestionProcessor.new(YesNoRule.new, CovidLastSelectionQuestion.new)

    question_proc.run(bot, message)
  end

  on_response_to CovidLastSelectionQuestion::TEXT do |bot, message|
    positive_case = LastSelectionRule.new.process(message.data)

    if positive_case
      registrado = RegisterCovidService.post_covid(message.message.chat.id)

      bot.api.send_message(
        chat_id: message.message.chat.id,
        text: CovidSupectResponse.create(registrado)
      )
    else
      bot.api.send_message(
        chat_id: message.message.chat.id,
        text: 'Gracias por realizar el diagnóstico'
      )
    end
  end
end
