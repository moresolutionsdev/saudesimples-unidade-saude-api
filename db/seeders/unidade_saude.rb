unidade = {
  tipo_unidade: TipoUnidade.first,
  tipo_pessoa_cnes_id: 1,
  situacao_unidade_saude_id: 1,
  classificacao_cnes_id: 2,
  codigo_cnes: 3392694,
  nome: "UBS MIRANTE DA MATA",
  cep: "06720-070",
  estado_id: 25,
  municipio_id: 4852,
  tipo_logradouro_id: 11,
  logradouro: "RUA FRANCISCO ALVES",
  numero: 78,
  bairro: "MIRANTE DA MATA",
  codigo_distrito_administrativo: 1,
  telefone: "(11) 4614-8521",
  email: "ubs.mirantedamata@cotia.sp.gov.br",
}

begin
  UnidadeSaude.create_with(unidade).find_or_create_by(nome: unidade[:nome])

  puts "Dados de 'unidade_saude' carregados com sucesso!".colorize(:green)
rescue => error
  puts "Não foi possível carregar dados de 'unidade_saude'".colorize(:yellow)
end
