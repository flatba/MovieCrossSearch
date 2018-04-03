#
# 保存処理（保存のSQL文）
# CRUD
#
class BaseSaveTaskDatabase
  # 登録
  def create(instance, table_name, column, value)
    instance.execute "INSERT INTO '#{table_name}' ('#{column}') values ('#{value}');"
  end

  # 参照
  def read_id(instance, table_name, column_name, value)
    record_id = instance.execute "select ROWID from '#{table_name}' where '#{column_name}' = '#{value}';"
    record_id[0]
  end

  # 更新
  def update(instance, table_name, column_name, value)
    instance.execute "UPDATE '#{table_name}' SET title=(title) WHERE title=(title); ,'#{contents.title}'"
  end

  # 削除
  def delete
    # ...
  end

  #
  # 映画コンテンツ
  #
  def create_movie_master_table(instance, item_list)
    instance.execute "INSERT INTO movie_master (thumbnail,title,original_title,release_year,running_time,summary) values ('#{item_list.thumbnail}','#{item_list.title}','#{item_list.original_title}','#{item_list.release_year}','#{item_list.running_time}','#{item_list.summary}');"
  end

  def read_movie_master_item(table_name, column_name, value)
    # 登録したものをtilteで取得
    record_id = @movie_master_table.execute "select ROWID from '#{table_name}' where title = '#{value}';"

    # 登録した最後の情報（全部返ってきちゃう）
    # record_id = @movie_master_table.execute "select * from '#{table}' where ROWID = last_insert_rowid();"
    record_id[0]
  end

  def update_contents_table(contents)
    @movie_master_table.execute "UPDATE movie_master SET title=(title) WHERE title=(title); ,'#{contents.title}'"
  end

  def delete_contents_table(contents)
    @movie_master_table.execute "DELETE  FROM movie_master WHERE title=(title);,'#{contents.title}'"
  end

  #
  # 中間テーブル
  #
  def create_middle_table(instance, table_name, column1, column2, value1, value2)
    instance.execute "INSERT INTO '#{table_name}' ('#{column1}', '#{column2}') values ('#{value1}','#{value2}');"
  end

  #
  # データベースの編集終了
  #
  def close_table_task(instance)
    instance.close
  end

  # def close_table_task_all
  #   @site_master_table.close
  #   @movie_master_table.close
  #   @genre_master_table.close
  #   @director_master_table.close
  #   @cast_master_table.close
  #   @movie_genre_table.close
  #   @movie_director_table.close
  #   @movie_cast_table.close
  # end
end
