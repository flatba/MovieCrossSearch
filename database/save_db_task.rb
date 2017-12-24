
# import classfile
require './database/create_database.rb'

class SaveDBTask

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

    #

end