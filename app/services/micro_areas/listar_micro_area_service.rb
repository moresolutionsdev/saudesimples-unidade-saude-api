# frozen_string_literal: true

module MicroAreas
  class ListarMicroAreaService
    def initialize(params)
      @params = params
    end

    def call
      micro_areas = MicroAreaRepository.search(@params)
      paginate(micro_areas)
    end

    private

    def paginate(micro_areas)
      page = @params[:page] || 1
      per_page = @params[:per_page] || 10

      paginated = micro_areas.page(page).per(per_page)
      {
        success: paginated
      }
    rescue StandardError => e
      { failure: e.message }
    end
  end
end
