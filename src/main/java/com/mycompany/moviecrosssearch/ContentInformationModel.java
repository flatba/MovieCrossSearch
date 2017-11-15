/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mycompany.moviecrosssearch;

/**
 *
 * @author flatba
 */
public class ContentInformationModel {

	// 各映画から取得する情報項目
	private String title;			// 映画タイトル
	private String originalTitle;	// 映画原題
	private String rereaseYear;		// 公開年
	private String genre;			// ジャンル
	private String runningTime;		// 上映時間
	private String director;		// 監督
	private String summary;			// あらすじ

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getOriginalTitle() {
		return originalTitle;
	}

	public void setOriginalTitle(String originalTitle) {
		this.originalTitle = originalTitle;
	}

	public String getRereaseDate() {
		return rereaseYear;
	}

	public void setRereaseDate(String rereaseDate) {
		this.rereaseYear = rereaseDate;
	}

	public String getGenre() {
		return genre;
	}

	public void setGenre(String genre) {
		this.genre = genre;
	}

	public String getRunningTime() {
		return runningTime;
	}

	public void setRunningTime(String runningTime) {
		this.runningTime = runningTime;
	}

	public String getDirector() {
		return director;
	}

	public void setDirector(String director) {
		this.director = director;
	}

	public String getSummary() {
		return summary;
	}

	public void setSummary(String summary) {
		this.summary = summary;
	}

}
