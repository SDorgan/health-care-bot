class PlanPresenter
  def self.parse_data_plan(body) # rubocop:disable Metrics/AbcSize
    json_response = JSON.parse(body)
    plan_json = json_response['plan']
    plan_parse = "Nombre Plan: #{plan_json['nombre']}\n"
    plan_parse << "Costo: $#{plan_json['costo']}\n"
    plan_parse << "Límite cobertura visitas: #{plan_json['limite_cobertura_visitas']}\n"
    plan_parse << "Copago: $#{plan_json['copago']}\n"
    plan_parse << "Cobertura Medicamentos: #{plan_json['cobertura_medicamentos']}%\n"
    plan_parse << "Edad mínima: #{plan_json['edad_minima']}\n"
    plan_parse << "Edad máxima: #{plan_json['edad_maxima']}\n"
    plan_parse << "Cantidad hijos máxima: #{plan_json['cantidad_hijos_maxima']}\n"
    plan_parse << "Conyuge: #{plan_json['conyuge'].gsub('_', ' ').capitalize}"

    plan_parse
  end
end
