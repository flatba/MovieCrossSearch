# coding: utf-8

require "selenium-webdriver"

require './crawl/selector.rb'
require './crawl/crawl.rb'
require './scrape/scrape.rb'
# require './database/database.rb'
# require './database/save_db_task.rb'

#
# AmazonPrime
#
class AmazonPrimeStructure

  attr_reader :crawl, :scrape, :driver, :selector, :movie_master

  def initialize(url, site_name)

      @crawl  = Crawl.new
      @scrape = Scrape.new
      # @db_task = SaveDBTask.new

      @driver        = @crawl.initialize_driver
      @selector      = @crawl.initialize_selector(site_name)
      @movie_master  = @scrape.movie_master
      # @movie_master = @scrape.initialize_movie_master # DB処理
      # @db           = @db_task.initialize_data_base(site_name)

      start(url, site_name)

  end

  def start(url, site_name)

      puts "open top page"
      driver.get(url)

      # メインページにアクセスしてパースデータを取得する
      main_doc = crawl.open_url(url)
      category_url_arr = []
      main_doc.css('#nav-subnav > a.nav-a').each do |element|
        category_url_arr << 'https://www.amazon.co.jp' + element.attribute('href')
      end

      # ↑カテゴリーURLの取得まで完了↑

      # [未着手]カテゴリにアクセスして、動画情報を取得する
      category_url_arr.each do |category_url|

        # 新規タブを開く

        # 新規タブでcategory_urlを開く

        # 新規タブを開く

        # 動画コンテンツを開く

        # 情報を取得する

        # 取得したらタブを閉じる

      end

  end

end