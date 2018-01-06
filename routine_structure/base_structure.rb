# coding: utf-8
#
# 全てのクローラーの親となるルーチン
#
class BaseStructure
  include Crawl

  attr_reader :crawl, :scrape, :driver, :selector, :movie_master

  def initialize(url, site_name)

    # @crawl  = Crawl.new
    @scrape = Scrape.new
    # @db_task = SaveDBTask.new

    @driver        = initialize_driver
    @selector      = initialize_selector(site_name)
    @movie_master  = @scrape.movie_master
    # @movie_master = @scrape.initialize_movie_master # DB処理
    # @db           = @db_task.initialize_data_base(site_name)

    start(url, site_name)

  end

  # サブクラスで必ず実装しておいて欲しい。
  def start(url, site_name)
    raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
  end

end