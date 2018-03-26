#
# Scrape
# 各サイトごとに取得した映画情報は、
# 文字列の加工が必要になるので委譲させる形式にする。
#
class ScrapeDelegator
  attr_reader :base

  def initialize(base)
    @base = base
  end

  def get_thumbnail
    base.get_thumbnail
  end

  def get_title
    base.get_title
  end

  def get_original_title
    base.get_original_title
  end

  def get_release_year
    base.get_release_year
  end

  def get_running_time
    base.get_running_time
  end

  def get_summary
    base.get_summary
  end

  def get_poster_image
    base.get_poster_image
  end

  def get_genre
    base.get_genre
  end

  def get_cast
    base.get_cast
  end

  def get_director
    base.get_director
  end

  def get_classification
    base.get_classification
  end
end
