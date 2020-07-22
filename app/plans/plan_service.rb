require 'faraday'

class PlanService
  def self.all_plans
    response = Faraday.get("#{ENV['API_URL']}/planes")
    plans = JSON.parse(response.body)
    plans['planes']
  end
end
