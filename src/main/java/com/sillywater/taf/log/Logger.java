package com.sillywater.taf.log;

import java.io.File;

public class Logger {
	String className = null;
	
	public Logger(Class<?> className){
		this.className = className.getName();
	}
	
	public void log(String message) {
		ContextLogger.getLogger().log("[" + this.className + "] " + message);
	}
	
	public void log(int level, String message) {
		ContextLogger.getLogger().log("[" + this.className + "] " + message, LogLevel.getLogLevel(level));
	}
	
	public void log(LogLevel level, String message) {
		ContextLogger.getLogger().log("[" + this.className + "] " + message, level);
	}
	
	public void log(int level, Exception e) {
		ContextLogger.getLogger().log(e, LogLevel.getLogLevel(level));
	}
	
	public void log(LogLevel level, Exception e) {
		ContextLogger.getLogger().log(e, level);
	}

	public void reportInfo(String message) {
		ContextLogger.getLogger().reportINFO(message);
	}

	public void reportWarn(String message) {
		ContextLogger.getLogger().reportWARN(message);
	}

	public void reportPass(String message) {
		ContextLogger.getLogger().reportPASS(message);
	}

	public void reportFail(String message) {
		ContextLogger.getLogger().reportFAIL(message);
	}
	
	public void assertFail(String message) {
		ContextLogger.getLogger().assertFAIL(message);
	}
	
	public void logScreenshot(File file) {
		ContextLogger.getLogger().logScreenshot(file);
	}
	
	public void logScreenshot(byte[] byteArrray) {
		ContextLogger.getLogger().logScreenshot(byteArrray);
	}
	
	public void logScreenshot(byte[] byteArrray, String fileName) {
		ContextLogger.getLogger().logScreenshot(byteArrray, fileName);
	}
	
	public void pritToConsole(String message, LogLevel level) {
		ContextLogger.getLogger().print("[" + this.className + "] " + message, level);
	}
	
	public void pritToConsole(String message) {
		ContextLogger.getLogger().print("[" + this.className + "] " + message);
	}

	public String getHomeDir() {
		return ContextLogger.getLogger().getHomeDir();
	}
	
	public String getResultDir() {
		return ContextLogger.getLogger().getResultDir();
	}
	
	public String getReportDir() {
		return ContextLogger.getLogger().getReportDir();
	}
}
