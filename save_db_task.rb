# coding: utf-8
require 'sqlite3'

#
# 保存処理
#
class SaveDBTask
  #
  # DB生成
  # CREATE TABLE IF NOT EXISTS をすると作成済みのテーブルを作ろうとするエラーを防げます。
  # 回す前にバックアップを生成して、更新が終わったらバックアップは削除する処理でも良いかも
  # ある程度進んだらActiveRecord使ってみたい
  #

  # attr_reader :db

  def initialize(site_name)

    # 出力先ディレクトリの有無の確認して無ければ作成する
    unless File.directory?("./db") || File.directory?("./output") || File.directory?("./output/screenshot")
      Dir::mkdir("./db")
      Dir::mkdir("./output")
      Dir::mkdir("./output/screenshot")
    end

    # movie_master_table（ムービーテーブル）の生成
    output_directory = 'db/' + site_name + '/' + 'movie_master' + '.db'

    unless File.directory?("./db/" + site_name)
      Dir::mkdir("./db/" + site_name)
    end

    @db = SQLite3::Database.new(output_directory)
    @db.execute 'CREATE TABLE IF NOT EXISTS movie_master (
      thumbnail varchar(500),
      title varchar(200),
      original_title varchar(200),
      release_year varchar(200),
      running_time varchar(200),
      summary varchar(200)
      );'

    # cast_table（ジャンルテーブル）の生成
    output_directory = 'db/' + site_name + '/' + 'cast' + '.db'
    @db = SQLite3::Database.new(output_directory)
    @db.execute(
      'CREATE TABLE IF NOT EXISTS genre_master (
        cast varchar(200)
      );'
    )

    # director_tale（監督テーブル）の生成
    output_directory = 'db/' + site_name + '/' + 'director' + '.db'
    @db = SQLite3::Database.new(output_directory)
    @db.execute(
      'CREATE TABLE IF NOT EXISTS director (
        director varchar(200)
      );'
    )

    # director_tale（監督テーブル）の生成
    output_directory = 'db/' + site_name + '/' + 'director' + '.db'
    @db = SQLite3::Database.new(output_directory)
    @db.execute(
      'CREATE TABLE IF NOT EXISTS director (
        movie_id varchar(200),
        genre_id varchar(200)
      );'
    )

    # movie_genre_table（映画とジャンルの紐付け）の生成（中間テーブル）
    output_directory = 'db/' + site_name + '/' + 'movie_genre' + '.db'
    @db = SQLite3::Database.new(output_directory)
    @db.execute(
      'CREATE TABLE IF NOT EXISTS movie_genre_master (
        movie_id varchar(200),
        genre_id varchar(200)
      );'
    )

    # movie_director_table（映画と監督の紐付け）の生成（中間テーブル）
    output_directory = 'db/' + site_name + '/' + 'movie_director' + '.db'
    @db = SQLite3::Database.new(output_directory)
    @db.execute(
      'CREATE TABLE IF NOT EXISTS movie_director_master (
        movie varchar(200),
        director varchar(200)
      );'
    )

    # movie_cast_table（映画と監督の紐付け）の生成（中間テーブル）
    output_directory = 'db/' + site_name + '/' + 'movie_cast' + '.db'
    @db = SQLite3::Database.new(output_directory)
    @db.execute(
      'CREATE TABLE IF NOT EXISTS movie_cast_master (
        movie varchar(200),
        cast varchar(200)
      );'
    )

  end

  #
  # 映画コンテンツの追加
  #
  def create_contents_DB(contents)
    @db.execute "INSERT INTO movie_master (thumbnail,title,original_title,release_year,genres,running_time,director,summary) values ('#{contents.thumbnail}','#{contents.title}','#{contents.original_title}','#{contents.release_year}','#{contents.genres}','#{contents.running_time}','#{contents.director}','#{contents.summary}');"
  end

  #
  # 映画コンテンツの更新
  # レコード探索して、idなどが合致していたら？
  # SELECT * FROM movie_master;
  # @db.execute "SELECT * FROM customer WHERE title=(title);,'#{contents.title}'"
  #
  def update_contents_DB(contents)
    @db.execute "UPDATE movie_master SET title=(title) WHERE title=(title); ,'#{contents.title}'"
  end

  #
  # 映画コンテンツの削除
  #
  def delete_contents_DB(contents)
    @db.execute "DELETE  FROM movie_master WHERE title=(title);,'#{contents.title}'"
  end

  #
  # ジャンルの追加
  #
  def create_genre_DB(genres)
    @db.execute "insert into genre_master (genres) values('#{contents.genres}')"
  end

  #
  # ジャンルの更新
  #
  def update_genre_DB(genres)
    @db.execute "UPDATE genre_master SET genres=(genres) WHERE title=(title); ,'#{genres.name}'"
  end

  #
  # ジャンルの削除
  #
  def delete_genre_DB(genres)
    @db.execute "DELETE  FROM genre_master WHERE genre=(genre);,'#{genres.name}'"
  end

  #
  # データベースの編集終了
  #
  def close_DB_task
    @db.close
  end
end
