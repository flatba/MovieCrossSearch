# coding: utf-8

require "selenium-webdriver"

require './crawl/selector.rb'
require './crawl/crawl.rb'
require './scrape/scrape.rb'
# require './database/database.rb'
# require './database/save_db_task.rb'

#
# AappleiTunes
#
class AappleiTunesStructure

  attr_reader :crawl, :scrape, :driver, :selector, :movie_master

  def initialize(url, site_name)

    @crawl  = Crawl.new
    @scrape = Scrape.new
    # @db_task = SaveDBTask.new

    @driver         = @crawl.initialize_driver
    @selector       = @crawl.initialize_selector(site_name)
    @movie_master   = @scrape.movie_master
    # @movie_master = @scrape.initialize_movie_master # DB処理
    # @db           = @db_task.initialize_data_base(site_name)

   start(url, site_name)

  end

  def start(url, site_name)

    # トップページを開く
    driver.get(url)

    # トップページにアクセスしてカテゴリURLを取得する
    puts "カテゴリ一覧を取得する"
    category_url_arr = []
    category = driver.find_element(:css, '#genre-nav > div').find_element(:class, 'list').find_elements(:tag_name, 'a')
    category.each do |element|
      url = element.attribute('href')
      category_url_arr << url
    end

    # 各動画情報の取得
    # ...

  end

end