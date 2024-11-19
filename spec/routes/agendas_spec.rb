# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Routes for agendas', type: :routing do
  it 'route GET /api/unidade_saude/agendas/:id to unidade_saude/agendas#show' do
    expect(get: '/api/unidade_saude/agendas/127').to route_to(
      controller: 'api/unidade_saude/agendas',
      action: 'show',
      id: '127'
    )
  end

  it 'route PUT /api/unidade_saude/agendas/:id to unidade_saude/agendas#update' do
    expect(put: '/api/unidade_saude/agendas/222').to route_to(
      controller: 'api/unidade_saude/agendas',
      action: 'update',
      id: '222'
    )
  end

  it 'route PATCH /api/unidade_saude/agendas/:id to unidade_saude/agendas#update' do
    expect(patch: '/api/unidade_saude/agendas/222').to route_to(
      controller: 'api/unidade_saude/agendas',
      action: 'update',
      id: '222'
    )
  end
end
