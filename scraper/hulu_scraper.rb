#
#
#
require './scraper/scrape_delegator.rb'
require './scraper/base_scraper.rb'

class HuluScraper
  attr_reader :base, :driver, :selector

  def initialize(driver, selector)
    do_click
    @base = ScrapeDelegator.new(BaseScraper.new(driver, selector))
    @driver = driver
    @selector = selector
  end

  def do_click
    driver.find_element(:css, selector['original']['detail_button']).click
  end

  def run_scrape
    # information_list = []
    # information_list = {
    #   thumbnail: thumbnail_processor,
    #   title: title_processor,
    #   original_title: original_title_processor,
    #   release_year: release_year_processor,
    #   running_time: running_time_processor,
    #   summary: summary_processor,
    #   poster_image: poster_image_processor,
    #   genre: genre_processor,
    #   cast: cast_processor,
    #   director: director_processor,
    #   url: driver.current_url
    # }
    information_list = []
    information_list << thumbnail_processor
    information_list << title_processor
    information_list << original_title_processor
    information_list << release_year_processor
    information_list << running_time_processor
    information_list << summary_processor
    information_list << poster_image_processor
    information_list << genre_processor
    information_list << cast_processor
    information_list << director_processor
    information_list << driver.current_url
    $LOG.debug(information_list)
    # :classification => classification_processor
    information_list
  end

  def thumbnail_processor
    thumbnail = base.get_thumbnail

    if check_type(thumbnail)
      #### ↓correction processing↓ ###
      puts thumbnail = thumbnail.attribute('src')
      thumbnail
    end
  end

  def title_processor
    title = base.get_title

    if check_type(title)
      #### ↓correction processing↓ ###
      puts title = title.text
      title
    end
  end

  def original_title_processor
    # サイトから取得できないので後回し
    original_title = base.get_original_title

    if check_type(original_title)
      #### ↓correction processing↓ ###
      puts original_title
      original_title
    end
  end

  def release_year_processor
    release_year = base.get_release_year

    if check_type(release_year)
      #### ↓correction processing↓ ###
      release_year = release_year.text
      tail = release_year.rindex('年') - 1
      head = tail - 3
      puts release_year = release_year[head..tail]
      release_year
    end
  end

  def running_time_processor # 単位：分
    running_time = base.get_running_time

    if check_type(running_time)
      #### ↓correction processing↓ ###
      running_time = running_time.text
      tail = running_time.rindex('分') - 1
      head = tail - 1
      puts running_time = running_time[head..tail]
      running_time
    end
  end

  def summary_processor
    summary = base.get_summary

    if check_type(summary)
      #### ↓correction processing↓ ###
      puts summary.text
      summary.text
    end
  end

  def poster_image_processor
    poster_image = base.get_poster_image

    if check_type(poster_image)
      #### ↓correction processing↓ ###
      puts poster_image
      poster_image
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
      genre_list
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
      cast_list
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
      puts director = director_list[0] # <= プロデューサーまで取得できてしまうので一個目の監督のみ返す
      director
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