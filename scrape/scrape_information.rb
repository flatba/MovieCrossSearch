#
# 解析（情報収集処理）
#
# require './database.rb'
#


class ScrapingInfomation
  include Selector

  attr_reader :driver, :selector

  def initialize(driver, selector)
    @driver = driver
    @selector = selector
  end

  def run
    # 開いているページの情報を取得する
    MovieInfomation.new(
      get_content_information,
      get_genre_information,
      get_cast_information,
      get_director_information
    )
  end

  def get_content_information
    # サムネイルを取得する
    if check_content_info(driver.find_element(:css, selector['common']['thumbnail']))
      thumbnail = driver.find_element(:css, selector['common']['thumbnail'])
    else
      thumbnail = ''
    end

    # タイトルを取得する
    if check_content_info(driver.find_element(:css, selector['common']['title']))
      title = driver.find_element(:css, selector['common']['title'])
    else
      title = ''
    end

    # 原題を取得する
    if check_content_info(driver.find_element(:css, selector['common']['original_title']))
      original_title = driver.find_element(:css, selector['common']['original_title'])
    else
      original_title = ''
    end

    # 公開年を取得する # <= 年で取得できないサイトもあるかもなので要検討
    if check_content_info(driver.find_element(:css, selector['common']['release_year']))
      release_year_tmp = driver.find_element(:css, selector['common']['release_year'])
      tail_num = release_year_tmp.rindex('年')
      release_year = release_year_tmp[tail_num-4..tail_num-1]
    else
      release_year = ''
    end

    # 上映時間を取得する # 「時間0分、/ 7分、, 3分」になっている箇所などあり要修正
    if check_content_info(driver.find_element(:css, selector['common']['running_time']))
      running_time_tmp = driver.find_element(:css, selector['common']['running_time'])
      tail_num = running_time_tmp.rindex('分')
      running_time = running_time_tmp[tail_num-3..tail_num].strip
    else
      running_time = ''
    end

    # あらすじを取得する
    if check_content_info(driver.find_element(:css, selector['common']['summary']))
      summary = driver.find_element(:css, selector['common']['summary'])
    else
      summary = ''
    end

    content_information = {
      'thumbnail' => thumbnail,
      'title' => title,
      'original_title' => original_title,
      'release_year' => release_year,
      'running_time' => running_time,
      'summary' => summary
    }
    content_information
  end

  def get_genre_information
    genre_list =[]
    genre_elements = driver.find_elements(:css, selector['common']['genre'])
    genre_elements.each do |genre|
      genre_list << genre
    end
    genre_list
  end

  def get_cast_information
    cast_list = []
    cast_elements = driver.find_elements(:css, selector['common']['cast'])
    cast_elements.each do |cast|
      cast_list << cast
    end
    cast_list
  end

  def get_director_information
    director_list = []
    director_elements = driver.find_elements(:css, selector['common']['director'])
    director_elements.each do |director|
      director_list << cast
    end
    directorlist
  end

  private
  # 情報取得の項目があるかどうかのチェック（new_contentsメソッドで使用）
  def check_content_info(info)
    if info.empty? || info.nil?
      return false
    end
    true
  end
end

class MovieInfomation
  attr_accessor :thumbnail, :title, :original_title, :release_year, :running_time, :summary, :genre, :cast, :director
  def initialize(content_information, genre, cast, director)
    @thumbnail      = content_information['thumbnail'],
    @title          = content_information['title'],
    @original_title = content_information['original_title'],
    @release_year   = content_information['release_year'],
    @running_time   = content_information['running_time'],
    @summary        = content_information['summary'],
    @genre          = genre,
    @cast           = cast,
    @director       = director
  end
end
