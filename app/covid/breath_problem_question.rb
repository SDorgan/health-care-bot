require_relative './yes_no_question'

class CovidBreathProblemQuestion < YesNoQuestion
  TEXT = 'Tenés dificultad respiratoria?'.freeze

  def initialize
    super(TEXT)
  end
end
