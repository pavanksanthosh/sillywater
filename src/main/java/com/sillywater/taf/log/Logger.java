package com.sillywater.taf.log;

import java.io.File;

public class Logger {
	String className = null;
	
	public Logger(Class<?> className){
		this.className = className.getName();
	}
	
	public void log(int level, String message) {
		CLogger.getLogger().log("[" + this.className + "] " + message, LogLevel.getLogLevel(level));
	}
	
	public void log(LogLevel level, String message) {
		CLogger.getLogger().log("[" + this.className + "] " + message, level);
	}
	
	public void log(int level, Exception e) {
		CLogger.getLogger().log(e, LogLevel.getLogLevel(level));
	}
	
	public void log(LogLevel level, Exception e) {
		CLogger.getLogger().log(e, level);
	}

	public void reportInfo(String message) {
		CLogger.getLogger().reportINFO(message);
	}

	public void reportWarn(String message) {
		CLogger.getLogger().reportWARN(message);
	}

	public void reportPass(String message) {
		CLogger.getLogger().reportPASS(message);
	}

	public void reportFail(String message) {
		CLogger.getLogger().reportFAIL(message);
	}
	
	public void assertFail(String message) {
		CLogger.getLogger().assertFAIL(message);
	}
	
	public void logScreenshot(File file) {
		CLogger.getLogger().logScreenshot(file);
	}
	
	public void logScreenshot(byte[] byteArrray) {
		CLogger.getLogger().logScreenshot(byteArrray);
	}
	
	public void logScreenshot(byte[] byteArrray, String fileName) {
		CLogger.getLogger().logScreenshot(byteArrray, fileName);
	}
}
