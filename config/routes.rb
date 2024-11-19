# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  get '/up', to: 'health_check#show'

  if Rails.env.development?
    get '/status', to: 'status#index'
    mount Sidekiq::Web => '/sidekiq'
  end

  namespace :api do
    # path /api/unidade_saude
    resources :unidade_saude, only: %i[index create update destroy show] do
      # recursos aninhados ao path /api/unidade_saude
      collection do
        get :tipo_administracao
        get :subtipo_unidade_saude
        get :tipo_unidade_saude, to: 'unidade_saude/tipo_unidade_saude#index'
        get :tipo_logradouro
        get :estados_habilitados
        get 'busca_cep/:cep', to: 'unidade_saude#busca_cep'
        get :local
        get 'servicos/classificacao', to: 'servicos_classificacao#index'
        get 'instalacao_fisica', to: 'instalacao_fisicas#search'
        get 'municipio/:municipio_id', to: 'unidade_saude#municipio'
        get 'listagem/minimal', to: 'unidade_saude_minimal#listagem_reduzida'
        get 'termos_uso/ultima_versao', to: 'unidade_saude/termos_uso#ultima_versao'
        get 'politicas_acesso/ultima_versao', to: 'unidade_saude/politicas_acesso#ultima_versao'
        get 'profissionais/:profissional_id/equipes', to: 'unidade_saude/equipe_profissionais#by_profissional'
        post '/termos_uso', to: 'unidade_saude/termos_uso#create'

        resources :equipes, only: %i[create show update destroy] do
          collection do
            get :exists, to: 'equipes#exists'
            get 'minimal', to: 'unidade_saude/equipes#minimal'
          end

          member do
            get 'micro_areas', to: 'unidade_saude/equipes#micro_areas'
          end

          put :alternar_situacao, on: :member
          resources :equipe_profissionais, only: %i[index], controller: 'equipes_profissionais'
        end

        get 'agendas/padroes_agendas', to: 'unidade_saude/padroes_agendas#index'
        get 'agendas/:id/restricoes_cids', to: 'unidade_saude/agendas/restricoes_cids#index', as: :restricoes_cids_index

        resources :agendas, only: %i[index create update show destroy], controller: 'unidade_saude/agendas' do
          resources :bloqueios, only: %i[create], controller: 'unidade_saude/agendas/bloqueios'

          collection do
            get 'agendas_mapas_periodos/conflitos', to: 'unidade_saude/agendas#conflitos'
            get :tipos_bloqueios
          end

          resources :outras_informacoes, controller: 'agendas_outra_informacao', only: %i[index]
          resources :mapas_periodos, only: [:update], param: :mapa_periodo_id, controller: 'unidade_saude/mapas_periodos'
          member do
            get 'mapas_periodos', to: 'unidade_saude/agendas#mapas_periodos'
            get 'mapas_periodos/:mapa_periodo_id', to: 'unidade_saude/agendas#mapa_periodo_show'
            post 'mapas_periodos', to: 'unidade_saude/agendas#mapa_periodo_create'
            get 'pendencias_bloqueios', to: 'unidade_saude/agendas#pendencias_bloqueios'
          end

          resources :bloqueios, only: [:index, :destroy], controller: 'agendas_bloqueios'
          get 'audits', to:'unidade_saude/agenda_audits#index'
        end

        resources :grupos_atendimentos, only: [:index], controller: 'unidade_saude/grupos_atendimentos'
        resources :permissoes, only: [:index]
        resources :ocupacoes, only: [:index]
        resources :profissionais, only: [:index]
        resources :servicos, only: [:index], controller: 'tipos_de_servico'
        resources :termos_usos, only: %i[index show], controller: 'unidade_saude/termos_uso'
        resources :politicas_acesso, only: %i[index show create], controller: 'unidade_saude/politicas_acesso'
        resources :audits, only: [:index]

        # path /api/unidade_saude/servicos_apoio
        namespace :servicos_apoio do
          resources :tipos, only: [:index]
          resources :caracteristica, only: [:index], controller: 'caracteristicas_servicos'
        end

        namespace :importacao_zip do
          resources :cnes, only: [:create]
          post 'sync_unidades_saude', to: 'webhook#sync_unidades_saude'
        end

        namespace :importacao do
          resources :cnes, only: [:create]
        end

      end

      # recursos aninhados ao path /api/unidade_saude/:id
      member do
        get 'auditorias', to: 'unidade_saude/auditorias#index'
        get 'servico_especializado', to: 'unidade_saude#servico_especializado'
        post 'instalacao_fisica', to: 'unidade_saude/instalacao_fisica/instalacao_unidades#create'
        get :equipamento, to: 'unidade_saude#unidade_saude_equipamentos'
        post :equipamento, to: 'unidade_saude#create_unidade_saude_equipamento'
        get :endereco_complementar
        get :profissional_cadastrado
      end

      # recursos aninhados ao path /api/unidade_saude/:unidade_saude_id
      get 'parametros', to: 'unidade_saude/parametros#index'
      resources :instalacao_fisica, only: [:index], controller: 'unidade_saude/instalacao_fisica/instalacao_unidades'
      resources :instalacao, only: [:destroy], controller: 'unidade_saude/instalacao_fisica/instalacao_unidades'
      resources :profissional, only: [:create], controller: 'unidade_saude/profissional'
      resources :servicos_apoio, only: %i[index create destroy], controller: 'servicos_apoio/servicos_apoio'
      resources :servico_especializado, only: %i[create destroy]
      resources :equipes, only: %i[index show], controller: 'unidade_saude/equipes' do
        resources :equipe_profissionais, only: %i[index], controller: 'unidade_saude/equipe_profissionais'
      end

      resources :unidade_saude_ocupacoes, only: %i[index]
    end

    resources :tipo_equipes, only: [:index]
    resources :mapeamento_indigenas, only: [:index]
    resources :equipamento, only: [:index]
    resources :estados, only: %i[index] do
      resources :municipios, only: %i[index]
    end
    resources :paises, only: %i[index]
    resources :nacionalidades, only: %i[index]
    resources :areas, only: %i[index]
    resources :micro_areas, only: %i[index]
    delete '/unidade_saude/:unidade_saude_id/equipamento/:id', to: 'unidade_saude#delete_unidade_saude_equipamentos'

    scope :ferramentas do
      resources :parametrizacoes, only: %i[index update], controller: 'ferramentas/parametrizacoes'
    end
  end
end
