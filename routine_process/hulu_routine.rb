# coding: utf-8
#
# Hulu（リファクタリング中）
#
class HuluRoutine < BaseRoutine

  # カテゴリURLの取得
  def get_category_list(url)
    category_url_arr = []
    main_doc = open_url(url)
    main_doc.css(select_selector[:category_selector]).each do |element|
      category_url_arr << element.attr('href')
    end
    return category_url_arr
  end

  def get_contents_list
    contents_url_arr = []
    content_elements = driver.find_elements(:css, select_selector[:content_click])
    content_elements.each do |element|
      if element.attribute('href').empty?
        return
      end
      contents_url_arr << element.attribute('href') # URLを取得する
    end
    return contents_url_arr
  end

  def save_content_item(content_url)
# y.hiraba^ 2018/01/09 DB処理を後回しのため、一旦コメントアウト
    # puts "映画コンテンツ情報を取得する"
    # content_doc = open_url(content_url)
    # puts movie_master_contents = get_contents_struct(selector, content_doc)
    # puts genre_list = create_genre_list(selector, content_doc)
    # puts director_list = create_director_list(selector, content_doc)
    # puts cast_list = create_cast_list(selector, content_doc)

    # 映画ページのURLを取得する

    # 保存処理(保存とレコードIDの取得)
    # movie_id = db_task.save_movie_master_contents(@db, movie_master_contents)
    # genre_id_list = db_task.save_genre_master_contents(@db, genre_list)
    # director_id_list = db_task.save_director_master_contents(@db, director_list)
    # cast_id_list = db_task.save_cast_master_contents(@db, cast_list)

    # # 中間テーブル処理① movie_genre
    # db_task.save_movie_genre(@db, movie_id, genre_id_list)
    # # 中間テーブル処理② movie_director
    # db_task.save_movie_director(@db, movie_id, director_id_list)
    # # 中間テーブル処理③ movie_cast
    # db_task.save_movie_cast(@db, movie_id, cast_id_list)
#y.hiraba$
  end

  def get_content_item(contents_url_arr, remenber_current_window_handle)
    contents_url_arr.each do |content_url|
      open_new_tab(driver)
      driver.get(content_url)
      save_content_item(content_url)
      close_new_tab(driver)
      sleep 1
    end
  end

  # 動画コンテンツが無いページへのアクセスをしたら何もしないでタブを閉じる
  def check_having_contents_or_not(url, handle)
    unless url.include?("tiles") then
      close_new_tab(driver)
      return true
    end
    return false
  end

  def crawl_sub_category_routine(more_watch_buttons)
    more_watch_buttons.each do |more_watch_button|
      remenber_current_window_handle = driver.window_handles.last
      more_watch_button.send_keys(:command, :enter) # 新規タブで開く
#flatba^ 20180110 クラス整理のため 修正中
      new_window = driver.window_handles.last
      driver.switch_to.window(new_window)
      driver.window_handle
      # change_current_tab(driver)
#flatba$
      if check_having_contents_or_not(driver.current_url, remenber_current_window_handle)
        next
      end
      sleep 5
#flatba^ 201712005 検証のため一旦コメントアウト
    # infinit_scroll(driver, 3)
#flatba$
      contents_url_arr = []
      get_contents_list().empty? ? next : contents_url_arr = get_contents_list()
      remenber_current_window_handle = driver.window_handles.last
      get_content_item(contents_url_arr, remenber_current_window_handle)
    end
  end

  #
  # main routine
  #
  def start(url, site_name)
    category_url_arr = []
    category_url_arr = get_category_list(url)

    begin
      category_url_arr.each do |category_url|
        # カテゴリーページを開く
        driver.get(category_url)
        # [もっと見る]ボタンを取得してルーチンに引き渡す
        more_watch_buttons = driver.find_elements(:class, 'vod-mod-button')
        crawl_sub_category_routine(more_watch_buttons)
      end
    rescue RuntimeError => e
      print e.message
      $browser.close
    rescue => e
      print e.message + "\n"
    end
  end
end
