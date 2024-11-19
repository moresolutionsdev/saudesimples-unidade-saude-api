# frozen_string_literal: true

class ProfissionalUnidadeSaudeSerializer < ApplicationSerializer
  identifier :id

  association :ocupacao, blueprint: OcupacaoSerializer
  association :profissional, blueprint: ProfissionalSerializer
end
