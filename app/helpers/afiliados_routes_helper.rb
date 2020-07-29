class AfiliadosRoutesHelper
  def self.get_numero_hijos(texto_a_verificar)
    matching = texto_a_verificar.match(/hijos-[0-9]+/)
    if matching
      matching.to_s.scan(/\d+/).first.to_i
    else
      0
    end
  end

  def self.have_conyuge(texto_a_verificar)
    !texto_a_verificar.match(/conyuge\b/).nil?
  end
end
