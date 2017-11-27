# coding: utf-8
require 'open-uri'
require 'nokogiri'
require 'robotex'
require 'sqlite3'
require "selenium-webdriver"
require "date"

# import classfile
require './selector.rb'
require './save_db_task.rb'

#
# 動画サイト横断検索
#

  @main_url = "https://www.happyon.jp/"

  #
  # URLからパースデータを取得する
  #
  def openURL(url)
    charset = nil
    html = nil
    # user_agent = 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.63 Safari/537.36' # GoogleChrome
    # html = open(url, "User-Agent" => user_agent) do |f|
    html = open(url) do |f|
      charset = f.charset
      f.read
    end
    doc = Nokogiri::HTML.parse(html, nil, charset)
    return doc
  end

  #
  # クロールするサイトの名称を判断する
  #
  def checkSiteName(url)
    if url.include?('happyon')
      @site_name = 'hulu'
    elsif url.include?('netflix')
      @site_name ='netflix'
    elsif url.include?('Prime-Video')
      @site_name = 'amazon_prime'
    elsif url.include?('Amazon')
      @site_name = 'amazon_video'
    elsif url.include?('gyao')
      @site_name = 'gyao'
    elsif url.include?('dmkt')
      @site_name = 'dtv'
    elsif url.include?('unext')
      @site_name = 'unext'
    elsif url.include?('apple iTunes')
      @site_name = 'apple_itunes'
    elsif url.include?('Microsoft')
      @site_name = 'ms_video'
    elsif url.include?('GooglePlay')
      @site_name = 'googleplay'
    elsif url.include?('mubi')
      @site_name = 'mubi'
    else
      @site_name = 'none' # 指定されたURLは取得先として読み込めない
    end
  end

  #
  # 情報取得の項目があるかどうかのチェック
  #
  def checkContentItem(item)
    return item.empty?
  end

  #
  # デバッグ用
  #
  def screenshot(driver)
    file_name = "_screenshot"
    extension = ".png"
    default_dir_path = "/Users/flatba/dev/project_ruby/movieCrossSearch/output/screenshot/"
    driver.save_screenshot default_dir_path + DateTime.now.strftime("%Y%m%d%H%M%S") + file_name + extension
  end

  robotex = Robotex.new
  p robotex.allowed?(@main_url)

  # サイト名称の識別 @site_name にサイト名称格納
  checkSiteName(@main_url)

  # メインページにアクセスしてパースデータを取得する
  main_doc = openURL(@main_url)

  # サイト名称に応じて読み込むセレクターのインスタンスを切り替える
  selector = Selector.new(@site_name)

  # サイト名称に応じてDBのインスタンスを生成する
  # 回す前にバックアップを生成して、更新が終わったらバックアップは削除する処理でも良いかも
  db = SaveDBTask.new(@site_name)

  # 構造体："トップ画像URL", "タイトル", "原題", "公開年", "ジャンル", "時間", "監督", "あらすじ"
  contents = Struct.new(:thumbnail, :title, :original_title, :release_year, :genres, :running_time, :director, :summary)

  # メインページから動画カテゴリ一覧のurlを取得する
  category_url_arr = []
  main_doc.css(selector.selectSelector[:category_selector]).each { |element|
    # puts a_tag.text.strip   # カテゴリ名称
    # puts a_tag.attr('href') # カテゴリURL
    category_url_arr << element.attr('href')
  }

  # 各カテゴリページにアクセスする
  category_url_arr.each do |category_url|

    # HeadressChrome起動
    # 通常起動：driver = Selenium::WebDriver.for :chrome
    caps = Selenium::WebDriver::Remote::Capabilities.chrome("chromeOptions" => {binary: '/Applications/Google Chrome Canary.app/Contents/MacOS/Google Chrome Canary', args: ["--headless", "--disable-gpu",  "window-size=1280x800"]})
    driver = Selenium::WebDriver.for :chrome, desired_capabilities: caps

    # カテゴリトップページにアクセス
    driver.get(category_url)
    screenshot(driver) # デバッグ用
    puts category_url + "にアクセス中..."

    # WebDriverはロードが完了するのを待たないので必要に応じて待ち時間を設定
    driver.manage.timeouts.implicit_wait = 10 # 一括設定

    # "もっと見る"をクリックして、カテゴリ動画一覧ページへ
    button_num = driver.find_elements(:class, 'vod-mod-button').size
    for btn_cnt in 0..button_num

      sleep 10
      screenshot(driver) # デバッグ用
      puts "[もっと見る]をクリック中..."

      # driver_idがページ遷移ごとに変わってしまうのでページが遷移するごとに取得する
      buttons_driver = driver.find_elements(:class, 'vod-mod-button')
      buttons_driver[btn_cnt].click

      screenshot(driver) # デバッグ用
      puts "各動画コンテンツ一覧にアクセス中..."

      # クリックしてアクセスした先のリンクに動画情報がなかったら次のボタンに移る
      unless driver.current_url.include?("tiles") then
        driver.navigate().back()
        sleep 10
        next
      end

      # 動画一覧からコンテンツ内にクリックで入っていく
      contents_num = driver.find_elements(:class, selector.selectSelector[:content_click]).size
      begin
        for content_btn_cnt in 0..contents_num

          # 最後まで読み込んだら前のページに戻る
          if content_btn_cnt == contents_num then
            driver.navigate().back()
            break
          end

          begin
            # driver_idがページ遷移ごとに変わってしまうのでページが遷移するごとに取得する
            contents_driver = driver.find_elements(:class, 'vod-mod-tile__item')
            contents_driver[content_btn_cnt].click

            screenshot(driver) # デバッグ用
            puts "各動画コンテンツにアクセス中..."

          rescue
            next
          end

          # 各動画ページのパースデータを取得する
          content_url = driver.current_url
          content_doc = openURL(content_url)

          screenshot(driver) # デバッグ用

          # パースデータから動画の情報を取得する
          add_contents = contents.new("", "", "", "", "", "", "", "")

          # データが存在しない場合は処理を飛ばす
          # トップ画像
          unless checkContentItem(content_doc.css(selector.selectSelector[:thumbnail]))
            add_contents.thumbnail = content_doc.css(selector.selectSelector[:thumbnail]).attr('src').to_s
          end

          # 映画タイトル
          unless checkContentItem(content_doc.css(selector.selectSelector[:title]).text)
            add_contents.title = content_doc.css(selector.selectSelector[:title]).text
          end

          # 原題
          unless checkContentItem(content_doc.css(selector.selectSelector[:original_title]))
            add_contents.original_title = content_doc.css(selector.selectSelector[:original_title])
          end

          # 公開年
          unless checkContentItem(content_doc.css(selector.selectSelector[:release_year]).text)
            add_contents.release_year = content_doc.css(selector.selectSelector[:release_year]).text
            tail_num = release_year.rindex('年')
            puts release_year = release_year[tail_num-4..tail_num-1]
          end

          # ジャンル # ここ配列のため、DBで文字化けのまま入ってしまう
          # テーブルを切り分けるので、あとで処理を直す必要あり
          unless checkContentItem(insert_contents.content_doc.css(selector.selectSelector[:genre]).children)
            genres = []
            add_contents.content_doc.css(selector.selectSelector[:genre]).children.each do |genre|
              genres.push(genre.text)
            end
            puts genres
          end

          # 上映時間
          unless checkContentItem(content_doc.css(selector.selectSelector[:running_time]).text)
            add_contents.running_time = content_doc.css(selector.selectSelector[:running_time]).text
            # head_num = 0
            # if running_time.rindex('/') > 0
            #   puts "通過"
            #   head_num = running_time.rindex('/')+1
            # end
            # puts tail_num = running_time.rindex('分')
            # puts add_contents.running_time = running_time[head_num..tail_num].strip
          end

          # キャスト
          # テーブルを切り分ける？ので、あとで処理を直す必要あり
          # unless checkContentItem(content_doc.css(selector.selectSelector[:director])[0])
            # casts = []
            # content_doc.css(selector.selectSelector[:director])[0].each do |cast|
            #   casts.push(cast.text)
            # end
            # puts casts
          # end

          # 監督
          # テーブルを切り分ける？ので、あとで処理を直す必要あり
          unless checkContentItem(content_doc.css(selector.selectSelector[:directors])[2].text.gsub("\\n", "").strip)
            # directors = []
            add_contents.directors = content_doc.css(selector.selectSelector[:directors])[2].text.chomp.strip
          end

          # あらすじ
          unless checkContentItem(content_doc.css(selector.selectSelector[:summary]).text)
            add_contents.summary = content_doc.css(selector.selectSelector[:summary]).text
          end

          puts contents

          # DBに保存する（一旦はsqliteで保存する（.db形式））
          @db = db.saveDBTask(contents)

          # コンテンツ情報を収集したら前のページに戻る
          driver.navigate().back()

        end
      rescue
        screenshot(driver) # デバッグ用
        puts "要素がなかったかも"
        puts driver.current_url
        driver.navigate().back()
        sleep 10
        next
      end
    end

    driver.quit    # ブラウザ終了
    db.closeDBTask # データベースの編集終了

  end
