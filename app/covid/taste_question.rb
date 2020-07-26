require_relative './yes_no_question'

class CovidTasteQuestion < YesNoQuestion
  TEXT = 'Percibiste una marcada pérdida del gusto de manera repentina?'.freeze

  def initialize
    super(TEXT)
  end
end
