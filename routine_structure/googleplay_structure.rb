# coding: utf-8

require "selenium-webdriver"

require './crawl/selector.rb'
require './crawl/crawl.rb'
require './scrape/scrape.rb'
# require './database/database.rb'
# require './database/save_db_task.rb'

#
#  GooglePlay
#
class GooglePlayStructure

  attr_reader :crawl, :scrape, :driver, :selector, :movie_master

  def initialize(url, site_name)

    @crawl  = Crawl.new
    @scrape = Scrape.new
    # @db_task = SaveDBTask.new

    @driver       = @crawl.initialize_driver
    @selector     = @crawl.initialize_selector(site_name)
    @movie_master = @scrape.movie_master
    # @movie_master = @scrape.initialize_movie_master # DB処理
    # @db           = @db_task.initialize_data_base(site_name)

   start(url, site_name)

  end

  def start(url, site_name)

    # トップページを開く
    driver.get(url)

    # jsを動作させないと情報を取得できなさそうなのでクリックしておく
    driver.find_element(:css, '#action-dropdown-parent-ジャンル').click

    # カテゴリURLの取得
    category_url_arr = []
    category = driver.find_element(:css, '#action-dropdown-children-ジャンル > div > ul').find_elements(:tag_name, 'a')
    category.each do |element|
      category_url_arr << element.attribute('href')
    end
    puts category_url_arr

    # TODO(flatba): カテゴリにアクセスして、動画情報を取得する
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