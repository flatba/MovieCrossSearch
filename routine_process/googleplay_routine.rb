# coding: utf-8
#
#  GooglePlay
#
class GooglePlayRoutine < BaseRoutine

  def start(url, site_name)
    super

    # jsを動作させないと情報を取得できなさそうなのでクリックしておく
    driver.find_element(:css, '#action-dropdown-parent-ジャンル').click

    # カテゴリURLの取得
    category_url_arr = []
    category = driver.find_element(:css, '#action-dropdown-children-ジャンル > div > ul').find_elements(:tag_name, 'a')
    category.each do |element|
      category_url_arr << element.attribute('href')
    end
    puts category_url_arr

    # TODO(flatba): カテゴリにアクセスして、動画情報を取得する
    category_url_arr.each do |category_url|

      # 新規タブを開く

      # 新規タブでcategory_urlを開く

      # 新規タブを開く

      # 動画コンテンツを開く

      # 情報を取得する

      # 取得したらタブを閉じる

    end

  end

end