# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MicroAreaRepository, type: :repository do
  let!(:equipe) { create(:equipe) }
  let!(:micro_area_1) { create(:micro_area, nome: 'Alpha', codigo: 10, equipes: [equipe]) }
  let!(:micro_area_2) { create(:micro_area, nome: 'Beta', codigo: 20, equipes: [equipe]) }
  let!(:micro_area_3) { create(:micro_area, nome: 'Gamma', codigo: 30) }

  describe '.search' do
    it 'returns all micro_areas when no filters are applied' do
      result = described_class.search

      expect(result).to contain_exactly(micro_area_1, micro_area_2, micro_area_3)
    end

    it 'filters micro_areas by nome' do
      result = described_class.search(nome: 'Alpha')

      expect(result).to contain_exactly(micro_area_1)
    end

    it 'filters micro_areas by codigo' do
      result = described_class.search(codigo: 20)

      expect(result).to contain_exactly(micro_area_2)
    end

    it 'filters micro_areas by area_id' do
      area = micro_area_1.area
      result = described_class.search(area_id: area.id)

      expect(result).to contain_exactly(micro_area_1)
    end

    it 'orders micro_areas by nome asc' do
      result = described_class.search(order: 'nome', order_direction: 'asc')

      expect(result).to eq([micro_area_1, micro_area_2, micro_area_3])
    end
  end

  describe '.search_by_equipe' do
    it 'returns micro_areas associated with a specific equipe' do
      result = described_class.search_by_equipe(equipe.id)

      expect(result).to contain_exactly(micro_area_1, micro_area_2)
    end

    it 'filters micro_areas by term within the equipe' do
      result = described_class.search_by_equipe(equipe.id, term: 'Alph')

      expect(result).to contain_exactly(micro_area_1)
    end

    it 'returns an empty array when no micro_areas match the term within the equipe' do
      result = described_class.search_by_equipe(equipe.id, term: 'Nonexistent')

      expect(result).to be_empty
    end

    it 'orders micro_areas by nome within the equipe' do
      result = described_class.search_by_equipe(equipe.id)

      expect(result).to eq([micro_area_1, micro_area_2])
    end
  end
end
