# frozen_string_literal: true

# TODO: Transformar essa classe em um Repository. Pois ela não está de seguindo os conceitos de Service.
# - Services devem ter apenas um método público, que é o `call`.
# - Services devem ser responsáveis por orquestrar a lógica de negócio em torno de uma determinada operação.
# - O nome do service deve representar a ação que ele executa. Exemplo 'SearchEquipamentoService'
# - Services devem retornar uma estrutura de dados consistente, adotamos as classes `Success` e `Failure` para isso.
module Equipamentos
  class EquipamentoService < ApplicationService
    def search_by_nome(params)
      data = ::EquipamentoRepository.search_by_nome(params[:nome]) if params[:nome].present?
      data = ::EquipamentoRepository.all if data.nil?

      {
        data:,
        success: true
      }
    end

    def search_by_unidade_saude(params)
      allowed_orders = {
        'nome_equipamentos' => 'equipamentos.nome'
      }

      order = allowed_orders[params[:order]] || 'equipamentos.nome'

      result = ::EquipamentoRepository.search_by_unidade_saude(
        params[:id],
        order,
        params[:order_direction] || 'ASC'
      )
      result = paginate(result, params)

      {
        data: result,
        total_pages: result.total_pages,
        total_count: result.total_count,
        current_page: params[:page]
      }
    end

    def add_to_unidade_saude(unidade_saude_id, params)
      result = ::EquipamentoRepository.add_to_unidade_saude(unidade_saude_id, params)
      {
        data: result,
        success: !result.nil?
      }
    end

    def remove_from_unidade_saude(id)
      ::EquipamentoRepository.remove_from_unidade_saude(id)
      {
        data: nil,
        success: true
      }
    end

    private

    def paginate(result, params)
      result.page(params[:page]).per(params[:per_page])
    end
  end
end
