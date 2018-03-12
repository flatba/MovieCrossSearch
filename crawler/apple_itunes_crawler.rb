#
# AappleiTunes
#
class AappleiTunesCrawler < BaseCrawler
  def start
    super

    # カテゴリURLを取得
    category_url_arr = get_category_list

    # TODO(flatba): カテゴリにアクセスして動画情報を取得する
    category_url_arr.each do |category_url|
      open_new_tab(driver)
      driver.get(category_url)

      # 新規タブを開く

      # 新規タブでcategory_urlを開く

      # 新規タブを開く

      # 動画コンテンツを開く

      # 情報を取得する

      # 取得したらタブを閉じる
      close_new_tab(driver)
    end
  end

  private

  def get_category_list
    category_url_arr = []
    category = driver.find_element(:css, '#genre-nav > div').find_element(:class, 'list').find_elements(:tag_name, 'a')
    category.each do |element|
      url = element.attribute('href')
      category_url_arr << url
    end
    category_url_arr
  end

  def get_contents_list
    # raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
  end

  def scrape_content_item_info
    # raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
  end

  def opentab(category_url)
    open_new_tab(driver)
    driver.get(category_url)
  end

end
