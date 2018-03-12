#
# Amazon
# prime側で吸収したので、必要なくなるかも。
#
class AmazonCrawler < BaseCrawler
  def start
    super

    #
    # レンタル・購入リストURLを取得して開く
    #
    begin
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

    rescue RuntimeError => e
      print e.message
      $browser.close
    rescue => e
      print e.message + "\n"
    end
  end
end
