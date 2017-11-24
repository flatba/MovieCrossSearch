require 'sqlite3'

# import classfile
require './Contents.rb'

class SaveDBTask

  def initialize()
    # DBを初期化してテーブルを作成
    @db = SQLite3::Database.new('hulu.db')
    @db.execute(
      'CREATE TABLE IF NOT EXISTS seminars (
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
    # contens.each { |content|
    # ここで詰まってる。複数代入の方法が合っていない。
      @db.execute 'INSERT INTO seminars values ( ?, ?, ?, ?, ?, ?, ?, ? );',
        [
          "#{contents['thumnail']}",
          "#{contents.title}",
          "#{contents.original_title}",
          "#{contents.release_year}",
          "#{contents.genre1}",
          "#{contents.running_time}",
          "#{contents.director}",
          "#{contents.summary}"
        ]
    # }

  end



end