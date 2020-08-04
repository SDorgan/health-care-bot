require 'faraday'

class CentrosService
  def self.get_centros(prestacion)
    Faraday.get("#{ENV['API_URL']}/centros", prestacion: prestacion)
  end
end
