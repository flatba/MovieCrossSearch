require 'open-uri'
require 'nokogiri'
require 'robotex'
require 'selenium-webdriver'
require 'date'

# require 'sqlite3'

# Import File
# require './database/database.rb'
# require './database/save_db_task.rb'

# crawler File
require './crawler/base_crawler.rb'
require './crawler/hulu_crawler.rb'
require './crawler/netflix_crawler.rb'
require './crawler/amazon_prime_crawler.rb'
require './crawler/amazon_video_crawler.rb'
require './crawler/gayo_crawler.rb'
require './crawler/dtv_crawler.rb'
require './crawler/apple_itunes_crawler.rb'
require './crawler/microsoft_crawler.rb'
require './crawler/googleplay_crawler.rb'
require './crawler/mubi_crawler.rb'
require './crawler/unext_crawler.rb'

class EntryCrawler
  include DataLoader
  # attr_reader :site_key, :site_name, :site_url, :crawl, :scrape, :driver, :selector
  attr_reader :site_key, :site_name, :site_url, :crawler

  def initialize
    # サイト情報
    site_info   = ask_standard_input
    @site_key   = site_info[:site_key]
    @site_name  = site_info[:site_name]
    @site_url   = site_info[:site_url]

    # @selector   = initialize_selector
    @genre_master    = []
    @director_master = []
    @cast_master     = []
  end

  def run
    check_robot
    @crawler = initialize_crawler_instance
    # driver.get(site_url)
  end

  private

  # Webサイトのrobot.txtを参照してクロール可否のチェック
  def check_robot
    robotex = Robotex.new
    if robotex.allowed?(site_url)
      puts 'クロールが許可されたサイト'
    else
      puts 'クロールが許可されていないサイト'
    end
    puts site_url
  end

  def initialize_driver
    # 通常chrome起動
    Selenium::WebDriver.for :chrome

    # HeadressChrome起動
    # caps = Selenium::WebDriver::Remote::Capabilities.chrome(
    #   "chromeOptions" => {
    #     binary: '/Applications/Google Chrome Canary.app/Contents/MacOS/Google Chrome Canary',
    #     args: ["--headless", "--disable-gpu",  "window-size=1280x800"]
    #   }
    # )
    # Selenium::WebDriver.for :chrome, desired_capabilities: caps
  end

  def initialize_selector
    # setup_selector(site_name)
    selector_hash_data = json_loader
    selector_list = selector_hash_data['website']
    selector = selector_list[site_name]

    # TODO(flatba): 直したい。valueにサイト名が含まれているので、JSONの作りを変更する。
    # selector_list.each do |key|
    #   if key.equal?(site_name)
    #     selector = value
    #   end
    # end
  end

  def initialize_crawler_instance
    case site_key
    when 0 then # HULU
      HuluCrawler.new(site_url, initialize_driver, initialize_selector)
    when 1 then # NETFLIX
      NetflixCrawler.new(site_url, initialize_driver, initialize_selector)
    when 2 then # AMAZON_PRIME
      AmazonPrimeCrawler.new(site_url, initialize_driver, initialize_selector)
    when 3 then # AMAZON_VIDEO
      AmazonVideoCrawler.new(site_url, initialize_driver, initialize_selector)
    when 4 then # GYAO
      GyaoCrawler.new(site_url, initialize_driver, initialize_selector)
    when 5 then # DTV
      DTvCrawler.new(site_url, initialize_driver, initialize_selector)
    when 6 then # UNEXT
      UNextCrawler.new(site_url, initialize_driver, initialize_selector)
    when 7 then # APPLE_ITUNES
      AappleiTunesCrawler.new(site_url, initialize_driver, initialize_selector)
    when 8 then # MICROSOFT
      MicrosoftCrawler.new(site_url, initialize_driver, initialize_selector)
    when 9 then # GOOGLEPLAY
      GooglePlayCrawler.new(site_url, initialize_driver, initialize_selector)
    when 10 then # MUBI
      MubiCrawler.new(site_url, initialize_driver, initialize_selector)
    else
      puts 'URL is Unknown...'
    end
    puts '処理完了'
  end

  # クロールするサイトの選択（標準入力）
  def ask_standard_input
    site_list = {
      0 => 'HULU',
      1 => 'NETFLIX',
      2 => 'AMAZON_PRIME',
      3 => 'AMAZON_VIDEO',
      4 => 'GYAO',
      5 => 'DTV',
      6 => 'UNEXT',
      7 => 'APPLE_ITUNES',
      8 => 'MICROSOFT',
      9 => 'GOOGLEPLAY',
      10 => 'MUBI'
    }
    print_first_question

    # input = gets.to_i # 標準入力
    input = 1
    site_name = site_list[input]
    site_url = get_url(site_name)
    { site_key: input, site_name: site_name, site_url: site_url }
  end

  def print_first_question
    puts 'クロールしたい動画サイトの番号を入力してください。'
    puts '###########################################################################'
    puts '# 0:Hulu / 1:Netflix / 2:Amazon Prime / 3:Amazon Video / 4:GYAO'
    puts '# 5:DTV / 6:UNEXT / 7:Apple iTunes / 8:Microsoft / 9:GooglePlay / 10:MUBI'
    puts '###########################################################################'
  end
end
