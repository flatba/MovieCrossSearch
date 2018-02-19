# coding: utf-8
#
# UNEXT
#
class UNextRoutine < BaseRoutine

  def start(url, site_name)
    super

    # サイドバーをクリックする（デフォルトのブラウザサイズだと表示されていないため）
    driver.find_element(:css, "body > div.app-container.js-app-container > header > div.lay-gnav__inner.js-lay-gnav__inner > div > ul > li.gnav__menu--nav > a > span").click

    # TODO(flatba): カテゴリURLの取得
    category_url_arr = []
    category_list = driver.find_element(:css, 'body > div.app-container.js-app-container > header > div.lay-gnav__inner.js-lay-gnav__inner > div > nav > div').find_elements(:class, 'gnav__item')
    category_list.each do |category|
      category_url = category.find_element(:tag_name, 'a').attribute('href')

      # TODO(flatba): 映画コンテンツページにアクセスする
      open_new_tab(driver)
      driver.get(category_url)

      # 新規タブを開く

      # 新規タブでcategory_urlを開く

      # 新規タブを開く

      # 動画コンテンツを開く

      # 情報を取得する

      # 取得したらタブを閉じる

    end

  end

end