# frozen_string_literal: true

if Rails.env.development?
  require "./db/seeders/usuario.rb"
  require "./db/seeders/tipo_cadastro_profissional.rb"
  require "./db/seeders/profissionais.rb"
  require "./db/seeders/ocupacao.rb"
  require "./db/seeders/tipo_unidade.rb"
  require "./db/seeders/unidade_saude.rb"
  require "./db/seeders/nacionalidades.rb"
  require "./db/seeders/paises.rb"
  require "./db/seeders/estados.rb"
  require "./db/seeders/municipios_acre.rb"
  require "./db/seeders/raca_cor.rb"
  require "./db/seeders/tipos_logradouro.rb"
  require "./db/seeders/conselhos_classes.rb"
end
