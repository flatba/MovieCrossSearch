require 'sqlite3'

# import classfile
require './Contents.rb'

class SaveDBTask

  def initialize(site_name)
    # DB生成（CREATE TABLE IF NOT EXISTS をすると作成済みのテーブルを作ろうとするエラーを防げます。）
    output_directory = 'output/' + site_name + '.db'
    @db = SQLite3::Database.new(output_directory)
    @db.execute(
      'CREATE TABLE IF NOT EXISTS contents_master (
      thumbnail varchar(200),
      title varchar(200),
      original_title varchar(200),
      release_year varchar(200),
      genre1 varchar(200),
      running_time varchar(200),
      director varchar(200),
      summary varchar(200)
      );'
    )
  end

  def saveDBTask(contents)
    @db.execute(
      "insert into contents_master (
      thumbnail, title, original_title, release_year, genre, running_time, director, summary
      ) values(
      '#{contents.getThumbnail}',
      '#{contents.getTitle}',
      '#{contents.getOriginalTitle}',
      '#{contents.getReleaseYear}',
      '#{contents.getGenre}',
      '#{contents.getRunningTime}',
      '#{contents.getDirector}',
      '#{contents.getSummary}'
    )")
    @db.close
  end
end