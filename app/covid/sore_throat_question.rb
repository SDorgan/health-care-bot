require_relative './yes_no_question'

class CovidSoreThroatQuestion < YesNoQuestion
  TEXT = 'Tenés dolor de garganta?'.freeze

  def initialize
    super(TEXT)
  end
end
