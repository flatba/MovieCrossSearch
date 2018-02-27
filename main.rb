require 'open-uri'
require 'nokogiri'
require 'robotex'
require 'selenium-webdriver'
require 'date'
require 'dotenv'
# require 'sqlite3'

# Import File
# require './database/database.rb'
# require './database/save_db_task.rb'

# Routine File
require './routine_process/base_routine.rb'
require './routine_process/hulu_routine.rb'
require './routine_process/netflix_routine.rb'
require './routine_process/amazon_prime_routine.rb'
require './routine_process/amazon_routine.rb'
require './routine_process/gayo_routine.rb'
require './routine_process/dtv_routine.rb'
require './routine_process/apple_itunes_routine.rb'
require './routine_process/microsoft_routine.rb'
require './routine_process/googleplay_routine.rb'
require './routine_process/mubi_routine.rb'
require './routine_process/unext_routine.rb'

class EntryCrawl
  attr_reader :site_key, :site_name, :site_base_url, :site_selector, :driver

  def initialize
    site_info        = ask_standard_input
    @site_key        = site_info[:site_key]
    @site_name       = site_info[:site_name]
    @site_base_url   = site_info[:site_url]
    @genre_master    = []
    @director_master = []
    @cast_master     = []
  end

  def run
    check_robot
    # detect_site_name_and_start_crawl
    get_instance
  end

  private

  # Webサイトのrobot.txtを参照してクロール可否のチェック
  def check_robot
    robotex = Robotex.new
    p robotex.allowed?(site_base_url)
  end

  # サイト名称を判断し、クローラを開始する。
  def get_instance
    case site_key
    when 0 then # HULU
      HuluRoutine.new(site_base_url, site_name)
    when 1 then # NETFLIX
      NetflixRoutine.new(site_base_url, site_name)
    when 2 then # AMAZON_PRIME
      AmazonPrimeRoutine.new(site_base_url, site_name)
    when 3 then # AMAZON_VIDEO
      # AmazonVideoRoutine.new(site_base_url, site_name)
      puts '未実装です'
    when 4 then # GYAO
      GyaoRoutine.new(site_base_url, site_name)
    when 5 then # DTV
      DTvRoutine.new(site_base_url, site_name)
    when 6 then # UNEXT
      UNextRoutine.new(site_base_url, site_name)
    when 7 then # APPLE_ITUNES
      AappleiTunesRoutine.new(site_base_url, site_name)
    when 8 then # MICROSOFT
      MicrosoftRoutine.new(site_base_url, site_name)
    when 9 then # GOOGLEPLAY
      GooglePlayRoutine.new(site_base_url, site_name)
    when 10 then # MUBI
      MubiRoutine.new(site_base_url, site_name)
    else
      puts 'URL is Unknown...'
    end
    puts '処理完了'
  end

  # クロールするサイトの選択（標準入力）
  def ask_standard_input
    site_list = {
      0 => 'HULU',
      1 => 'NETFLIX',
      2 => 'AMAZON_PRIME',
      3 => 'AMAZON_VIDEO',
      4 => 'GYAO',
      5 => 'DTV',
      6 => 'UNEXT',
      7 => 'APPLE_ITUNES',
      8 => 'MICROSOFT',
      9 => 'GOOGLEPLAY',
      10 => 'MUBI'
    }

    puts 'クロールしたい動画サイトの番号を入力してください。'
    puts '###########################################################################'
    puts '# 0:Hulu / 1:Netflix / 2:Amazon Prime / 3:Amazon Video / 4:GYAO'
    puts '# 5:DTV / 6:UNEXT / 7:Apple iTunes / 8:Microsoft / 9:GooglePlay / 10:MUBI'
    puts '###########################################################################'

    input = gets.to_i
    site_name = site_list[input]
    env_loader = EnvLoader.new
    { site_key: input, site_name: site_name, site_url: env_loader.get_url(site_name) }
  end
end

# .env（hash形式）ファイルの呼び出し
class EnvLoader
  def initialize
    Dotenv.load
  end

  def get_url(env_key)
    ENV[env_key]
  end
end

#
# main routine
#
entry = EntryCrawl.new
entry.run

# 次にやりたいのは、インスタンスの生成をサイトごとに作らないで内部で処理するようにする