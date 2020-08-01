require_relative './register_covid_service'
require_relative './suspect_response'

class CovidQuestionProcessor
  def initialize(prev_question_rule, next_question)
    @prev_question_rule = prev_question_rule
    @next_question = next_question
  end

  def run(bot, message)
    positive_case = @prev_question_rule.process(message.data)

    if positive_case
      process_positive_case(bot, message)
    else
      process_next_question(bot, message)
    end
  end

  private

  def process_positive_case(bot, message)
    registrado = RegisterCovidService.post_covid(message.message.chat.id)

    bot.api.send_message(
      chat_id: message.message.chat.id,
      text: CovidSupectResponse.create(registrado)
    )
  end

  def process_next_question(bot, message)
    bot.api.edit_message_text(
      chat_id: message.message.chat.id,
      message_id: message.message.message_id,
      text: @next_question.text,
      reply_markup: @next_question.body
    )
  end
end
