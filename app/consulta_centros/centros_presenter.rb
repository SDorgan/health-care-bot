class CentrosPresenter
  def self.parse_centros(body)
    json_response = JSON.parse(body)
    centros = json_response['centros']
    return 'Lo sentimos, no hay hospitales disponibles para esa prestación.' if centros.empty?

    respuesta = ''
    centros.each do |centro|
      respuesta << add_centro(centro)
    end

    respuesta
  end

  def self.add_centro(centro)
    "#{centro['nombre']} - Coordenadas(#{centro['latitud']}, #{centro['longitud']})\n"
  end

  private_class_method :add_centro
end
