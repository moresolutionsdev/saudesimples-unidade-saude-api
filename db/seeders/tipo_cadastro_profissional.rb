tipos_cadastro = [
  {nome: "PADRÃO"},
  {nome: "CNES"},
  {nome: "SUPORTE/TI"},
]

begin
  tipos_cadastro.each { |tipo| TipoCadastroProfissional.create_with(tipo).find_or_create_by(nome: tipo[:nome]) }

  puts "Dados de 'tipos_cadastros_profissionais' carregados com sucesso!".colorize(:green)
rescue => error
  puts "Não foi possível carregar dados de 'tipos_cadastros_profissionais'".colorize(:yellow)
end
