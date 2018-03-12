#
# GYAO
#
class GyaoCrawler < BaseCrawler
  def start
    super

    # カテゴリURLを取得
    category_url_arr = get_category_list

    # TODO(flatba): カテゴリにアクセスして、動画情報を取得する
    category_url_arr.each do |category_url|
      if category_url.include?('movie')
        open_new_tab(driver) # 新規タブを開く
        driver.get(category_url) # 新規タブでcategory_urlを開く

        content_list_url = driver.find_element(:xpath, '//*[@id="sbox"]/p[2]/a').attribute('href')
        open_new_tab(driver) # 新規タブを開く
        driver.get(content_list_url) # 新規タブでcategory_urlを開く

        # 映画カテゴリのみの表示に切り替える
        genre_movie_url = driver.find_element(:css, '#list_ct_flt > div > ul > li:nth-child(3) > a').attribute('href')
        driver.get(genre_movie_url)

        # 総件数の取得
        page_number = get_page_number

        for num in 1..page_number
          # ページのURLを生成して開く
          list_url = get_page_url(num)
          driver.get(list_url)

          # 詳細表示に切り替える
          driver.find_element(:css, '#list_disp > dl > dd.list_l > a').click
          # 各映画コンテンツのページURLを取得する
          contents_list = driver.find_element(:css, "#list_lst_dtl").find_elements(:class, "mono_wrapper")

          # 動画詳細ページを開く
          contents_list.each do |content|
            url = content.find_element(:tag_name, "a").attribute("href")
            open_new_tab(driver)
            driver.get(url)

            # 情報を取得する
            # ...

            close_new_tab(driver)
            sleep 1
          end

          # 取得したらタブを閉じる
          close_new_tab(driver)
        end
      end
    end
  end

  private

  def get_category_list
    # raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
    category_url_arr = []
    driver.find_elements(:css, '#new_topNav > ul > li').each do |element|
      category_url = element.find_element(:tag_name, 'a').attribute('href')
      category_url_arr << category_url
    end
    category_url_arr
  end

  def get_contents_list
    # raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
  end

  def scrape_content_item_info
    # raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
  end

  def get_page_number
    contents_num_str = driver.find_element(:css, '#pg > div > h3').text
    tail = contents_num_str.index("件") - 1
    contents_num = contents_num_str[0..tail].delete(",").to_i
    contents_num / 20
  end

  def get_page_url(num)
    BASE_PAGE_URL_HEAD = "https://gyao.yahoo.co.jp/list/pg/movie/all/all?dlv=now&title=99&sort=update&rs=down&b="
    BASE_PAGE_URL_HEAD.freeze
    list_url = BASE_PAGE_URL_HEAD + num.to_s
  end
end
