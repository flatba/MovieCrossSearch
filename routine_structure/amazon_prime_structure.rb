# coding: utf-8

require "selenium-webdriver"

require './crawl/selector.rb'
require './crawl/crawl.rb'
require './scrape/scrape.rb'
# require './database/database.rb'
# require './database/save_db_task.rb'

#
# AmazonPrime
#
class AmazonPrimeStructure < BaseStructure

  # attr_reader :crawl, :scrape, :driver, :selector, :movie_master

  # def initialize(url, site_name)

  #   @crawl  = Crawl.new
  #   @scrape = Scrape.new
  #   # @db_task = SaveDBTask.new

  #   @driver        = @crawl.initialize_driver
  #   @selector      = @crawl.initialize_selector(site_name)
  #   @movie_master  = @scrape.movie_master
  #   # @movie_master = @scrape.initialize_movie_master # DB処理
  #   # @db           = @db_task.initialize_data_base(site_name)

  #   start(url, site_name)

  # end

  def start(url, site_name)

    driver.get("https://www.amazon.co.jp/s/ref=sr_rot_p_n_ways_to_watch_0?fst=as%3Aoff&rh=n%3A2351649051%2Cp_n_ways_to_watch%3A3746328051&bbn=2351649051&ie=UTF8&qid=1515058940&rnid=3746327051")

    # プライム会員特典 映画リスト
    prime_menber_video_list_url = driver.find_element(:css, '#refinementsOnTop > ul > li:nth-child(2) > span > div').find_element(:tag_name, 'a').attribute('href')
    driver.get(prime_menber_video_list_url)

    result_url_arr = []
    driver.find_element(:css, '#s-results-list-atf').find_elements(:tag_name, 'a').each do |result_url|
      result_url_arr << result_url.attribute('href')
    end



    # レンタル・購入 映画リスト
    rental_video_list_url = driver.find_element(:css, '#refinementsOnTop > ul > li:nth-child(3) > span > div').find_element(:tag_name, 'a').attribute('href')
    driver.get(rental_video_list_url)



  #   # トップページを開く
  #   driver.get(url)

  #   # メインページにアクセスしてパースデータを取得する
  #   category_url_arr = []
  #   main_doc = crawl.open_url(url)
  #   main_doc.css('#nav-subnav > a.nav-a').each do |element|
  #     category_url_arr << 'https://www.amazon.co.jp' + element.attribute('href')
  #   end
  #   # puts category_url_arr

  #   # ↑カテゴリーURLの取得まで完了↑

  #   # TODO(flatba): カテゴリにアクセスして、動画情報を取得する
  #   contents_url_arr = []
  #   category_url_arr.each do |category_url|

  #     # # 新規タブを開く
  #     # crawl.open_new_tab_then_move_handle(driver)
  #     # # 新規タブでcategory_urlを開く
  #     # driver.get(category_url)
  #     # # ページ末尾までスクロールを済ませておく
  #     # crawl.infinit_scroll(driver, 3)
  #     # # 動画一覧URLを取得する
  #     # contents = driver.find_element(:css, '#content').find_elements(:tag_name, 'a')
  #     # contents.each do |content|
  #     #   puts content.text
  #     #   contents_url_arr << content.attribute('href')
  #     # end
  #     # puts contents_url_arr

  #     # 方法１
  #     # 全てのコンテンツを取得しようとしていたが、間違いで、全て見るのリンクだけ取得すればよかったのでは？
  #     # そうすれば、動画一覧ページに飛ぶので、そこからまたページネーションで次ページ...って感じで情報どんどん取得できたのでは？
  #     # というかカテゴリ分けされているトップページからクロールする必要はあるのか？

  #     # 新規タブを開く

  #     # 動画コンテンツを開く

  #     # 情報を取得する

  #     # 取得したらタブを閉じる

  #   end

  # end

end