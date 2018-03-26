#
#
#
require './scrape/scrape_delegator.rb'
require './scrape/base_scraper.rb'

class HuluScraper
  attr_reader :base

  def initialize(driver, selector)
    @base = ScrapeDelegator.new(BaseScraper.new(driver, selector))
  end

  def run_scrape
    thumbnail_processor
    title_processor
    original_title_processor
    release_year_processor
    running_time_processor
    summary_processor
    poster_image_processor
    genre_processor
    cast_processor
    director_processor
  end

  def thumbnail_processor
    # [DONE]
    thumbnail = base.get_thumbnail

    if check_type(thumbnail)
      puts thumbnail
    else
      #### ↓correction processing↓ ###
      puts thumbnail.attribute('src')
    end
  end

  def title_processor
    # [DONE]
    title = base.get_title

    if check_type(title)
      puts title
    else
      #### ↓correction processing↓ ###
      puts title.text
    end
  end

  def original_title_processor
    # サイトから取得できないので後回し
    original_title = base.get_original_title

    if check_type(original_title)
      puts original_title
    else
      #### ↓correction processing↓ ###
      puts original_title
    end
  end

  def release_year_processor
    release_year_tmp = base.get_release_year.text

    if check_type(release_year_tmp)
      puts release_year_tmp
    else
      #### ↓correction processing↓ ###
      tail = release_year_tmp.rindex('年') - 1
      head = tail - 3
      puts release_year_tmp[head..tail]
    end
  end

  def running_time_processor
    running_time_tmp = base.get_running_time.text

    if check_type(running_time_tmp)
      puts running_time_tmp
    else
      #### ↓correction processing↓ ###
      tail = running_time_tmp.rindex('分') - 1
      head = tail - 3
      running_time_tmp[head..tail].strip
    end
  end

  def summary_processor
    summary = base.get_summary

    if check_type(running_time_tmp)
      puts running_time_tmp
    else
      #### ↓correction processing↓ ###
      puts summary
    end
  end

  def poster_image_processor
    poster_image = base.get_poster_image

    if check_type(running_time_tmp)
      puts running_time_tmp
    else
      #### ↓correction processing↓ ###
      puts poster_image
    end
  end

  def genre_processor
    genre = base.get_genre

    if check_type(running_time_tmp)
      puts running_time_tmp
    else
      #### ↓correction processing↓ ###
      puts genre
    end
  end

  def cast_processor
    cast = base.get_cast

    if check_type(running_time_tmp)
      puts running_time_tmp
    else
      #### ↓correction processing↓ ###
      puts cast
    end
  end

  def director_processor
    director = base.get_director

    if check_type(running_time_tmp)
      puts running_time_tmp
    else
      #### ↓correction processing↓ ###
      puts director
    end
  end

  private

  def check_type(value)
    value.kind_of?(String)
  end

end
