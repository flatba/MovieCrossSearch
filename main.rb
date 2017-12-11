# coding: utf-8
require 'open-uri'
require 'nokogiri'
require 'robotex'
require 'sqlite3'
require "selenium-webdriver"
require "date"

# import classfile
require './selector.rb'
require './database.rb'
require './save_db_task.rb'
require './crawl.rb'
require './scrape.rb'

#
# 動画サイト横断検索
#
class Entry

  attr_reader :base_url, :site_name, :selector, :db, :driver, :wait, :movie_master, :genre_master, :director_master, :cast_master

  # 初期データの生成
  def initialize(url)

    # クロール可能サイトかどうかチェックする
    robotex = Robotex.new
    p robotex.allowed?(url)

    @base_url = url
    @site_name = ""
    @genre_master    = []
    @director_master = []
    @cast_master     = []

  end

  def initialize_selector(site_name)
    @selector = Selector.new(site_name)
  end

  def initialize_data_base(site_name)
    @db = Database.new(site_name)
  end

  def initialize_movie_master
    @movie_master = Struct.new(:thumbnail, :title, :original_title, :release_year, :running_time, :summary)
  end

  def initialize_driver
    # 通常chrome起動
    @driver = Selenium::WebDriver.for :chrome

    # HeadressChrome起動
    # caps = Selenium::WebDriver::Remote::Capabilities.chrome("chromeOptions" => {binary: '/Applications/Google Chrome Canary.app/Contents/MacOS/Google Chrome Canary', args: ["--headless", "--disable-gpu",  "window-size=1280x800"]})
    # @driver = Selenium::WebDriver.for :chrome, desired_capabilities: caps

  end

  # クロールするサイトの名称を判断する
  def check_site_name(url)
    name = ""
    if url.include?('happyon')
      name = 'hulu'
    elsif url.include?('netflix')
      name ='netflix'
    elsif url.include?('Prime-Video')
      name = 'amazon_prime'
    elsif url.include?('Amazon')
      name = 'amazon_video'
    elsif url.include?('gyao')
      name = 'gyao'
    elsif url.include?('dmkt')
      name = 'dtv'
    elsif url.include?('unext')
      name = 'unext'
    elsif url.include?('apple iTunes')
      name = 'apple_itunes'
    elsif url.include?('Microsoft')
      name = 'ms_video'
    elsif url.include?('GooglePlay')
      name = 'googleplay'
    elsif url.include?('mubi')
      name = 'mubi'
    end
    @site_name = name
  end

end


# ----------------------------------------------------------------------
# main
# ----------------------------------------------------------------------
entry = Entry.new("https://www.happyon.jp/")
entry.check_site_name(entry.base_url)
@selector     = entry.initialize_selector(entry.site_name)
@db           = entry.initialize_data_base(entry.site_name)
@movie_master = entry.initialize_movie_master
@driver       = entry.initialize_driver

db_task = SaveDBTask.new
crawl = Crawl.new
scrape = Scrape.new

# メインページにアクセスしてパースデータを取得する
main_doc = crawl.open_url(entry.base_url)

# [DONE]カテゴリ一覧を取得する
puts "カテゴリ一覧を取得する"
category_url_arr = []
main_doc.css(@selector.select_selector[:category_selector]).each { |element|
  # puts a_tag.text.strip   # カテゴリ名称
  # puts a_tag.attr('href') # カテゴリURL
  category_url_arr << element.attr('href')
}

begin
category_url_arr.each do |category_url|

  # [DONE]カテゴリにアクセスする
  puts "カテゴリにアクセスする"
  @driver.get(category_url)

  # [DONE]サブカテゴリを取得する（[もっと見る]ボタンを取得する）
  puts "サブカテゴリを取得する"
  more_watch_buttons = @driver.find_elements(:class, 'vod-mod-button')

  more_watch_buttons.each do |button_element|

    # [DONE]元ページのウィンドウ情報（ハンドル）を記憶
    puts "元ページのウィンドウ情報（ハンドル）を記憶"
    current_window = @driver.window_handles.last

    # [DONE]サブカテゴリにアクセスする（[もっと見る]ボタンを新規タブで開いて動画一覧のURLを取得する）
    puts "サブカテゴリにアクセスする（[もっと見る]ボタンを新規タブで開いて動画一覧のURLを取得する）"
    crawl.send_key_new_tab(button_element)

    puts "　新規タブにハンドルを移す"
    contents_url = crawl.change_current_window(@driver, button_element)

    # [DONE]クリックしてアクセスした先のリンクに動画情報がなかったら次のボタンに移る
    unless contents_url.include?("tiles") then
      puts "動画コンテンツが無い"
      crawl.close_new_window(@driver, current_window)
      next
    end

    ###### ここまでで、動画一覧ページ ######

    # 動画一覧を取得する
    sleep 5
#flatba^201712005 細かい情報取得のために一旦コメントアウト
    # puts "**********スクロールの開始**********"
    # body_dom_height = crawl.get_body_dom_height(@driver)
    # @driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
    # sleep 5
    # new_body_dom_height = crawl.get_body_dom_height(@driver)
    # cnt = 1
    # while body_dom_height != new_body_dom_height do
    #   body_dom_height = crawl.get_body_dom_height(@driver)
    #   puts '%{cnt}スクロール目' % { cnt: cnt }
    #   @driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
    #   sleep 3 # スクロールがDOMのサイズ取得に追いついてしまって途中までしかスクロールしてない事象ありのためsleep 3秒
    #   new_body_dom_height = crawl.get_body_dom_height(@driver)
    #   cnt += 1
    # end
    # puts "**********スクロールの終了（末端までスクロールした）**********"
#flatba$
    puts "動画一覧を取得する"
    content_elements = @driver.find_elements(:css, @selector.select_selector[:content_click])

    # [DONE]元ページのウィンドウ情報（ハンドル）を記憶
    puts "元ページのウィンドウ情報（ハンドル）を記憶"
    current_window = @driver.window_handles.last

    puts "**********動画コンテンツ情報取得開始**********"
    content_elements.each do |element|

      puts "動画コンテンツのURLを取り出す"
      content_url = element.attribute('href')

      puts "現在のタブ情報を保持する"
      current_window = @driver.window_handles.last

      puts "新規タブを開く"
      @driver.execute_script("window.open()")

      puts "新規タブにハンドルを移す"
      new_window = @driver.window_handles.last
      @driver.switch_to.window(new_window)

      puts "新規タブでリンクを開く"
      @driver.get(content_url)

      puts "　新規タブにハンドルを移す"
      # パースデータの取得
      content_doc = crawl.open_url(content_url)
      # 映画コンテンツ情報

      @movie_master = scrape.create_movie_master_contents(@selector, content_doc, @movie_master)
      puts genre_list = scrape.create_genre_list(@selector, content_doc)
      puts director_list = scrape.create_director_list(@selector, content_doc)
      puts cast_list = scrape.create_cast_list(@selector, content_doc)

      #
      # 保存処理(保存とレコードIDの取得)
      #
      movie_id = db_task.save_movie_master_contents(@db, @movie_master)
      genre_id_list = db_task.save_genre_master_contents(@db, genre_list)
      cast_id_list = db_task.save_director_master_contents(@db, director_list)
      db_task.save_cast_master_contents(@db, cast_list)

      # 中間テーブル処理① movie_genre
      db_task.save_movie_genre(movie_id, genre_id_list)
      # 中間テーブル処理② movie_director
      db_task.save_movie_director(movie_id, director_id_list)
      # 中間テーブル処理③ movie_cast
      db_task.save_movie_cast(movie_id, cast_id_list)


      # 新規タブを閉じて元タブにハンドルを戻す
      crawl.close_new_window(@driver, current_window)

      sleep 1

    end
    puts "**********動画コンテンツ情報取得終了**********"

  end

  crawl.close(@driver, @db)

end

rescue RuntimeError => e
  print e.message
  $browser.close
rescue => e
  print e.message + "\n"
  crawl.close(@driver, @db)
end
