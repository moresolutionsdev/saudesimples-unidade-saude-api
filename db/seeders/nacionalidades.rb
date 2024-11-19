data = [
  {
    "id": 1,
    "nome": "Brasileira",
    "codigo": 31
  },
  {
    "id": 2,
    "nome": "Estrangeira",
    "codigo": 33
  },
  {
    "id": 3,
    "nome": "Naturalizado",
    "codigo": 34
  }
]

data.each do |nacionalidade|
  next if Nacionalidade.exists?(nome: nacionalidade[:nome])

  Nacionalidade.create(nacionalidade)

  puts "Nacionalidade #{nacionalidade[:nome]} criada com sucesso"
end
