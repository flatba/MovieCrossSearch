# coding: utf-8
#
# UNEXT
#
class UNextRoutine < BaseRoutine

  def start(url, site_name)

    # トップページを開く
    driver.get(url)

    # TODO(flatba): カテゴリURLの取得
    category_url_arr = []
    # ...

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