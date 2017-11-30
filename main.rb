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

class Main

  # 初期データの生成
  def initialize

  end

  # URLからパースデータを取得する
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

  # クロールするサイトの名称を判断する
  def checkSiteName(url)
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
    return name
  end

  # ログイン処理
  def login

  end

  # クローズ処理
  def close(driver, db)
    driver.quit    # ブラウザ終了
    db.closeDBTask # データベースの編集終了
  end


  #
  # 情報収集処理
  #

  # 情報を取得してcontents（構造体）に入れて返す
  def newContents(selector, doc, contents)
    # パースデータから動画の情報を取得する
    contents = contents.new("", "", "", "", "", "", "", "")

    # データが存在しない場合は処理を飛ばす
    # トップ画像
    unless checkContentsItem(doc.css(selector.selectSelector[:thumbnail]))
      puts contents.thumbnail = doc.css(selector.selectSelector[:thumbnail]).attr('src').to_s
    end

    # 映画タイトル
    unless checkContentsItem(doc.css(selector.selectSelector[:title]).text)
      puts add_contents.title = doc.css(selector.selectSelector[:title]).text
    end

    # 原題
    # screenshot(@driver) # デバッグ用
    # unless checkContentsItem(doc.css(@selector.selectSelector[:original_title]))
    #   puts contents.original_title = doc.css(@selector.selectSelector[:original_title])
    # end

    # 公開年
    unless checkContentsItem(doc.css(selector.selectSelector[:release_year]).text)
      release_year_tmp = doc.css(selector.selectSelector[:release_year]).text
      tail_num = release_year_tmp.rindex('年')
      puts contents.release_year = release_year_tmp[tail_num-4..tail_num-1]
    end

    # ジャンル <= ここ複数項目のためテーブルを切り分けるので、あとで処理を直す必要あり
    # unless checkContentsItem(insert_contents.doc.css(@selector.selectSelector[:genre]).children)
      # genres = []
      # contents.doc.css(@selector.selectSelector[:genre]).children.each do |genre|
      #   genres.push(genre.text)
      # end
      # puts genres
    # end

    # 上映時間
    unless checkContentsItem(doc.css(selector.selectSelector[:running_time]).text)
      running_time_tmp = doc.css(selector.selectSelector[:running_time]).text
      tail_num = running_time_tmp.rindex('分')
      puts contents.running_time = running_time_tmp[tail_num-3..tail_num].strip
    end

    # キャスト <= ここ複数項目のためテーブルを切り分けるので、あとで処理を直す必要あり
    # unless checkContentsItem(doc.css(@selector.selectSelector[:director])[0])
      # casts = []
      # doc.css(@selector.selectSelector[:director])[0].each do |cast|
      #   casts.push(cast.text)
      # end
      # puts casts
    # end

    # 監督 <= ここ複数項目のためテーブルを切り分けるので、あとで処理を直す必要あり
    # unless checkContentsItem(doc.css(@selector.selectSelector[:directors])[2].text.gsub("\\n", "").strip)
    #   # directors = []
    #   contents.directors = doc.css(@selector.selectSelector[:directors])[2].text.chomp.strip
    # end

    # あらすじ
    unless checkContentsItem(doc.css(selector.selectSelector[:summary]))
      contents.summary = doc.css(selector.selectSelector[:summary]).text
    end

    # rescue
    #   puts contents
    #   puts driver.current_url + "内で要素がなかったかも"
    #   driver.navigate().back()
    # end

    return contents

  end


  def Clawl
    # クロール処理をここにまとめる
  end


  def scrape
    # 解析処理をここにまとめる
    # 厳密にはクロール処理と分けにくいので一緒でも良いのかも
  end

  # def startDriver
  #   # HeadressChrome起動
  #   # 通常起動：driver = Selenium::WebDriver.for :chrome
  #   caps = Selenium::WebDriver::Remote::Capabilities.chrome("chromeOptions" => {binary: '/Applications/Google Chrome Canary.app/Contents/MacOS/Google Chrome Canary', args: ["--headless", "--disable-gpu",  "window-size=1280x800"]})
  #   @driver = Selenium::WebDriver.for :chrome, desired_capabilities: caps
  #   # WebDriverはロードが完了するのを待たないので必要に応じて待ち時間を設定
  #   @wait = Selenium::WebDriver::Wait.new(timeout: 10)
  # end

  def screenshot(driver)
    file_name = "_screenshot"
    extension = ".png"
    default_dir_path = "/Users/flatba/dev/project_ruby/movieCrossSearch/output/screenshot/"
    driver.save_screenshot default_dir_path + DateTime.now.strftime("%Y%m%d%H%M%S") + file_name + extension
  end

  private
  # 情報取得の項目があるかどうかのチェック
  def checkContentsItem(item)
    if item.empty? || item.nil?
      return true
    end
  end

end



main = Main.new

@base_url = "https://www.happyon.jp/"

# クロール可能サイトかどうかチェックする
robotex = Robotex.new
p robotex.allowed?(@base_url)

# サイト名称の識別
@site_name = main.checkSiteName(@base_url)

# サイト名称に応じて読み込むセレクターのインスタンスを切り替える
@selector = Selector.new(@site_name)

# サイト名称に応じてDBのインスタンスを生成する
# 回す前にバックアップを生成して、更新が終わったらバックアップは削除する処理でも良いかも
@db = SaveDBTask.new(@site_name)

# 構造体："トップ画像URL", "タイトル", "原題", "公開年", "ジャンル", "時間", "監督", "あらすじ"
@contents = Struct.new(:thumbnail, :title, :original_title, :release_year, :genres, :running_time, :director, :summary)

# ドライバー起動
caps = Selenium::WebDriver::Remote::Capabilities.chrome("chromeOptions" => {binary: '/Applications/Google Chrome Canary.app/Contents/MacOS/Google Chrome Canary', args: ["--headless", "--disable-gpu",  "window-size=1280x800"]})
@driver = Selenium::WebDriver.for :chrome, desired_capabilities: caps
# WebDriverはロードが完了するのを待たないので必要に応じて待ち時間を設定
@wait = Selenium::WebDriver::Wait.new(timeout: 10)

# メインページにアクセスしてパースデータを取得する
main_doc = main.openURL(@base_url)

# メインページから動画カテゴリ一覧のurlを取得する
category_url_arr = []
main_doc.css(@selector.selectSelector[:category_selector]).each { |element|
  # puts a_tag.text.strip   # カテゴリ名称
  # puts a_tag.attr('href') # カテゴリURL
  category_url_arr << element.attr('href')
}
puts "カテゴリ一覧を取得した。"

# 各カテゴリページにアクセスする
category_url_arr.each do |category_url|

  # カテゴリトップページにアクセス
  @driver.get(category_url)
  puts "カテゴリのひとつにアクセス中..." + category_url

  # "もっと見る"をクリックして、カテゴリ動画一覧ページへ
  more_watch_button_num = @driver.find_elements(:class, 'vod-mod-button').size
  for more_watch_btn_cnt in 0..more_watch_button_num

    puts "[もっと見る]の#{more_watch_btn_cnt}個目をクリック"
    puts "カテゴリにアクセス..." + @driver.current_url

    # @driver_idがページ遷移ごとに変わってしまうのでページが遷移するごとに取得する
    # @wait.until { @driver.find_elements(:class, 'vod-mod-button').displayed? }
    more_watch_buttons_elements = @wait.until{@driver.find_elements(:class, 'vod-mod-button')}
    # <= 二週目以降のelement情報が2個しか取れていない。なぜ？
    main.screenshot(@driver)

    # ここのクリックのURLがズレてる？
    more_watch_buttons_elements[more_watch_btn_cnt].click
    main.screenshot(@driver)
    puts "[もっと見る]をクリック"

    # クリックしてアクセスした先のリンクに動画情報がなかったら次のボタンに移る
    unless @driver.current_url.include?("tiles") then
      @driver.navigate().back()
      puts "動画コンテンツがないので動画コンテンツ一覧に戻る..."
      sleep 10
      next
    end

    @wait.until{@driver.find_elements(:class, @selector.selectSelector[:content_click])}

    # 動画一覧にある動画コンテンツの数
    # all_content_num = @wait.until{@driver.find_elements(:class, @selector.selectSelector[:content_click]).size}
    puts content_elements = @wait.until{@driver.find_elements(:class, @selector.selectSelector[:content_click])}
    puts all_content_num = content_elements.size
    begin
      for slect_content_num in 0..30

        puts @driver.current_url

        begin
          # 毎回elementsを取得するのは時間かかるからなんとか、新規ページ開いてという実装にしたい。

          # @driver_idがページ遷移ごとに変わってしまうのでページが遷移するごとに取得する
          content_elements = @wait.until{@driver.find_elements(:class, @selector.selectSelector[:content_click])}
          content_elements[slect_content_num].click
          puts "コンテンツをクリック"
          puts @driver.current_url + "にアクセス中..."
        rescue RuntimeError => e
          print e.message
          $browser.close
        rescue => e
          print e.message + "\n"
          next
        end


        # 各動画ページの映画情報を取得する
        content_url = @driver.current_url
        content_doc = main.openURL(content_url)
        puts contents = main.newContents(@selector, content_doc, @contents)

        # 取得したデータをDBに保存する（sqlite形式）
        @db = db.addContentsDB(contents)

        # コンテンツ情報を収集したら前のページに戻る
        @driver.navigate().back()

        # 最後まで読み込んだら前のページに戻る
        if slect_content_number == all_content_num then
          @driver.navigate().back()
          break
        end

      end
    rescue
      puts contents
      puts @driver.current_url + "内で要素がなかったかも"
      @driver.navigate().back()
      next
    end

  end

  main.close(@driver, @db)

end