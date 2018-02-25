#
# 全てのクローラーの親となるルーチン
#
require './crawl/crawl.rb'
require './crawl/selector.rb'
require './crawl/control_browser.rb'
require './scrape/scrape.rb'

class BaseRoutine
  include Crawl
  include ControlBrowser
  include Scrape

  attr_reader :url, :crawl, :scrape, :driver, :selector, :movie_master

  def initialize(url, site_name)
    # TODO(flatba): urlのチェックを入れて識別できるURLかを判断する
    @url           = url
    @driver        = initialize_driver
    @selector      = initialize_selector(site_name)
    @movie_master  = movie_master
    # @db_task = SaveDBTask.new
    # @movie_master = @scrape.initialize_movie_master # DB処理
    # @db           = @db_task.initialize_data_base(site_name)
    start
  end

  # サブクラスで必ず実装しておいて欲しい。
  # 各継承先でsuperで呼び出して実行する
  def start
    driver.get(url)
  end

  def get_category_list
    # raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
  end

  def get_contents_list
    # raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
  end
end
