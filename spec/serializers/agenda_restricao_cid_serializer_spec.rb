# frozen_string_literal: true

RSpec.describe AgendaRestricaoCidSerializer do
  before do
    Faker::UniqueGenerator.clear
  end

  let(:datasus_cid) { create(:datasus_cid, co_cid: 'A00') }
  let(:cid) { create(:cid, datasus_cid:, nome: 'Cólera') }
  let(:agenda_restricao_cid) { build(:agenda_restricao_cid, id: 1, codigo_cid: cid.codigo) }
  let(:agenda_restricao_cid_2) { build(:agenda_restricao_cid, id: 2, codigo_cid: cid.codigo) }

  describe 'AgendaRestricaoCidSerializer#render_as_hash' do
    context 'when serializing a single object' do
      it 'serializes the agenda_restricao_cid correctly in list view' do
        result = described_class.render(agenda_restricao_cid, view: :list)

        expect(JSON.parse(result, symbolize_names: true)).to eq(
          id: 1,
          cid: {
            id: 1,
            co_cid: 'A00',
            no_cid: 'Cólera'
          }
        )
      end
    end

    context 'when serializing a list of objects' do
      it 'serializes a list of agenda_restricao_cids correctly in list view' do
        result = described_class.render([agenda_restricao_cid, agenda_restricao_cid_2], view: :list)

        expect(JSON.parse(result, symbolize_names: true)).to eq([
          {
            id: 1,
            cid: {
              id: 1,
              co_cid: 'A00',
              no_cid: 'Cólera'
            }
          },
          {
            id: 2,
            cid: {
              id: 2,
              co_cid: 'A00',
              no_cid: 'Cólera'
            }
          }
        ])
      end
    end
  end
end
