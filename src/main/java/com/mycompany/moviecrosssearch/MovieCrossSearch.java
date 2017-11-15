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
public class MovieCrossSearch {

	static private String url = "http://takezoe.hatenablog.com/";

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {

		// クローラの呼び出しとhtmlのパース
		ContentsCrawler cc = new ContentsCrawler();
		cc.startCrawl(url); // 内部で情報を取得メソッドにパースデータを引き渡し

		// 




    }

}