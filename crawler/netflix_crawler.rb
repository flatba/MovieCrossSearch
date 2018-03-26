#
# Netflix
#
class NetflixCrawler < BaseCrawler

  attr_reader :crawl, :scrape, :driver, :selector, :movie_master

  # カテゴリURLを取得する
  def get_category_url
    category_url_arr = []
    category = driver.find_element(:class, 'tabbed-primary-navigation')
    category.find_elements(:class, 'navigation-tab').each do |element|
      # puts a_tag.text.strip   # カテゴリ名称
      # puts a_tag.attr('href') # カテゴリURL
      category_url_arr << get_a_tag_href_element(element) # URLを取得する
    end
    category_url_arr
  end

  # ジャンルURLを取得する
  def get_genre_url
    genre_url_arr = []
    genre_list = driver.find_element(:css, selector['original']['genre_list']).find_elements(:tag_name, 'a')
    genre_list.each do |genre|
      puts genre.text
      genre_url_arr << genre.attribute('href')
    end
    genre_url_arr
  end

  # URLからジャンルIDを切り出す
  def get_genre_id(genre_url)
    head = genre_url.rindex('genre/') + ('genre/'.length)
    tail = genre_url.length
    genre_url[head..tail]
  end

  # 読み込もうとしているジャンルidが読み込み済でないかチェックする
  # def check_duplicate_genre_id(genre_url)
    # genre_id = get_genre_id(genre_url)
    # if @genre_id_list.include?(genre_id)
    #   true
    # else
    #   @genre_id_list << genre_id
    # end
  # end

  def save_contents
    # TODO(flatba): 動画情報を取得する
    # ジャンルidが同じ場合は飛ばしても良い
    # ただし、映画一本に複数のジャンルidが紐づくことは考慮する必要あり。
  end

  def show_top_page
    # ログインする
    login(driver, ENV['NETFLIX_LOGIN_ID'], ENV['NETFLIX_LOGIN_PASSWORD'])
    # ログイン後に視聴ユーザーを選択する
    driver.find_element(:xpath, selector['original']['select_user']).click
  end

  #
  # main routine
  #
  def start
    super
    show_top_page
    # カテゴリURLを取得する
    # category_url_arr = []
    category_url_arr = get_category_url

    # カテゴリページを開く
    # begin
    @genre_id_list = [] # クロール中にジャンルidを保持しておいて同じidにアクセスしようとしたら処理を飛ばす
    category_url_arr.each do |category_url|

      # カテゴリではなくトップページならば飛ばす
      if category_url === 'https://www.netflix.com/browse'
        next
      end

      open_new_tab(driver)
      driver.get(category_url)

      # ジャンルをクリックする（クリックしておかないと値を取得できない）
      driver.find_element(:css, selector['original']['genre_button']).click
      # ジャンルにアクセスする
      genre_url_arr = get_genre_url()
      genre_url_arr.each do |genre_url|

        # クロール中に一度でも読み込んだジャンルidは処理を飛ばす
        genre_id = get_genre_id(genre_url)
        if @genre_id_list.include?(genre_id)
          next
        end
        @genre_id_list << genre_id
        open_new_tab(driver)
        driver.get(genre_url)

        # 映画を一覧表示に切り替える
        driver.find_element(:css, selector['original']['show_list']).click
        # 並び順を変えるボタンをクリックする
        driver.find_element(:css, selector['original']['sort_button']).click
        # 公開年でソートするソートするボタンをクリックする
        driver.find_element(:css, selector['original']['sort_display_release_year']).click

# flatba^ 20180116 コンテンツ情報取得のために一旦コメントアウト
        # infinite_scrollを追加して末端まで読み込む
        # infinit_scroll(driver, 3)
        sleep 5 # コンテンツ読み込み待ち（読み込みより先にクリックしてしまう）上記有効化までこれで対応する
# flatba$

        # ジャンル内の映画一覧から各コンテンツページにアクセスする
        gallery_content_list = driver.find_element(:class, 'galleryContent').find_elements(:class, 'rowContainer')
        gallery_content_list.each do |contents|
          contents_list = contents.find_elements(:tag_name, 'a')
          contents_list.each do |content|
            content_link = content.attribute('href')
            p content_link
            head_identifier = 'watch/'
            head_num = content_link.index(head_identifier) + (head_identifier.length)
            # tail_num = content_link.index('?trackId') - 1 # 旧
            tail_num = content_link.length
            content_id = content_link[head_num..tail_num]
            puts content_url = 'https://www.netflix.com/title/' + content_id

            # ページを開く
            open_new_tab(driver)
            driver.get(content_url)

            # TODO(flatba): 動画情報の取得
            # ここで処理をゴニョゴニョ書くよりも、
            # 映画の個別ページが開かれている状態なので、scrapeクラスを呼び出して処理はそっちに任せたほうが良いかも
            # クラスで返してやって、変数に入れておく
            scrape = ScrapingInfomation.new(driver, selector)
            scraping_infomation = scrape.run # <= class構造体

            # TODO(flatba): 取得した動画情報の保存
            # 情報を取得した変数を動画保存クラスを呼び出して渡してやる
            # (仮)SaveInformation.new(scraping_infomation)

            sleep 1
            close_new_tab(driver)
            sleep 1
          end
        end
      end
      close_new_tab(driver)
      sleep 1
    end

    @genre_id_list.clear

    # rescue RuntimeError => e
    #   print e.message
    #   $browser.close
    # rescue => e
    #   print e.message + "\n"
    # end
  end
end
