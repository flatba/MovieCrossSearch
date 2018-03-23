#
# AappleiTunes
#
class AappleiTunesCrawler < BaseCrawler
  def start
    super

    # ジャンルを開く
    genre_url_list = get_genre_url_list
    genre_url_list.each do |genre_url|
      open_new_tab(driver)
      driver.get(genre_url)

      # ABC...のURL取得
      alphabet_nation_url_arr = get_alphabet_nation_url_arr
      alphabet_nation_url_arr.each do |alphabet_nation_url|
        open_new_tab(driver)
        driver.get(alphabet_nation_url)
        # ABC..ごとにページを開く
        # ページネーションを取得する
        page_nation_url_arr = get_page_nation_url_arr(alphabet_nation_url)
        page_nation_url_arr.each do |page_nation_url|
          # 映画URLを取得する
          content_url_list = get_contents_list(page_nation_url)
          content_url_list.each do |content_url|
            open_new_tab(driver)
            driver.get(content_url)

            # scrape_content_item_info()
            scrape = ScrapingInfomation.new(driver, selector)
            scraping_infomation = scrape.run # <= class構造体
            # TODO(flatba): この構造体が取れるところまでがスクレイピング

            close_new_tab(driver)
            sleep 1
          end
          # close_new_tab(driver)
          # sleep 3
        end
        # close_new_tab(driver)
        # sleep 3
      end
      close_new_tab(driver)
      sleep 3
    end
  end

  private

  # カテゴリURLを取得
  def get_genre_url_list
    category_url_list = []
    category = driver.find_element(:css, '#genre-nav > div').find_elements(:tag_name, 'li')
    category.each do |element|
      url = get_a_tag_href_element(element)
      category_url_list << url
    end
    category_url_list
  end

  def get_alphabet_nation_url_arr
    # [A,B,C,...,Z,#]のリストを取得する
    alphabet_nation_url_arr = []
    alphabet_nation_list = driver.find_elements(:css, '#selectedgenre > ul > li')
    alphabet_nation_list.each do |alphabet|
      alphabet_url = alphabet.find_element(:tag_name, 'a').attribute('href')
      alphabet_nation_url_arr << alphabet_url
    end
    alphabet_nation_url_arr
  end

  def get_page_nation_url_arr(alphabet_nation_url)
    # アルファベットページネーションにアクセスする
    # alphabet_nation_url_arr.each do |alphabet_nation_url|
      driver.get(alphabet_nation_url)

      # ページネーションを取得する
      page_nation_url_arr = []
      page_nation_list = driver.find_elements(:css, '#selectedgenre > ul:nth-child(2) > li')
      page_nation_list.each do |page|
        # ページネーションのURLを取得する
        page_nation_url_arr << get_a_tag_href_element(page)
      end
      page_nation_url_arr
    # end
  end

  def get_contents_list(page_nation_url)
    # raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
    content_url_list = []

    # # [A,B,C,...,Z,#]のリストを取得する
    # alphabet_nation_url_arr = []
    # alphabet_nation_list = driver.find_elements(:css, '#selectedgenre > ul > li')
    # alphabet_nation_list.each do |alphabet|
    #   alphabet_url = alphabet.find_element(:tag_name, 'a').attribute('href')
    #   alphabet_nation_url_arr << alphabet_url
    # end

    # アルファベットページネーションにアクセスする
    # alphabet_nation_url_arr.each do |alphabet_nation_url|
    #   driver.get(alphabet_nation_url)

    #   # ページネーションを取得する
    #   page_nation_url_list = []
    #   page_nation = driver.find_elements(:css, '#selectedgenre > ul:nth-child(5)')
    #   page_nation.each do |page|
    #     # ページネーションにアクセスする
    #     page_nation_url_list << get_a_tag_href_element(page)
    #   end

    # page_nation_url_list.each do |page_nation_url|
      driver.get(page_nation_url)

      # コンテンツリストを取得する
      contents_list = driver.find_element(:css, '#selectedcontent').find_elements(:tag_name, 'li')
      # コンテンツURLを取得する
      contents_list.each do |content|
        content_url_list << get_a_tag_href_element(content)
      end
    # end
    content_url_list
  end

  # end

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
