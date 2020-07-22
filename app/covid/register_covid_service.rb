require 'faraday'

class RegisterCovidService
  def self.post_covid(id_telegram)
    @request = {
      "id_telegram": id_telegram.to_s
    }
    @response = Faraday.post("#{ENV['API_URL']}/covid", @request.to_json, 'Content-Type' => 'application/json')
    true if @response.status == 200
  end
end
