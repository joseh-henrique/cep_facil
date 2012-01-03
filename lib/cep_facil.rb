# coding: utf-8
require "cep_facil/version"
require "net/http"

module CepFacil

  # Receives the zip code (CEP) and the Token (get yours at http://cepfacil.com.br) and
  # returns the address referent to that zip code as a hash object.
  #
  # == Exemplo 
  # require "cep_facil"
  # cep = "5417-540"
  # token = "1234567890"
  # address = CepFacil.get_address(cep, token)
  # address is a hash with 6 keys: cep, type, state, city, neighborhood, description
  # Reading them: 
  # address[:city]
  # address[:state]
  # Some applications store Brazilian zip codes (CEPs) in formats like "22222222", or "22222-222"
  # or even as an integer. This method accept these three possible formats so you don´t need to format it yourself.
  
  def self.get_address(zip_code, token)
    zip_code = zip_code.to_s
    
    if zip_code.match(/^[0-9]{5}[-]?[0-9]{3}/)
      zip_code.gsub!("-", "")
      @uri = URI.parse "http://www.cepfacil.com.br/service/?filiacao=#{token}&cep=#{zip_code}&formato=texto"
    else
      @uri = URI.parse "http://www.cepfacil.com.br/service/?filiacao=#{token}&cep=#{zip_code}&formato=texto"
    end
    
    http = Net::HTTP.new(@uri.host, @uri.port)
    call = Net::HTTP::Get.new(@uri.request_uri)
    
    response = http.request(call)
    response.body
    
    pattern = /^([a-z]+)\=/
    result = response.body.split("&")
    
    type = result[2].gsub!(pattern, "")
    state = result[3].gsub!(pattern, "")
    city = result[4].gsub!(pattern, "")
    neighborhood = result[5].gsub!(pattern, "")
    description = result[6].gsub!(pattern, "")
    
    address = {
      cep: zip_code,
      type: type,
      state: state,
      city: city,
      neighborhood: neighborhood,
      description: description
    }
  
  end
end
