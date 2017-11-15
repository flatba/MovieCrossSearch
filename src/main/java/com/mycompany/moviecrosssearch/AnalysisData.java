/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mycompany.moviecrosssearch;

import java.util.ArrayList;
import org.jsoup.nodes.Document;

/**
 *
 * @author flatba
 */
public class AnalysisData {

	ArrayList<ArrayList> allMovieInfomation;  // アクセスしたコンテンツの映画情報を全て保持するための配列
	ArrayList<String>    eachMovieInfomation; // 各映画情報を一旦格納する配列

	// 各映画から取得する情報項目
	private String title;			// 映画タイトル
	private String originalTitle;	// 映画原題
	private String rereaseDate;		// 公開日
	private String cast;			// キャスト
	private String review;			// （レビュー）
	private String genre;			// ジャンル
	private String runningTime;		// 上映時間
	private String director;		// 監督
	private String summary;			// あらすじ

	public void getInformationData ( Document doc ) {

		title = "";			// 映画タイトル
		originalTitle = "";	// 映画原題
		rereaseDate = "";		// 公開日
		cast = "";			// キャスト
		review = "";			// レビュー
		genre = "";			// ジャンル
		runningTime = "";		// 上映時間
		director = "";		// 監督
		summary = "";			// あらすじ


	}

}
