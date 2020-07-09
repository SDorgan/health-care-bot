require 'net/http'

class PlanManager
  def self.all_plans
    plan_uri = URI("#{ENV['API_URL']}/planes")
    plans = JSON.parse(Net::HTTP.get(plan_uri))

    plans['planes']
  end
end
