# coding: utf-8
require 'sqlite3'

#
# 保存処理
#
class SaveDBTask

  #
  # DB生成
  # CREATE TABLE IF NOT EXISTS をすると作成済みのテーブルを作ろうとするエラーを防げます。
  #
  def initialize(site_name)
    # movie_master_table（ムービーテーブル）の生成
    output_directory = 'output/' + site_name + '/' + 'movie_master' + '.db'
    @db = SQLite3::Database.new(output_directory)
    @db.execute(
      'CREATE TABLE IF NOT EXISTS movie_master (
      thumbnail varchar(200),
      title varchar(200),
      original_title varchar(200),
      release_year varchar(200),
      genres varchar(200),
      running_time varchar(200),
      director varchar(200),
      summary varchar(200)
      );'
    )

    # genre_table（ジャンルテーブル）の生成
    output_directory = 'output/' + site_name + '/' + 'genre' + '.db'
    @db = SQLite3::Database.new(output_directory)
    @db.execute(
      'CREATE TABLE IF NOT EXISTS genre_master (
        genres varchar(200)
      );'
    )

    # movie_genre_table（映画とジャンルの紐付け）の生成（中間テーブル）
    output_directory = 'output/' + site_name + '/' + 'movie_genre' + '.db'
    @db = SQLite3::Database.new(output_directory)
    @db.execute(
      'CREATE TABLE IF NOT EXISTS genre_master (
        movie_id varchar(200),
        genre_id varchar(200)
      );'
    )

    # director_tale（監督テーブル）の生成
    output_directory = 'output/' + site_name + '/' + 'director' + '.db'
    @db = SQLite3::Database.new(output_directory)
    @db.execute(
      'CREATE TABLE IF NOT EXISTS genre_master (
        movie_id varchar(200),
        genre_id varchar(200)
      );'
    )

  end

  #
  # 映画コンテンツの追加
  #
  def createContents(contents)
    @db.execute(
      "insert into movie_master (
      thumbnail, title, original_title, release_year, genres, running_time, director, summary
      ) values(
      '#{contents.thumbnail}',
      '#{contents.title}',
      '#{contents.original_title}',
      '#{contents.release_year}',
      '#{contents.genres}',
      '#{contents.running_time}',
      '#{contents.director}',
      '#{contents.summary}'
    )")
  end

  #
  # 映画コンテンツの更新
  #
  def updateContents(contents)
    @db.execute(
      "insert into movie_master (
      thumbnail, title, original_title, release_year, genres, running_time, director, summary
      ) values(
      '#{contents.thumbnail}',
      '#{contents.title}',
      '#{contents.original_title}',
      '#{contents.release_year}',
      '#{contents.genres}',
      '#{contents.running_time}',
      '#{contents.director}',
      '#{contents.summary}'
    )")
  end

  #
  # 映画コンテンツの削除
  #
  def deleteContents(contents)
    @db.execute(
      "insert into movie_master (
      thumbnail, title, original_title, release_year, genres, running_time, director, summary
      ) values(
      '#{contents.thumbnail}',
      '#{contents.title}',
      '#{contents.original_title}',
      '#{contents.release_year}',
      '#{contents.genres}',
      '#{contents.running_time}',
      '#{contents.director}',
      '#{contents.summary}'
    )")
  end

  #
  # ジャンルの追加
  #
  def createGenre(genres)
    @db.execute("insert into genre_master (genres) values('#{contents.genres}')")
  end

  #
  # ジャンルの更新
  #
  def updateGenre(genres)
    # 未編集　コマンドがinsertではない <= あとで編集
    # @db.execute("insert into genre_master (genres) values('#{contents.genres}')")
  end

  #
  # ジャンルの削除
  #
  def deleteGenre(genres)
    # 未編集　コマンドがinsertではない <= あとで編集
    # @db.execute("insert into genre_master (genres) values('#{contents.genres}')")
  end

  #
  # データベースの編集終了
  #
  def closeDBTask
    @db.close
  end
end
