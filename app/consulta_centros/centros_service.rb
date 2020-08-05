require 'faraday'

class CentrosService
  def self.get_centros(prestacion)
    Faraday.get("#{ENV['API_URL']}/centros", { prestacion: prestacion }, { 'API_KEY': API_KEY })
  end

  def self.get_near_centro(latitud, longitud)
    Faraday.get("#{ENV['API_URL']}/centros", { latitud: latitud, longitud: longitud }, { 'API_KEY': API_KEY })
  end
end
