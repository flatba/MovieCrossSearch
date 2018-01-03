# coding: utf-8

require "selenium-webdriver"

require './crawl/selector.rb'
require './crawl/crawl.rb'
require './scrape/scrape.rb'
# require './database/database.rb'
# require './database/save_db_task.rb'

#
# DTV
#
class DTvStructure

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

      puts "get category url"
      category_url_arr = []
      category = driver.find_elements(:class, 'sitemap_content')

      # ジャンル別／50音順／作品種別の内、ジャンル別のみ取得するので[0]指定
      category[0].find_element(:class => 'sitemap_list').find_elements(:tag_name, 'a').each do |element|
        category_url = element.attribute('href')
        category_url_arr << category_url
      end
      puts category_url_arr

      # ↑カテゴリーURLの取得まで完了↑

      # [未着手] 動画情報の取得
      # ...


  end

end