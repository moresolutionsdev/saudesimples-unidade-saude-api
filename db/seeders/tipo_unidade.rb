tipos_cadastro = [
  {nome: "Pronto Atendimento"},
  {nome: "Com Agendamento"},
  {nome: "Misto"},
]

begin
  tipos_cadastro.each { |tipo| TipoUnidade.create_with(tipo).find_or_create_by(nome: tipo[:nome]) }

  puts "Dados de 'tipos_unidades' carregados com sucesso!".colorize(:green)
rescue => error
  puts "Não foi possível carregar dados de 'tipos_unidades'".colorize(:yellow)
end
