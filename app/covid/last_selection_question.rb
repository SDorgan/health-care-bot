class CovidLastSelectionQuestion
  TEXT = 'Última: elija una opción'.freeze

  OPT_CONVIVIR = {
    text: 'Convivo con alguien que tiene COVID'.freeze,
    id: 'convivir'
  }.freeze
  OPT_14_DIAS_CERCA = {
    text: 'En los últimos 14 días estuve cerca de alguien con COVID',
    id: 'cerca'
  }.freeze
  OPT_EMBARAZADA = {
    text: 'Estoy embarazada',
    id: 'embarazada'
  }.freeze
  OPT_CANCER = {
    text: 'Tengo/tuve cancer',
    id: 'cancer'
  }.freeze
  OPT_DIAB = {
    text: 'Tengo diabetes',
    id: 'diabetes'
  }.freeze
  OPT_HEPA = {
    text: 'Tengo enfermedad hepática',
    id: 'hepatica'
  }.freeze
  OPT_RENAL = {
    text: 'Tengo enfermedad renal crónica',
    id: 'renal'
  }.freeze
  OPT_RESP = {
    text: 'Tengo alguna enfermedad respiratoria',
    id: 'respirar'
  }.freeze
  OPT_CARD = {
    text: 'Tengo alguna enfermedad cardiológica',
    id: 'cardio'
  }.freeze
  OPT_NINGUNA = {
    text: 'Ninguna',
    id: 'ninguna'
  }.freeze

  attr_accessor :text, :body

  def initialize
    @text = TEXT
    @body = create_options
  end

  private

  def create_options # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    kb = [
      Telegram::Bot::Types::InlineKeyboardButton.new(
        text: OPT_CONVIVIR[:text], callback_data: OPT_CONVIVIR[:id]
      ),
      Telegram::Bot::Types::InlineKeyboardButton.new(
        text: OPT_14_DIAS_CERCA[:text], callback_data: OPT_14_DIAS_CERCA[:id]
      ),
      Telegram::Bot::Types::InlineKeyboardButton.new(
        text: OPT_EMBARAZADA[:text], callback_data: OPT_EMBARAZADA[:id]
      ),
      Telegram::Bot::Types::InlineKeyboardButton.new(
        text: OPT_CANCER[:text], callback_data: OPT_CANCER[:id]
      ),
      Telegram::Bot::Types::InlineKeyboardButton.new(
        text: OPT_DIAB[:text], callback_data: OPT_DIAB[:id]
      ),
      Telegram::Bot::Types::InlineKeyboardButton.new(
        text: OPT_HEPA[:text], callback_data: OPT_HEPA[:id]
      ),
      Telegram::Bot::Types::InlineKeyboardButton.new(
        text: OPT_RENAL[:text], callback_data: OPT_RENAL[:id]
      ),
      Telegram::Bot::Types::InlineKeyboardButton.new(
        text: OPT_RESP[:text], callback_data: OPT_RESP[:id]
      ),
      Telegram::Bot::Types::InlineKeyboardButton.new(
        text: OPT_CARD[:text], callback_data: OPT_CARD[:id]
      ),
      Telegram::Bot::Types::InlineKeyboardButton.new(
        text: OPT_NINGUNA[:text], callback_data: OPT_NINGUNA[:id]
      )
    ]

    Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
  end
end
