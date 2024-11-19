# frozen_string_literal: true

# TODO: Transformar essa classe em um Repository. Pois ela não está de seguindo os conceitos de Service.
# - Services devem ter apenas um método público, que é o `call`.
# - Services devem ser responsáveis por orquestrar a lógica de negócio em torno de uma determinada operação.
# - O nome do service deve representar a ação que ele executa. Exemplo 'SearchEquipamentoService'
# - Services devem retornar uma estrutura de dados consistente, adotamos as classes `Success` e `Failure` para isso.
class UnidadeSaude
  class UnidadeSaudeEnderecoService
    def estados_habilitados(codigo_esus = Pais::BRASIL_CODIGO_ESUS)
      estados = ::UnidadeSaudeEnderecoRepository.estados_habilidados(codigo_esus)
      estados.presence || []
    end

    def buscar_cep(cep)
      cep_simples = ::Endereco::CepSimplesService.new.call(cep:)
      dados_cep = cep_simples[:data]
      ibge = dados_cep[:ibge].chop
      logradouro = dados_cep[:logradouro]

      municipio = ::UnidadeSaudeEnderecoRepository.search_municipio_ibge(ibge)
      estado = ::UnidadeSaudeEnderecoRepository.find_estado_by_id(municipio.estado_id) if municipio.present?
      if logradouro.present? && municipio.present?
        logradouro = ::UnidadeSaudeEnderecoRepository.find_logradouro_by_municipio_and_nome(municipio.id,
                                                                                            logradouro)
      end
      {
        data: {
          busca_cep: dados_cep,
          municipio:,
          estado:,
          logradouro:
        }
      }
    end

    def search_locais(nome)
      ::Local.where('nome ILIKE ?', "%#{nome}%").order(nome: :asc)
    end

    def tipo_logradouro
      ::UnidadeSaudeEnderecoRepository.tipo_logradouro
    end

    def find_municipio(id)
      ::UnidadeSaudeEnderecoRepository.find_by(id:)
    end
  end
end
