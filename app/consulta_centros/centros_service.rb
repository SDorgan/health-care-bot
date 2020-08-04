require 'faraday'

class CentrosService
  def self.get_centros(prestacion)
    Faraday.get("#{ENV['API_URL']}/centros", prestacion: prestacion)
  end

  def self.get_near_centro(latitud, longitud)
    Faraday.get("#{ENV['API_URL']}/centros", latitud: latitud, longitud: longitud)
  end
end
