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
    @response = Faraday.post("#{ENV['API_URL']}/afiliados", @request.to_json, {
                               'Content-Type': 'application/json',
                               'API_KEY': API_KEY
                             })
    @response
  end

  def self.check_afiliado(id_telegram)
    @response = Faraday.head("#{ENV['API_URL']}/afiliados/#{id_telegram}", {}, { 'API_KEY': API_KEY })
    return true if @response.status == 200

    false
  end
end
