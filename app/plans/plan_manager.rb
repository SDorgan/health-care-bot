class PlanManager
  @@plans = [] # rubocop:disable Style/ClassVars

  def self.add_fake_plan(name)
    @@plans << { 'nombre' => name, 'id' => @@plans.length }
  end

  def self.all_plans
    return @@plans if ENV['RACK_ENV'] == 'test'

    []
  end
end
