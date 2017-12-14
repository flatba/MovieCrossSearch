/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mycompany.moviecrosssearch;

import edu.uci.ics.crawler4j.crawler.CrawlConfig;
import edu.uci.ics.crawler4j.crawler.CrawlController;
import edu.uci.ics.crawler4j.fetcher.PageFetcher;
import edu.uci.ics.crawler4j.robotstxt.RobotstxtConfig;
import edu.uci.ics.crawler4j.robotstxt.RobotstxtServer;
import java.util.ArrayList;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.jsoup.nodes.Document;

/**
 * スクレイピング（解析）
 * @author flatba
 */
public class Scrape {

	public void getInformationData ( Document doc ) {

		// 記事の内容をHTMLで取得
		//String content = doc.select("div.entry-content").html();

		// selectorの呼び出し
		//Properties prop = new Properties(); まだできてない

		// 各映画から取得する情報をモデルにセットする
		ContentInformationModel cim = new ContentInformationModel();

//		String title = doc.select("a.entry-title-link").text();
                String title = "";
		cim.setTitle(title);			// 映画タイトル

		String originalTitle = doc.title();
		cim.setOriginalTitle(originalTitle);	// 映画原題

		String rereaseYear = doc.title();
		cim.setRereaseDate(rereaseYear);	// 公開年

		String genre = doc.title();
		cim.setGenre(genre);			// ジャンル

		String runningTime = doc.title();
		cim.setRunningTime(runningTime);	// 上映時間

		String director = doc.title();
		cim.setDirector(director);		// 監督

		String summary = doc.select("body > div.vod-frm--user01 > main > div.vod-mod-detail-info02 > div > div.vod-mod-detail-info02__description > div.vod-mod-detail-info02__summary.vod-utl-brief-target.is-brief-opened > div > div.vod-mod-detail-info02__program-description.is-truncated > p").text();
		cim.setSummary(summary);		// あらすじ

		// 取得したデータを保存する
		SaveDBTask sdbt = new SaveDBTask(cim);

	}

}
