#
# テーブル生成と保存の委譲クラス
#
class DatabaseDelegator
  attr_reader :create_table, :store_table

  def initialize(base_db_creater, base_db_saver)
    check_existence_output_dir
    create_tmp_table_data
    @create_table = base_db_creater
    @store_table = base_db_saver
    delete_tmp_table_data
  end

  def create_tmp_table_data
    # 既に保存してある.dbデータをtmpとしてクローラーを回している最中はバックアップとして避けておく
    # ...
  end

  def delete_tmp_table_data
    # クローラの処理が完了ないし中断したらバックアップをどうこうする処理を書く
    # ...
  end

  # 出力先ディレクトリの有無の確認して無ければ作成する
  def check_existence_output_dir
    unless File.directory?('./db') || File.directory?('./output') || File.directory?('./output/screenshot')
      Dir::mkdir('./db')
      Dir::mkdir('./output')
      Dir::mkdir('./output/screenshot')
    end

    # unless File.directory?('./db/' + site_name)
    #   Dir::mkdir('./db/' + site_name)
    # end
  end

  #
  # メインテーブルの生成
  #
  def create_movie_master_table
    create_table.create_movie_master_table
  end

  def create_streaming_site_master_table
    create_table.create_streaming_site_master_table
  end

  def create_genre_master_table
    create_table.create_genre_master_table
  end

  def create_thumbnail_table
    create_table.create_thumbnail_table
  end

  # def create_director_table
  #   create_table.create_director_table
  # end

  # def create_cast_master_table
  #   create_table.create_cast_master_table
  # end

  def create_category_master_table
    create_table.create_category_master_table
  end

  def create_person_master_table
    create_table.create_person_master_table
  end

  def create_role_master_table
    create_table.create_role_master_table
  end

  def create_review_site_master_table
    create_table.create_review_site_master_table
  end

  #
  # 中間テーブルの生成
  #
  def create_content_table # 旧：create_movie_site_table
    create_table.create_movie_site_table
  end

  def create_movie_genre_table
    create_table.create_movie_genre_table
  end

  def create_movie_thumbnail_table
    create_table.create_movie_thumbnail_table
  end

  # def create_movie_director_table
  #   create_table.create_movie_director_table
  # end

  # def create_movie_cast_table
  #   create_table.create_movie_cast_table
  # end

  def create_movie_category_table
    create_table.create_movie_category_table
  end

  def create_participant_table
    create_table.create_participant_table
  end

  def create_person_role_table
    create_table.create_person_role_table
  end


  #
  # 保存
  #


end
