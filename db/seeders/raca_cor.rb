data = [
  {"id"=>1, "nome"=>"AMARELA", "codigo"=>"04", "codigo_esus"=>3},
  {"id"=>2, "nome"=>"BRANCA", "codigo"=>"01", "codigo_esus"=>1},
  {"id"=>3, "nome"=>"INDIGENA", "codigo"=>"05", "codigo_esus"=>5},
  {"id"=>4, "nome"=>"PARDA", "codigo"=>"03", "codigo_esus"=>4},
  {"id"=>5, "nome"=>"PRETA", "codigo"=>"02", "codigo_esus"=>2},
  {"id"=>6, "nome"=>"SEM INFORMACAO", "codigo"=>"99", "codigo_esus"=>6}
]

data.each do |raca_cor|
  next if RacaCor.exists?(nome: raca_cor['nome'])

  RacaCor.create(raca_cor)

  puts "RacaCor #{raca_cor['nome']} criada com sucesso"
end
