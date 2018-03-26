#
# Hulu
# https://www.happyon.jp/
#
require './scrape/hulu_scraper.rb'

class HuluCrawler < BaseCrawler
  def start
    super

    grobal_navi_url_arr = get_grobal_navi_url_arr

    grobal_navi_url_arr.each do |grobal_navi_url|
      next if grobal_navi_url.include?('Ranking')   # ランキング
      next if grobal_navi_url.include?('realtimes') # リアルタイム
      next if grobal_navi_url.include?('features')  # 特集

      open_new_tab(driver)
      driver.get(grobal_navi_url)
      open_movie_list_page(grobal_navi_url)

      # 無限スクロール
      # infinit_scroll(driver, 3)

      # コンテンツURLの取得
      contents_url_arr = get_contents_url_arr

      # コンテンツページ開く
      contents_url_arr.each do |content_url|
        open_new_tab(driver)
        driver.get(content_url)

        # TODO(flatba): この構造体が取れるところまでがスクレイピング
        # scrape = ScrapingInfomation.new(driver, selector)
        # scraping_infomation = scrape.run # <= class構造体

        hulu = HuluScraper.new(driver, selector)
        hulu.run_scrape


        close_new_tab(driver)
        sleep 1
      end
      close_new_tab(driver)
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

    sleep 5 # ロードが完全に完了するまで待つようにしたい

    if url.include?('International')
      if url.include?('Series')
        # すべての海外ドラマ・TV
        driver.find_element(:css, selector['original']['all_International_Series']).click
        sleep 5
      elsif url.include?('Movies')
        # すべての洋画
        driver.find_element(:css, selector['original']['all_International_Movies']).click
        sleep 5
      end

    elsif url.include?('Japanese')
      if url.include?('Series')
        # すべての国内ドラマ・TV
        driver.find_element(:css, selector['original']['all_Japanese_Series']).click
        sleep 5
      elsif url.include?('Movies')
        # すべての邦画
        driver.find_element(:css, selector['original']['all_Japanese_Movies']).click
        sleep 5
      end

    elsif url.include?('Anime')
      # すべてのTVアニメシリーズ
      driver.find_element(:css, selector['original']['all_Anime']).click
      # すべてのアニメ映画(切り替え処理必要)
      # driver.find_element(:css, selector['original']['all_Anime_Movies']).click

    elsif url.include?('kids')
      # すべてのKids作品
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
