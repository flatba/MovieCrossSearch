#
# 受け取った値を分解して、保存するSQL文を発行するメソッドに渡す
#
class SaveDatabaseTask
  attr_reader :item_list, :db_task

  def initialize(list)
    @item_list = list
    @db_task = DatabaseDelegator.new(BaseCreateDatabase.new, BaseSaveTaskDatabase.new)
  end

  #
  # マスターテーブル
  #
  def movie_master_table
    movie_master_table = create_db.create_movie_master_table
    #### ↓correction processing↓ ####
    create_movie_master_table(movie_master_table, item_list)
  end

  def site_master_table
    site_master_table = db_task.create_site_master_table
    #### ↓correction processing↓ ####
    db_task.create(site_master_table, 'site_master_table', 'title', title)
  end

  def genre_master_table
    genre_master_table = db_task.create_genre_master_table
    #### ↓correction processing↓ ####
    genre = information_list[1]
    db_task.create(genre_master_table, 'site_master_table', 'genre', genre)
  end

  def director_table
    director_master_table = db_task.create_director_table
    #### ↓correction processing↓ ####
    # ...
  end

  def caste_master_table
    cast_master_table = db_task.create_caste_master_table
    #### ↓correction processing↓ ####
    # ...
  end

  def create_category_master_table
    category_master_table = db_task.create_category_master_table
    #### ↓correction processing↓ ####
    # ...
  end

  def create_person_master_table
    person_master_table = db_task.create_person_master_table
    #### ↓correction processing↓ ####
    # ...
  end

  def create_role_master_table
    role_master_table = db_task.create_role_master_table
    #### ↓correction processing↓ ####
    # ...
  end

  def create_review_site_master_table
    review_site_master_table = db_task.create_review_site_master_table
    #### ↓correction processing↓ ####
    # ...
  end


  #
  # 中間テーブル
  #
  def movie_site_table
    movie_site_table = db_task.create_movie_site_table
    #### ↓correction processing↓ ####
    # ...
  end

  def movie_genre_table
    movie_genre_table = db_task.create_movie_genre_table
    #### ↓correction processing↓ ####
    # ...
  end

  # def movie_director_table
  #   movie_director_table = db_task.create_movie_director_table
  # end

  # def movie_cast_table
  #   movie_cast_table = db_task.create_movie_cast_table
  # end

  def create_movie_category_table
    movie_category_table = db_task.create_movie_category_table
    #### ↓correction processing↓ ####
    # ...
  end

  def create_participant_table
    participant_table = db_task.create_participant_table
    #### ↓correction processing↓ ####
    # ...
  end

  def create_person_role_table
    person_role_table = db_task.create_person_role_table
    #### ↓correction processing↓ ####
    # ...
  end




    #
    # 保存処理
    #

      # サイト名称保存
      def save_site_master_contents(db, site_name)
        # DBにサイト名称を保存する
        db.create_movie_master_DB(db, site_name)
        # 保存したサイト名称のレコードIDを取得する
        site_id = db.read_movie_master_item('site_master', 'title', site_name)
        return site_id
      end

      # 映画コンテンツ保存
      def save_movie_master_contents(db, movie_master)
        # DBに映画コンテンツを保存する
        db.create_movie_master_DB(db, movie_master)
        # 保存した映画コンテンツのタイトルに合致するレコードIDを取得する
        movie_id = db.read_movie_master_item('movie_master', 'title', movie_master.title)
        return movie_id
      end

      # ジャンル保存
      def save_genre_master_contents(db, genre_list)
        genre_id_list = []
        genre_list.each do |genre|
          # 保存
          db.create_genre_master_DB(genre)
          # id取得
          genre_id_list << db.read_genre_master_item('genre_master', 'title', genre)
        end
        return genre_id_list
      end

      # 監督保存
      def save_director_master_contents(db, director_list)
        # 保存
        db.create_director_master_DB(db, director_list)
        # idを取得
        director_id_list = []
        director_id_list << db.read_director_master_item("director_master", 'title', director_list)
      end

      # キャスト保存
      def save_cast_master_contents(db, cast_list)
        cast_id_list = []
        cast_list.each do |cast|
          # 保存
          db.create_cast_master_DB(db, cast)
          # idを取得
          cast_id_list << db.read_cast_master_item("cast_master", 'name', cast)
        end
        return cast_id_list
      end
    #

    #
    # 中間テーブル処理
    #

      # 中間テーブル処理０ # 配列なのを直したい
      def save_movie_site(db, movie_id, site_id)
        db.create_movie_site_DB(movie_id, site_id)
      end

      # 中間テーブル処理１ # 配列なのを直したい
      def save_movie_genre(db, movie_id, genre_id_list)
        db.create_movie_genre_DB(movie_id, genre_id_list)
      end

      # 中間テーブル処理２ # 配列なのを直したい
      def save_movie_director(db, movie_id, director_id_list)
        db.create_movie_director_DB(movie_id, director_id_list)
      end

      #中間テーブル処理３ # 配列なのを直したい
      def save_movie_cast(db, movie_id, cast_id_list)
        db.create_movie_cast_DB(movie_id, cast_id_list)
      end

end