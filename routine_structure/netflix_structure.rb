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

  attr_reader :crawl, :scrape, :driver, :selector, :movie_master

  def initialize(url, site_name)

    @crawl = Crawl.new
    @scrape = Scrape.new
    # @db_task = SaveDBTask.new

    @driver       = @crawl.initialize_driver
    @selector     = @crawl.initialize_selector(site_name)
    @movie_master = @scrape.movie_master
    # @movie_master = @scrape.initialize_movie_master # DB処理
    # @db           = @db_task.initialize_data_base(site_name)

    start(url, site_name)

  end

  # 元ページのウィンドウ情報（ハンドル）を返して新規タブを開く
  def get_current_handle_then_open_new_tab(driver)
      remenber_current_window_handle = driver.window_handles.last
      crawl.open_new_tab_then_move_handle(driver)
      return remenber_current_window_handle
  end

  def start(url, site_name)

    # ログインしてトップページを開く
    crawl.login(url, driver, selector, ENV['NETFLIX_LOGIN_ID'], ENV['NETFLIX_LOGIN_PASSWORD'])

    # トップページにアクセスしてカテゴリURLを取得する
    puts "カテゴリ一覧を取得する"
    category_url_arr = []
    category = driver.find_element(:class, 'tabbed-primary-navigation')
    category.find_elements(:class => 'navigation-tab').each do |element|
      # puts a_tag.text.strip   # カテゴリ名称
      # puts a_tag.attr('href') # カテゴリURL
      category_url_arr << element.find_element(:tag_name, 'a').attribute('href') # URLを取得する
    end
    puts category_url_arr

    # ----------------↑カテゴリーURLの取得まで完了↑-------------

    # カテゴリを開く
    begin
    category_url_arr.each do |category_url|

      # カテゴリではなくホームなので飛ばす
      if category_url === 'https://www.netflix.com/browse'
        next
      end

      remenber_current_window_handle = get_current_handle_then_open_new_tab(driver)
      driver.get(category_url)

      # ジャンルをクリックする
      driver.find_element(:css, '#appMountPoint > div > div > div.pinning-header > div > div.sub-header > div:nth-child(2) > div > div > div.aro-genre-details > div.subgenres > div > div').click

      # ジャンルURLの取得
      genre_url_arr = []
      genre_arr = driver.find_element(:css, '#appMountPoint > div > div > div.pinning-header > div > div.sub-header > div:nth-child(2) > div > div > div.aro-genre-details > div.subgenres > div > div.sub-menu.theme-lakira').find_elements(:tag_name, 'a')
      genre_arr.each do |genre|
        genre_url_arr << genre.attribute('href')
      end
      puts genre_url_arr

      # ジャンルページを開く
      remenber_category_window_handle = get_current_handle_then_open_new_tab(driver)
      genre_url_arr.each do |genre_url|

        driver.get(genre_url)

        # 各ジャンルの動画グループは階層が複雑だが、URIのidのかぶりがある。
        # 別のジャンルに同じidの動画グループがあるので、一度回ったidは記憶しておく必要などして処理を回す必要あり。
        # 基本は全てにアクセスするが、URIのidが同じだったら飛ばす。
        # 時間はかかるが、確実と思う。





        sleep 1
        # 取得処理中はいちいち閉じなくて良いかも。開きっぱなしでURLを開き直す。

      end

      puts "a"
      # TODO(flatba) 深いとこに入っていって動画のみの一覧ページまでアクセスする

      # スクロールで読み込めるコンテンツがある場合スクロールする
      # crawl.infinit_scroll(driver, 3) # 1ページスクロールするごとに sleep 3 させる

      # TODO(flatba): カテゴリにアクセスして、動画情報を取得する

      crawl.close_new_window(driver, remenber_current_window_handle)
      sleep 1

    end

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
