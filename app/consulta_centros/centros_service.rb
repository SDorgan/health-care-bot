require 'faraday'

class CentrosService
  def self.get_centros(prestacion)
    param = Faraday::FlatParamsEncoder.encode({ 'prestacion': prestacion })

    Faraday.get("#{ENV['API_URL']}/centros?#{param}")
  end
end
