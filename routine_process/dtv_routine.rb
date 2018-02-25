#
# DTV
#
class DTvRoutine < BaseRoutine

  def start(url, site_name)
    super

    # カテゴリURLを取得
    category_url_arr = []
    category = driver.find_elements(:class, 'sitemap_content')
    # ジャンル別／50音順／作品種別の内、ジャンル別のみ取得するので[0]指定
    category[0].find_element(:class => 'sitemap_list').find_elements(:tag_name, 'a').each do |element|
      category_url = element.attribute('href')
      category_url_arr << category_url
    end
    puts category_url_arr

    # TODO(flatba): カテゴリにアクセスして、動画情報を取得する
    category_url_arr.each do |category_url|

      # 新規タブを開く
      open_new_tab(driver)
      # 新規タブでcategory_urlを開く
      driver.get(category_url)

      # 特定のジャンルは読み込まない
      # if title == 'ニュース'
      #   next
      # end

      # 無限スクロール
      # infinit_scroll(driver, 3) # TODO(flatba):読み込み速度に応じて調整する

      contents_list = driver.find_element(:css, 'body > div.wrapper > main > section > div.titleList_outer')
      contents_list = contents_list.find_elements(:class, 'titleList_card')
      contents_list.each do |content|
        content_url = content.find_element(:class, 'titleCard_link').attribute('href')
        # 新規タブを開く
        open_new_tab(driver)
        # 新規タブでcategory_urlを開く
        driver.get(content_url)

        # TODO(flatba):情報を取得する
        # ...

        # 取得したらタブを閉じる
        close_new_tab(driver)
        sleep 1
      end
    end
  end
end