# frozen_string_literal: true

namespace :descricao_subtipo_unidade do
  desc 'Atualiza ou cria registros em DescricaoSubtipoUnidade com base na tabela fornecida e ClassificacaoCNES'

  task update: :environment do
    mapeamento = {
      '07' => {
        '001' => 'PEDIATRIA',
        '002' => 'CARDIOLOGIA',
        '003' => 'ORTOPEDIA',
        '004' => 'ONCOLOGIA',
        '005' => 'MATERNIDADE',
        '006' => 'PSIQUIATRIA'
      },
      '36' => {
        '001' => 'CENTRO ESPECIALIZADO EM REABILITAÇÃO (CER)',
        '002' => 'CENTRO ESPECIALIZADO EM REABILITAÇÃO (CER-II)',
        '003' => 'CENTRO ESPECIALIZADO EM REABILITAÇÃO (CER-III)',
        '004' => 'CENTRO ESPECIALIZADO EM REABILITAÇÃO (CER-IV)',
        '005' => 'CENTRO DE REFERÊNCIA EM SAÚDE DO TRABALHADOR CEREST',
        '006' => 'CEO-I',
        '007' => 'CEO-II',
        '008' => 'CEO-III',
        '009' => 'OUTROS'
      },
      '39' => {
        '003' => 'LABORATORIO REGIONAL DE PROTÉSE DENTÁRIA (LRPD)'
      },
      '40' => {
        '001' => 'UNIDADE MÓVEL ODONTOLOGICA',
        '002' => 'CONSULTÓRIO ITINERANTE'
      },
      '50' => {
        '001' => 'UNIDADE DE VIGILÂNCIA DE ZOONOSES'
      },
      '67' => {
        '001' => 'PORTE I - NÍVEL A',
        '002' => 'PORTE I - NÍVEL B',
        '003' => 'PORTE I - NÍVEL C',
        '004' => 'PORTE I - NÍVEL D',
        '005' => 'PORTE I - NÍVEL E',
        '006' => 'PORTE II - NÍVEL A',
        '007' => 'PORTE II - NÍVEL B',
        '008' => 'PORTE II - NÍVEL C',
        '009' => 'PORTE II - NÍVEL D',
        '010' => 'PORTE II - NÍVEL E',
        '011' => 'PORTE III - NÍVEL A',
        '012' => 'PORTE III - NÍVEL B',
        '013' => 'PORTE III - NÍVEL C',
        '014' => 'PORTE III - NÍVEL D',
        '015' => 'PORTE III - NÍVEL E',
        '016' => 'PORTE IV - NÍVEL A',
        '017' => 'PORTE IV - NÍVEL B',
        '018' => 'PORTE IV - NÍVEL C',
        '019' => 'PORTE IV - NÍVEL D',
        '020' => 'PORTE IV - NÍVEL E',
        '021' => 'PORTE V - NÍVEL A',
        '022' => 'PORTE V - NÍVEL B',
        '023' => 'PORTE V - NÍVEL C',
        '024' => 'PORTE V - NÍVEL D',
        '025' => 'PORTE V - NÍVEL E'
      },
      '68' => {
        '001' => 'SECRETARIA DE ESTADO DA SAÚDE (SES)',
        '002' => 'REGIONAL DE SAÚDE',
        '003' => 'SECRETARIA MUNICIPAL DE SAÚDE (SMS)',
        '004' => 'DISTRITO SANITÁRIO',
        '005' => 'SEDE DE OPERADORA DE PLANO DE SAÚDE',
        '006' => 'SEDE DE CONSÓRCIO PÚBLICO NA ÁREA DE SAÚDE'
      },
      '69' => {
        '001' => 'HEMOTERAPIA/HEMATOLOGIA-COORDENADOR',
        '002' => 'HEMOTERAPIA/HEMATOLOGIA-REGIONAL',
        '003' => 'HEMOTERAPIA/HEMATOLOGIA-NUCLEO',
        '004' => 'UNIDADE DE COLETA E TRANSFUSÃO – UCT',
        '005' => 'UNIDADE DE COLETA - UC',
        '006' => 'CENTRAL DE TRIAGEM LABORATORIAL DE DOADORES – CTLD',
        '007' => 'ORGANIZAÇÃO DE PROCURA DE ÓRGÃOS E TECIDOS'
      },
      '70' => {
        '001' => 'CAPS I',
        '002' => 'CAPS II',
        '003' => 'CAPS III',
        '004' => 'CAPS INFANTO/JUVENIL',
        '005' => 'CAPS ÁLCOOL E DROGA',
        '006' => 'CAPS ÁLCOOL E DROGAS III - MUNICIPAL',
        '007' => 'CAPS ÁLCOOL E DROGAS III - REGIONAL',
        '008' => 'CAPS AD IV'
      },
      '72' => {
        '001' => 'CASA DE SAÚDE INDÍGENA (CASAI)',
        '002' => 'UNIDADE BÁSICA DE SAÚDE INDÍGENA (UBSI)',
        '003' => 'POLO BASE TIPO I - SEDE',
        '004' => 'POLO BASE TIPO II - SEDE',
        '005' => 'DISTRITO SANITÁRIO ESPECIAL INDÍGENA (DSEI) - SEDE'
      },
      '73' => {
        '001' => 'PRONTO ATENDIMENTO GERAL',
        '002' => 'PRONTO ATENDIMENTO ESPECIALIZADO',
        '003' => 'UPA'
      },
      '75' => {
        '001' => 'NUCLEO TÉCNICO-CIENTÍFICO PROG NAC TELESSAUDE BRASIL REDES',
        '002' => 'UNIDADE DE TELESSAUDE'
      },
      '76' => {
        '001' => 'ESTADUAL',
        '002' => 'REGIONAL',
        '003' => 'MUNICIPAL'
      },
      '80' => {
        '001' => 'LABORATÓRIO CENTRAL DE SAÚDE PÚBLICA (LACEN)',
        '002' => 'LABORATÓRIO FEDERAL',
        '003' => 'LABORATÓRIO ESTADUAL',
        '004' => 'LABORATÓRIO MUNICIPAL'
      },
      '81' => {
        '001' => 'AMBULATORIAL',
        '002' => 'INTERNACAO HOSPITALAR',
        '003' => 'AMBULATORIAL E DE INTERNACAO HOSPITALAR',
        '004' => 'ALTA COMPLEXIDADE E AMBULATORIAL',
        '005' => 'ALTA COMPLEXIDADE E INTERNACAO HOSPITALAR',
        '006' => 'ALTA COMPLEXIDADE, AMBULATORIAL E INTERNACAO HOSPITALAR'
      },
      '82' => {
        '001' => 'CENTRAL DE NOTIFICAÇÃO,CAPTAÇÃO E DISTRIB DE ÓRGÃOS SEDE',
        '002' => 'CENTRAL DE NOTIFICAÇÃO,CAPTAÇÃO E DISTRIB DE ÓRGÃOS REGIONAL',
        '003' => 'ORGANIZAÇÃO DE PROCURA DE ÓRGÃOS E TECIDOS'
      }
    }

    ClassificacaoCNES.find_or_create_by(codigo: '82') do |classificacao|
      classificacao.nome = 'CENTRAL DE NOTIFICACAO,CAPTACAO E DISTRIBUICAO DE ORGAOS'
    end
    mapeamento.each do |tipo_codigo, subtipos|
      classificacao = ClassificacaoCNES.find_or_initialize_by(codigo: tipo_codigo)

      if classificacao.new_record?
        classificacao.nome = "Nome padrão para o código #{tipo_codigo}"
        begin
          classificacao.save!
          puts "ClassificacaoCNES com código #{tipo_codigo} criada com sucesso."
        rescue ActiveRecord::RecordInvalid => e
          puts "Erro ao criar ClassificacaoCNES com código #{tipo_codigo}: #{e.message}"
          next
        end
      end

      puts "Processando ClassificacaoCNES com código: #{tipo_codigo}, nome: #{classificacao.nome}"

      subtipos.each do |subtipo_codigo, subtipo_nome|
        descricao_subtipo_unidade = DescricaoSubtipoUnidade.find_or_initialize_by(codigo: subtipo_codigo,
                                                                                  classificacao:)
        descricao_subtipo_unidade.nome = subtipo_nome

        if descricao_subtipo_unidade.new_record? || descricao_subtipo_unidade.changed?
          begin
            descricao_subtipo_unidade.save!
            puts "Criado/Atualizado: #{descricao_subtipo_unidade.nome} com classificação_cnes_id #{classificacao.id}"
          rescue ActiveRecord::RecordInvalid => e
            puts "Erro ao salvar: #{e.message}"
            puts e.record.errors.full_messages
          end
        else
          puts "Registro já está atualizado: #{descricao_subtipo_unidade.nome}"
        end
      end
    end

    puts 'Processamento concluído.'
  end
end
