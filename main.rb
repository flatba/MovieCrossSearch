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

# crawler File
require './crawler/base_crawler.rb'
require './crawler/hulu_crawler.rb'
require './crawler/netflix_crawler.rb'
require './crawler/amazon_prime_crawler.rb'
require './crawler/amazon_crawler.rb'
require './crawler/gayo_crawler.rb'
require './crawler/dtv_crawler.rb'
require './crawler/apple_itunes_crawler.rb'
require './crawler/microsoft_crawler.rb'
require './crawler/googleplay_crawler.rb'
require './crawler/mubi_crawler.rb'
require './crawler/unext_crawler.rb'

class EntryCrawler
  attr_reader :site_key, :site_name, :site_base_url, :site_selector, :driver

  def initialize
    # site_info        = ask_standard_input
    # @site_key        = site_info[:site_key]
    # @site_name       = site_info[:site_name]
    # @site_base_url   = site_info[:site_url]
    @genre_master    = []
    @director_master = []
    @cast_master     = []
  end

  def run
    @crawler = BaseCrawler.new
  end
end

#
# main Crawler
#
entry = EntryCrawler.new
entry.run
