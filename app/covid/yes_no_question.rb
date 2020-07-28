class YesNoQuestion
  attr_accessor :text, :body

  def initialize(text)
    @text = text
    @body = create_options
  end

  private

  def create_options
    kb = [
      Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Sí', callback_data: 'si'),
      Telegram::Bot::Types::InlineKeyboardButton.new(text: 'No', callback_data: 'no')
    ]

    Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
  end
end
