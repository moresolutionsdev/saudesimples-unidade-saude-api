# frozen_string_literal: true

# TODO!: Refactor this class to use the new ApplicationRepository

class UnidadeSaudeRepository
  extend CurrentUser
  include CurrentUser

  def initialize(params)
    @params = params
  end

  def self.all
    UnidadeSaude.all
  end

  def self.ativas(params = {})
    unidades_saude = UnidadeSaude.where(inativa: false)

    if params[:exportacao_esus].present? && params[:exportacao_esus] == 'true'
      unidades_saude = unidades_saude.where(exportacao_esus: true)
    end

    if params[:term].present?
      unidades_saude = unidades_saude.where('nome ILIKE :term OR codigo_cnes LIKE :term', term: "%#{params[:term]}%")
    end

    unidades_saude
  end

  def self.inativas
    UnidadeSaude.inativas
  end

  def self.search_by_term(term)
    query = 'nome ILIKE :term'
    sanitized_term = sanitize_cpf_cnpj(term)

    if sanitized_term.present?
      query +=
        ' OR regexp_replace(cpf_numero, \'[^0-9]\', \'\', \'g\') LIKE :sanitized_term
          OR regexp_replace(cnpj_numero, \'[^0-9]\', \'\', \'g\') LIKE :sanitized_term
          OR codigo_cnes LIKE :sanitized_term'
    end
    UnidadeSaude.where(query, term: "#{term.strip}%", sanitized_term: "#{sanitized_term.strip}%")
  end

  def self.sanitize_cpf_cnpj(term)
    term.gsub(/[^\d]/, '')
  end

  def self.search_by_cnes(codigo_cnes)
    UnidadeSaude.where(codigo_cnes:)
  end

  def self.search_by_id(id)
    UnidadeSaude.find_by(id:)
  end

  def self.set_mantenedora(unidade_saude_id:, mantenedora_id:)
    unidade_saude = UnidadeSaude.find(unidade_saude_id)
    unidade_saude.update(mantenedora_id:)

    unidade_saude
  end

  def self.upsert_unidade_saude(codigo_cnes, object)
    unidade_saude = ::UnidadeSaude.find_or_initialize_by(codigo_cnes:)
    unidade_saude.update(object)

    raise ActiveRecord::RecordInvalid, unidade_saude unless unidade_saude.valid?

    unidade_saude
  end

  # rubocop:disable Metrics/AbcSize
  def self.create(params)
    filtered_params = filter_params(params)
    unidade_saude_params = filtered_params[:unidade_saude]
    unidade_saude_params[:numero] = 'S/N' if unidade_saude_params[:numero].nil?
    nova_unidade_saude = ::UnidadeSaude.new(unidade_saude_params)

    unless nova_unidade_saude.valid?
      raise ::UnidadeSaude::UnidadeSaudeCriacaoError.new(nova_unidade_saude.errors.full_messages).message
    end

    nova_unidade_saude.save!
    SyncElasticsearchJob.perform_later({ id: nova_unidade_saude[:id] })

    nova_unidade_saude
  rescue StandardError => e
    raise ::UnidadeSaude::UnidadeSaudeCriacaoError, e.message
  end

  def self.update(params)
    unidade_saude = ::UnidadeSaude.find(params[:id])
    filtered_params = filter_params(params).except(:administrador_id)
    filtered_params[:unidade_saude] =
      filtered_params[:unidade_saude].except(:administrador_id, :horarios_funcionamento, :mantenedora)

    if filtered_params[:unidade_saude][:tipo_unidade_id].nil?
      filtered_params[:unidade_saude][:tipo_unidade_id] =
        filtered_params[:unidade_saude][:classificacao_cnes_id]
    end

    unidade_saude_params = filtered_params[:unidade_saude]
    unidade_saude_params[:numero] = 'S/N' if unidade_saude_params[:numero].nil?

    unless unidade_saude.update(unidade_saude_params)
      raise UnidadeSaude::UnidadeSaudeAtualizarError, unidade_saude.errors.full_messages
    end

    SyncElasticsearchJob.perform_later({ id: unidade_saude.id })

    unidade_saude
  rescue StandardError => e
    raise ::UnidadeSaude::UnidadeSaudeAtualizarError, e.message
  end
  # rubocop:enable Metrics/AbcSize

  def deactivate
    unidade_saude = UnidadeSaude.find(@params[:id])
    unidade_saude.update(inativa: true)
    SyncElasticsearchJob.perform_later({ id: @params[:id] })

    unidade_saude
  rescue StandardError => e
    raise ::UnidadeSaude::UnidadeSaudeDesativarError, e.message
  end

  def self.filter_params(params)
    data = params.dup
    {
      unidade_ibge: {
        id: data.delete(:ibge)
      },
      unidade_saude: data
    }
  end
end
