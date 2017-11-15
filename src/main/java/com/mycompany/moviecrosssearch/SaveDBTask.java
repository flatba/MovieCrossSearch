/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mycompany.moviecrosssearch;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author flatba
 */
public class SaveDBTask {

    ContentInformationModel cim;

    SaveDBTask(ContentInformationModel model) {
            cim = new ContentInformationModel();
            cim = model;
    }

    private static Connection conn;
    private static Statement stmt;
//    private static ResultSet rs;

//	private void saveDBSqlite() { // ファイル単体のデバッグ中なのでコメントアウト
    public static void main(String[] args) {

	String outputDBDir = "jdbc:sqlite:" + "/Users/flatba/dev/output/testdatabase/sample.db";

	try {
            Class.forName("org.sqlite.JDBC");
            conn = DriverManager.getConnection(outputDBDir);
            stmt = conn.createStatement();

            //テーブル作成
            stmt.executeUpdate(
                            "create table test1"
                            + "( "
                            + "title string, "
                            + "originalTitle string, "
                            + "rereaseYear integer, "
                            + "genre string, "
                            + "runningTime string, "
                            + "director string, "
                            + "summary text"
                            + ")"
            );

            //値を入力する
            stmt.execute( "insert into test1 values ( 'テストタイトル', '原題', 2017, 'ジャンル', '上映時間', '監督', 'これはあらすじです。' )" );

            //結果を表示する
//            rs = stmt.executeQuery("select * from test1");
//            while(rs.next()) {
//                System.out.println(rs.getString("title"));
//                System.out.println(rs.getInt("originalTitle"));
//                System.out.println(rs.getInt("rereaseYear"));
//                System.out.println(rs.getInt("genre"));
//                System.out.println(rs.getInt("runningTime"));
//                System.out.println(rs.getInt("director"));
//                System.out.println(rs.getInt("summary"));
//            }

            } catch (ClassNotFoundException e) {
                // TODO 自動生成された catch ブロック
                e.printStackTrace();
            } catch (SQLException e) {
                // TODO 自動生成された catch ブロック
                e.printStackTrace();
            } finally {
                if(conn != null) {
                    try {
                        //接続を閉じる
                        conn.close();
                    } catch (SQLException e) {
                        // TODO 自動生成された catch ブロック
                        e.printStackTrace();
                    }
                }
            }
    }

}
