require 'byebug'
class ResumenPresenter
  def self.parse_resumen(body) # rubocop:disable Metrics/AbcSize
    json_response = JSON.parse(body)
    resumen_json = json_response['resumen']
    plan = resumen_json['plan']

    resumen = "Nombre: #{resumen_json['afiliado']}\n"
    resumen << "Plan: #{plan['nombre']}\n"
    resumen << "Costo plan: $#{plan['costo']}\n"
    resumen << "Saldo adicional: $#{resumen_json['adicional']}\n"
    resumen << "Total a pagar: $#{resumen_json['total']}"
    resumen << add_items(resumen_json['items']).to_s

    resumen
  end

  def self.add_items(items) # rubocop:disable Metrics/AbcSize
    return '' if items.nil? || items.empty?

    longest_concept = items.max_by { |item| item['concepto'] }
    concept_field_len = [longest_concept['concepto'].length, 'concepto'.length].max

    output = "\n\n<pre>Fecha      | #{'Concepto'.ljust(concept_field_len, ' ')} | Costo"

    items.each do |item|
      output << "\n#{item['fecha']} | #{item['concepto'].ljust(concept_field_len, ' ')} | $#{item['costo']}"
    end

    output << '</pre>'

    output
  end

  private_class_method :add_items
end
