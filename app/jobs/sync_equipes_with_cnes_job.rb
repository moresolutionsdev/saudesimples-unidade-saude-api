# frozen_string_literal: true

class SyncEquipesWithCNESJob < ApplicationJob
  queue_as :default

  def perform(page)
    equipes = EquipeRepository.list_from_cnes(page:)

    return if equipes.empty?

    Equipes::UpsertService.call(equipes)
    SyncEquipesWithCNESJob.perform_later(page + 1)
  end
end
