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

    # 20171130
    # 細かい情報を取得するよりちゃんと全ての動画コンテンツを舐める流れを作るほうが優先度高い。
    # ので、ここのコンテンツ取得は一旦コメントアウトしておく。

    # 構造体："トップ画像URL", "タイトル", "原題", "公開年", "ジャンル", "時間", "監督", "あらすじ"
    contents = contents.new("", "", "", "", "", "", "", "")

    # データが存在しない場合は処理を飛ばす
    # トップ画像
    # unless checkContentsItem(doc.css(selector.selectSelector[:thumbnail]))
    #   puts contents.thumbnail = doc.css(selector.selectSelector[:thumbnail]).attr('src').to_s
    # end

    # 映画タイトル
    # unless checkContentsItem(doc.css(selector.selectSelector[:title]).text)
    #   puts add_contents.title = doc.css(selector.selectSelector[:title]).text
    # end

    # 原題
    # screenshot(@driver) # デバッグ用
    # unless checkContentsItem(doc.css(@selector.selectSelector[:original_title]))
    #   puts contents.original_title = doc.css(@selector.selectSelector[:original_title])
    # end

    # 公開年
    # unless checkContentsItem(doc.css(selector.selectSelector[:release_year]).text)
    #   release_year_tmp = doc.css(selector.selectSelector[:release_year]).text
    #   tail_num = release_year_tmp.rindex('年')
    #   puts contents.release_year = release_year_tmp[tail_num-4..tail_num-1]
    # end

    # ジャンル <= ここ複数項目のためテーブルを切り分けるので、あとで処理を直す必要あり
    # unless checkContentsItem(insert_contents.doc.css(@selector.selectSelector[:genre]).children)
      # genres = []
      # contents.doc.css(@selector.selectSelector[:genre]).children.each do |genre|
      #   genres.push(genre.text)
      # end
      # puts genres
    # end

    # 上映時間
    # unless checkContentsItem(doc.css(selector.selectSelector[:running_time]).text)
    #   running_time_tmp = doc.css(selector.selectSelector[:running_time]).text
    #   tail_num = running_time_tmp.rindex('分')
    #   puts contents.running_time = running_time_tmp[tail_num-3..tail_num].strip
    # end

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
    # unless checkContentsItem(doc.css(selector.selectSelector[:summary]))
    #   contents.summary = doc.css(selector.selectSelector[:summary]).text
    # end

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

@site_name = main.checkSiteName(@base_url)
@selector = Selector.new(@site_name)
@db = SaveDBTask.new(@site_name)
@contents = Struct.new(:thumbnail, :title, :original_title, :release_year, :genres, :running_time, :director, :summary)
@driver = Selenium::WebDriver.for :chrome
@wait = Selenium::WebDriver::Wait.new(timeout: 30)

# メインページにアクセスしてパースデータを取得する
main_doc = main.openURL(@base_url)

#--- 大枠の流れはこれ。---#
# ログインする
# [DONE]カテゴリ一覧を取得する
# [DONE]カテゴリにアクセスする
  # [DONE]サブカテゴリを取得する（[もっと見る]ボタンを取得する）
  # [DONE]サブカテゴリにアクセスする（[もっと見る]ボタンを押す）
    # [DONE]動画一覧を取得する
    # [DOING]動画にアクセスする
      # 情報を取得する
        # 情報を保存する（sqlite形式）

# [DONE]カテゴリ一覧を取得する
puts "カテゴリ一覧を取得する"
category_url_arr = []
main_doc.css(@selector.selectSelector[:category_selector]).each { |element|
  # puts a_tag.text.strip   # カテゴリ名称
  # puts a_tag.attr('href') # カテゴリURL
  category_url_arr << element.attr('href')
}


# [DONE]カテゴリにアクセスする
puts "カテゴリにアクセスする"
begin
  category_url_arr.each do |category_url|
    @driver.get(category_url)

    # [DONE]サブカテゴリを取得する（[もっと見る]ボタンを取得する）
    puts "サブカテゴリを取得する"
    more_watch_button_num = @driver.find_elements(:class, 'vod-mod-button').size # 動画一覧の動画数を取得する（最下までいったら読み込みを開始している処理なので、表示されている分しか取れていない。直す。）

    # [DONE]サブカテゴリにアクセスする（[もっと見る]ボタンを押す）
    puts "サブカテゴリにアクセスする"
    for more_watch_btn_cnt in 0..more_watch_button_num

      # [DONE?]動画一覧を取得する
      puts "動画一覧を取得する"
      more_watch_buttons_elements = @wait.until{@driver.find_elements(:class, 'vod-mod-button')}

      # 動画にアクセスする
      puts "動画一覧にアクセスする"
      more_watch_buttons_elements[more_watch_btn_cnt].click

      # クリックしてアクセスした先のリンクに動画情報がなかったら次のボタンに移る
      unless @driver.current_url.include?("tiles") then
        puts "動画一覧に戻る"
        @driver.get(category_url)
        next
      end

      # 動画にアクセスする
      puts "動画にアクセスする"
      sleep 10 # 読み込みタイミングが合わないと要素を取得できないため
      content_elements = @driver.find_elements(:class, @selector.selectSelector[:content_click])
      all_content_num = content_elements.size

      for slect_content_num in 0..all_content_num

        if slect_content_num > 0
          sleep 10 # 読み込みタイミングが合わないと要素を取得できないため
          content_elements = @driver.find_elements(:class, @selector.selectSelector[:content_click]) # @driver_idがページ遷移ごとに変わってしまうのでページが遷移するごとに取得する
        end

        puts "動画をクリック"
        content_elements[slect_content_num].click

        # 情報を取得する
        puts "情報を取得する"
        content_url = @driver.current_url
        content_doc = main.openURL(content_url)
        contents = main.newContents(@selector, content_doc, @contents)

        # 情報を保存する
        puts "情報を保存する"
        # @db.addContentsDB(contents)

        # コンテンツ情報を収集したら前のページに戻る
        puts "動画一覧に戻る"
        @driver.navigate().back()

        # 最後まで読み込んだら前のページに戻る処理を入れる
      end
    end
    main.close(@driver, @db)
  end

rescue RuntimeError => e
  print e.message
  $browser.close
rescue => e
  print e.message + "\n"
  main.close(@driver, @db)
end