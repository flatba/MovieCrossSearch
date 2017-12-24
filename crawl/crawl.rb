# coding: utf-8

require 'open-uri'
require 'nokogiri'


#
# クロール（主にページ遷移のための処理）
#
class Crawl

  def initialize_driver
    # 通常chrome起動
    @driver = Selenium::WebDriver.for :chrome

    # HeadressChrome起動
    caps = Selenium::WebDriver::Remote::Capabilities.chrome(
      "chromeOptions" => {
        binary: '/Applications/Google Chrome Canary.app/Contents/MacOS/Google Chrome Canary',
        args: ["--headless", "--disable-gpu",  "window-size=1280x800"]
      }
    )
    # @driver = Selenium::WebDriver.for :chrome, desired_capabilities: caps

    return @driver

  end

  def initialize_selector(site_name)
    @selector = Selector.new(site_name)
  end

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
  # def close(driver, db)
  def close(driver)
    driver.quit    # ブラウザ終了
    # db.close_DB_task # データベースの編集終了
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