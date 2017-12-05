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
class Entry

  attr_reader :base_url, :site_name, :selector, :db, :contents, :driver, :wait

  # 初期データの生成
  def initialize(url)

    # クロール可能サイトかどうかチェックする
    robotex = Robotex.new
    p robotex.allowed?(url)

    @base_url = url
    @site_name = ""

  end

  def initialize_selector(site_name)
    @selector = Selector.new(site_name)
  end

  def initialize_db(site_name)
    @db = SaveDBTask.new(site_name)
  end

  def initialize_contents
    @contents = Struct.new(:thumbnail, :title, :original_title, :release_year, :genres, :running_time, :director, :summary)
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


#
# クロール（主にページ遷移のための処理）
#
class Crawl

  # URLからパースデータを取得する
  def open_url(url)
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

  # ログイン処理
  def login

  end

  # クローズ処理
  def close(driver, db)
    driver.quit    # ブラウザ終了
    db.close_DB_task # データベースの編集終了
  end

  # ウィンドウを閉じる
  def close_new_window(driver, window)
    puts "新規タブを閉じる"
    driver.close
    puts "　元タブにハンドルを戻す"
    driver.switch_to.window(window)
  end

  def send_key_new_tab(element)
    puts "新規タブでリンクを開く"
    element.send_keys(:command, :enter)
    sleep 3
  end

  # ウィンドウのハンドルを後から開いたタブに移す
  def change_current_window(driver, element)

      # elementを新規タブで開く（環境によりkeyが異なるみたいなのでサーバーではどうなる？）
      # mac chromeの場合、新規タブのショートカットキーがcommand + クリック
      # puts "新規タブでリンクを開く"
      # element.send_keys(:command, :enter)

      # 新規で開いたタブのハンドルを取得
      puts "新規で開いたタブのハンドルを取得"
      new_window = driver.window_handles.last

      # 新規タブにハンドルを移す
      puts "新規タブにハンドルを移す"
      driver.switch_to.window(new_window)
      driver.window_handle

      # 新規タブのURLを取得する
      puts "新規タブのURLを取得する"
      screenshot(driver)
      content_url = driver.current_url

      return content_url

  end

  # bodyの高さを取得する（動的に変動する高さの取得に使用）
  def get_body_dom_height(driver)
    return driver.find_element(:tag_name, 'body').size.height
  end

  def screenshot(driver)
    file_name = "_screenshot"
    extension = ".png"
    default_dir_path = "/Users/flatba/dev/project_ruby/movieCrossSearch/output/screenshot/"
    driver.save_screenshot default_dir_path + DateTime.now.strftime("%Y%m%d%H%M%S") + file_name + extension
  end

end


#
# 解析（情報収集処理）
#
class Scrape

  # 情報を取得する
  def get_contents_information(content_url)
    puts "情報を取得する"
    # content_doc = main.openURL(content_url)
    # contents = main.newContents(@selector, content_doc, @contents)
    # return contents
  end

  # 情報を保存する
  def save_contents(contents)
    puts "情報を保存する"
    # @db.addContentsDB(contents)
  end

  # 情報を取得してcontents（構造体）に入れて返す
  def new_contents(selector, doc, contents)

    # 20171130
    # 細かい情報を取得するよりちゃんと全ての動画コンテンツを舐める流れを作るほうが優先度高い。
    # ので、ここのコンテンツ取得は一旦コメントアウトしておく。

    # 構造体："トップ画像URL", "タイトル", "原題", "公開年", "ジャンル", "時間", "監督", "あらすじ"
    contents = contents.new("", "", "", "", "", "", "", "")

    # データが存在しない場合は処理を飛ばす
    トップ画像
    unless check_contents_item(doc.css(selector.selectSelector[:thumbnail]))
      puts contents.thumbnail = doc.css(selector.selectSelector[:thumbnail]).attr('src').to_s
    end

    # 映画タイトル
    # unless check_contents_item(doc.css(selector.selectSelector[:title]).text)
    #   puts add_contents.title = doc.css(selector.selectSelector[:title]).text
    # end

    # 原題
    # crawl.screenshot(@driver) # デバッグ用
    # unless check_contents_item(doc.css(@selector.selectSelector[:original_title]))
    #   puts contents.original_title = doc.css(@selector.selectSelector[:original_title])
    # end

    # 公開年
    # unless check_contents_item(doc.css(selector.selectSelector[:release_year]).text)
    #   release_year_tmp = doc.css(selector.selectSelector[:release_year]).text
    #   tail_num = release_year_tmp.rindex('年')
    #   puts contents.release_year = release_year_tmp[tail_num-4..tail_num-1]
    # end

    # ジャンル <= ここ複数項目のためテーブルを切り分けるので、あとで処理を直す必要あり
    # unless check_contents_item(insert_contents.doc.css(@selector.selectSelector[:genre]).children)
      # genres = []
      # contents.doc.css(@selector.selectSelector[:genre]).children.each do |genre|
      #   genres.push(genre.text)
      # end
      # puts genres
    # end

    # 上映時間
    # unless check_contents_item(doc.css(selector.selectSelector[:running_time]).text)
    #   running_time_tmp = doc.css(selector.selectSelector[:running_time]).text
    #   tail_num = running_time_tmp.rindex('分')
    #   puts contents.running_time = running_time_tmp[tail_num-3..tail_num].strip
    # end

    # キャスト <= ここ複数項目のためテーブルを切り分けるので、あとで処理を直す必要あり
    # unless check_contents_item(doc.css(@selector.selectSelector[:director])[0])
      # casts = []
      # doc.css(@selector.selectSelector[:director])[0].each do |cast|
      #   casts.push(cast.text)
      # end
      # puts casts
    # end

    # 監督 <= ここ複数項目のためテーブルを切り分けるので、あとで処理を直す必要あり
    # unless check_contents_item(doc.css(@selector.selectSelector[:directors])[2].text.gsub("\\n", "").strip)
    #   # directors = []
    #   contents.directors = doc.css(@selector.selectSelector[:directors])[2].text.chomp.strip
    # end

    # あらすじ
    # unless check_contents_item(doc.css(selector.selectSelector[:summary]))
    #   contents.summary = doc.css(selector.selectSelector[:summary]).text
    # end

    # rescue
    #   puts contents
    #   puts driver.current_url + "内で要素がなかったかも"
    #   driver.navigate().back()
    # end

    return contents

  end

  private
  # 情報取得の項目があるかどうかのチェック（new_contentsメソッドで使用）
  def check_contents_item(item)
    if item.empty? || item.nil?
      return true
    end
  end

end


# ----------------------------------------------------------------------
# main
# ----------------------------------------------------------------------

entry = Entry.new("https://www.happyon.jp/")
entry.check_site_name(entry.base_url)
@selector = entry.initialize_selector(entry.site_name)
@db       = entry.initialize_db(entry.site_name)
@contents = entry.initialize_contents
@driver   = entry.initialize_driver

crawl = Crawl.new
scrape = Scrape.new

# メインページにアクセスしてパースデータを取得する
main_doc = crawl.open_url(entry.base_url)

# [DONE]カテゴリ一覧を取得する
puts "カテゴリ一覧を取得する"
category_url_arr = []
main_doc.css(@selector.selectSelector[:category_selector]).each { |element|
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
    puts "**********スクロールの開始**********"
    body_dom_height = crawl.get_body_dom_height(@driver)
    @driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
    sleep 5
    new_body_dom_height = crawl.get_body_dom_height(@driver)
    cnt = 1
    while body_dom_height != new_body_dom_height do
      body_dom_height = crawl.get_body_dom_height(@driver)
      puts '%{cnt}スクロール目' % { cnt: cnt }
      @driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
      sleep 3 # スクロールがDOMのサイズ取得に追いついてしまって途中までしかスクロールしてない事象ありのためsleep 3秒
      new_body_dom_height = crawl.get_body_dom_height(@driver)
      cnt += 1
    end
    puts "**********スクロールの終了（末端までスクロールした）**********"

    puts "動画一覧を取得する"
    content_elements = @driver.find_elements(:css, @selector.selectSelector[:content_click])

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
      scrape.get_contents_information(content_url)
      scrape.save_contents(@contents)

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