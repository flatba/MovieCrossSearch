#
# UNEXT
#
class UNextCrawler < BaseCrawler
  def start
    super # base_routineの呼び出し
    category_list = get_category_list
    get_contents_list(category_list)
  end

  private

  def get_category_list
    # サイドバーをクリックする（デフォルトのブラウザサイズだと表示されていないため）
    driver.find_element(:css, selector['UNEXT']['original']['sidebar_button']).click
    # カテゴリURLの取得
    driver.find_element(:css, selector['UNEXT']['original']['category_list']).find_elements(:class, 'gnav__item')
  end

  def get_contents_list(category_list)
    # raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
    category_list.each do |category|
      category_url = get_a_tag_href_element(category)

      # 映画以外のカテゴリだったらページを飛ばす
      if /(welcome|login|introduction|ranking)/ =~ category_url
        next
      end

      # TODO(flatba): 映画コンテンツページにアクセスする
      open_new_tab(driver) # 新規タブを開く
      puts category_url
      driver.get(category_url) # 新規タブでcategory_urlを開く

      # 全ての作品一覧に切り替え
      driver.find_element(:css, selector['UNEXT']['original']['show_list']).click

      # 無限スクロール
      # TODO(flatba): うまく動作してない
      infinit_scroll(driver, 5)

      # 動画コンテンツのリストを収集する
      contents_list = driver.find_element(:css, selector['UNEXT']['original']['contents_list']).find_elements(:class, 'ui-item-v__link')

      open_movie_page(contents_list)
    end
  end

  def open_movie_page(contents_list)
    contents_list.each do |content|
      # 動画コンテンツURLを取得する
      content_url = content.attribute('href')

      # 新規タブで映画ページを開く
      open_new_tab(driver)
      driver.get(content_url)

      # 情報を取得する
      #scrape_content_info(Content.new)

      # Save to DataBase
      #save_content_info

      # 取得したらタブを閉じる
      close_new_tab(driver)
      sleep 3
    end
  end

  def scrape_content_item_info()
    # ...
    # selector['']['common']['']
  end
end

class Content
  attr_reader :thumbnail, :title, :original_title, :release_year, :running_time, :summary, :genre, :director, :cast
  def initialeze(thumbnail, title, original_title, release_year, running_time, summary, genre, director, cast)
      @thumbnail = thumbnail
      @title = title
      @original_title = original_title
      @release_year = release_year
      @running_time = running_time
      @summary = summary
      @genre = genre
      @director = director
      @cast = cast
  end
end