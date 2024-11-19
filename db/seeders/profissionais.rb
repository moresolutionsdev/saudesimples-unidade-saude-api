profissional = {
  tipo_cadastro_profissional_id: 1,
  codigo_cns: "980016282701134",
  nome: "ACS MODELO",
  telefone_celular: "(15)99124-0110",
  cpf_numero: "310.263.858-90",
  data_admissao: "01/11/2020",
  tipo_relacao_profissional_id: 1,
  numero_conselho: 33333333,
  orgao_classe_id: 15,
  orgao_classe_estado_id: 2,
  tipo_profissional_id: 1,
}

begin
  Profissional.create_with(profissional).find_or_create_by(nome: profissional[:nome])

  puts "Dados de 'profissionais' carregados com sucesso!".colorize(:green)
rescue => error
  puts "Não foi possível carregar dados de 'profissionais'".colorize(:yellow)
end
