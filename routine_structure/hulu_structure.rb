# coding: utf-8

require "selenium-webdriver"

# import file
require './crawl/selector.rb'
require './crawl/crawl.rb'
require './scrape/scrape.rb'
# require './database/database.rb'
# require './database/save_db_task.rb'

#
# Hulu
#
class HuluStructure

  attr_reader :crawl, :scrape, :driver, :selector, :movie_master

  def initialize(url, site_name)

    @crawl = Crawl.new
    @scrape = Scrape.new
    # @db_task = SaveDBTask.new

    @driver       = @crawl.initialize_driver
    @selector     = @crawl.initialize_selector(site_name)
    @movie_master = @scrape.movie_master
    # @movie_master = @scrape.initialize_movie_master
    # @db           = @db_task.initialize_data_base(site_name)

    start(url, site_name)

  end

  def start(url, site_name)

    # カテゴリURLの取得
    category_url_arr = []
    main_doc = crawl.open_url(url)
    main_doc.css(selector.select_selector[:category_selector]).each do |element|
      # puts a_tag.text.strip   # カテゴリ名称
      # puts a_tag.attr('href') # カテゴリURL
      category_url_arr << element.attr('href')
    end

    begin
    category_url_arr.each do |category_url|

      # [DONE]カテゴリにアクセスする
      puts "カテゴリにアクセスする"
      driver.get(category_url)

      # [DONE]サブカテゴリを取得する（[もっと見る]ボタンを取得する）
      puts "サブカテゴリを取得する"
      more_watch_buttons = driver.find_elements(:class, 'vod-mod-button')

      more_watch_buttons.each do |button_element|

        # [DONE]元ページのウィンドウ情報（ハンドル）を記憶
        puts "元ページのウィンドウ情報（ハンドル）を記憶"
        remenber_current_window_handle = driver.window_handles.last

        # [DONE]サブカテゴリにアクセスする（[もっと見る]ボタンを新規タブで開いて動画一覧のURLを取得する）
        puts "サブカテゴリにアクセスする（[もっと見る]ボタンを新規タブで開いて動画一覧のURLを取得する）"
        # @crawl.send_key_new_tab(button_element)
        button_element.send_keys(:command, :enter)
        sleep 3

        puts "　新規タブにハンドルを移す"
        contents_url = @crawl.change_current_window(driver, button_element)

        # [DONE]クリックしてアクセスした先のリンクに動画情報がなかったら次のボタンに移る
        unless contents_url.include?("tiles") then
          puts "動画コンテンツが無い"
          @crawl.close_new_window(driver, remenber_current_window)
          next
        end

        ###### ここまでで、動画一覧ページ ######

        # 動画一覧を取得する
        sleep 5
#flatba^201712005 細かい情報取得のために一旦コメントアウト
      # crawl.infinit_scroll(driver, 3)
#flatba$
        puts "動画一覧を取得する"
        contents_url_arr = []
        content_elements = driver.find_elements(:css, selector.select_selector[:content_click])
        content_elements.each do |element|
          if element.attribute('href').empty?
            next
          end
          contents_url_arr << element.attribute('href') # URLを取得する
          # category_url_arr << element.find_element(:tag_name, 'a').attribute('href') # URLを取得する
        end
        puts contents_url_arr

        # [DONE]元ページのウィンドウ情報（ハンドル）を記憶
        puts "元ページのウィンドウ情報（ハンドル）を記憶"
        remenber_current_window_handle = driver.window_handles.last

        puts "**********動画コンテンツ情報取得開始**********"
        # content_elements.each do |element|
        contents_url_arr.each do |content_url|

          # puts "現在のタブ情報を保持する"
          # remenber_current_window_handle = driver.window_handles.last

          crawl.open_new_tab_then_move_handle(driver)
          driver.get(content_url)

          puts "映画コンテンツ情報を取得する"
          content_doc = crawl.open_url(content_url)

          puts movie_master_contents = @scrape.create_movie_master_contents(selector, content_doc, @movie_master)
          puts genre_list = @scrape.create_genre_list(selector, content_doc)
          puts director_list = @scrape.create_director_list(selector, content_doc)
          puts cast_list = @scrape.create_cast_list(selector, content_doc)

          #
          # 保存処理(保存とレコードIDの取得)
          #
          # movie_id = db_task.save_movie_master_contents(@db, movie_master_contents)
          # genre_id_list = db_task.save_genre_master_contents(@db, genre_list)
          # director_id_list = db_task.save_director_master_contents(@db, director_list)
          # cast_id_list = db_task.save_cast_master_contents(@db, cast_list)

          # # 中間テーブル処理① movie_genre
          # db_task.save_movie_genre(@db, movie_id, genre_id_list)
          # # 中間テーブル処理② movie_director
          # db_task.save_movie_director(@db, movie_id, director_id_list)
          # # 中間テーブル処理③ movie_cast
          # db_task.save_movie_cast(@db, movie_id, cast_id_list)

          # 新規タブを閉じて元タブにハンドルを戻す
          crawl.close_new_window(driver, remenber_current_window)
          sleep 1

        end

        puts "**********動画コンテンツ情報取得終了**********"

    end

    # @crawl.close(driver, @db)

  end

    rescue RuntimeError => e
      print e.message
      $browser.close
    rescue => e
      print e.message + "\n"
      # @crawl.close(driver, @db)
    end
  end

end
