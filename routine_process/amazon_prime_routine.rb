# coding: utf-8
#
# Amazon Prime
#
class AmazonPrimeRoutine < BaseRoutine

  attr_reader :crawl, :scrape, :driver, :selector, :movie_master

  # 開いているページの全てのコンテンツのURLを配列にして返してくれる
  def get_content_url_list
    content_url_arr = []
    page_contents_list = driver.find_element(:css, '#s-results-list-atf').find_elements(:class, 's-access-detail-page')
    page_contents_list.each do |content_url|
      content_url_arr << content_url.attribute('href')
    end
    return content_url_arr
  end

  # ページ番号（String）を渡すと次のページのURLの文字列を返してくれる
  def get_next_page_url(page_num)
    url = driver.find_element(:css, '#pagn > span:nth-child(3) > a').attribute('href')
    url_head = url[0..url.index('pg_')+2]
    url_middle = url[url.index('pg_')+4..url.index('page')+4]
    url_tail = url[url.index('page=')+6..url.length]
    page_url = url_head + page_num + url_middle + page_num + url_tail
    return page_url
  end

  # 処理の開始をしてくれる
  def start(url, site_name)
    super

    # プライム会員特典リストURLを取得して開く
    prime_menber_video_list_url = driver.find_element(:css, '#refinementsOnTop > ul > li:nth-child(2) > span > div').find_element(:tag_name, 'a').attribute('href')
    driver.get(prime_menber_video_list_url)

    content_url_arr = []
    content_url_arr = get_content_url_list()

    next_page_url = get_next_page_url(page_num)



    # -----------------------------------------------------

    # レンタル・購入リストURLを取得して開く
    rental_video_list_url = driver.find_element(:css, '#refinementsOnTop > ul > li:nth-child(3) > span > div').find_element(:tag_name, 'a').attribute('href')
    driver.get(rental_video_list_url)


# flatba^ 2017/01/06 取得方法変更のため一旦コメントアウト
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
# flatba$
  end

end