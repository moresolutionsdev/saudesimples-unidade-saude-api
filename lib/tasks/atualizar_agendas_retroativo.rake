# frozen_string_literal: true

namespace :agendas do
  desc 'Atualiza a tabela agendas com base nas informações das tabelas relacionadas'
  task atualizar: :environment do
    sql = <<-SQL.squish
      WITH joined_data AS (
        SELECT
          a.id AS agenda_id,
          MAX(CASE
            WHEN amh.regulacao > 0 OR amh.regulacao_retorno > 0 THEN 1
            ELSE 0
          END) AS regulacao,
          MAX(CASE
            WHEN amh.nova_consulta > 0 OR amh.reserva_tecnica > 0 OR amh.retorno > 0 THEN 1
            ELSE 0
          END) AS local
        FROM agendas a
        JOIN agendas_mapas_periodos amp ON amp.agenda_id = a.id
        JOIN agendas_mapas_dias amd ON amd.agenda_mapa_periodo_id = amp.id
        JOIN agendas_mapas_horarios amh ON amh.agenda_mapa_dia_id = amd.id
        GROUP BY a.id
      )
      UPDATE agendas
      SET
        regulacao = joined_data.regulacao::boolean,
        local = joined_data.local::boolean
      FROM joined_data
      WHERE agendas.id = joined_data.agenda_id;
    SQL

    ActiveRecord::Base.connection.execute(sql)
    puts 'Tarefa concluída. Tabela agendas atualizada.'
  end
end
