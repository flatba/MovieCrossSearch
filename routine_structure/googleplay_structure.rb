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

  def initialize

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

    # [未着手]
    # ...


  end

end