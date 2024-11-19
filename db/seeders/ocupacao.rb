ocupacoes = [
  [{"id"=>3,
    "codigo"=>"322215",
    "nome"=>"Técnico de e enfermagem do trabalho",
    "saude"=>true,
    "classificacao"=>nil,
    "regulamentado"=>false,
    "permite_cid_encaminhamento"=>false},
   {"id"=>1,
    "codigo"=>"322230",
    "nome"=>"Auxiliar de enfermagem",
    "saude"=>true,
    "classificacao"=>nil,
    "regulamentado"=>false,
    "permite_cid_encaminhamento"=>false},
   {"id"=>2,
    "codigo"=>"322210",
    "nome"=>"Técnico de enfermagem de terapia intensiva",
    "saude"=>false,
    "classificacao"=>nil,
    "regulamentado"=>false,
    "permite_cid_encaminhamento"=>false},
   {"id"=>4,
    "codigo"=>"322220",
    "nome"=>"Técnico de e enfermagem psiquiátrica",
    "saude"=>false,
    "classificacao"=>nil,
    "regulamentado"=>false,
    "permite_cid_encaminhamento"=>false}]
]

begin
  ocupacoes.each do |op|
    Ocupacao.create_with(op).find_or_create_by(nome: op['nome'])
  end

  puts "Dados de 'ocupações' carregados com sucesso!"
rescue => error
  puts "Não foi possível carregar dados de 'ocupações'"
end
