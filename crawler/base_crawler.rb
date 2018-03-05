#
# 全てのクローラーの親クラス
#
require './crawler/module/selector.rb'
require './crawler/module/control_browser.rb'
require './crawler/module/env_loader.rb'
require './crawler/module/data_loader.rb'
require './scrape/scrape.rb'

class BaseCrawler
  include ControlBrowser
  include DataLoader
  include Selector
  include Scrape

  # attr_reader :site_key, :site_name, :site_url, :crawl, :scrape, :driver, :selector, :movie_master
  attr_reader :site_url, :driver, :selector

  def initialize(site_url, driver, selector)
    # 利用モジュール
    @driver   = driver
    @selector = selector
    @site_url = site_url

    # @movie_master  = movie_master
    # @db_task = SaveDBTask.new
    # @movie_master = @scrape.initialize_movie_master # DB処理
    # @db           = @db_task.initialize_data_base(site_name)
    start
  end

  # サブクラスで必ず実装しておいて欲しい。
  # 各継承先でsuperで呼び出して実行する
  def start
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
