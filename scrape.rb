# coding: utf-8
#
# 解析（情報収集処理）
#
require './save_db_task.rb'
require './crawl.rb'


class Scrape

  def initialize
    # 普通にここにdbの初期化入れたほうが良いか？
  end

  # 情報を保存する
  def save_contents(db, contents)
    puts "情報を保存する"
    db.create_contents_DB(contents)
  end

  # 情報を取得してcontents（構造体）に入れて返す
  # データが存在しない場合は処理を飛ばす
  # 旧名：def new_contents(selector, doc, contents)
  def create_movie_master_contents(selector, doc, contents)
    # "トップ画像URL", "タイトル", "原題", "公開年", "時間", "あらすじ"
    contents = contents.new("", "", "", "", "", "", "", "")

    # [DONE]トップ画像
    unless check_contents_item(doc.css(selector.select_selector[:thumbnail]))
      puts contents.thumbnail = doc.css(selector.select_selector[:thumbnail]).attr('src').to_s
    end

    # 映画タイトル
    unless check_contents_item(doc.css(selector.select_selector[:title]).text)
      puts contents.title = doc.css(selector.select_selector[:title]).text
    end

    # 原題
    # crawl.screenshot(@driver) # デバッグ用
    # unless check_contents_item(doc.css(@selector.select_selector[:original_title]))
    #   puts contents.original_title = doc.css(@selector.select_selector[:original_title])
    # end

    # 公開年
    unless check_contents_item(doc.css(selector.select_selector[:release_year]).text)
      release_year_tmp = doc.css(selector.select_selector[:release_year]).text
      tail_num = release_year_tmp.rindex('年') # <= 年で取得できないサイトもあるかもなので要検討
      puts contents.release_year = release_year_tmp[tail_num-4..tail_num-1]
    end



    # 上映時間
    # unless check_contents_item(doc.css(selector.select_selector[:running_time]).text)
    #   running_time_tmp = doc.css(selector.select_selector[:running_time]).text
    #   tail_num = running_time_tmp.rindex('分')
    #   puts contents.running_time = running_time_tmp[tail_num-3..tail_num].strip
    # end





    # あらすじ
    # unless check_contents_item(doc.css(selector.select_selector[:summary]))
    #   contents.summary = doc.css(selector.select_selector[:summary]).text
    # end

    # rescue
    #   puts contents
    #   puts driver.current_url + "内で要素がなかったかも"
    #   driver.navigate().back()
    # end

    return contents

  end

  def

  # ジャンル取得
  def create_genre_list
    unless check_contents_item(insert_contents.doc.css(@selector.select_selector[:genre]).children)
      genre_list = []
      contents.doc.css(@selector.select_selector[:genre]).children.each do |genre|
        genre_list.push(genre.text)
      end
    end
  end

  # 監督一覧取得
  def create_director_list
    unless check_contents_item(doc.css(@selector.select_selector[:directors])[2].text.gsub("\\n", "").strip)
      director_list = []
      # ここ未調整のため直す。2監督いる場合に対応する
      doc.css(@selector.select_selector[:directors])[2].text.chomp.strip
    end
  end

  # キャスト取得
  def create_cast_list(selector, doc, contents)
    unless check_contents_item(doc.css(@selector.select_selector[:director])[0])
      cast_list = []
      doc.css(@selector.select_selector[:director])[0].each do |cast|
        cast_list.push(cast.text)
      end
      puts casts
    end
  end


  # 情報を取得する
  def get_contents_information(content_url, selector)
    puts "情報を取得する"
    crawl = Crawl.new
    content_doc = crawl.open_url(content_url)
    contents = new_contents(selector, content_doc)
    return contents
  end

  private
  # 情報取得の項目があるかどうかのチェック（new_contentsメソッドで使用）
  def check_contents_item(item)
    if item.empty? || item.nil?
      return true
    end
  end

end