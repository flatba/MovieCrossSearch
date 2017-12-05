# coding: utf-8
#
# 解析（情報収集処理）
#
require './crawl.rb'

class Scrape

  # 情報を保存する
  def save_contents(contents)
    puts "情報を保存する"
    # @db.addContentsDB(contents)
  end

  # 情報を取得してcontents（構造体）に入れて返す
  def new_contents(selector, doc, contents)

    # 20171130
    # 細かい情報を取得するよりちゃんと全ての動画コンテンツを舐める流れを作るほうが優先度高い。
    # ので、ここのコンテンツ取得は一旦コメントアウトしておく。

    # 構造体："トップ画像URL", "タイトル", "原題", "公開年", "ジャンル", "時間", "監督", "あらすじ"
    contents = contents.new("", "", "", "", "", "", "", "")

    # データが存在しない場合は処理を飛ばす
    # [DONE]トップ画像
    unless check_contents_item(doc.css(selector.select_selector[:thumbnail]))
      puts contents.thumbnail = doc.css(selector.select_selector[:thumbnail]).attr('src').to_s
    end

    # 映画タイトル
    # unless check_contents_item(doc.css(selector.select_selector[:title]).text)
    #   puts add_contents.title = doc.css(selector.select_selector[:title]).text
    # end

    # 原題
    # crawl.screenshot(@driver) # デバッグ用
    # unless check_contents_item(doc.css(@selector.select_selector[:original_title]))
    #   puts contents.original_title = doc.css(@selector.select_selector[:original_title])
    # end

    # 公開年
    # unless check_contents_item(doc.css(selector.select_selector[:release_year]).text)
    #   release_year_tmp = doc.css(selector.select_selector[:release_year]).text
    #   tail_num = release_year_tmp.rindex('年')
    #   puts contents.release_year = release_year_tmp[tail_num-4..tail_num-1]
    # end

    # ジャンル <= ここ複数項目のためテーブルを切り分けるので、あとで処理を直す必要あり
    # unless check_contents_item(insert_contents.doc.css(@selector.select_selector[:genre]).children)
      # genres = []
      # contents.doc.css(@selector.select_selector[:genre]).children.each do |genre|
      #   genres.push(genre.text)
      # end
      # puts genres
    # end

    # 上映時間
    # unless check_contents_item(doc.css(selector.select_selector[:running_time]).text)
    #   running_time_tmp = doc.css(selector.select_selector[:running_time]).text
    #   tail_num = running_time_tmp.rindex('分')
    #   puts contents.running_time = running_time_tmp[tail_num-3..tail_num].strip
    # end

    # キャスト <= ここ複数項目のためテーブルを切り分けるので、あとで処理を直す必要あり
    # unless check_contents_item(doc.css(@selector.select_selector[:director])[0])
      # casts = []
      # doc.css(@selector.select_selector[:director])[0].each do |cast|
      #   casts.push(cast.text)
      # end
      # puts casts
    # end

    # 監督 <= ここ複数項目のためテーブルを切り分けるので、あとで処理を直す必要あり
    # unless check_contents_item(doc.css(@selector.select_selector[:directors])[2].text.gsub("\\n", "").strip)
    #   # directors = []
    #   contents.directors = doc.css(@selector.select_selector[:directors])[2].text.chomp.strip
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