#
# .env（hash形式）ファイルの呼び出し
#
module EnvLoader
  # def initialize
  #   Dotenv.load
  # end

  def get_url(env_key)
    Dotenv.load
    ENV[env_key]
  end
end
