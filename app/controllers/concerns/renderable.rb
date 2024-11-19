# frozen_string_literal: true

module Renderable
  extend ActiveSupport::Concern

  def render_200(data, meta: nil)
    render json: {
      data:
    }.tap { |hash|
      hash[:meta] = meta if meta
    }, status: :ok
  end

  def render_201(data)
    render json: {
      data:
    }, status: :created
  end

  def render_204
    head :no_content
  end

  def render_400(error)
    render json: {
      status: 'bad_request',
      code: 400,
      message: error
    }, status: :bad_request
  end

  def render_403
    render json: {
      status: 'forbidden',
      code: 403,
      message: 'O usuário não tem permissão para acessar este recurso'
    }, status: :forbidden
  end

  def render_404(error)
    render json: {
      status: 'not_found',
      code: 404,
      message: error
    }, status: :not_found
  end

  def render_412(error)
    render json: {
      status: 'precondition_failed',
      code: 412,
      message: error
    }, status: :precondition_failed
  end

  def render_422(error)
    render json: {
      status: 'unprocessable_entity',
      code: 422,
      message: error
    }, status: :unprocessable_entity
  end

  def render_500(error)
    render json: {
      status: 'internal_server_error',
      code: 500,
      message: error
    }, status: :internal_server_error
  end
end
