# frozen_string_literal: true

class UnidadeSaude
  class ListarProfissionaisCadastrados < ApplicationService
    DEFAULT_ORDER = 'profissionais.nome'
    ALLOWED_ORDERS = {
      'profissional_nome' => 'profissionais.nome',
      'ocupacao_nome' => 'ocupacoes.nome'
    }.freeze

    def initialize(unidade_saude:, search_params:)
      @unidade_saude = unidade_saude
      @search_params = search_params
    end

    def call
      collection = profissionais_cadastrados

      collection = apply_filters(collection)
      paginated_collection = paginate(collection)

      Success.new(paginated_collection)
    rescue StandardError => e
      Failure.new(e)
    end

    private

    def profissionais_cadastrados
      @profissionais_cadastrados ||= @unidade_saude.profissionais_cadastrados
    end

    def apply_filters(collection)
      collection = find_by_search_term if @search_params[:nome]
      collection = find_by_ocupacao_id(collection, @search_params[:ocupacao_id]) if @search_params[:ocupacao_id]
      collection
    end

    def apply_order(collection); end

    def find_by_search_term
      ::ProfissionalUnidadeSaudeRepository.by_search_term(@unidade_saude.id, @search_params[:nome])
    end

    def find_by_profissional
      ::ProfissionalUnidadeSaudeRepository.by_nome_profissional(@unidade_saude.id, @search_params[:nome])
    end

    def find_by_ocupacao
      ::ProfissionalUnidadeSaudeRepository.by_nome_ocupacao(@unidade_saude.id, @search_params[:nome])
    end

    def find_by_cpf_numero
      ::ProfissionalUnidadeSaudeRepository.by_cpf_profissional(@unidade_saude.id, @search_params[:nome])
    end

    def find_by_ocupacao_id(collection, ocupacao_id)
      collection.where(ocupacao_id:)
    end

    def paginate(collection)
      direction = (@search_params[:order_direction] || 'asc').downcase
      order_field = ALLOWED_ORDERS[@search_params[:order]] || DEFAULT_ORDER

      collection
        .joins(:profissional, :ocupacao)
        .order("#{order_field} #{direction}")
        .page(@search_params[:page]).per(@search_params[:per_page])
    end
  end
end
