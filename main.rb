# coding: utf-8

require 'open-uri'
require 'nokogiri'
require 'robotex'
require "selenium-webdriver"
require "date"
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
      puts "URL is Unknown..."

    end

    puts "処理完了"
  end
end


#
# main routine
#
Dotenv.load
# HULU_URL NETFLIX_URL AMAZON_PRIME_URL AMAZON_VIDEO_URL GYAO_URL DTV_URL UNEXT_URL APPLE_ITUNES_URL MICROSOFT_URL GOOGLEPLAY_URL MUBI_URL
base_url = "APPLE_ITUNES_URL"
# クローラーのインスタンス化
entry = EntryCrawl.new(ENV[base_url])
# サイトのクロール可否のチェック
entry.check_robot(entry.base_url)
# サイト名称を判断し、クローラを開始する
entry.detect_site_name_and_start_crawl(entry.base_url)
