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
  attr_reader :base_url, :site_name, :selector, :driver

  def initialize
    key = ask_standard_input
    env = LoadEnv.new(key)
    @base_url = env.base_url
    @site_name = ""
    @genre_master    = []
    @director_master = []
    @cast_master     = []
  end

  def run
    check_robot(base_url)
    detect_site_name_and_start_crawl(base_url)
  end

  private

  # Webサイトのrobot.txtを参照してクロール可否のチェック
  def check_robot(url)
    robotex = Robotex.new
    p robotex.allowed?(url)
  end

  # クロールするサイトの名称を判断してメインストラクチャーを実行する
  # サイト名称を判断し、クローラを開始する
  def detect_site_name_and_start_crawl(url)
    if url.include?('happyon')
      @site_name = 'hulu'
      HuluRoutine.new(url, @site_name)

    elsif url.include?('netflix')
      @site_name ='netflix'
      NetflixRoutine.new(url, @site_name)

# flatba^ 2017/01/08 一つにまとめられそうなので、一旦コメントアウトする
    # elsif url.include?('Prime-Video')
    #   @site_name = 'amazon_prime'
    #   AmazonPrimeRoutine.new(url, @site_name)

    # elsif url.include?('Amazon')
    #   @site_name = 'amazon_video'
    #   AmazonVideoRoutine.new(url, @site_name)
    elsif url.include?('amazon')
      @site_name = 'amazon_prime'
      AmazonPrimeRoutine.new(url, @site_name)
# flatba$

    elsif url.include?('gyao')
      @site_name = 'gyao'
      GyaoRoutine.new(url, @site_name)

    elsif url.include?('dmkt')
      @site_name = 'dtv'
      DTvRoutine.new(url, @site_name)

    elsif url.include?('unext')
      @site_name = 'unext'
      UNextRoutine.new(url, @site_name)

    elsif url.include?('apple')
      @site_name = 'apple_itunes'
      AappleiTunesRoutine.new(url, @site_name)

    elsif url.include?('microsoft')
      @site_name = 'ms_video'
      MicrosoftRoutine.new(url, @site_name)

    elsif url.include?('google')
      @site_name = 'googleplay'
      GooglePlayRoutine.new(url, @site_name)

    elsif url.include?('mubi')
      @site_name = 'mubi'
      MubiRoutine.new(url, @site_name)

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
    puts 'クロールしたいサイトの番号を入力してください。'
    puts '###########################################################################'
    puts '# 0:HULU / 1:NETFLIX / 2:AMAZON_PRIME / 3:AMAZON_VIDEO / 4:GYAO'
    puts '# 5:DTV / 6:UNEXT / 7:APPLE_ITUNES / 8:MICROSOFT / 9:GOOGLEPLAY / 10:MUBI'
    puts '###########################################################################'
    input = gets
    site_list[input.to_i]
  end
end

# .env（hash形式）ファイルの呼び出し
class LoadEnv
  attr_reader :base_url
  def initialize(env_key)
    Dotenv.load
    @base_url = ENV[env_key]
  end
end

#
# main routine
# key listのkeyを切り替えると
#
entry = EntryCrawl.new
entry.run

# 次にやりたいのは、インスタンスの生成ををサイトごとに作らないで内部で処理するようにする