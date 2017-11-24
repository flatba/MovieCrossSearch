class Contents

  def initialize() # クラスからオブジェクトを作るときに必ず実行される初期化処理
    # @name = name # @から始まる変数はインスタンス変数という
  end

  # サムネイル画像
  def setThumbnail(thumbnail)
    @thumbnail = thumbnail
  end
  def getThumbnail()
    @thumbnail
  end

  # タイトル
  def setTitle(title)
    @title = title
  end
  def getTitle()
    @title
  end

  # 原題
  def setOriginalTitle(original_title)
    @originalTitle = original_title
  end
  def getOriginalTitle()
    @originalTitle
  end

  # 公開日
  def setReleaseYear(release_year)
    @releaseYear = release_year
  end
  def getReleaseYear()
    @releaseYear
  end

  # ジャンル
  def setGenre(genre)
    @genre = genre
  end
  def getGenre()
    @genre
  end

  # 時間
  def setRunningTime(running_time)
    @runningTime = running_time
  end
  def getRunningTime()
    @runningTime
  end

  # 監督
  def setDirector(director)
    @director = director
  end
  def getDirector()
    @director
  end

  # あらすじ
  def setSummary(summary)
    @summary = summary
  end
  def getSummary()
    @summary
  end

end
