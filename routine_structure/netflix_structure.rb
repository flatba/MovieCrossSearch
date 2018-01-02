# coding: utf-8

require "selenium-webdriver"
require 'mechanize'

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
      category_url_arr << element.find_element(:tag_name, 'a').attribute('href')
    }
    puts category_url_arr


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


    begin
      category_url_arr.each do |category_url|

        # カテゴリにアクセスする
        puts "カテゴリにアクセスする"
        @netflix_driver.get(category_url)

        # サブカテゴリを取得する（[もっと見る]ボタンを取得する）
        puts "サブカテゴリを取得する"
        more_watch_buttons = @hulu_driver.find_elements(:class, 'vod-mod-button')

        more_watch_buttons.each do |button_element|

          # 元ページのウィンドウ情報（ハンドル）を記憶
          puts "元ページのウィンドウ情報（ハンドル）を記憶"
          current_window = @hulu_driver.window_handles.last

          # サブカテゴリにアクセスする（[もっと見る]ボタンを新規タブで開いて動画一覧のURLを取得する）
          puts "サブカテゴリにアクセスする（[もっと見る]ボタンを新規タブで開いて動画一覧のURLを取得する）"
          # @crawl.send_key_new_tab(button_element)
          button_element.send_keys(:command, :enter)
          sleep 3

          puts "　新規タブにハンドルを移す"
          contents_url = @crawl.change_current_window(@hulu_driver, button_element)

          # クリックしてアクセスした先のリンクに動画情報がなかったら次のボタンに移る
          unless contents_url.include?("tiles") then
            puts "動画コンテンツが無い"
            @crawl.close_new_window(@hulu_driver, current_window)
            next
          end

          ###### ここまでで、動画一覧ページ ######

          # 動画一覧を取得する
          sleep 5
  # netflixページ内での処理なので、中の様子に寄って残す残さないを精査する
  #flatba^201712005 細かい情報取得のために一旦コメントアウト
          # puts "**********スクロールの開始**********"
          # body_dom_height = @crawl.get_body_dom_height(@hulu_driver)
          # @hulu_driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
          # sleep 5
          # new_body_dom_height = @crawl.get_body_dom_height(@hulu_driver)
          # cnt = 1
          # while body_dom_height != new_body_dom_height do
          #   body_dom_height = @crawl.get_body_dom_height(@hulu_driver)
          #   puts '%{cnt}スクロール目' % { cnt: cnt }
          #   @hulu_driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
          #   sleep 3 # スクロールがDOMのサイズ取得に追いついてしまって途中までしかスクロールしてない事象ありのためsleep 3秒
          #   new_body_dom_height = @crawl.get_body_dom_height(@hulu_driver)
          #   cnt += 1
          # end
          # puts "**********スクロールの終了（末端までスクロールした）**********"
  #flatba$
          puts "動画一覧を取得する"
          content_elements = @hulu_driver.find_elements(:css, @selector.select_selector[:content_click])

          # 元ページのウィンドウ情報（ハンドル）を記憶
          puts "元ページのウィンドウ情報（ハンドル）を記憶"
          current_window = @hulu_driver.window_handles.last

          puts "**********動画コンテンツ情報取得開始**********"
          content_elements.each do |element|

            puts "動画コンテンツのURLを取り出す"
            content_url = element.attribute('href')

            puts "現在のタブ情報を保持する"
            current_window = @hulu_driver.window_handles.last

            puts "新規タブを開く"
            @hulu_driver.execute_script("window.open()")

            puts "新規タブにハンドルを移す"
            new_window = @hulu_driver.window_handles.last
            @hulu_driver.switch_to.window(new_window)

            puts "新規タブでリンクを開く"
            @hulu_driver.get(content_url)

            puts "　新規タブにハンドルを移す"
            # パースデータの取得
            content_doc = @crawl.open_url(content_url)
            # 映画コンテンツ情報

            puts movie_master_contents = @scrape.create_movie_master_contents(@selector, content_doc, @movie_master)
            puts genre_list = @scrape.create_genre_list(@selector, content_doc)
            puts director_list = @scrape.create_director_list(@selector, content_doc)
            puts cast_list = @scrape.create_cast_list(@selector, content_doc)

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
            @crawl.close_new_window(@hulu_driver, current_window)

            sleep 1

          end
          puts "**********動画コンテンツ情報取得終了**********"

        end

        # @crawl.close(@hulu_driver, @db)

      end
    rescue RuntimeError => e
      print e.message
      $browser.close
    rescue => e
      print e.message + "\n"
      # @crawl.close(@hulu_driver, @db)
    end
  end

end
