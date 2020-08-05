require 'faraday'
require_relative 'plan_presenter'

class PlanService
  def self.all_plans
    headers = { 'API_KEY': API_KEY }
    response = Faraday.get("#{ENV['API_URL']}/planes", {}, headers)
    plans = JSON.parse(response.body)
    plans['planes']
  end

  def self.get_plan(nombre)
    response = Faraday.get("#{ENV['API_URL']}/planes", { nombre: nombre }, { 'API_KEY': API_KEY })
    if response.status == 200
      PlanPresenter.parse_data_plan(response.body)
    else
      'El plan ingresado no existe'
    end
  end
end
