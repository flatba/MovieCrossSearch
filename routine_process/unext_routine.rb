# coding: utf-8
#
# UNEXT
#
class UNextRoutine < BaseRoutine

  def get_category_list()
    # raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
  end

  def get_contents_list()
    # raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
  end

  def start(url, site_name)
    super

    # サイドバーをクリックする（デフォルトのブラウザサイズだと表示されていないため）
    driver.find_element(:css, "body > div.app-container.js-app-container > header > div.lay-gnav__inner.js-lay-gnav__inner > div > ul > li.gnav__menu--nav > a > span").click

    # TODO(flatba): カテゴリURLの取得
    category_url_arr = []
    category_list = driver.find_element(:css, 'body > div.app-container.js-app-container > header > div.lay-gnav__inner.js-lay-gnav__inner > div > nav > div').find_elements(:class, 'gnav__item')
    category_list.each do |category|
      category_url = category.find_element(:tag_name, 'a').attribute('href')

      # 映画以外のカテゴリだったらページを飛ばす
      # ...

      # TODO(flatba): 映画コンテンツページにアクセスする
      open_new_tab(driver) # 新規タブを開く
      driver.get(category_url) # 新規タブでcategory_urlを開く

      # 動画コンテンツのリストを収集する
      contents_list = driver.find_element(:css, "ここのタグまだ")
      contents_list.each do |content|

        # 動画コンテンツURLを取得する
        content_url = content.find_element(:tag_name, 'a').attribute('href')

        open_new_tab(driver)
        driver.get(content_url)

        # 情報を取得する
        # 取得したらタブを閉じる
        close_new_tab(driver)
        sleep 3
      end
    end
  end
end