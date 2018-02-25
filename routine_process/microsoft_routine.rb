#
# Microsoft
#
class MicrosoftRoutine < BaseRoutine

  def start(url, site_name)
    super

    # カテゴリURLの取得
    category_url_arr = []

#flatba^ 2017/1/4 [今すぐ購入]の枠内のリンクを取得したが、必要なさそうなのでコメントアウトする
    # category = driver.find_element(:css, '#coreui-contentplacement-3y115ua > div > div:nth-child(1) > div:nth-child(1) > div > div > div > ul').find_elements(:tag_name, 'a')
    # puts category
    # category.each do |element|
    #   category_url_arr << 'https://www.microsoft.com' + element.attribute('href')
    # end
    # puts category_url_arr
#flatba$

    category = driver.find_element(:css, '#coreui-multicolumnlist-qsmv9dd > div > ul').find_elements(:tag_name, 'a')
    category.each do |element|
      category_url_arr << element.attribute('href')
    end
    puts category_url_arr


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