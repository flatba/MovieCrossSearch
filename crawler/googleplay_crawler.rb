#
# GooglePlay
# https://play.google.com/store/movies
#
class GooglePlayCrawler < BaseCrawler
  def start
    super

    category_url_arr = get_category_list

    # TODO(flatba): カテゴリにアクセスして、動画情報を取得する
    category_url_arr.each do |category_url|

      # もっと見るボタンのURLの取得
      more_button_url_arr = []
      more_button_list = get_more_button_list(category_url)
      more_button_list.each do |more_button|
        more_button_url_arr << more_button.attribute('href')
      end
      # more_button_url_arr

      # もっと見るボタンにアクセスして、映画一覧を表示する
      # more_button_url = more_button.attribute('href')
      more_button_url_arr.each do |more_button_url|
        open_new_tab(driver)
        driver.get(more_button_url)

        # 映画一覧からURLのリストを取得する
        category_name = driver.find_element(:css, selector['original']['category_name']).text

        # 無限スクロールを追加する
        # infinit_scroll(driver, 3)

        # 映画リストの取得
        contents_url_arr = get_contents_list()

        # 映画個別ページを開く
        contents_url_arr.each do |content_url|
          open_new_tab(driver)
          driver.get(content_url)

          # scrape_content_item_info()
          scrape = ScrapingInfomation.new(driver, selector)
          scraping_infomation = scrape.run # <= class構造体
          # TODO(flatba): この構造体が取れるところまでがスクレイピング

          close_new_tab(driver)
          sleep 3
        end
      end
      close_new_tab(driver)
    end
  end

  # カテゴリURLの取得
  def get_category_list
    driver.find_element(:css, selector['original']['genre_button']).click
    category_url_arr = []
    category = driver.find_element(:css, selector['original']['genre_list']).find_elements(:tag_name, 'a')
    category.each do |element|
      category_url_arr << element.attribute('href')
    end
    category_url_arr
  end

  def get_more_button_list(category_url)
    open_new_tab(driver)
    driver.get(category_url)
    driver.find_elements(:class, selector['original']['more_button'])
  end

  def get_contents_list
    # raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
    # 映画リストの取得
    contents_url_arr = []
    contents_list = driver.find_element(:css, selector['original']['contents_list']).find_elements(:class, selector['original']['target'])
    contents_list.each do |content|
      content_url = content.attribute('href')
      contents_url_arr << content_url
    end
    contents_url_arr
  end

  def scrape_content_item_info
    # raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
  end
end
