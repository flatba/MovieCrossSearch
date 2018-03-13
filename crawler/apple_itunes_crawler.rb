#
# AappleiTunes
#
class AappleiTunesCrawler < BaseCrawler
  def start
    super

    category_url_list = get_category_url_list

    category_url_list.each do |category_url|
      open_new_tab(driver)
      driver.get(category_url)

      content_url_list = get_contents_list

      content_url_list.each do |content_url|
        open_new_tab(driver)
        driver.get(content_url)
        # ページネーションがうまくいっていない
        close_new_tab(driver)
        sleep 3
      end
    end
  end

  private

  # カテゴリURLを取得
  def get_category_url_list
    category_url_list = []
    category = driver.find_element(:css, '#genre-nav > div').find_element(:class, 'list').find_elements(:tag_name, 'a')
    category.each do |element|
      url = element.attribute('href')
      category_url_list << url
    end
    category_url_list
  end

  def get_contents_list
    # raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
    content_url_list = []
    # [A,B,C,...,Z,#]のリストを取得する
    alphabet_nation_list = driver.find_elements(:css, '#selectedgenre > ul.list.alpha')
    alphabet_nation_list.each do |alphabet|
      # アルファベットページネーションにアクセスする
      alphabet_url = get_a_tag_href_element(alphabet)
      driver.get(alphabet_url)
      # ページネーションを取得する
      page_nation = driver.find_elements(:css, '#selectedgenre > ul:nth-child(5)')
      page_nation.each do |page|
        # ページネーションにアクセスする
        page_url = get_a_tag_href_element(page)
        driver.get(page_url)
        # コンテンツリストを取得する
        contents_list = driver.find_element(:css, '#selectedcontent').find_elements(:tag_name, 'li')
        # コンテンツURLを取得する
        contents_list.each do |content|
          content_url_list << get_a_tag_href_element(content)
        end
      end
    end
    content_url_list
  end

  def scrape_content_item_info
    # raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
  end

  def open_tab(category_url)
    open_new_tab(driver)
    driver.get(category_url)
  end

  def scroll
    open_new_tab(driver)
    driver.get(content_url)
    close_new_tab(driver)
    sleep 3
  end
end
