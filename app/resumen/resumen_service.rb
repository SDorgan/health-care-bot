require 'faraday'
require_relative 'resumen_presenter'

class ResumenService
  def self.get_resumen(id_telegram)
    response = Faraday.get("#{ENV['API_URL']}/resumen", id: id_telegram)
    return ResumenPresenter.parse_resumen(response.body) if response.status == 200

    return 'Parece que no estás afiliado a ningún plan, por lo que no podemos mandarte un resumen en este momento.' if response.status == 401

    'Error obteniendo el resumen'
  end
end
