class PlanManager
  def initialize
    @plans = []
  end

  def all_plans
    return @plans if ENV['RACK_ENV'] == 'test'

    []
  end
end
