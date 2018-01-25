#
# GYAO
#
class GyaoRoutine < BaseRoutine
  def start(url, site_name)
    super

    # カテゴリURLを取得
    category_url_arr = []
    driver.find_elements(:css, '#new_topNav > ul > li').each do |element|
      category_url = element.find_element(:tag_name, 'a').attribute('href')
      category_url_arr << category_url
    end
    puts category_url_arr

    # ↑カテゴリーURLの取得まで完了↑

    # TODO(flatba): カテゴリにアクセスして、動画情報を取得する
    category_url_arr.each do |category_url|
      if category_url.include?('movie')
        open_new_tab(driver) # 新規タブを開く
        driver.get(category_url) # 新規タブでcategory_urlを開く
        open_new_tab(driver) # 新規タブを開く

        # 動画コンテンツリストのURLを取得する？クリックする？
        contents_list = driver.find_element(:css, '#sbox > p.search_list > a').find_element(:tag_name, 'a').attribute('href')
        driver.get(contents_list) # 新規タブでcategory_urlを開く

        # 動画コンテンツ一覧を開く
        driver.find_element(:css, '#list_ct_flt')

        # 動画情報を取得するために、詳細ページのURLを取得する

        # 動画詳細ページを開く（新規タブで開きたくない）

        # 情報を取得する

        # 取得したらタブを閉じる
        close_new_tab(driver)
      end
    end
  end
end
