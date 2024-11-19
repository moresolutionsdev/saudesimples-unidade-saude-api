# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::UnidadeSaude::AgendasController do
  describe 'GET #index' do
    include_context 'with an authenticated token'

    let(:unidade_saude_ocupacao) { create(:unidade_saude_ocupacao) }
    let(:profissional) { create(:profissional) }
    let(:padrao_agenda) { create(:padrao_agenda) }
    let(:procedimento) { create(:procedimento) }
    let!(:agenda) do
      create(:agenda,
             unidade_saude_ocupacao:,
             profissional_id: profissional.id,
             padrao_agenda_id: padrao_agenda.id,
             procedimento_id: procedimento.id)
    end
    let!(:agenda_mapa_periodos) do
      create(:agenda_mapa_periodo, agenda:, data_inicial: '2024-09-01', data_final: '2024-09-10')
    end
    let(:serialized_data) { AgendaSerializer.render_as_hash(agenda, view: :normal) }
    let(:agenda_contract) do
      %w[
        acoes data_inicial data_final especialidade inativo local
        padrao_agenda profissional regulacao situacao unidade_saude
      ]
    end

    it 'return base contract' do
      get :index, params: { unidade_saude_id: unidade_saude_ocupacao.unidade_saude_id }

      expect(response.parsed_body['data'].first.keys).to include(*agenda_contract)
    end

    context 'when filtering by unidade_saude_id' do
      let(:params) do
        {
          page: 1,
          per_page: 10,
          unidade_saude_id: unidade_saude_ocupacao.unidade_saude_id
        }
      end

      before { get :index, params: }

      it 'returns status code ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns parsed data filtered by unidade_saude_id' do
        expect(response.parsed_body).to include(
          'data' => [serialized_data],
          'meta' => { 'current_page' => 1, 'total_pages' => 1, 'total_count' => 1 }
        )
      end
    end

    context 'when filtering by profissional_id' do
      let(:params) do
        {
          page: 1,
          per_page: 10,
          profissional_id: profissional.id,
          unidade_saude_id: unidade_saude_ocupacao.unidade_saude_id
        }
      end

      before { get :index, params: }

      it 'returns status code ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns parsed data filtered by profissional_id' do
        expect(response.parsed_body).to include(
          'data' => [serialized_data],
          'meta' => { 'current_page' => 1, 'total_pages' => 1, 'total_count' => 1 }
        )
      end
    end

    context 'when filtering by padrao_agenda_id' do
      let(:params) do
        {
          page: 1,
          per_page: 10,
          padrao_agenda_id: padrao_agenda.id,
          unidade_saude_id: unidade_saude_ocupacao.unidade_saude_id
        }
      end

      before { get :index, params: }

      it 'returns status code ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns parsed data filtered by padrao_agenda_id' do
        expect(response.parsed_body).to include(
          'data' => [serialized_data],
          'meta' => { 'current_page' => 1, 'total_pages' => 1, 'total_count' => 1 }
        )
      end
    end

    context 'when filtering by data_inicial and data_final' do
      let(:params) do
        {
          page: 1,
          per_page: 10,
          data_inicial: '2024-09-01',
          data_final: '2024-09-10',
          unidade_saude_id: unidade_saude_ocupacao.unidade_saude_id
        }
      end

      before { get :index, params: }

      it 'returns status code ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns parsed data filtered by data_inicial and data_final' do
        expect(response.parsed_body).to include(
          'data' => [serialized_data],
          'meta' => { 'current_page' => 1, 'total_pages' => 1, 'total_count' => 1 }
        )
      end
    end

    context 'when filtering by procedimento_id' do
      let(:params) do
        {
          page: 1,
          per_page: 10,
          procedimento_id: procedimento.id,
          unidade_saude_id: unidade_saude_ocupacao.unidade_saude_id
        }
      end

      before { get :index, params: }

      it 'returns status code ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns parsed data filtered by procedimento_id' do
        expect(response.parsed_body).to include(
          'data' => [serialized_data],
          'meta' => { 'current_page' => 1, 'total_pages' => 1, 'total_count' => 1 }
        )
      end
    end

    context 'when filtering by inativo' do
      let(:params) do
        {
          page: 1,
          per_page: 10,
          unidade_saude_id: unidade_saude_ocupacao.unidade_saude_id
        }
      end

      before { get :index, params: }

      it 'returns status code ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns parsed data filtered by inativo' do
        expect(response.parsed_body).to include(
          'data' => [serialized_data],
          'meta' => { 'current_page' => 1, 'total_pages' => 1, 'total_count' => 1 }
        )
      end
    end

    context 'when no agendas match the filters' do
      let(:params) do
        {
          page: 1,
          per_page: 10,
          unidade_saude_id: 0
        }
      end

      before { get :index, params: }

      it 'returns status code ok with empty data' do
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to include(
          'data' => [],
          'meta' => { 'current_page' => 1, 'total_pages' => 1, 'total_count' => 0 }
        )
      end
    end
  end

  describe 'POST #create' do
    include_context 'with an authenticated token'

    let(:valid_params) do
      {
        agenda: {
          unidade_saude_ocupacao_id: 1,
          profissional_id: 1,
          procedimento_id: 1,
          possui_grupo: true,
          possui_equipamento: false,
          dias_agendamento: '2024-09-23',
          local: 'Sala 1',
          regulacao: 'Sim',
          mapa_periodos: [
            { data_inicial: '2024-09-23', data_final: '2024-09-30' }
          ]
        }
      }
    end

    context 'when the service returns success' do
      let(:agenda) { create(:agenda) }

      before do
        allow(Agendas::CreateAgendaService).to receive(:call).and_return(success: agenda)
        post :create, params: valid_params
      end

      it 'returns status 201' do
        expect(response).to have_http_status(:created)
      end
    end
  end

  describe 'PUT #update' do
    include_context 'with an authenticated token'

    let!(:profissional) { create(:profissional) }
    let!(:procedimento) { create(:procedimento) }
    let!(:unidade_saude_ocupacao) { create(:unidade_saude_ocupacao) }
    let!(:padrao_agenda) { create(:padrao_agenda) }
    let!(:equipamento_utilizavel) { create(:equipamento_utilizavel) }

    let!(:agenda) do
      create(
        :agenda,
        profissional:,
        procedimento:,
        unidade_saude_ocupacao:,
        padrao_agenda:,
        equipamento_utilizavel: nil,
        local: true,
        possui_equipamento: false
      )
    end

    let(:params) do
      {
        id: agenda.id,
        profissional_id: create(:profissional).id,
        procedimento_id: create(:procedimento).id,
        unidade_saude_ocupacao_id: create(:unidade_saude_ocupacao).id,
        padrao_agenda_id: create(:padrao_agenda).id,
        equipamento_utilizavel_id: create(:equipamento_utilizavel).id,
        possui_equipamento: true,
        local: false,
        regulacao: true
      }
    end

    context 'when update is successful' do
      let(:serialized_data) { AgendaSerializer.render_as_json(params, view: :edicao_agenda) }

      it 'returns a 200 status code' do
        put(:update, params:)
        expect(response).to have_http_status(:ok)
      end

      it 'updates the agenda with new parameters' do
        put(:update, params:)

        agenda.reload
        expect(agenda.profissional_id).to eq(params[:profissional_id])
        expect(agenda.procedimento_id).to eq(params[:procedimento_id])
        expect(agenda.unidade_saude_ocupacao_id).to eq(params[:unidade_saude_ocupacao_id])
        expect(agenda.padrao_agenda_id).to eq(params[:padrao_agenda_id])
        expect(agenda.equipamento_utilizavel_id).to eq(params[:equipamento_utilizavel_id])
        expect(agenda.possui_equipamento).to eq(params[:possui_equipamento])
        expect(agenda.local).to be(false)
        expect(agenda.regulacao).to be(true)
      end

      it 'returns the updated agenda in the response' do
        put(:update, params:)
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body['data']['id']).to eq(agenda.id)
        expect(response.parsed_body['data']['profissional_id']).to eq(params[:profissional_id])
        expect(response.parsed_body['data']).to include(serialized_data)
      end
    end

    context 'when update with nested parameters is successful' do
      let(:nested_params) do
        { id: agenda.id, agenda: params.except(:id) }
      end

      it 'returns a 200 status code' do
        put(:update, params: nested_params)
        expect(response).to have_http_status(:ok)
      end

      it 'updates the agenda with new parameters' do
        put(:update, params: nested_params)
        agenda.reload
        expect(agenda.profissional_id).to eq(params[:profissional_id])
      end
    end

    context 'when no parameters are changed' do
      let(:unchanged_params) do
        {
          id: agenda.id,
          profissional_id: agenda.profissional_id,
          procedimento_id: agenda.procedimento_id,
          unidade_saude_ocupacao_id: agenda.unidade_saude_ocupacao_id,
          padrao_agenda_id: agenda.padrao_agenda_id,
          local: agenda.local,
          regulacao: agenda.regulacao
        }
      end

      it 'returns a 200 status code without changes' do
        put(:update, params: unchanged_params)
        expect(response).to have_http_status(:ok)
      end

      it 'does not alter any attributes' do
        expect do
          put(:update, params: unchanged_params)
        end.not_to(change { agenda.reload.attributes })
      end

      it 'returns the updated agenda in the response' do
        expect(response.parsed_body['data']).to be_nil
      end
    end

    context 'when update fails' do
      let(:agenda) { create(:agenda) }

      before do
        allow(Agendas::AtualizaAgendaService).to receive(:call).and_return(Failure.new('something went wrong'))

        put :update, params:
      end

      it 'render status 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'return error response' do
        expect(response.parsed_body).to include(
          { code: 422, message: 'something went wrong', status: 'unprocessable_entity' }
        )
      end
    end
  end

  describe 'GET #conflitos' do
    include_context 'with an authenticated token'

    let(:valid_params) do
      { profissional_id: 1, unidade_saude_id: 1, data_inicial: '2024-01-01', data_final: '2024-01-31' }
    end

    context 'when the service call is successful' do
      it 'returns a 200 status' do
        get :conflitos, params: valid_params
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET #tipo_bloqueios' do
    include_context 'with an authenticated token'

    context 'quando existem tipos de bloqueio cadastrado' do
      let!(:tipo_bloqueios) { create_list(:tipo_bloqueio, 2) }
      let(:serialized_data) { TipoBloqueioSerializer.render_as_json(tipo_bloqueios) }

      before do
        get :tipos_bloqueios
      end

      it 'retorna status da resposta 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'retorna tipos de bloqueios' do
        expect(response.parsed_body['data']).to eq(serialized_data)
      end
    end

    context 'quando houve algum problema ocorre' do
      before do
        allow(Agendas::ListarTiposBloqueiosService).to receive(:call).and_return(Failure.new('something went wrong'))

        get :tipos_bloqueios
      end

      it 'retorna status da resposta 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET #pendencias_bloqueios' do
    include_context 'with an authenticated token'

    let(:agenda_id) { 5 }
    let(:valid_params) { { id: agenda_id } }

    before do
      allow(Agendas::ValidaExclusaoService).to receive(:call).with(agenda_id.to_s).and_return(service_response)
    end

    context 'quando há pendências e bloqueios' do
      let(:service_response) { Success.new('false') }

      it 'retorna status 200 e pode_excluir: false' do
        get :pendencias_bloqueios, params: { id: agenda_id }

        expect(response).to have_http_status(:ok)
        json_response = response.parsed_body
        expect(json_response['data']['pode_excluir']).to eq('false')
      end
    end

    context 'quando não há pendências e bloqueios' do
      let(:service_response) { Success.new('true') }

      it 'retorna status 200 e pode_excluir: true' do
        get :pendencias_bloqueios, params: { id: agenda_id }

        expect(response).to have_http_status(:ok)
        json_response = response.parsed_body
        expect(json_response['data']['pode_excluir']).to eq('true')
      end
    end

    context 'quando o serviço retorna um erro' do
      let(:service_response) { { failure: { status: 400, error: 'Erro ao verificar pendências' } } }

      it 'retorna status 400 e a mensagem de erro' do
        get :pendencias_bloqueios, params: { id: agenda_id }

        expect(response).to have_http_status(:bad_request)
        json_response = response.parsed_body
        expect(json_response['message']).to eq('Erro ao verificar pendências')
      end
    end

    context 'quando o serviço retorna um erro 422' do
      let(:service_response) { { failure: { status: 422, error: 'Unprocessable entity' } } }

      it 'retorna status 422 e a mensagem de erro' do
        get :pendencias_bloqueios, params: { id: agenda_id }

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = response.parsed_body
        expect(json_response['message']).to eq('Unprocessable entity')
      end
    end
  end

  describe 'GET /api/unidade_saude/agendas/:id' do
    let(:agenda) { create(:agenda) }

    include_context 'with an authenticated token'

    context 'quando a agenda existe' do
      before do
        allow(UnidadeSaude::Agendas::BuscarAgendaService)
          .to receive(:call)
          .with(agenda.id.to_s)
          .and_return({ success: agenda })

        get :show, params: { id: agenda.id }
      end

      it 'retorna status 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'usa o serializer correto' do
        expect(response.body).to match(AgendaSerializer.render_as_hash(agenda, view: :listagem_agenda).to_json)
      end
    end

    context 'quando não acha a agenda' do
      let(:error_message) { 'Não foi possivel encontrar a agenda com id 999' }

      before do
        allow(UnidadeSaude::Agendas::BuscarAgendaService)
          .to receive(:call)
          .with('999')
          .and_return({ failure: error_message })

        get :show, params: { id: 999 }
      end

      it 'retorna status 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'retorna mensagem de erro' do
        expect(response.parsed_body).to eq({
          'status' => 'unprocessable_entity',
          'code' => 422,
          'message' => error_message
        })
      end
    end
  end

  describe 'GET #mapa_periodo_show' do
    include_context 'with an authenticated token'

    let(:agenda) { create(:agenda) }
    let!(:agenda_mapa_periodo) do
      create(:agenda_mapa_periodo, id: mapa_periodo_id, agenda_id: agenda.id)
    end
    let(:agenda_id) { '1' }
    let(:mapa_periodo_id) { '1' }
    let(:periodo_mock) { instance_double(AgendaPeriodo, id: 1, data_inicial: '2024-10-01', data_final: '2024-10-10') }

    context 'when the service returns success' do
      it 'returns status 200' do
        get :mapa_periodo_show, params: { id: agenda_id, mapa_periodo_id: }

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the service returns failure' do
      let(:error_message) { 'Erro ao obter período' }

      before do
        allow(Agendas::GetMapaPeriodoService).to receive(:call)
          .with(agenda_id.to_s)
          .and_return(failure: error_message)
      end

      it 'returns status 422' do
        get :mapa_periodo_show, params: { id: agenda.id, mapa_periodo_id: agenda_mapa_periodo.id }

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'renders the error message' do
        get :mapa_periodo_show, params: { id: agenda.id, mapa_periodo_id: agenda_mapa_periodo.id }

        expect(response.body).to include(error_message)
      end
    end
  end

  describe 'POST #mapa_periodo_create' do
    include_context 'with an authenticated token'

    let(:agenda) { create(:agenda) }

    context 'when the service runs successfully' do
      let(:valid_params) do
        {
          data_inicial: '2024-09-19',
          data_final: '2024-09-20',
          possui_horario_distribuido: 'false',
          possui_tempo_atendimento_configurado: 'false',
          inativo: false,
          dias_agendamento: 2,
          data_liberacao_agendamento: '2024-09-18',
          tempo_atendimento: {
            nova_consulta: 60,
            retorno: 60,
            reserva_tecnica: 60,
            regulacao: 60,
            regulacao_retorno: 60
          },
          mapa_dias: [
            {
              dia_atendimento_id: 1,
              mapa_horarios: [{
                hora_inicio: '09:00',
                hora_fim: '10:00',
                retorno: 60,
                nova_consulta: 1,
                reserva_tecnica: 1,
                regulacao: 1,
                regulacao_retorno: 1,
                hora_inicio_str: '09:00',
                hora_fim_str: '10:00',
                observacao: 'observacao',
                grupo_atendimento_id: nil
              }]
            }
          ]
        }
      end

      it 'returns a 201 status code' do
        post :mapa_periodo_create, params: { id: agenda.id, mapa_periodo: valid_params }

        expect(response).to have_http_status(:created)
      end
    end

    context 'when the service returns failure' do
      let(:valid_params) do
        {
          data_inicial: '2024-09-19',
          data_final: '2024-09-20',
          possui_horario_distribuido: 'true',
          possui_tempo_atendimento_configurado: 'true',
          inativo: false,
          dias_agendamento: 2,
          data_liberacao_agendamento: '2024-09-18',
          tempo_atendimento: {
            nova_consulta: 60,
            retorno: 60,
            reserva_tecnica: 60,
            regulacao: 60,
            regulacao_retorno: 60
          },
          mapa_dias: [
            {
              dia_atendimento_id: 1,
              mapa_horarios: [{
                hora_inicio: '09:00',
                hora_fim: '10:00',
                retorno: 60,
                nova_consulta: 1,
                reserva_tecnica: 1,
                regulacao: 1,
                regulacao_retorno: 1,
                hora_inicio_str: '09:00',
                hora_fim_str: '10:00',
                observacao: 'observacao',
                grupo_atendimento_id: nil
              }]
            }
          ]
        }
      end

      it 'returns a 422 status code' do
        post :mapa_periodo_create, params: { id: agenda.id, mapa_periodo: valid_params }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET #mapas_periodos' do
    include_context 'with an authenticated token'

    let(:agenda_id) { '1' }
    let(:valid_params) do
      {
        id: agenda_id,

        order: 'data_inicial',
        order_direction: 'ASC'
      }
    end

    let(:periodo_mock) { instance_double(AgendaPeriodo, id: 1, data_inicial: '2024-10-01', data_final: '2024-10-10') }

    context 'when the service returns success' do
      it 'returns status 200' do
        get :mapas_periodos, params: { id: agenda_id }

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the service returns failure' do
      let(:error_message) { 'Erro ao obter períodos' }

      before do
        allow(Agendas::AgendaPeriodosService).to receive(:call)
          .with(agenda_id.to_s, ActionController::Parameters.new(valid_params).permit!)
          .and_return(failure: error_message)
      end

      it 'returns status 422' do
        get :mapas_periodos, params: valid_params

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'renders the error message' do
        get :mapas_periodos, params: valid_params

        expect(response.body).to include(error_message)
      end
    end
  end

  describe 'DELETE #destroy' do
    include_context 'with an authenticated token'

    let!(:agenda) { create(:agenda) }

    context 'quando a exclusão é bem-sucedida' do
      before do
        allow(Agendas::DeletaAgendaService).to receive(:call).with(agenda.id.to_s).and_return(success: nil)
        delete :destroy, params: { id: agenda.id }
      end

      it 'retorna status 204 No Content' do
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'quando a exclusão falha' do
      let(:error_message) { 'Erro ao excluir a agenda' }

      before do
        allow(Agendas::DeletaAgendaService).to receive(:call).with(agenda.id.to_s).and_return(failure: error_message)
        delete :destroy, params: { id: agenda.id }
      end

      it 'retorna status 400 Bad Request' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'retorna a mensagem de erro na resposta' do
        expect(response.parsed_body['message']).to eq(error_message)
      end
    end
  end
end
