/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mycompany.moviecrosssearch;

import java.io.IOException;
import java.io.InputStream;
import org.mozilla.universalchardet.UniversalDetector;

/**
 * InputStreamのバイト列から文字コードを推定する
 * @param in 文字コード推定に用いるInputStream
 * @return 推定された文字コード名
 * @throws IOException
 * @author flatba
 */
public class DetectCharsetName {

	public String detectCharsetName( InputStream in ) throws IOException {
		UniversalDetector detector = new UniversalDetector(null);

		int mark;
		byte[] buf = new byte[1024];
		while ( (mark = in.read(buf)) > 0 && !detector.isDone() ) {
			detector.handleData(buf, 0, mark);
		}
		detector.dataEnd();

		return detector.getDetectedCharset();
	}

}
