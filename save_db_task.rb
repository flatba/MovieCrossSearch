
# import classfile
require './database.rb'

class SaveDBTask

    # 保存処理
    #
     # 映画コンテンツ保存
      def save_movie_master_contents(db, movie_master)
        # DBに映画コンテンツを保存する
        db.create_movie_master_DB(db, movie_master)

        # 保存した映画コンテンツのDB上のタイトルのIDを取得する
        # タイトルに合致するIDを取得する
        ここでタイトルが見つからないというを修正する
        movie_id = db.read_movie_master_item(db, "movie_master", title, movie_master.title)

        return movie_id
      end

      # ジャンル保存
      def save_genre_master_contents(db, genre_list)
        genre_id_list = []
        genre_list.each do |item|
          # 保存
          db.create_genre_master_DB(db, item)
          # id取得
          genre_id_list << db.read_movie_master_item(db, "genre_master", title, item)
        end
        return genre_id_list
      end

      # 監督保存
      def save_director_master_contents(db, director_list)
        # 保存
        db.create_director_master_DB(db, director_list)
        # idを取得
        director_id_list = []
        director_id_list << db.read_movie_master_item(db, "genre_master", title, item)
      end

      # キャスト保存
      def save_cast_master_contents(db, cast_list)
        cast_list.each do |item|
          # 保存
          db.create_cast_master_DB(db, item)
          # idを取得
          cast_id_list = []
          cast_id_list << db.read_movie_master_item(db, "genre_master", title, item)
        end
        return cast_id_list
      end
    #

    #
    # 中間テーブル処理
    #
      # 中間テーブル処理①
      def save_movie_genre(db, movie_id, genre_id_list)
        db.create_movie_genre_DB(db, movie_id, genre_id_list)
      end

      # 中間テーブル処理②
      def save_movie_director(db, movie_id, director_id_list)
        db.create_movie_director_DB(db, movie_id, director_id_list)
      end


      #中間テーブル処理③
      def save_movie_cast(db, movie_id, cast_id_list)
        db.create_movie_cast_DB(db, movie_id, cast_id_list)
      end
    #

end