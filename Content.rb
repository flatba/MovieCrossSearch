class Content

  def initialize() # クラスからオブジェクトを作るときに必ず実行される初期化処理
    # @name = name # @から始まる変数はインスタンス変数という
  end

  # サムネイル画像
  def setThumbnail(thumbnail)
    puts "1"
    @thumbnail = thumbnail
  end

  # タイトル
  def setTitle(title)
    @title = title
  end

  # 原題
  def setOriginalTitle(original_title)
    @originalTitle = original_title
  end

  # 公開日
  def setReleaseYear(release_year)
    @releaseYear = release_year
  end

  # ジャンル
  def setGenre(genre)
    @genre = genre
  end

  # 時間
  def setRunningTime(running_time)
    @runningTime = running_time
  end

  # 監督
  def setDirector(director)
    @director = director
  end

  # あらすじ
  def setSummary(summary)
    @summary = summary
  end

end
