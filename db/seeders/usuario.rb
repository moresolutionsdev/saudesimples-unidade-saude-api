user = {
  "administrador":false,
  "administrador_cnes":false,
  "certificado_content_type":nil,
  "certificado_file_name":nil,
  "certificado_file_size":nil,
  "certificado_hash":nil,
  "certificado_pin":nil,
  "certificado_tipo":nil,
  "certificado_updated_at":nil,
  "created_at":"2024-05-23T09:03:59-03:00",
  "deleted_at":nil,
  "edita_regulacao":false,
  "email":"bossabox@om30tech.com.br",
  "equipe_sad":false,
  "exibir_alerta":true,
  "farmaceutico_responsavel_unidades_saude":false,
  # "gerenciar_personalizacoes_prontuario":false,
  "id":4293178047,
  "inativo":false,
  # "lembrete_administrativo":false,
  "login":"bossabox",
  "password_changed_at":"2024-05-23T09:03:59-03:00",
  "permite_aprovar_requisicao":false,
  "permite_confirmar_cancelar_regulacao":false,
  "profissional_id":4284195514,
  "regulador":false,
  "restrito_relatorio_saldos":false,
  "tipo_acesso_estoque_id":1,
  "tipo_acesso_id":11,
  "tipo_permissao_id":2,
  "updated_at":"2024-05-24T23:57:22-03:00"
}

begin
  Usuario.create_with(user).find_or_create_by(login: user[:login])

  puts "Dados de 'usuario' carregados com sucesso!".colorize(:green)
rescue => error
  puts "==============================================".colorize(:red)
  puts "#{error.inspect}".colorize(:yellow)
  puts "==============================================".colorize(:red)
  puts "Não foi possível carregar dados de 'usuario'".colorize(:yellow)
end
