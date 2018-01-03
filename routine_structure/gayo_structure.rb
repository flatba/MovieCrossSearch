# coding: utf-8

require "selenium-webdriver"

require './crawl/selector.rb'
require './crawl/crawl.rb'
require './scrape/scrape.rb'
# require './database/database.rb'
# require './database/save_db_task.rb'

#
# GYAO
#
class GyaoStructure

 attr_reader :crawl, :scrape

 def initialize
   @crawl  = Crawl.new
   @scrape = Scrape.new
   # @db_task = SaveDBTask.new
 end

 def start(url, site_name)
    @driver        = crawl.initialize_driver
    @selector      = crawl.initialize_selector(site_name)
    @movie_master  = scrape.movie_master
    # @movie_master = @scrape.initialize_movie_master # DB処理
    # @db           = @db_task.initialize_data_base(site_name)

    puts "open top page"
    @driver.get(url)

    puts "get category url"
    category_url_arr = []
    @driver.find_elements(:css, '#new_topNav > ul > li').each do |element|
      category_url = element.find_element(:tag_name, 'a').attribute('href')
      category_url_arr << category_url
    end
    puts category_url_arr

    # ↑カテゴリーURLの取得まで完了↑



    # ...


 end

end