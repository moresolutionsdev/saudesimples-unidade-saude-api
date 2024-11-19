# frozen_string_literal: true

class ContratoRepository < ApplicationRepository
  def self.tipo_administracao
    AdministradorContrato.all
  end
end
