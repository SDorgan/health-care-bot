require 'net/http'
require 'byebug'

class PlanManager
  @@plans = [] # rubocop:disable Style/ClassVars

  def self.add_fake_plan(name)
    @@plans << { 'nombre' => name, 'id' => @@plans.length }
  end

  def self.all_plans
    return @@plans if ENV['RACK_ENV'] == 'test' || ENV['API_URL'].nil?

    plan_uri = URI("#{ENV['API_URL']}/planes")
    plans = JSON.parse(Net::HTTP.get(plan_uri))

    plans['planes']
  end
end
