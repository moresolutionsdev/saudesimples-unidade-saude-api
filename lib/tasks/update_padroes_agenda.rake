# frozen_string_literal: true

namespace :padrao_agenda do
  desc 'Atualiza a tabela padroes_agendas com base nas informações das tabelas relacionadas'
  task atualizar: :environment do
    data = [
      'Especialidade',
      'Procedimento',
      'Grupo de atendimento',
      'Equipamentos'
    ]

    data.each do |d|
      result = PadraoAgenda.where('nome ILIKE ?', "%#{d}%")

      if result.count > 1
        result.each_with_index do |r, i|
          next if i.zero?

          r.destroy
        end

        result.first.update(nome: d)
      elsif result.count.zero?
        PadraoAgenda.create(nome: d)

        next

      else
        result.first.update(nome: d)
      end
    end

    puts 'Tarefa concluída. Tabela padroes_agenda atualizada.'
  end
end
