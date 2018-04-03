#
# テーブルの生成
#
require 'sqlite3'

class BaseCreateDatabase
  def create_movie_master_table
    output_directory = 'db/' + 'movie_master' + '.db'
    @movie_master_table = SQLite3::Database.new(output_directory)
    @movie_master_table.execute 'CREATE TABLE IF NOT EXISTS movie_master (
      thumbnail varchar(500),
      title varchar(200),
      original_title varchar(200),
      release_year varchar(200),
      running_time varchar(200),
      summary varchar(500)
      );'
    @movie_master_table
  end

  def create_streaming_site_master_table
    output_directory = 'db/' + 'streaming_site_master' + '.db'
    @streaming_site_master_table = SQLite3::Database.new(output_directory)
    @streaming_site_master_table.execute 'CREATE TABLE IF NOT EXISTS streaming_site_master (name varchar(100));'
    @streaming_site_master_table
  end

  def create_genre_master_table
    output_directory = 'db/' + 'genre_master' + '.db'
    @genre_master_table = SQLite3::Database.new(output_directory)
    @genre_master_table.execute(
      'CREATE TABLE IF NOT EXISTS genre_master (
        name varchar(200)
      );'
    )
    @genre_master_table
  end

  def create_thumbnail_master_table
    output_directory = 'db/' + 'thumbnail_master' + '.db'
    @thumbnail_master_table = SQLite3::Database.new(output_directory)
    @thumbnail_master_table.execute(
      'CREATE TABLE IF NOT EXISTS thumbnail_master (
        name varchar(200)
      );'
    )
    @thumbnail_master_table
  end

  def create_director_table
    output_directory = 'db/' + 'director_master' + '.db'
    @director_master_table = SQLite3::Database.new(output_directory)
    @director_master_table.execute(
      'CREATE TABLE IF NOT EXISTS director_master (
        name varchar(200)
      );'
    )
    @director_master_table
  end

  def create_cast_master_table
    output_directory = 'db/' + 'cast_master' + '.db'
    @cast_master_table = SQLite3::Database.new(output_directory)
    @cast_master_table.execute(
      'CREATE TABLE IF NOT EXISTS cast_master (
        name varchar(200)
      );'
    )
    @cast_master_table
  end

  def create_category_master_table
    output_directory = 'db/' + 'category_master' + '.db'
    @category_master_table = SQLite3::Database.new(output_directory)
    @category_master_table.execute(
      'CREATE TABLE IF NOT EXISTS category_master (
        name varchar(200)
      );'
    )
    @category_master_table
  end

  def create_person_master_table
    output_directory = 'db/' + 'person_master' + '.db'
    @person_master_table = SQLite3::Database.new(output_directory)
    @person_master_table.execute(
      'CREATE TABLE IF NOT EXISTS person_master (
        name varchar(200)
      );'
    )
    @person_master_table
  end

  def create_role_master_table
    output_directory = 'db/' + 'role_master' + '.db'
    @role_master_table = SQLite3::Database.new(output_directory)
    @role_master_table.execute(
      'CREATE TABLE IF NOT EXISTS role_master (
        name varchar(200)
      );'
    )
    @role_master_table
  end

  def create_review_site_master_table
    output_directory = 'db/' + 'review_site_master' + '.db'
    @review_site_master_table = SQLite3::Database.new(output_directory)
    @review_site_master_table.execute(
      'CREATE TABLE IF NOT EXISTS review_site_master (
        name varchar(200)
      );'
    )
    @review_site_master_table
  end

  #
  # 中間テーブル
  #
  def create_movie_streaming_site_table
    output_directory = 'db/' + 'movie_site' + '.db'
    @movie_streaming_site_table = SQLite3::Database.new(output_directory)
    @movie_streaming_site_table.execute(
      'CREATE TABLE IF NOT EXISTS movie_streaming_site (
        movie_id varchar(200),
        streaming_site_id varchar(200)
      );'
    )
    @movie_site_table
  end

  def create_movie_genre_table
    output_directory = 'db/' + 'movie_genre' + '.db'
    @movie_genre_table = SQLite3::Database.new(output_directory)
    @movie_genre_table.execute(
      'CREATE TABLE IF NOT EXISTS movie_genre (
        movie_id varchar(200),
        genre_id varchar(200)
      );'
    )
    @movie_genre_table
  end

  def create_movie_thumbnail_table
    output_directory = 'db/' + 'movie_thumbnail' + '.db'
    @movie_thumbnail_table = SQLite3::Database.new(output_directory)
    @movie_thumbnail_table.execute(
      'CREATE TABLE IF NOT EXISTS movie_thumbnail (
        movie_id varchar(200),
        thumbnail_id varchar(200)
      );'
    )
    @movie_thumbnail_table
  end

  def create_movie_director_table
    output_directory = 'db/' + 'movie_director' + '.db'
    @movie_director_table = SQLite3::Database.new(output_directory)
    @movie_director_table.execute(
      'CREATE TABLE IF NOT EXISTS movie_director (
        movie_id varchar(200),
        director_id varchar(200)
      );'
    )
    @movie_director_table
  end

  # def create_movie_cast_table
  #   output_directory = 'db/' + 'movie_cast' + '.db'
  #   @movie_cast_table = SQLite3::Database.new(output_directory)
  #   @movie_cast_table.execute(
  #     'CREATE TABLE IF NOT EXISTS movie_cast (
  #       movie_id varchar(200),
  #       cast_id varchar(200)
  #     );'
  #   )
  #   @movie_cast_table
  # end

  def create_participant_table # 作品関係者
    output_directory = 'db/' + 'participant' + '.db'
    @participant_table = SQLite3::Database.new(output_directory)
    @participant_table.execute(
      'CREATE TABLE IF NOT EXISTS participant (
        movie_id varchar(200),
        person_role_id varchar(200)
      );'
    )
    @participant_table
  end

  def create_evaluation_table
    output_directory = 'db/' + 'evaluation' + '.db'
    @evaluation_table = SQLite3::Database.new(output_directory)
    @evaluation_table.execute(
      'CREATE TABLE IF NOT EXISTS evaluation (
        movie_id varchar(200),
        review_site_id varchar(200),
        value varchar(200)
      );'
    )
    @evaluation_table
  end

  def create_movie_category_table
    output_directory = 'db/' + 'movie_category' + '.db'
    @movie_category_table = SQLite3::Database.new(output_directory)
    @movie_category_table.execute(
      'CREATE TABLE IF NOT EXISTS movie_category (
        movie_id varchar(200),
        category_id varchar(200)
      );'
    )
    @movie_category_table
  end

  def create_person_role_table
    output_directory = 'db/' + 'person_role' + '.db'
    @person_role_table = SQLite3::Database.new(output_directory)
    @person_role_table.execute(
      'CREATE TABLE IF NOT EXISTS person_role (
        person_id varchar(200),
        role_id varchar(200)
      );'
    )
    @person_role_table
  end
end
