#
# 継承先で必ず使うメソッドを用意しておく？
#
module Base
  # サブクラスで必ず実装しておいて欲しい。
  def start(url, site_name)
    # envファイルで指定している読み込み開始のトップページを開く
    # 各継承先でsuperで呼び出して実行する
    driver.get(url)
  end

  def get_category_list()
    # raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
  end

  def get_contents_list()
    # raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
  end
end