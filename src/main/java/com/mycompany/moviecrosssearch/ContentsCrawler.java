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
import java.util.logging.Level;
import java.util.logging.Logger;
import org.jsoup.nodes.Document;

/**
 * クローラー
 * @author flatba
 */
public class ContentsCrawler {

	static private String user_agent = "Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/1C28 Safari/419.3"; // iOS
	private String charset;
	public String html;

	ArrayList<ArrayList> allMovieInfomation;  // アクセスしたコンテンツの映画情報を全て保持するための配列
	ArrayList<String>    eachMovieInfomation; // 各映画情報を一旦格納する配列

	public void startCrawl (String url) {

		// クロール中のワークデータを格納するディレクトリを指定
		String crawlStorageFolder = "/Users/flatba/dev/output/crawlStorageFolder";

		// クローラーの同時実行数
		int numberOfCrawlers = 1;

		// URLにアクセスする
		CrawlConfig config = new CrawlConfig();

		// 開始URLから何階層先までリンクをたどるか（設定しなければ-1で無制限）
		config.setMaxDepthOfCrawling(1);

		// クローラーのデータを保持するディレクトリ
		config.setCrawlStorageFolder(crawlStorageFolder);

		// ユーザエージェントの指定
		//config.setUserAgentString(user_agent);

		// リクエストの間隔を指定（ミリ秒）
		config.setPolitenessDelay(1000);

		// CrawlControllerを準備する
		PageFetcher pageFecher = new PageFetcher(config);
		RobotstxtConfig robotstxtConfig = new RobotstxtConfig();
		RobotstxtServer robotstxtServer = new RobotstxtServer(robotstxtConfig, pageFecher);
		CrawlController controller;

		try {
                    controller = new CrawlController(config, pageFecher, robotstxtServer);
                    // クロールを開始するURLを指定
                    controller.addSeed(url);
                    // クロールを開始
                    controller.start(myWebCrawler.class, numberOfCrawlers);
		} catch (Exception ex) {
                    //Logger.getLogger(Crawler4j.class.getName()).log(Level.SEVERE, null, ex);
		}

	}


}
