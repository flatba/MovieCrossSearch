require 'open-uri'
require 'nokogiri'
require 'robotex'
require 'sqlite3'
require "selenium-webdriver"



  # アクセス先メインURL
  main_url = "https://www.happyon.jp/"

  robotex = Robotex.new
  p robotex.allowed?(main_url)


  def openURL(url)
    @charset = nil
    @user_agent = 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.63 Safari/537.36' # GoogleChrome
    @html = open(url, "User-Agent" => @user_agent) do |f|
      @charset = f.charset
      f.read
    end
  end

  def parseHTML()
    doc = Nokogiri::HTML.parse(@html, nil, @charset)
    return doc
  end

  # メインページにアクセスする
  openURL(main_url)
  main_doc = parseHTML()

  # メインページから動画一覧のurlを取得する
  category_url_arr = []
  main_doc.css('div.vod-frm--user01 > header > div > div > nav > ul > li > a').each { |a_tag| 
    # puts a_tag.text.strip   # カテゴリ名称
    # puts a_tag.attr('href') # カテゴリURL
    category_url_arr << a_tag.attr('href')
  }
  puts category_url_arr

  # 各カテゴリページにアクセスする
  category_url_arr.each do |category_url|

    # ブラウザ起動
    driver = Selenium::WebDriver.for :chrome 
    # urlにアクセス（動画をクリックして各動画コンテンツの中に入る）
    driver.get(category_url)
    # WebDriverはロードが完了するのを待たないので必要に応じて待ち時間を設定
    driver.manage.timeouts.implicit_wait = 1000

    # マウスオーバーさせるターゲットの要素
    # WebElement mouseTarget = driver.findElements(:css, "body > div.vod-frm--user01 > main > div.vod-mod-content > section:nth-child(1) > div > div > div.vod-mod-tray__slider.slick-initialized.slick-slider > div > div > div.vod-mod-tray__column.slick-slide.slick-current.slick-active > div:nth-child(1) > a > div.vod-mod-tray__thumbnail > img")

    WebElement mouseTarget = driver.findElement(:css, 'a')


  # マウスオーバー操作&クリック
    driver.move_to(mouseTarget).perform
    driver.manage.timeouts.implicit_wait = 30
    mouseTarget.click


    # driver.find_element(:css, "body > div.vod-frm--user01 > main > div.vod-mod-content > section:nth-child(1) > div > div > div.vod-mod-tray__slider.slick-initialized.slick-slider > div > div > div.vod-mod-tray__column.slick-slide.slick-current.slick-active > div:nth-child(1) > a > div.vod-mod-tray__thumbnail > img").click.build().perform()

    driver.quit # ブラウザ終了



    # user_agent = 'Mozilla/5.0 (iPad; CPU OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1' # GoogleChrome
    # category_doc = openURL(category_url, user_agent)
    
    

    # どうやら、各動画ページに入っていくには、jsを突破する必要がありそう。
    # 映画の画像をマウスオーバーすると詳細が出てきてそれをクリックすれば、
    # 各動画ページにアクセスできる

    # どのみちjsの処理は避けて通れないけど、SPから攻めたほうがもしかして楽か？
    # 少なくとも、謎のワンクリックは回避できる


  end


# 動画一覧ページから各動画へのリンクを取得する
# content_url = ""












# 実装手順
# クロールクラス
# ・トップページ（URL）にアクセスする
# ・ログインが必要な場合、seleniumでログインする
# ・動的なページの場合は、PahantomJSを使う
# ・動画一覧にアクセスする
#   ・各動画にアクセスする

# スクレイプクラス
# ・各動画の必要情報を取得する
#   title				  タイトル	String
# 	originalTitle	原題	String
# 	rereaseYear		公開年	String
# 	genre				  ジャンル	String
# 	runningTime		時間	String
# 	director			監督	String
# 	summary				あらすじ	String
# ・取得した情報を配列Aに格納する
# ・アクセスしたサイトの全ての映画情報を格納する配列Bに配列Aを格納する
# ・配列BをDBクラスに渡す

# DB保存クラス
# ・スクレイプクラスから受け取った配列Bを展開して、
# ・DBデータとして保存する（暫定DB:sqlite）
