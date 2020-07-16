require 'faraday'

class ResumenManager
  def self.get_resumen(id_telegram)
    response = Faraday.get("#{ENV['API_URL']}/resumen?id=#{id_telegram}&from=telegram")
    return parse_resumen(response.body) if response.status == 200

    'Error obteniendo el resumen'
  end

  def self.parse_resumen(body)
    json_response = JSON.parse(body)

    plan = json_response['plan']
    plan_cost = plan['costo']
    aditionals = json_response['adicional']
    total = plan_cost + aditionals

    resumen = "Nombre: #{json_response['afiliado']}\n"
    resumen << "Plan: #{plan['nombre']}\n"
    resumen << "Costo plan: $#{plan_cost}\n"
    resumen << "Saldo adicional: $#{aditionals}\n"
    resumen << "Total a pagar: $#{total}"

    resumen
  end
end
