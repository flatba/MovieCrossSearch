# coding: utf-8
#
# 解析（情報収集処理）
#
require './database.rb'
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
  def create_movie_master_contents(selector, doc, contents)
    # "トップ画像URL", "タイトル", "原題", "公開年", "時間", "あらすじ"

    # [DONE]トップ画像
    unless check_contents_item(doc.css(selector.select_selector[:thumbnail]))
      # contents.thumbnail = doc.css(selector.select_selector[:thumbnail]).attr('src').to_s
      thumbnail = doc.css(selector.select_selector[:thumbnail]).attr('src').to_s
    else
      thumbnail = ""
    end

    # [DONE]映画タイトル
    unless check_contents_item(doc.css(selector.select_selector[:title]).text)
      # contents.title = doc.css(selector.select_selector[:title]).text
      title = doc.css(selector.select_selector[:title]).text
    else
      title = ""
    end

    # 原題
    # unless check_contents_item(doc.css(@selector.select_selector[:original_title]))
    #   puts contents.original_title = doc.css(@selector.select_selector[:original_title])
    # end
    original_title = ""

    # [一旦DONE]公開年 # <= 年で取得できないサイトもあるかもなので要検討
    unless check_contents_item(doc.css(selector.select_selector[:release_year]).text)
      release_year_tmp = doc.css(selector.select_selector[:release_year]).text
      tail_num = release_year_tmp.rindex('年')
      # puts contents.release_year = release_year_tmp[tail_num-4..tail_num-1]
      release_year = release_year_tmp[tail_num-4..tail_num-1]
    else
      release_year = ""
    end

    # 上映時間 # <= 分で取得できないサイトもあるかもなので要検討
    unless check_contents_item(doc.css(selector.select_selector[:running_time]).text)
      running_time_tmp = doc.css(selector.select_selector[:running_time]).text
      tail_num = running_time_tmp.rindex('分')
      # puts contents.running_time = running_time_tmp[tail_num-3..tail_num].strip
      running_time = running_time_tmp[tail_num-3..tail_num].strip
    else
      running_time = ""
    end

    # あらすじ
    unless check_contents_item(doc.css(selector.select_selector[:summary]))
      # contents.summary = doc.css(selector.select_selector[:summary]).text
      summary = doc.css(selector.select_selector[:summary]).text
    else
      summary = ""
    end

    # 例外処理
    # rescue
    #   puts contents
    #   puts driver.current_url + "内で要素がなかったかも"
    #   driver.navigate().back()
    # end

    contents = contents.new(thumbnail, title, original_title, release_year, running_time, summary)

    return contents

  end

  # [DONE]ジャンル一覧取得
  def create_genre_list(selector, doc)
    genre_list = []
    unless check_contents_item(doc.css(selector.select_selector[:genre]).children)
      doc.css(selector.select_selector[:genre]).children.each do |genre|
        genre_list.push(genre.text)
      end
    end
    return genre_list
  end

  # 監督一覧取得
  def create_director_list(selector, doc)
    director_list = []
    unless check_contents_item(doc.css(selector.select_selector[:director]))
      # ここ未調整のため直す。2監督いる場合に対応する
      doc.css(selector.select_selector[:director]).each do |director|
        director_list.push(director.text)
      end
    end
    return director_list
  end

  # キャスト一覧取得
  def create_cast_list(selector, doc)
    cast_list = []
    unless check_contents_item(doc.css(selector.select_selector[:cast]))
      doc.css(selector.select_selector[:cast]).children.each do |cast|
        cast_list.push(cast.text)
      end
      return cast_list
    end
  end


  # # 情報を取得する
  # def get_contents_all(content_url, selector)
  #   puts "情報を取得する"
  #   crawl = Crawl.new
  #   content_doc = crawl.open_url(content_url)
  #   # contents = new_contents(selector, content_doc)
  #   return contents
  # end


  private
  # 情報取得の項目があるかどうかのチェック（new_contentsメソッドで使用）
  def check_contents_item(item)
    if item.empty? || item.nil?
      return true
    end
  end

end