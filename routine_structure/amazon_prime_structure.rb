# coding: utf-8
#
# AmazonPrime
#
class AmazonPrimeStructure < BaseStructure

  def start(url, site_name)

    driver.get(url)

    # プライム会員特典 映画リスト
    prime_menber_video_list_url = driver.find_element(:css, '#refinementsOnTop > ul > li:nth-child(2) > span > div').find_element(:tag_name, 'a').attribute('href')
    driver.get(prime_menber_video_list_url)

    result_url_arr = []
    driver.find_element(:css, '#s-results-list-atf').find_elements(:tag_name, 'a').each do |result_url|
      result_url_arr << result_url.attribute('href')
    end
    puts result_url_arr
    puts result_url_arr.size
    # 不要なURLも取得しているので条件を狭める必要あり。



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

  end

end