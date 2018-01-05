# coding: utf-8
#
# Microsoft
#
class MicrosoftStructure < BaseStructure

  # attr_reader :crawl, :scrape, :driver, :selector, :movie_master

  # def initialize(url, site_name)

  #   @crawl  = Crawl.new
  #   @scrape = Scrape.new
  #   # @db_task = SaveDBTask.new

  #   @driver       = @crawl.initialize_driver
  #   @selector     = @crawl.initialize_selector(site_name)
  #   @movie_master = @scrape.movie_master
  #   # @movie_master = @scrape.initialize_movie_master # DB処理
  #   # @db           = @db_task.initialize_data_base(site_name)

  #   start(url, site_name)

  # end

  def start(url, site_name)

    # トップページを開く
    driver.get(url)

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

      # 新規タブを開く

      # 新規タブでcategory_urlを開く

      # 新規タブを開く

      # 動画コンテンツを開く

      # 情報を取得する

      # 取得したらタブを閉じる

    end

  end

end