# coding: utf-8
#
# UNEXT
#
class UNextRoutine < BaseRoutine

  def start(url, site_name)
    super

    # TODO(flatba): カテゴリURLの取得
    category_url_arr = []
    # ...

    # TODO(flatba): カテゴリにアクセスする
    category_url_arr.each do |category_url|

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