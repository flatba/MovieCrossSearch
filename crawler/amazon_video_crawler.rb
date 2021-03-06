#
# Amazon
# レンタル・購入リストURLを取得して開く
#
class AmazonVideoCrawler < BaseCrawler
  def start
    super
    rental_video_list_url = get_rental_video_list_url
    driver.get(rental_video_list_url)

    # 各ページの動画ページにアクセスする
    base_page_url = get_next_page_url
    last_page_num = (driver.find_element(:class, "pagnDisabled").text).to_i
    pagenation_crawler(base_page_url, last_page_num)

    # 新規タブを開く

    # 新規タブでcategory_urlを開く

    # 新規タブを開く

    # 動画コンテンツを開く

    # 情報を取得する

    # 取得したらタブを閉じる
  end

  private

  def get_rental_video_list_url
    driver.find_element(:css, selector['AMAZON_VIDEO']['original']['rental_video_list']).find_element(:tag_name, 'a').attribute('href')
  end

  def get_category_list
    # raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
  end

  def get_contents_list
    # raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
  end

  def scrape_content_item_info
    # raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
  end

  # 開いているページの全てのコンテンツのURLを配列にして返してくれる
  def get_content_url_list
    content_url_arr = []
    page_contents_list = driver.find_element(:css, '#s-results-list-atf').find_elements(:class, 's-access-detail-page')
    page_contents_list.each do |content_url|
      content_url_arr << content_url.attribute('href')
    end
    content_url_arr
  end

  # ページURLのベースになるURLを返す
  def get_next_page_url
    url = driver.find_element(:css, '#pagn > span > a').attribute('href')
    url_head   = url[0..url.index('pg_')+2]
    url_middle = url[url.index('pg_')+4..url.index('page')+4]
    url_tail   = url[url.index('page=')+6..url.length]
    page_url   = url_head + "***" + url_middle + "***" + url_tail
    page_url
  end

  # ページ番号（String）を渡すと次のページのURLの文字列を返してくれる
  def make_next_page_url(url, page_num)
    page_url = url.gsub('***', page_num)
    page_url
  end

  # コンテンツページを新規タブで開いて、各動画情報を取得する
  def get_contents_item(content_url_arr)
    content_url_arr.each do |content_url|
      open_new_tab(driver)
      driver.get(content_url)

      # ここで情報取得
      # save_contents

      close_new_tab(driver)
      sleep 1
    end
  end

  def scrape_content_info
    # TODO(flatba): 動画情報を取得する
  end

  # ページネーションのクロール
  def pagenation_crawler(base_page_url, last_page_num)
    for page_num in 1..last_page_num do
      next_page_url = make_next_page_url(base_page_url, page_num.to_s)
      driver.get(next_page_url)

      content_url_arr = []
      content_url_arr = get_content_url_list

      get_contents_item(content_url_arr)
    end
  end
end
