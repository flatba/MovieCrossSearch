# coding: utf-8
#
# 解析（情報収集処理）
#
# require './database.rb'

module Scrape
  include Selector

  # 情報を保存する
  def save_contents(db, contents)
    puts "情報を保存する"
    db.create_contents_DB(contents)
  end



  # 情報を取得して構造体として返す
  def get_contents_struct(selector, doc)

    # [DONE]トップ画像
    unless check_contents_item(doc.css(select_selector[:thumbnail]))
      thumbnail = doc.css(select_selector[:thumbnail]).attr('src').to_s
    else
      thumbnail = ""
    end

    # [DONE]映画タイトル
    unless check_contents_item(doc.css(select_selector[:title]).text)
      title = doc.css(select_selector[:title]).text
    else
      title = ""
    end

    # 原題
    # unless check_contents_item(doc.css(select_selector[:original_title]))
    #   puts original_title = doc.css(select_selector[:original_title])
    # end
    original_title = ""

    # [一旦DONE]公開年 # <= 年で取得できないサイトもあるかもなので要検討
    unless check_contents_item(doc.css(select_selector[:release_year]).text)
      release_year_tmp = doc.css(select_selector[:release_year]).text
      tail_num = release_year_tmp.rindex('年')
      release_year = release_year_tmp[tail_num-4..tail_num-1]
    else
      release_year = ""
    end

    # 上映時間
    # 「時間0分、/ 7分、, 3分」になっている箇所などあり要修正
    unless check_contents_item(doc.css(select_selector[:running_time]).text)
      running_time_tmp = doc.css(select_selector[:running_time]).text
      tail_num = running_time_tmp.rindex('分')
      running_time = running_time_tmp[tail_num-3..tail_num].strip
    else
      running_time = ""
    end

    # あらすじ
    unless check_contents_item(doc.css(select_selector[:summary]))
      summary = doc.css(select_selector[:summary]).text
    else
      summary = ""
    end

    # "トップ画像URL", "タイトル", "原題", "公開年", "時間", "あらすじ"
    movie_info = MovieInfo.new(thumbnail, title, original_title, release_year, running_time, summary)
    return movie_info
  end

  # ジャンル一覧取得
  def create_genre_list(selector, doc)
    genre_list = []
    unless check_contents_item(doc.css(select_selector[:genre]).children)
      doc.css(select_selector[:genre]).children.each do |genre|
        genre_list.push(genre.text)
      end
    end
    return genre_list
  end

  # 監督一覧取得
  def create_director_list(selector, doc)
    director_list = []
    unless check_contents_item(doc.css(select_selector[:director]))
      # ここ未調整のため直す。2監督いる場合に対応する
      doc.css(select_selector[:director]).each do |director|
        director_list.push(director.text)
      end
    end
    return director_list
  end

  # キャスト一覧取得
  def create_cast_list(selector, doc)
    cast_list = []
    unless check_contents_item(doc.css(select_selector[:cast]))
      doc.css(select_selector[:cast]).children.each do |cast|
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


class MovieInfo
  # "トップ画像URL", "タイトル", "原題", "公開年", "時間", "あらすじ"
  attr_accessor :thumbnail, :title, :original_title, :release_year, :running_time, :summary

  def initialize(thumbnail, title, original_title, release_year, running_time, summary)
    @thumbnail = thumbnail,
    @title = title,
    @original_title = original_title,
    @release_year = release_year,
    @running_time = running_time,
    @summary = summary
  end
end