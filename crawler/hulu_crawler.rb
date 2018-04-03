#
# Hulu
# https://www.happyon.jp/
#
require './scraper/hulu_scraper.rb'
require './database/save_task_database.rb'

class HuluCrawler < BaseCrawler
  def start
    super

    grobal_navi_url_arr = get_grobal_navi_url_arr
    grobal_navi_url_arr.each do |grobal_navi_url|

      if check_grobal_navi_url(grobal_navi_url)
        next
      else
        open_new_tab(driver)
        driver.get(grobal_navi_url)
        open_movie_list_page(grobal_navi_url)
      end

      $LOG.debug('カテゴリ情報の取得')
      puts category_name = driver.find_element(:css, selector['original']['category_name']).text
      $LOG.debug(category_name)

      $LOG.debug('無限スクロール')
      # infinit_scroll(driver, 3)

      $LOG.debug('コンテンツURLの取得')
      contents_url_arr = get_contents_url_arr

      $LOG.debug('コンテンツページ開く')
      contents_url_arr.each do |content_url|
        open_new_tab(driver)
        driver.get(content_url)

        # infinit_scroll(driver, 3) # ページを全て舐める
        begin
          scraper = HuluScraper.new(driver, selector)
          item_list = scraper.run_scrape
        rescue => e
          p e
          $LOG.debug('Error: ' + e.to_s)
          puts 'Error: ' + content_url.to_s
          item_list = 'Error: ' + content_url.to_s
          $LOG.debug('Error: ' + content_url.to_s)
        end
        puts classification_processor(category_name)
        item_list.store(:category_name, category_name)

        $LOG.debug(item_list) # <= ここまで取得できた。

        begin
          task = SaveDatabaseTask.new(item_list)
          task.check_existence_output_dir
          task.create_movie_master_table
          task.movie_master_table
        rescue => e
          puts 'Error: ' + e.to_s
          $LOG.debug('Error: ' + e.to_s)
        end

        close_new_tab(driver)
        sleep 1
      end
      close_new_tab(driver)
    end
  end

  def check_grobal_navi_url(grobal_navi_url)
    flg = false
    flg = true if grobal_navi_url.include?('Ranking')   # ランキング
    flg = true if grobal_navi_url.include?('realtimes') # リアルタイム
    flg = true if grobal_navi_url.include?('features')  # 特集
    flg
  end

  def classification_processor(category_name)
    # true:映画/false:TV（booleanなことに懸念あったけど、どうせジャンル取得しているからどうとでもなりそう。）
    if category_name.include?('洋画')
      true
    elsif category_name.include?('邦画')
      true
    else
      false
    end
  end

  def get_contents_url_arr
    contents_url_arr = []
    contents_list = driver.find_elements(:css, selector['original']['contents_list'])
    contents_list.each do |element|
      contents_url_arr << get_a_tag_href_element(element)
    end
    contents_url_arr
  end

  def open_movie_list_page(url)

    $LOG.debug('ロードが完全に完了するまで待つ')
    sleep 5

    if url.include?('International')
      if url.include?('Series')
        $LOG.debug('すべての海外ドラマ・TV') # <a href="/tiles/422">▼すべての海外ドラマ･TV</a>
        driver.find_element(:css, selector['original']['all_International_Series']).click
        sleep 5
      elsif url.include?('Movies')
        $LOG.debug('すべての洋画') # <a href="/tiles/1039">▼すべての洋画</a>
        driver.find_element(:css, selector['original']['all_International_Movies']).click
        sleep 5
      end

    elsif url.include?('Japanese')
      if url.include?('Series')
        $LOG.debug('すべての国内ドラマ・TV') # <a href="/tiles/424">▼すべての国内ドラマ･TV</a>
        driver.find_element(:css, selector['original']['all_Japanese_Series']).click
        sleep 5
      elsif url.include?('Movies')
        $LOG.debug('すべての邦画') # <a href="/tiles/1041">▼すべての邦画</a>
        driver.find_element(:css, selector['original']['all_Japanese_Movies']).click
        sleep 5
      end

    elsif url.include?('Anime')
      $LOG.debug('すべてのTVアニメシリーズ') # <a href="/tiles/398">▼すべてのTVアニメシリーズ</a>
      driver.find_element(:css, selector['original']['all_Anime']).click
      # すべてのアニメ映画(切り替え処理必要)
      # driver.find_element(:css, selector['original']['all_Anime_Movies']).click

    elsif url.include?('kids')
      $LOG.debug('すべてのKids作品')
      driver.find_element(:css, selector['original']['all_kids']).click
    end
  end

  def get_grobal_navi_url_arr
    grobal_navi_url_arr = []
    grobal_navi_list = driver.find_elements(:css, "body > div.vod-frm--user01 > header > div > div > nav > ul > li")
    grobal_navi_list.each do |element|
      grobal_navi_url_arr << get_a_tag_href_element(element)
    end
    grobal_navi_url_arr
  end
end
