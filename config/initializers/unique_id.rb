# Algumas tabelas não tem ID incremental e criam um ID único
class ActiveRecord::Base
  def gerar_id_unico
    timestamp = Time.now.strftime("%Y%m%d%H%M%S%L%9N")
    random = rand(99).to_s.rjust(2, "0")

    self.id = Zlib::crc32("#{timestamp}#{random}")
  end
end
