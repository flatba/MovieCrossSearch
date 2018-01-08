# coding: utf-8
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

    # ↑カテゴリーURLの取得まで完了↑

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