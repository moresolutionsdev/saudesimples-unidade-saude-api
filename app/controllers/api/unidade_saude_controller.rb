# frozen_string_literal: true

module Api
  class UnidadeSaudeController < ApplicationController
    include ::Authorizable

    # Sobrescreve o getter para unidade de saúde definido no concern Authorizable, pois aqui usamos
    # params[:id] ao invés de params[:unidade_saude_id]
    def unidade_saude
      @unidade_saude ||= ::UnidadeSaude.find(params[:id])
    end

    # GET /unidade_saude
    def index
      case ::UnidadeSaude::SearchService.new(index_params).call
      in success: result
        render_200(
          serialize(result[:unidades_saude], UnidadeSaudeListSerializer),
          meta: {
            current_page: result[:current_page],
            total_pages: result[:total_pages],
            total_count: result[:total_count]
          }
        )
      in failure: error_message
        render_422 error_message
      end
    end

    # GET /unidade_saude/:id
    def show
      case ::UnidadeSaude::BuscaUnidadeSaudeService.call(params[:id])
      in success: unidade_saude
        render_200 serialize(unidade_saude, UnidadeSaudeSerializer, view: :normal)
      in failure: error_message
        render_422 error_message
      end
    end

    # POST /unidade_saude
    def create
      result = ::UnidadeSaude::NovaUnidadeSaudeService.new(unidade_saude_params).call
      if result[:success]
        unidade_saude = result[:unidade_saude]
        render_201 serialize(unidade_saude, UnidadeSaudeSerializer)
      else
        render_422 message: result[:errors]
      end
    end

    # PATCH/PUT /unidade_saude/:id
    def update
      update_params = { id: unidade_saude.id }.merge(update_unidade_saude_params)

      case ::UnidadeSaude::AtualizaUnidadeSaudeService.call(update_params, validate: true)
      in success: unidade_saude
        render_200 serialize(unidade_saude, UnidadeSaudeSerializer)
      in failure: error
        render_422 error
      end
    rescue ActiveRecord::RecordNotFound
      render_404 'Unidade de saúde não encontrada'
    end

    def destroy
      case ::UnidadeSaude::DesativaUnidadeSaudeService.call(unidade_saude.id)
      in success: _
        render_204
      in failure: error
        render_422 error
      end
    end

    # TODO: Mover actions para controllers responsáveis por cada recurso
    # ----------------------------------------------------------------------------------------
    # As actions abaixo são responsáveis por recursos que são associados à Unidade de Saúde
    # ----------------------------------------------------------------------------------------
    def tipo_logradouro
      render json: {
        data: ::UnidadeSaude::UnidadeSaudeEnderecoService.new.tipo_logradouro
      }
    end

    # GET /api/unidade_saude/tipo_administracao
    def tipo_administracao
      case Contratos::BuscaTipoAdministracaoService.call
      in success: data
        render_200(data)
      in failure: error
        render_500(error)
      end
    end

    # GET /unidade_saude/subtipo_unidade_saude
    def subtipo_unidade_saude
      classificacao_cnes_id = params[:classificacao_cnes_id]

      case ::UnidadeSaude::SearchSubtipoUnidadeService.call(classificacao_cnes_id:)
      in success: subtipo_unidade
        render_200 serialize(subtipo_unidade, SubtipoUnidadeSaudeSerializer)
      in failure: error
        render_500(error)
      end
    end

    # GET /unidade_saude/estados_habilitados
    def estados_habilitados
      codigo_esus = params[:codigo_esus] || Pais::BRASIL_CODIGO_ESUS
      data = ::UnidadeSaude::UnidadeSaudeEnderecoService.new.estados_habilitados(codigo_esus)
      render_200 serialize(data, EstadoSerializer)
    end

    # GET /unidade_saude/busca_cep/:cep
    # rubocop:disable Metrics/AbcSize
    def busca_cep
      cep = params[:cep]
      endereco = ::UnidadeSaude::UnidadeSaudeEnderecoService.new.buscar_cep(cep)
      data = endereco[:data]

      municipio = MunicipioSerializer.render_as_hash(data[:municipio]) if data[:municipio].present?
      estado = EstadoSerializer.render_as_hash(data[:estado]) if data[:estado].present?
      logradouro = LogradouroSerializer.render_as_hash(data[:logradouro]) if data[:logradouro].present?

      render_200({
        busca_cep: DadosBuscaCepSerializer.render_as_hash(data[:busca_cep]),
        municipio:,
        estado:,
        logradouro:
      })
    end
    # rubocop:enable Metrics/AbcSize

    # GET /unidade_saude/:id/equipamento
    def unidade_saude_equipamentos
      result = ::Equipamentos::EquipamentoService.new.search_by_unidade_saude(equipamento_search_params)
      render_200(
        serialize(result[:data], ::EquipamentoUnidadeSaudeSerializer),
        meta: {
          current_page: result[:current_page],
          total_pages: result[:total_pages],
          total_count: result[:total_count]
        }
      )
    end

    # POST /unidade_saude/:id/equipamento
    def create_unidade_saude_equipamento
      id = unidade_saude.id
      result = ::Equipamentos::EquipamentoService.new.add_to_unidade_saude(id, unidade_saude_equipamento_params)
      data = EquipamentoUnidadeSaudeSerializer.render_as_hash(result[:data], current_user:) unless result[:data].nil?

      render_201 data
    rescue ActiveRecord::RecordInvalid => e
      error = e.record.errors.full_messages
      render_422 error
    end

    # GET /unidade_saude/local
    def local
      locais = ::UnidadeSaude::UnidadeSaudeEnderecoService.new.search_locais(local_params[:nome])
      render_200 serialize(locais, LocalSerializer)
    end

    def delete_unidade_saude_equipamentos
      ::Equipamentos::EquipamentoService.new.remove_from_unidade_saude(params[:id])
      render_204
    end

    def municipio
      municipio = ::UnidadeSaude::UnidadeSaudeEnderecoService.new.find_municipio(params[:id])
      render_200 serialize(municipio, MunicipioSerializer)
    end

    def servico_especializado
      case ::UnidadeSaude::BuscarServicosEspecializadoService.call(unidade_saude, servico_especializado_params)
      in success: servicos_especializados
        render_200(
          serialize(servicos_especializados, ::ServicoUnidadeSaudeSerializer),
          meta: {
            current_page: params[:page] || 1,
            total_pages: servicos_especializados.total_pages,
            total_count: servicos_especializados.total_count
          }
        )
      in failure: error
        render_422 error
      end
    end

    def endereco_complementar
      case ::UnidadeSaude::EnderecoComplementarSearchService.call(
        unidade_saude:,
        search_term: params[:search_term]
      )
      in success: enderecos
        render_200 serialize(enderecos, EnderecoComplementarUnidadeSerializer)
      in failure: error
        render_500 error
      end
    end

    def profissional_cadastrado
      case ::UnidadeSaude::ListarProfissionaisCadastrados.call(
        unidade_saude:,
        search_params: profissional_cadastrado_search_params
      )
      in success: profissionais
        render_200(
          serialize(profissionais, ProfissionalUnidadeSaudeSerializer),
          meta: {
            current_page: profissional_cadastrado_search_params[:page] || 1,
            total_pages: profissionais.total_pages,
            total_count: profissionais.total_count
          }
        )
      in failure: error
        render_500 error
      end
    end

    private

    def local_params
      params.permit(:nome)
    end

    def unidade_saude_params
      clean_up_unidade_saude_params(params[:unidade_saude])
      clean_up_mantenedora_params(params[:unidade_saude][:mantenedora])

      params.require(:unidade_saude).permit(
        *permitted_unidade_saude_params,
        horarios_funcionamento: %i[dia_semana horario_inicio horario_encerramento],
        mantenedora: %i[
          nome cnpj_numero cep estado_id municipio_id tipo_logradouro_id logradouro numero bairro
          complemento codigo_regiao_saude telefone agencia conta_corrente
        ]
      )
    end

    def clean_up_unidade_saude_params(unidade_saude_params)
      unidade_saude_params.delete(:municipio)
      unidade_saude_params.delete(:numero_sem_numero)
    end

    def clean_up_mantenedora_params(mantenedora_params)
      return if mantenedora_params.blank?

      mantenedora_params.delete(:municipio)
      mantenedora_params.delete(:numero_sem_numero)
    end

    def permitted_unidade_saude_params
      %i[
        codigo_cnes classificacao_cnes_id codigo_tipo_unidade cnpj_numero cpf_numero tipo_pessoa_cnes_id
        situacao_unidade_saude_id descricao_subtipo_unidade_id razao_social cep estado_id municipio_id
        tipo_logradouro_id logradouro numero bairro ibge nome tipo_unidade_id local_id complemento
        telefone email url administrador_id referencia_local
      ]
    end

    def update_unidade_saude_params
      params.require(:unidade_saude).permit(
        :codigo_cnes, :classificacao_cnes_id, :cnpj_numero, :cpf_numero, :tipo_pessoa_cnes_id,
        :situacao_unidade_saude_id, :descricao_subtipo_unidade_id, :razao_social, :cep, :estado_id,
        :municipio_id, :tipo_logradouro_id, :logradouro, :numero, :bairro, :ibge, :nome,
        :tipo_unidade_id, :local_id, :complemento, :telefone, :email, :url, :administrador_id,
        :referencia_local,
        horarios_funcionamento: %i[dia_semana horario_inicio horario_encerramento],
        mantenedora: %i[
          nome cnpj_numero cep estado_id municipio_id tipo_logradouro_id logradouro numero bairro
          complemento codigo_regiao_saude telefone agencia conta_corrente
        ]
      ).tap do |whitelisted|
        whitelisted[:mantenedora] = [] if params[:unidade_saude][:mantenedora].nil?
      end
    end

    def servico_especializado_params
      params.permit(:page, :per_page, :order, :order_direction)
    end

    def unidade_saude_equipamento_params
      params.require(:data).permit(:equipamento_id, :qtde_existente, :qtde_em_uso, :disponivel_para_sus)
    end

    def index_params
      params.permit(:situacao, :status, :term, :cnes, :page, :per_page, :order, :order_direction)
    end

    def equipamento_search_params
      params.permit(:id, :page, :per_page, :order, :order_direction)
    end

    def profissional_cadastrado_search_params
      params.except(:unidade_saude).permit(
        :page, :per_page, :order, :order_direction, :nome, :ocupacao_id, :ocupacao_nome, :id
      )
    end

    def subtipo_unidade_params
      params.permit(:classificacao_cnes_id)
    end
  end
end
