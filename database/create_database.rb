# coding: utf-8
require 'sqlite3'

#
# 保存処理
#
class CreateDatabase
  #
  # DB生成
  # CREATE TABLE IF NOT EXISTS をすると作成済みのテーブルを作ろうとするエラーを防げます。
  # 回す前にバックアップを生成して、更新が終わったらバックアップは削除する処理でも良いかも
  # ある程度進んだらActiveRecord使ってみたい
  #

  # attr_reader :db


# initialize
  def initialize(site_name)

#
# ディレクトリの生成

    # 出力先ディレクトリの有無の確認して無ければ作成する
    unless File.directory?("./db") || File.directory?("./output") || File.directory?("./output/screenshot")
      Dir::mkdir("./db")
      Dir::mkdir("./output")
      Dir::mkdir("./output/screenshot")
    end

    unless File.directory?("./db/" + site_name)
      Dir::mkdir("./db/" + site_name)
    end
#

#
# メインテーブルの生成

    # site_table（取得先サイトのテーブル）の生成
    output_directory = 'db/' + 'site_master' + '.db'
    @site_master_db = SQLite3::Database.new(output_directory)
    @site_master_db.execute 'CREATE TABLE IF NOT EXISTS site_master (
      name varchar(100)
      );'

    # movie_master_table（ムービーテーブル）の生成
    output_directory = 'db/' + 'movie_master' + '.db'
    @movie_master_db = SQLite3::Database.new(output_directory)
    @movie_master_db.execute 'CREATE TABLE IF NOT EXISTS movie_master (
      thumbnail varchar(500),
      title varchar(200),
      original_title varchar(200),
      release_year varchar(200),
      running_time varchar(200),
      summary varchar(500)
      );'

    # genre_table（ジャンルテーブル）の生成
    output_directory = 'db/' + 'genre_master' + '.db'
    @genre_master_db = SQLite3::Database.new(output_directory)
    @genre_master_db.execute(
      'CREATE TABLE IF NOT EXISTS genre_master (
        name varchar(200)
      );'
    )

    # director_tale（監督テーブル）の生成
    output_directory = 'db/' + 'director_master' + '.db'
    @director_master_db = SQLite3::Database.new(output_directory)
    @director_master_db.execute(
      'CREATE TABLE IF NOT EXISTS director_master (
        name varchar(200)
      );'
    )

    # cast_tale（キャストテーブル）の生成
    output_directory = 'db/' + 'cast_master' + '.db'
    @cast_master_db = SQLite3::Database.new(output_directory)
    @cast_master_db.execute(
      'CREATE TABLE IF NOT EXISTS cast_master (
        name varchar(200)
      );'
    )
#

#
# 中間テーブルの生成

  # movie_site_table（映画と取得先サイト名の紐付け）の生成（中間テーブル）
  output_directory = 'db/' + 'movie_site' + '.db'
  @movie_genre_db = SQLite3::Database.new(output_directory)
  @movie_genre_db.execute(
    'CREATE TABLE IF NOT EXISTS movie_genre (
      movie_id varchar(200),
      site_id varchar(200)
    );'
  )

  # movie_genre_table（映画とジャンルの紐付け）の生成（中間テーブル）
  output_directory = 'db/' + 'movie_genre' + '.db'
  @movie_genre_db = SQLite3::Database.new(output_directory)
  @movie_genre_db.execute(
    'CREATE TABLE IF NOT EXISTS movie_genre (
      movie_id varchar(200),
      genre_id varchar(200)
    );'
  )

  # movie_director_table（映画と監督の紐付け）の生成（中間テーブル）
  output_directory = 'db/' + 'movie_director' + '.db'
  @movie_director_db = SQLite3::Database.new(output_directory)
  @movie_director_db.execute(
    'CREATE TABLE IF NOT EXISTS movie_director (
      movie_id varchar(200),
      director_id varchar(200)
    );'
  )

  # movie_cast_table（映画と監督の紐付け）の生成（中間テーブル）
  output_directory = 'db/' + 'movie_cast' + '.db'
  @movie_cast_db = SQLite3::Database.new(output_directory)
  @movie_cast_db.execute(
    'CREATE TABLE IF NOT EXISTS movie_cast (
      movie_id varchar(200),
      cast_id varchar(200)
    );'
  )
#

  end
#


#
# 映画コンテンツ / ジャンル / 監督 / キャスト CRUDでまとめてみる
#

  # 映画情報とサイト名の保存
  def create_site_master_DB(site_name)
    @site_master_db.execute "INSERT INTO movie_master (name) values ('#{site_name}');"
  end

  # サイトidの取得
  def read_site_master_item(table, column_name, item_name)
    record_id = @genre_master_db.execute "select ROWID from '#{table}' where name = '#{item_name}';"
    return record_id[0]
  end


# 映画コンテンツテーブル

  # 映画コンテンツの追加
  def create_movie_master_DB(db, contents)
    @movie_master_db.execute "INSERT INTO movie_master (thumbnail,title,original_title,release_year,running_time,summary) values ('#{contents.thumbnail}','#{contents.title}','#{contents.original_title}','#{contents.release_year}','#{contents.running_time}','#{contents.summary}');"
  end

  # [DONE]映画コンテンツの取得
  def read_movie_master_item(table, column_name, item_name)
    # 登録したものをtilteで取得
    record_id = @movie_master_db.execute "select ROWID from '#{table}' where title = '#{item_name}';"

    # 登録した最後の情報（全部返ってきちゃう）
    # record_id = @movie_master_db.execute "select * from '#{table}' where ROWID = last_insert_rowid();"
    return record_id[0]
  end

  # 映画コンテンツの更新
  # レコード探索して、idなどが合致していたら？
  # SELECT * FROM movie_master;
  # @db.execute "SELECT * FROM customer WHERE title=(title);,'#{contents.title}'"
  def update_contents_DB(contents)
    @movie_master_db.execute "UPDATE movie_master SET title=(title) WHERE title=(title); ,'#{contents.title}'"
  end

  # 映画コンテンツの削除
  def delete_contents_DB(contents)
    @movie_master_db.execute "DELETE  FROM movie_master WHERE title=(title);,'#{contents.title}'"
  end
#

# ジャンルテーブル

  # ジャンルの追加
  def create_genre_master_DB(genre)
    # もし既にあったら登録しない処理を入れる
    @genre_master_db.execute "insert into genre_master (name) values ('#{genre}')"
  end

  # ジャンルの取得
  def read_genre_master_item(table, column_name, item_name)
    record_id = @genre_master_db.execute "select ROWID from '#{table}' where name = '#{item_name}';"
    return record_id[0]
  end

  # ジャンルの更新
  def update_genre_master_DB(db, genres)
    @genre_master_db.execute "UPDATE genre_master SET genres=(genres) WHERE title=(title); ,'#{genres.name}'"
  end

  # ジャンルの削除
  def delete_genre_master_DB(db, genres)
    @genre_master_db.execute "DELETE FROM genre_master WHERE genre=(genre);,'#{genres.name}'"
  end

#

# 監督テーブル

  # 監督の追加
  def create_director_master_DB(db, director)
    # もし既に登録されてたら処理飛ばす処理を入れる
    @director_master_db.execute "insert into director_master (name) values('#{director}')"
  end

  # 監督の取得
  def read_director_master_item(table, column_name, item_name)
    # @director_master_db.execute "SELECT * FROM director_master WHERE column = 'column_name';, '#{column_name}','#{item_name}'"
    record_id = @director_master_db.execute "select ROWID from '#{table}' where name = '#{item_name}';"
    return record_id[0]
  end

  # 監督の更新
  def update_director_master_DB(db, director)
    @director_master_db.execute "UPDATE director_master SET director=(director) WHERE title=(title); ,'#{director}'"
  end

  # 監督の削除
  def delete_director_master_DB(db, director)
    @director_master_db.execute "DELETE  FROM director_master WHERE director=(director);,'#{director}'"
  end

#

# キャストテーブル

  # キャストの追加
  def create_cast_master_DB(db, cast)
    # 既に登録されてたら飛ばす処理入れる
    @cast_master_db.execute "insert into cast_master (name) values('#{cast}')"
  end

  # キャストの取得
  def read_cast_master_item(table, column_name, item_name)
    record_id = @cast_master_db.execute "select ROWID from '#{table}' where name = '#{item_name}';"
    return record_id[0]
  end

  # キャストの更新
  def update_cast_master_DB(db, cast)
    @cast_master_db.execute "UPDATE cast_master SET cast=(cast) WHERE title=(title); ,'#{cast}'"
  end

  # キャストの削除
  def delete_cast_master_DB(db, cast)
    @cast_master_db.execute "DELETE  FROM cast_master WHERE cast=(cast);,'#{cast}'"
  end

#

# 中間テーブル

  # 映画コンテンツ-サイト名の追加
  def create_movie_site_DB(movie_id, site_id)
      @movie_site_db.execute "INSERT INTO movie_genre (movie_id,genre_id) values ('#{movie_id[0]}','#{site_id[0]}');"
  end

  # 映画コンテンツ-ジャンルの追加
  def create_movie_genre_DB(movie_id, genre_id_list)
    genre_id_list.each do |id|
      @movie_genre_db.execute "INSERT INTO movie_genre (movie_id,genre_id) values ('#{movie_id[0]}','#{id[0]}');"
    end
  end

  # 映画コンテンツ-監督の追加
  def create_movie_director_DB(movie_id, director_id_list)
    director_id_list.each do |id|
      @movie_director_db.execute "INSERT INTO movie_director (movie_id,director_id) values ('#{movie_id[0]}','#{id[0]}');"
    end
  end

  # 映画コンテンツ-キャストの追加
  def create_movie_cast_DB(movie_id, cast_id_list)
    cast_id_list.each do |id|
      @movie_cast_db.execute "INSERT INTO movie_cast (movie_id,cast_id) values ('#{movie_id[0]}','#{id[0]}');"
    end
  end

#

# データベースの編集終了

  def close_DB_task
    @site_master_db.close
    @movie_master_db.close
    @genre_master_db.close
    @director_master_db.close
    @cast_master_db.close
    @movie_genre_db.close
    @movie_director_db.close
    @movie_cast_db.close
  end
#
end