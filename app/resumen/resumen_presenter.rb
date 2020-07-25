class ResumenPresenter
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
