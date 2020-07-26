class CovidTemperatureRule
  def self.process(temp)
    temp.eql? '38'
  end
end
