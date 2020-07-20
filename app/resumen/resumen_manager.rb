require 'faraday'

class ResumenManager
  def self.get_resumen(id_telegram)
    response = Faraday.get("#{ENV['API_URL']}/resumen?id=#{id_telegram}&from=telegram")
    return parse_resumen(response.body) if response.status == 200

    'Error obteniendo el resumen'
  end

  def self.parse_resumen(body)
    json_response = JSON.parse(body)
    resumen_json = json_response['resumen']

    plan = resumen_json['plan']

    resumen = "Nombre: #{resumen_json['afiliado']}\n"
    resumen << "Plan: #{plan['nombre']}\n"
    resumen << "Costo plan: $#{plan['costo']}\n"
    resumen << "Saldo adicional: $#{resumen_json['adicional']}\n"
    resumen << "Total a pagar: $#{resumen_json['total']}"

    resumen
  end
end
