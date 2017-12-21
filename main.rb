# coding: utf-8

require 'open-uri'
require 'nokogiri'
require 'robotex'
# require 'sqlite3'
require "selenium-webdriver"
require "date"
require 'dotenv'

# Import File
# require './entry_crawl.rb'
# require './routine_stracture.rb'
# Structure File
require './routine_structure/hulu_structure.rb'
require './routine_structure/netflix_structure.rb'
require './routine_structure/amazon_prime_structure.rb'
require './routine_structure/amazon_structure.rb'
require './routine_structure/gayo_structure.rb'
require './routine_structure/dtv_structure.rb'
require './routine_structure/apple_music_structure.rb'
require './routine_structure/microsoft_structure.rb'
require './routine_structure/googleplay_structure.rb'
require './routine_structure/mubi_structure.rb'


class EntryCrawl

  # attr_reader :base_url, :site_name, :selector, :db, :driver, :wait, :movie_master, :genre_master, :director_master, :cast_master
  attr_reader :base_url, :site_name, :selector, :driver, :wait, :movie_master, :genre_master, :director_master, :cast_master

   # 初期データの生成
   def initialize(url)

    check_robot(url)

     @base_url = url
     @site_name = ""
     @genre_master    = []
     @director_master = []
     @cast_master     = []

   end

   def check_robot(url)
     # クロール可能サイトかどうかチェックする
     robotex = Robotex.new
     p robotex.allowed?(url)
   end

   def initialize_selector(site_name)
     @selector = Selector.new(site_name)
   end

   # def initialize_data_base(site_name)
   #   @db = Database.new(site_name)
   # end

   def initialize_movie_master
     @movie_master = Struct.new(:thumbnail, :title, :original_title, :release_year, :running_time, :summary)
   end

   def initialize_driver
     # 通常chrome起動
     # @driver = Selenium::WebDriver.for :chrome

     # HeadressChrome起動
     caps = Selenium::WebDriver::Remote::Capabilities.chrome(
       "chromeOptions" => {
         binary: '/Applications/Google Chrome Canary.app/Contents/MacOS/Google Chrome Canary',
         args: ["--headless", "--disable-gpu",  "window-size=1280x800"]
       }
     )
     @driver = Selenium::WebDriver.for :chrome, desired_capabilities: caps

   end

   # クロールするサイトの名称を判断して、
   # メインストラクチャーを実行する
   def detect_site_url(url)
     if url.include?('happyon')
       @site_name = 'hulu'
       hulu_structure = HuluStructure.new
       hulu_structure.start

     elsif url.include?('netflix')
       @site_name ='netflix'
       netflix_structure = HuluStructure.new
       netflix_structure.start

     elsif url.include?('Prime-Video')
       @site_name = 'amazon_prime'
       amazon_prime_structure = HuluStructure.new
       amazon_prime_structure.start

     elsif url.include?('Amazon')
       @site_name = 'amazon_video'
       amazon_video_structure = HuluStructure.new
       amazon_video_structure.start

     elsif url.include?('gyao')
       @site_name = 'gyao'
       gyao_structure = HuluStructure.new
       gyao_structure.start

     elsif url.include?('dmkt')
       @site_name = 'dtv'
       dtv_structure = HuluStructure.new
       dtv_structure.start

     elsif url.include?('unext')
       @site_name = 'unext'
       unext_structure = HuluStructure.new
       unext_structure.start

     elsif url.include?('apple iTunes')
       @site_name = 'apple_itunes'
       apple_itunes_structure = HuluStructure.new
       apple_itunes_structure.start

     elsif url.include?('Microsoft')
       @site_name = 'ms_video'
       ms_video_structure = HuluStructure.new
       ms_video_structure.start

     elsif url.include?('GooglePlay')
       @site_name = 'googleplay'
       googleplay_structure = HuluStructure.new
       googleplay_structure.start

     elsif url.include?('mubi')
       @site_name = 'mubi'
       mubi_structure = HuluStructure.new
       mubi_structure.start

     end
     puts "URLエラー"
   end
end


Dotenv.load
entry = EntryCrawl.new(ENV["HULU_URL"])


entry.site_name









