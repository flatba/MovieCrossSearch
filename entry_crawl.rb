class EntryCrawl

 # attr_reader :base_url, :site_name, :selector, :db, :driver, :wait, :movie_master, :genre_master, :director_master, :cast_master
 attr_reader :base_url, :site_name, :selector, :driver, :wait, :movie_master, :genre_master, :director_master, :cast_master

  # 初期データの生成
  def initialize(url)

    # クロール可能サイトかどうかチェックする
    robotex = Robotex.new
    p robotex.allowed?(url)

    @base_url = url
    @site_name = ""
    @genre_master    = []
    @director_master = []
    @cast_master     = []

  end

  def initialize_selector(site_name)
    @selector = Selector.new(site_name)
  end

  # def initialize_data_base(site_name)
  #   @db = Database.new(site_name)
  # end

  def initialize_movie_master
    @movie_master = Struct.new(:thumbnail, :title, :original_title, :release_year, :running_time, :summary)
  end

  def initialize_driver
    # 通常chrome起動
    # @driver = Selenium::WebDriver.for :chrome

    # HeadressChrome起動
    caps = Selenium::WebDriver::Remote::Capabilities.chrome("chromeOptions" => {binary: '/Applications/Google Chrome Canary.app/Contents/MacOS/Google Chrome Canary', args: ["--headless", "--disable-gpu",  "window-size=1280x800"]})
    @driver = Selenium::WebDriver.for :chrome, desired_capabilities: caps

  end

  # クロールするサイトの名称を判断する
  def check_site_name(url)
    name = ""
    if url.include?('happyon')
      name = 'hulu'
    elsif url.include?('netflix')
      name ='netflix'
    elsif url.include?('Prime-Video')
      name = 'amazon_prime'
    elsif url.include?('Amazon')
      name = 'amazon_video'
    elsif url.include?('gyao')
      name = 'gyao'
    elsif url.include?('dmkt')
      name = 'dtv'
    elsif url.include?('unext')
      name = 'unext'
    elsif url.include?('apple iTunes')
      name = 'apple_itunes'
    elsif url.include?('Microsoft')
      name = 'ms_video'
    elsif url.include?('GooglePlay')
      name = 'googleplay'
    elsif url.include?('mubi')
      name = 'mubi'
    end
    @site_name = name
  end

end