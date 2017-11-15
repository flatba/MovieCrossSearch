/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mycompany.moviecrosssearch;

import edu.uci.ics.crawler4j.crawler.Page;
import edu.uci.ics.crawler4j.crawler.WebCrawler;
import edu.uci.ics.crawler4j.parser.HtmlParseData;
import edu.uci.ics.crawler4j.url.WebURL;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;

/**
 * 起動の指示で起動
 * @author flatba
 */
public class myWebCrawler extends WebCrawler  {

	@Override
	public boolean shouldVisit(Page referringPage, WebURL url) {

		// 各記事のURLのみクロール対象とする
		String href  = url.getURL();
		return href.startsWith("http://takezoe.hatenablog.com./entry/"); // URLの頭を指定する

	}

	@Override
	 public void visit( Page page ) {

		String url = page.getWebURL().getURL();
		// 各記事のページの場合のみ処理する
		if ( url.startsWith("http://takezou.hatenablog.com./entry/") ) {
			HtmlParseData data = (HtmlParseData) page.getParseData();

			// ページのHTMLをJsoupでパース
			Document doc = Jsoup.parse(data.getHtml());

			// パースしたdocデータを解析処理に引き渡して項目を取得する
			Scrape scrape = new Scrape();
			scrape.getInformationData(doc);

		}

	  }

}
