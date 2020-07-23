require 'faraday'
require_relative 'resumen_presenter'

class ResumenService
  def self.get_resumen(id_telegram)
    response = Faraday.get("#{ENV['API_URL']}/resumen?id=#{id_telegram}&from=telegram")
    return ResumenPresenter.parse_resumen(response.body) if response.status == 200

    'Error obteniendo el resumen'
  end
end
