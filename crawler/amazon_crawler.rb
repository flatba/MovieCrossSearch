#
# Amazon
# レンタル・購入リストURLを取得して開く
#
class AmazonCrawler < BaseCrawler
  def start
    super
    rental_video_list_url = driver.find_element(:css, '#refinementsOnTop > ul > li:nth-child(3) > span > div').find_element(:tag_name, 'a').attribute('href')
    driver.get(rental_video_list_url)

    # 各ページの動画ページにアクセスする
    base_page_url = get_next_page_url()
    last_page_num = (driver.find_element(:class, "pagnDisabled").text).to_i
    pagenation_crawler(base_page_url, last_page_num)

    # 新規タブを開く

    # 新規タブでcategory_urlを開く

    # 新規タブを開く

    # 動画コンテンツを開く

    # 情報を取得する

    # 取得したらタブを閉じる
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
end
