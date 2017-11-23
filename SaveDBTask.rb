require 'sqlite3'

class SaveDBTask

  def initialize()
    # DBを初期化してテーブルを作成
    @db = SQLite3::Database.new('scraping.db')
    @db.execute('CREATE TABLE IF NOT EXISTS seminars (title varchar(100), url varchar(200));')
  end

  def saveDBTask(data)

    @db.execute 'INSERT INTO seminars values ( ?, ? );', ["#{a_tag.text}", "#{a_tag[:href]}"]

  end



end