#
#
#
require './scraper/scrape_delegator.rb'
require './scraper/base_scraper.rb'

class MubiScraper
  attr_reader :base

  def initialize(driver, selector)
    do_click(driver, selector)
    @base = ScrapeDelegator.new(BaseScraper.new(driver, selector))
  end

  def do_click(driver, selector)
    driver.find_element(:css, selector['original']['detail_button']).click
  end

  def run_scrape
    thumbnail = thumbnail_processor
    title = title_processor
    original_title = original_title_processor
    release_year = release_year_processor
    running_time = running_time_processor
    summary = summary_processor
    poster_image = poster_image_processor
    genre_list = genre_processor
    cast_list = cast_processor
    director_list = director_processor
    # classification_processor
  end

  def thumbnail_processor
    thumbnail = base.get_thumbnail

    if check_type(thumbnail)
      #### ↓correction processing↓ ###
      puts thumbnail.attribute('src')
    end
  end

  def title_processor
    title = base.get_title

    if check_type(title)
      #### ↓correction processing↓ ###
      puts title.text
    end
  end

  def original_title_processor
    # サイトから取得できないので後回し
    original_title = base.get_original_title

    if check_type(original_title)
      #### ↓correction processing↓ ###
      puts original_title
    end
  end

  def release_year_processor
    release_year = base.get_release_year

    if check_type(release_year)
      #### ↓correction processing↓ ###
      release_year = release_year.text
      tail = release_year.rindex('年') - 1
      head = tail - 3
      puts release_year[head..tail]
    end
  end

  def running_time_processor # 単位：分
    running_time = base.get_running_time

    if check_type(running_time)
      #### ↓correction processing↓ ###
      running_time = running_time.text
      tail = running_time.rindex('分') - 1
      head = tail - 1
      puts running_time[head..tail]
    end
  end

  def summary_processor
    summary = base.get_summary

    if check_type(summary)
      #### ↓correction processing↓ ###
      puts summary
    end
  end

  def poster_image_processor
    poster_image = base.get_poster_image

    if check_type(poster_image)
      #### ↓correction processing↓ ###
      puts poster_image
    end
  end

  def genre_processor
    genre = base.get_genre

    if check_type(genre)
      #### ↓correction processing↓ ###
      genre_list = []
      genre.find_elements(:tag_name, 'a').each do |genre_element|
        genre_list << genre_element.text
      end
      puts genre_list
    end
  end

  def cast_processor
    cast = base.get_cast

    if check_type(cast)
      #### ↓correction processing↓ ###
      cast_list = []
      cast.find_elements(:tag_name, 'a').each do |cast_element|
        cast_list << cast_element.text
      end
      puts cast_list
    end
  end

  def director_processor
    director = base.get_director

    if check_type(director)
      #### ↓correction processing↓ ###
      director_list = []
      director.find_elements(:tag_name, 'a').each do |director_element|
        director_list << director_element.text
      end
      puts director_list[0] # <= プロデューサーまで取得できてしまうので一個目の監督のみ返す
    end
  end

  # def classification_processor
  #   # classification = base.get_classification

  #   # true:映画/false:TV
  #   if check_type(classification)
  #     if true
  #       false
  #     end
  #     true
  #   end
  # end

  private

  def check_type(value)
    if value.is_a?(String)
      puts value
    else
      true
    end
  end
end
