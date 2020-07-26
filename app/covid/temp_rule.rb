class CovidTemperatureRule
  BOUND = '38'.freeze

  def process(temp)
    temp.eql? BOUND
  end
end
