#
#
#
class HuluScraper
  attr_reader :base

  def initialize
    @base = ScrapeDelegator.new(BaseScraper.new)

  end

  def thumbnail_processor
    thumbnail = base.get_thumbnail
    puts thumbnail
    # Selenium形式？文字列そのもの？で返ってくるので加工が必要
    # ... こいつはURLなのでなのでS3に保存する処理とか？
  end

  def title_processor
    title = base.get_title
    puts title
    # Selenium形式？文字列そのもの？で返ってくるので加工が必要
    # ...
  end

  def original_title_processor
    original_title = base.get_original_title
    puts original_title

  end

  def release_year_processor
    release_year_tmp = base.get_release_year
    # Selenium形式？文字列そのもの？で返ってくるので加工が必要
    # ... 下記みたいな感じ

    tail_num = release_year_tmp.rindex('年')
    release_year = release_year_tmp[tail_num-4..tail_num-1]
    return release_year
  end

  def running_time_processor
    running_time = base.get_running_time
    puts running_time
    # Selenium形式？文字列そのもの？で返ってくるので加工が必要
    # ... 下記みたいな感じ
    running_time_tmp = driver.find_element(:css, selector['common']['running_time'])
    tail_num = running_time_tmp.rindex('分')
    running_time = running_time_tmp[tail_num-3..tail_num].strip
    return running_time
  end

  def summary_processor
    summary = base.get_summary
    puts summary
  end

  def poster_image_processor
    poster_image = base.get_poster_image
    puts poster_image
  end

  def genre_processor
    genre = base.get_genre
    puts genre
  end

  def cast_processor
    cast = base.get_cast
    puts cast
  end

  def director_processor
    director = base.get_director
    puts director
  end
end
