class CovidTempQuestion
  TEXT = 'Cuál es tu temperatura corporal?'.freeze

  attr_accessor :text, :body

  def initialize
    @text = TEXT
    @body = create_options
  end

  private

  def create_options
    kb = [
      Telegram::Bot::Types::InlineKeyboardButton.new(text: '35 o menos', callback_data: '35'),
      Telegram::Bot::Types::InlineKeyboardButton.new(text: '36', callback_data: '36'),
      Telegram::Bot::Types::InlineKeyboardButton.new(text: '37', callback_data: '37'),
      Telegram::Bot::Types::InlineKeyboardButton.new(text: '38 o más', callback_data: '38')
    ]

    Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
  end
end
