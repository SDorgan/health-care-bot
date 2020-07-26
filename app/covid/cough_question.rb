require_relative './yes_no_question'

class CovidCoughQuestion < YesNoQuestion
  TEXT = 'Tenés tos?'.freeze

  def initialize
    super(TEXT)
  end
end
