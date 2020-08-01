class YesNoRule
  AFIRMATIVE = 'si'.freeze

  def process(answer)
    answer.eql? AFIRMATIVE
  end
end
