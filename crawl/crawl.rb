# coding: utf-8

require './crawl/selector.rb'
require './crawl/crawl.rb'

#
# クロール（主にページ遷移のための処理）
#
module Crawl
  include Selector

  def initialize_driver
    # 通常chrome起動
    driver = Selenium::WebDriver.for :chrome

    # HeadressChrome起動
    # caps = Selenium::WebDriver::Remote::Capabilities.chrome(
    #   "chromeOptions" => {
    #     binary: '/Applications/Google Chrome Canary.app/Contents/MacOS/Google Chrome Canary',
    #     args: ["--headless", "--disable-gpu",  "window-size=1280x800"]
    #   }
    # )
    # driver = Selenium::WebDriver.for :chrome, desired_capabilities: caps

    return driver
  end

  def initialize_selector(site_name)
    setup_selector(site_name)
  end

  # ログインしてトップページを開く
  def login(url, driver, selector, id, pw)
    # 画面を開いて情報をセットしてログインする
    driver.find_element(:name, 'email').send_keys id
    driver.find_element(:name, 'password').send_keys pw
    driver.find_element(:xpath, select_selector[:login]).click

    if url.include?('netflix')
      # ログイン後に視聴ユーザーを選択する
      driver.find_element(:xpath, select_selector[:select_user]).click
    end
  end

  # URLからパースデータを取得する
  def open_url(url)
    charset = nil
    html = nil
    user_agent = 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.63 Safari/537.36' # GoogleChrome
    html = open(url, "User-Agent" => user_agent) do |f|
    # html = open(url) do |f|
      charset = f.charset
      f.read
    end
    doc = Nokogiri::HTML.parse(html, nil, charset)
    doc
  end

  # クローズ処理
  # def close(driver, db)
  def close(driver)
    driver.quit    # ブラウザ終了
    # db.close_DB_task # データベースの編集終了
  end

  # 新規タブを開いてハンドルを新規タブに移し、もとページのハンドルを返す
  def open_new_tab_then_move_handle(driver)
    current_window_handle = driver.window_handles.last
    driver.execute_script("window.open()")
    new_window_handle = driver.window_handles.last
    driver.switch_to.window(new_window_handle)
    return current_window_handle
  end

  # 新規タブを開いてハンドルを新規タブに移し、受け取ったURLを新規タブで開く
  # 使っていない
  # def open_new_tab(driver, url)
  #   driver.execute_script("window.open()")
  #   new_window = driver.window_handles.last
  #   driver.switch_to.window(new_window)
  #   driver.get(url)
  # end

  # 疑似キーボード操作で新規タブを開く
  def send_key_new_tab(element)
    puts "新規タブでリンクを開く"
    element.send_keys(:command, :enter)
    sleep 3
  end

  # ウィンドウのハンドルを後から開いたタブに移す
  # def change_current_tab(driver, element)
  def change_current_tab(driver)
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
    # puts "新規タブのURLを取得する"
    # content_url = driver.current_url

    # return content_url
  end

  # タブを閉じる
  def close_new_tab(driver, handle)
    puts "新規タブを閉じる"
    driver.close
    puts "　元タブにハンドルを戻す"
    driver.switch_to.window(handle)
  end

  # bodyの高さを取得する（動的に変動する高さの取得に使用）
  def get_body_dom_height(driver)
    return driver.find_element(:tag_name, 'body').size.height
  end

  def infinit_scroll(driver, sleep_time)
    puts "**********スクロールの開始**********"

    # 取得したウィンドウの差分で末尾に到達したかを判断する
    body_dom_height = get_body_dom_height(driver)

    driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
    sleep 5
    new_body_dom_height = get_body_dom_height(driver)
    cnt = 1
    while body_dom_height != new_body_dom_height do
      body_dom_height = get_body_dom_height(driver)
      puts '%{cnt}スクロール目' % { cnt: cnt }
      driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")

      # スクロールがDOMのサイズ取得に追いついてしまって途中までしかスクロールしてない事象が起こり得るため、
      # スクロールする箇所によって調整する
      sleep sleep_time

      new_body_dom_height = get_body_dom_height(driver)
      cnt += 1
    end

    puts "**********スクロールの終了（末端までスクロールした）**********"
  end

  def screenshot(driver)
    file_name = "_screenshot"
    extension = ".png"
    default_dir_path = "/Users/flatba/dev/project_ruby/movieCrossSearch/output/screenshot/"
    driver.save_screenshot default_dir_path + DateTime.now.strftime("%Y%m%d%H%M%S") + file_name + extension
  end

end