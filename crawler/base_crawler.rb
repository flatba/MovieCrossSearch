#
# 全てのクローラーの親クラス
#
require './crawler/module/selector.rb'
require './crawler/module/control_browser.rb'
require './crawler/module/env_loader.rb'
require './scrape/scrape.rb'

class BaseCrawler
  include ControlBrowser
  include EnvLoader
  include Selector
  include Scrape

  attr_reader :site_key, :site_name, :site_url, :crawl, :scrape, :driver, :selector, :movie_master

  def initialize
    # サイト情報
    site_info   = ask_standard_input
    @site_key   = site_info[:site_key]
    @site_name  = site_info[:site_name]
    @site_url   = site_info[:site_url]

    # 利用モジュール
    @driver     = initialize_driver
    @selector   = initialize_selector
    # @movie_master  = movie_master
    # @db_task = SaveDBTask.new
    # @movie_master = @scrape.initialize_movie_master # DB処理
    # @db           = @db_task.initialize_data_base(site_name)
  end

  # サブクラスで必ず実装しておいて欲しい。
  # 各継承先でsuperで呼び出して実行する
  def run
    check_robot
    driver.get(site_url)
  end

  def get_category_list
    # raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
  end

  def get_contents_list
    # raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
  end

  def save_content_item
    # raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
  end

  private

  # Webサイトのrobot.txtを参照してクロール可否のチェック
  def check_robot
    robotex = Robotex.new
    p robotex.allowed?(site_url)
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
    setup_selector(site_name)
  end

  def initialize_crawler_instance
    case site_key
    when 0 then # HULU
      HuluCrawler.new
    when 1 then # NETFLIX
      NetflixCrawler.new
    when 2 then # AMAZON_PRIME
      AmazonPrimeCrawler.new
    when 3 then # AMAZON_VIDEO
      # AmazonVideoCrawler.new
      puts '未実装です'
    when 4 then # GYAO
      GyaoCrawler.new
    when 5 then # DTV
      DTvCrawler.new
    when 6 then # UNEXT
      UNextCrawler.new
    when 7 then # APPLE_ITUNES
      AappleiTunesCrawler.new
    when 8 then # MICROSOFT
      MicrosoftCrawler.new
    when 9 then # GOOGLEPLAY
      GooglePlayCrawler.new
    when 10 then # MUBI
      MubiCrawler.new
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
    input = 0
    site_name = site_list[input]
    { site_key: input, site_name: site_name, site_url: get_url(site_name) }
  end

  def print_first_question
    puts 'クロールしたい動画サイトの番号を入力してください。'
    puts '###########################################################################'
    puts '# 0:Hulu / 1:Netflix / 2:Amazon Prime / 3:Amazon Video / 4:GYAO'
    puts '# 5:DTV / 6:UNEXT / 7:Apple iTunes / 8:Microsoft / 9:GooglePlay / 10:MUBI'
    puts '###########################################################################'
  end

  # URLからパースデータを取得する
  def open_url(url)
    charset = nil
    # html = nil
    # GoogleChrome
    user_agent = 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.63 Safari/537.36'
    html = open(url, 'User-Agent' => user_agent) do |f|
      charset = f.charset
      f.read
    end
    Nokogiri::HTML.parse(html, nil, charset)
  end
end
