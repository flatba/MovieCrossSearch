require 'open-uri'
require 'nokogiri'
require 'robotex'
require 'sqlite3'
require "selenium-webdriver"

# import classfile
require './Contents.rb'
require './Selector.rb'
require './SaveDBTask.rb'

def openURL(url)
  charset = nil
  html = nil
  # user_agent = 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.63 Safari/537.36' # GoogleChrome
  #html = open(url, "User-Agent" => user_agent) do |f|
  html = open(url) do |f|
    charset = f.charset
    f.read
  end
  doc = nil
  doc = Nokogiri::HTML.parse(html, nil, charset)
  return doc
end

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

# アクセス先メインURL
main_url = "https://www.happyon.jp/"

robotex = Robotex.new
p robotex.allowed?(main_url)

# サイト名称の識別 @site_name にサイト名称格納
checkSiteName(main_url)

# メインページにアクセスしてパースデータを取得する
main_doc = openURL(main_url)

# サイト名称に応じて読み込むセレクターのインスタンスを切り替える
selector = Selector.new(@site_name)

# サイト名称に応じてDBのインスタンスを生成する
# 今後定期で回すとき、ファイルが存在している場合は新たに生成しない処理にする
# 回す前にバックアップを生成して、更新が終わったらバックアップは削除する処理でも良いかも
db = SaveDBTask.new(@site_name)

# メインページから動画カテゴリ一覧のurlを取得する
category_url_arr = []
main_doc.css(selector.selectSelector[:category_selector]).each { |element|
  # puts a_tag.text.strip   # カテゴリ名称
  # puts a_tag.attr('href') # カテゴリURL
  category_url_arr << element.attr('href')
}

# 各カテゴリページにアクセスする
category_url_arr.each do |category_url|

  # ブラウザ起動
  driver = Selenium::WebDriver.for :chrome
  # urlにアクセス（動画をクリックして各動画コンテンツの中に入る）
  driver.get(category_url)
  # WebDriverはロードが完了するのを待たないので必要に応じて待ち時間を設定
  # driver.manage.timeouts.implicit_wait = 1000
  sleep 1

  # 動画一覧からコンテンツをポチポチクリックしていく
  driver.find_elements(:class_name, selector.selectSelector[:thumbnail_click]).each{ |element|

    # 動画個別ページを開く
    element.click # 別ページに遷移してしまうので、クリック後に戻る処理も必要

    # 各動画ページのパースデータを取得する
    content_url = driver.current_url
    content_doc = openURL(content_url)

    # パースデータから動画の情報を取得する
    puts thumbnail = content_doc.css(selector.selectSelector[:thumbnail]).attr('src').to_s
    puts title = content_doc.css(selector.selectSelector[:title]).text
    # original_title = content_doc.css(selector.selectSelector[:original_title])
    release_year = content_doc.css(selector.selectSelector[:release_year]).text
    tail_num = release_year.rindex('年')
    puts release_year = release_year[tail_num-4..tail_num-1]
    puts  genre = content_doc.css(selector.selectSelector[:genre1]).attr('href')
    #puts genre2 = content_doc.css(selector.selectSelector[:genre2]).attr('href')
    #puts  genre3 = content_doc.css(selector.selectSelector[:genre3).attr('href')
    #puts  running_time = content_doc.css(selector.selectSelector[:rrunning_time])
    #puts  director = content_doc.css(selector.selectSelector[:director]) # 監督情報一発で取れないので特殊な取り方しないといけないかも
    #puts  summary = content_doc.css(selector.selectSelector[:summary])

    # モデルに値をセット
    contents = Contents.new
    contents.setThumbnail(thumbnail)
    contents.setTitle(title)
    contents.setOriginalTitle("original_title")
    contents.setReleaseYear(release_year)
    contents.setGenre("genre")
    contents.setRunningTime("running_time")
    contents.setDirector("director")
    contents.setSummary("summary")
    p contents

    # DBに保存する（一旦はsqliteで保存する（.db形式））
    db.saveDBTask(contents)

    # 動画個別の収集が終わったら一覧に戻る
    driver.get(category_url)

  }


  driver.quit # ブラウザ終了

end