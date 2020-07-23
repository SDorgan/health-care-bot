require 'faraday'

class AfiliadosService
  def self.post_afiliados(nombre, nombre_plan, id_telegram)
    @request = {
      "nombre": nombre,
      "nombre_plan": nombre_plan,
      "id_telegram": id_telegram
    }
    @response = Faraday.post("#{ENV['API_URL']}/afiliados", @request.to_json, 'Content-Type' => 'application/json')
    true if @response.status == 201
  end
end
