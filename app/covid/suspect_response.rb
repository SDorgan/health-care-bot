class CovidSupectResponse
  def self.create(register_status)
    text = if register_status
             'Sos un caso sospechoso de COVID. Acércate a un centro médico'
           else
             'Sos un caso sospechoso de COVID. Acércate a un centro médico. No se pudo registrar el caso correctamente en el centro'
           end

    text
  end
end
