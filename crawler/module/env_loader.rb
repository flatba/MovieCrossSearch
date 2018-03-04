#
# .env（hash形式）ファイルの呼び出し
#
require 'json'
require 'dotenv'

module DataLoader
  # def initialize
  #   Dotenv.load
  # end

  # def env_loader
  #   Dotenv.load
  # end

  def get_url(env_key)
    Dotenv.load
    ENV[env_key]
  end

  def json_loader
    json_file_path = './crawler/selector_data/selector.json'
    File.open(json_file_path) do |file|
      hash = JSON.load(file)
    end
  end
end
