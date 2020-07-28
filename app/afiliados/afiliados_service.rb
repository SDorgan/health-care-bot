require 'faraday'

class AfiliadosService
  def self.post_afiliados(data = {})
    @request = {
      "nombre": data[:nombre],
      "nombre_plan": data[:nombre_plan],
      "id_telegram": data[:id_telegram],
      "edad": data[:edad],
      "cantidad_hijos": data[:cantidad_hijos],
      "conyuge": data[:conyuge]
    }
    @response = Faraday.post("#{ENV['API_URL']}/afiliados", @request.to_json, 'Content-Type' => 'application/json')
    true if @response.status == 201
  end
end
