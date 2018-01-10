# coding: utf-8

require './crawl/selector.rb'

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

end