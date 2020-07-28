require_relative './yes_no_question'

class CovidSmellQuestion < YesNoQuestion
  TEXT = 'Percibiste una marcada pérdida de olfato de manera repentina?'.freeze

  def initialize
    super(TEXT)
  end
end
