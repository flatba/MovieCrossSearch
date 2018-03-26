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
    check_value(base.get_thumbnail)
  end

  def get_title
    check_value(base.get_title)
  end

  def get_original_title
    check_value(base.get_original_title)
  end

  def get_release_year
    check_value(base.get_release_year)
  end

  def get_running_time
    check_value(base.get_running_time)
  end

  def get_summary
    check_value(base.get_summary)
  end

  def get_poster_image
    check_value(base.get_poster_image)
  end

  def get_genre
    check_value(base.get_genre)
  end

  def get_cast
    check_value(base.get_cast)
  end

  def get_director
    check_value(base.get_director)
  end

  private

  def check_value(value)
    if value.nil?
      get_error_message(0)
    # elsif value.empty?
    #   get_error_message(1)
    # elsif value.blank?
    #   get_error_message(2)
    else
      value
    end
  end

  def get_error_message(num)
    case num
    when 0 then
      # nil? すべてのオブジェクトに定義されている。nilのときのみtrueを返す。
      'Error Message: value is nil.'
    when 1 then
      # empty? 文字列の長さが0のとき、または配列が空のときにTrueを返す。もちろん数値には定義されていない。
      'Error Message: value is empty.'
    when 2 then
      # blank? railsの拡張。nil, "", " ", [], {} のいずれかでTrueを返す。
      'Error Message: value is blank.'
    end
  end
end
