#
# scrapeの基底クラス（カプセル化）
# cssセレクターのみ対応（xpathには現状対応していない。）
#
class BaseScraper
  include Selector

  def get_thumbnail
    driver.find_element(:css, selector['common']['thumbnail'])
  end

  def get_title
    driver.find_element(:css, selector['common']['title'])
  end

  def get_original_title
    driver.find_element(:css, selector['common']['original_title'])
  end

  def get_release_year
    driver.find_element(:css, selector['common']['release_year'])
  end

  def get_running_time
    driver.find_element(:css, selector['common']['running_time'])
  end

  def get_summary
    driver.find_element(:css, selector['common']['summary'])
  end

  def get_poster_image
    driver.find_element(:css, selector['common']['poster_image'])
  end

  def get_genre
    driver.find_elements(:css, selector['common']['genre'])
  end

  def get_cast
    driver.find_elements(:css, selector['common']['cast'])
  end

  def get_director
    driver.find_elements(:css, selector['common']['director'])
  end
end
