require 'faraday'

class PlanService
  def self.all_plans
    headers = { 'API_KEY': API_KEY }
    response = Faraday.get("#{ENV['API_URL']}/planes", {}, headers)
    plans = JSON.parse(response.body)
    plans['planes']
  end
end
