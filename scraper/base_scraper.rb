#
# scrapeの基底クラス（カプセル化）
# cssセレクターのみ対応（xpathには現状対応していない。）
#

class BaseScraper
  attr_reader :driver, :selector

  def initialize(driver, selector)
    @driver = driver
    @selector = selector
  end

  def get_thumbnail
    check_selector_value(selector['common']['thumbnail'])
  end

  def get_title
    check_selector_value(selector['common']['title'])
  end

  def get_original_title
    check_selector_value(selector['common']['original_title'])
  end

  def get_release_year
    check_selector_value(selector['common']['release_year'])
  end

  def get_running_time
    check_selector_value(selector['common']['running_time'])
  end

  def get_summary
    check_selector_value(selector['common']['summary'])
  end

  def get_poster_image
    check_selector_value(selector['common']['poster_image'])
  end

  def get_genre
    check_selector_value(selector['common']['genre'])
  end

  def get_cast
    check_selector_value(selector['common']['cast'])
  end

  def get_director
    check_selector_value(selector['common']['director'])
  end

  def get_classification
    check_selector_value(selector['common']['classification'])
  end

  private

  def check_selector_value(selector_value)
    if selector_value.nil?
      get_error_message(0)
    elsif selector_value.empty?
      get_error_message(1)
    else
      # check_selector_element(driver.find_element(:css, selector_value))
      begin
        driver.find_element(:css, selector_value)
      rescue => e
        # p e
        get_error_message(2)
      end
    end
  end

  # def check_selector_element(element)
  #   begin
  #     element
  #   rescue => e
  #     # p e
  #     get_error_message(2)
  #   end
  # end

  def get_error_message(num)
    # nil?とempty?はrubyのメソッド。blank?とpresent?はrailsで拡張されたメソッド（つまりrubyでは使えない）。
    case num
    when 0 then
      # nil? すべてのオブジェクトに定義されている。nilのときのみtrueを返す。
      'Error Message: selector value is nil.'
    when 1 then
      # empty? 文字列の長さが0のとき、または配列が空のときにTrueを返す。もちろん数値には定義されていない。
      'Error Message: selector value is empty.'
    when 2 then
      # タグ情報が変わったりしてemlementが発見できない場合の例外処理時のエラー文
      'Error Message: Uncaught exception. No such element.'
    end
  end
end
