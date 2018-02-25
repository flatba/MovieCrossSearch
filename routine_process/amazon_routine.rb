#
# Amazon
# prime側で吸収したので、必要なくなるかも。
#
class AmazonRoutine < BaseRoutine

  def start(url, site_name)
    super

    # これのほうが速いかも
    # https://www.amazon.co.jp/gp/search/ref=sr_ex_n_1?rh=n%3A2351649051%2Cp_n_format_browse-bin%3A2792332051&bbn=2351649051&ie=UTF8&qid=1515052675

    # TODO(flatba): カテゴリURLの取得
    category_url_arr = []

    # TODO(flatba): カテゴリにアクセスして、動画情報を取得する
    category_url_arr.each do |category_url|

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