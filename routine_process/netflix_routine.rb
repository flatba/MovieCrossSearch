# coding: utf-8
#
# Netflix
#
class NetflixRoutine < BaseRoutine

  attr_reader :crawl, :scrape, :driver, :selector, :movie_master

  # カテゴリURLを取得する
  def get_category_url()
    category_url_arr = []
    category = driver.find_element(:class, 'tabbed-primary-navigation')
    category.find_elements(:class => 'navigation-tab').each do |element|
      # puts a_tag.text.strip   # カテゴリ名称
      # puts a_tag.attr('href') # カテゴリURL
      category_url_arr << element.find_element(:tag_name, 'a').attribute('href') # URLを取得する
    end
    return category_url_arr
  end

  # ジャンルURLを取得する
  def get_genre_url
    genre_url_arr = []
    genre_arr = driver.find_element(:css, '#appMountPoint > div > div > div.pinning-header > div > div.sub-header > div:nth-child(2) > div > div > div.aro-genre-details > div.subgenres > div > div.sub-menu.theme-lakira').find_elements(:tag_name, 'a')
    genre_arr.each do |genre|
      puts genre.text
      genre_url_arr << genre.attribute('href')
    end
    return genre_url_arr
  end

  def start(url, site_name)
    super

    login(url, driver, selector, ENV['NETFLIX_LOGIN_ID'], ENV['NETFLIX_LOGIN_PASSWORD'])

    category_url_arr = []
    category_url_arr = get_category_url()

    # カテゴリページを開く
    begin
    @genre_id_list = [] # 異なるカテゴリーでもidが重複した場合処理を飛ばす
    category_url_arr.each do |category_url|

      # カテゴリではなくトップページならば飛ばす
      if category_url === 'https://www.netflix.com/browse'
        next
      end

      remenber_current_window_handle = open_new_tab_then_move_handle(driver)
      driver.get(category_url)

      # ジャンルをクリックする（クリックしておかないと値を取得できない）
      driver.find_element(:css, '#appMountPoint > div > div > div.pinning-header > div > div.sub-header > div:nth-child(2) > div > div > div.aro-genre-details > div.subgenres > div > div').click

      # ジャンルページを開く
      # remenber_category_window_handle = open_new_tab_then_move_handle(driver)

      genre_url_arr = get_genre_url()
      genre_url_arr.each do |genre_url|

        # 一度でも読み込んだジャンルidは処理を飛ばす
        genre_id = genre_url[genre_url.rindex('genre/')+('genre/'.length)..genre_url.length]
        if @genre_id_list.include?(genre_id)
          puts "next"
          next
        end
        @genre_id_list << genre_id

        driver.get(genre_url)

        # 各ジャンルの動画グループは階層が複雑だが、URIのidのかぶりがある。
        # 別のジャンルに同じidの動画グループがあるので、一度回ったidは記憶しておく必要などして処理を回す必要あり。
        # 基本は全てにアクセスするが、URIのidが同じだったら飛ばす。
        # 時間はかかるが、確実と思う。

        sleep 1
        # 取得処理中はいちいち閉じなくて良いかも。開きっぱなしでURLを開き直す。
      end

      # TODO(flatba): 深いとこに入っていって動画のみの一覧ページまでアクセスする

      # スクロールで読み込めるコンテンツがある場合スクロールする
      # infinit_scroll(driver, 3) # 1ページスクロールするごとに sleep 3 させる

      # TODO(flatba): カテゴリにアクセスして、動画情報を取得する

      close_new_tab(driver, remenber_current_window_handle)
      sleep 1
    end

    @genre_id_list.clear

    rescue RuntimeError => e
      print e.message
      $browser.close
    rescue => e
      print e.message + "\n"
      # close(@hulu_driver, @db)
    end
  end

end
