# coding: utf-8

require "selenium-webdriver"

require './crawl/selector.rb'
require './crawl/crawl.rb'
require './scrape/scrape.rb'
# require './database/database.rb'
# require './database/save_db_task.rb'

#
# Netflix
#
class NetflixStructure

  attr_reader :crawl, :scrape

  def initialize
    @crawl = Crawl.new
    @scrape = Scrape.new
    # @db_task = SaveDBTask.new
  end

  def start(url, site_name)

    @netflix_driver  = crawl.initialize_driver
    @selector     = @crawl.initialize_selector(site_name)
    @movie_master = scrape.movie_master
    # @movie_master = @scrape.initialize_movie_master # DB処理
    # @db           = @db_task.initialize_data_base(site_name)

    # ログインしてトップページを開く
    crawl.login(url, @netflix_driver, @selector)

    # トップページにアクセスしてカテゴリURLを取得する
    puts "カテゴリ一覧を取得する"
    category_url_arr = []
    category = @netflix_driver.find_element(:class, 'tabbed-primary-navigation')
    category.find_elements(:class => 'navigation-tab').each { |element|
      # puts a_tag.text.strip   # カテゴリ名称
      # puts a_tag.attr('href') # カテゴリURL
      category_url_arr << element.find_element(:tag_name, 'a').attribute('href') # URLを取得する
      # category_url_arr << element
    }

    begin
    # カテゴリを開く
    category_url_arr.each { |category_url|

      puts "元ページのウィンドウ情報（ハンドル）を記憶"
      current_window = @netflix_driver.window_handles.last

      crawl.open_new_window(@netflix_driver, category_url)

      # 次は、深いとこに入っていって、動画のみの一覧ページまでアクセスする。

      # 動画情報の取得は未着手

      crawl.close_new_window(@netflix_driver, current_window)
      sleep 1

    }

    # ここのクロールで重要なのが、おそらく重複してデータを取得してしまう事があると思う。
    # ので、重複した場合に追加しない処理を入れないといけない。
    # ただ、アクセスの負荷を検知されないか不安あり。

    # ログイン後のトップページからの処理
      # TV番組／映画／オリジナル作品のカテゴリのURLを取得する
        # TV番組のジャンルを取得する
          # 各ジャンルにアクセスする
            # 見出しごとにアクセスして深い階層に入っていく
            # [Netflixで人気の作品]は飛ばす？
              #

        # 映画のジャンルを取得する
          # 各ジャンルにアクセスする
            # [Netflixで人気の作品]は飛ばす？

        # オリジナル作品
          # 見出しごとにアクセスする

    rescue RuntimeError => e
      print e.message
      $browser.close
    rescue => e
      print e.message + "\n"
      # @crawl.close(@hulu_driver, @db)
    end
  end

end
