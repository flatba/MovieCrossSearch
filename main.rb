# coding: utf-8

require 'open-uri'
require 'nokogiri'
require 'robotex'
require "selenium-webdriver"
# require 'sqlite3'
require "date"
require 'dotenv'

# Import File
require './scrape/scrape.rb'
# require './database/database.rb'
# require './database/save_db_task.rb'

# Structure File
require './routine_structure/base_structure.rb'
require './routine_structure/hulu_structure.rb'
require './routine_structure/netflix_structure.rb'
require './routine_structure/amazon_prime_structure.rb'
require './routine_structure/amazon_structure.rb'
require './routine_structure/gayo_structure.rb'
require './routine_structure/dtv_structure.rb'
require './routine_structure/apple_itunes_structure.rb'
require './routine_structure/microsoft_structure.rb'
require './routine_structure/googleplay_structure.rb'
require './routine_structure/mubi_structure.rb'


class EntryCrawl

  # attr_reader :base_url, :site_name, :selector, :db, :driver, :wait, :movie_master, :genre_master, :director_master, :cast_master
  attr_reader :base_url, :site_name, :selector, :driver, :wait, :movie_master, :genre_master, :director_master, :cast_master

  # 初期データの生成
  def initialize(url)
    @base_url = url
    @site_name = ""
    @genre_master    = []
    @director_master = []
    @cast_master     = []
  end

  # クロール可能サイトかどうかチェックする
  def check_robot(url)
    robotex = Robotex.new
    p robotex.allowed?(url)
  end

  # クロールするサイトの名称を判断してメインストラクチャーを実行する
  def detect_site_name_and_start_crawl(url)
    if url.include?('happyon')
      @site_name = 'hulu'
      HuluStructure.new(url, @site_name)

    elsif url.include?('netflix')
      @site_name ='netflix'
      NetflixStructure.new(url, @site_name)

    # elsif url.include?('Prime-Video')
    #   @site_name = 'amazon_prime'
    #   AmazonPrimeStructure.new(url, @site_name)

    # elsif url.include?('Amazon')
    #   @site_name = 'amazon_video'
    #   AmazonVideoStructure.new(url, @site_name)

    elsif url.include?('amazon')
      @site_name = 'amazon_prime'
      AmazonPrimeStructure.new(url, @site_name)

    elsif url.include?('gyao')
      @site_name = 'gyao'
      GyaoStructure.new(url, @site_name)

    elsif url.include?('dmkt')
      @site_name = 'dtv'
      DTvStructure.new(url, @site_name)

    elsif url.include?('unext')
      @site_name = 'unext'
      UNextStructure.new(url, @site_name)

    elsif url.include?('apple')
      @site_name = 'apple_itunes'
      AappleiTunesStructure.new(url, @site_name)

    elsif url.include?('microsoft')
      @site_name = 'ms_video'
      MicrosoftStructure.new(url, @site_name)

    elsif url.include?('google')
      @site_name = 'googleplay'
      GooglePlayStructure.new(url, @site_name)

    elsif url.include?('mubi')
      @site_name = 'mubi'
      MubiStructure.new(url, @site_name)

    elsif
      puts "URLエラー"

    end

    puts "処理完了"

  end
end


#
# main
#
Dotenv.load
# HULU_URL NETFLIX_URL AMAZON_PRIME_URL AMAZON_VIDEO_URL GYAO_URL DTV_URL UNEXT_URL APPLE_ITUNES_URL MICROSOFT_URL GOOGLEPLAY_URL MUBI_URL
url = "AMAZON_PRIME_URL"

# クローラーのインスタンス化
entry = EntryCrawl.new(ENV[url])

# サイトのクロール可否のチェック
entry.check_robot(entry.base_url)

# サイト名称を判断し、クローラを開始する
entry.detect_site_name_and_start_crawl(entry.base_url)
