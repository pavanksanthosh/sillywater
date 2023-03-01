package com.sillywater.taf.base;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.TimeZone;

import com.sillywater.taf.log.LogLevel;
import com.sillywater.taf.log.Logger;

public abstract class BaseTest {
	private static Logger logger = new Logger(BaseTest.class);

	public static String getCaseStamp() {
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd_HHmmss");
		dateFormat.setTimeZone(TimeZone.getTimeZone("UTC"));
		return System.getProperty("user.name") + "_" + dateFormat.format(new Date());
	}

	public static void debug(String message) {
		logger.log(LogLevel.DEBUG, message);
	}

	public static void info(String message) {
		logger.log(LogLevel.INFO, message);
	}

	public static void warn(String message) {
		logger.log(LogLevel.WARN, message);
	}

	public static void error(String message) {
		logger.log(LogLevel.ERROR, message);
	}

	public static void fatal(String message) {
		logger.log(LogLevel.FATAL, message);
	}

	public static void debug(Exception e) {
		logger.log(LogLevel.DEBUG, e);
	}

	public static void info(Exception e) {
		logger.log(LogLevel.INFO, e);
	}

	public static void warn(Exception e) {
		logger.log(LogLevel.WARN, e);
	}

	public static void error(Exception e) {
		logger.log(LogLevel.ERROR, e);
	}

	public static void fatal(Exception e) {
		logger.log(LogLevel.FATAL, e);
	}

	public static void reportInfo(String message) {
		logger.reportInfo(message);
	}

	public static void reportWarn(String message) {
		logger.reportWarn(message);
	}

	public static void reportPass(String message) {
		logger.reportPass(message);
	}

	public static void reportFail(String message) {
		logger.reportFail(message);
	}

	public static void assertFail(String message) {
		logger.assertFail(message);
	}
}
