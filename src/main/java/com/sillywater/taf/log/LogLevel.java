package com.sillywater.taf.log;

public class LogLevel {
	private final String name;
	private final int value;

	public static final LogLevel FINEST = new LogLevel("FINEST", 0);
	public static final LogLevel FINE = new LogLevel("FINE", 1);
	public static final LogLevel DEBUG = new LogLevel("DEBUG", 2);
	public static final LogLevel INFO = new LogLevel("INFO", 3);
	public static final LogLevel WARN = new LogLevel("WARN", 4);
	public static final LogLevel ERROR = new LogLevel("ERROR", 5);
	public static final LogLevel FATAL = new LogLevel("FATAL", 6);
	public static final LogLevel OFF = new LogLevel("OFF", 7);

	private LogLevel(String name, int value) {
		this.name = name;
		this.value = value;
	}

	public String getName() {
		return this.name;
	}

	public int getLevel() {
		return this.value;
	}

	public static LogLevel getLogLevel(int level){
		switch(level) {
		case 0 :
			return FINEST;
		case 1 :
			return FINE;
		case 2 :
			return DEBUG;
		case 3 :
			return INFO;
		case 4 :
			return WARN;
		case 5 :
			return ERROR;
		case 6 :
			return FATAL;
		case 7 :
			return OFF;
		default: 
			return DEBUG;
		}
	}

	public static LogLevel getLogLevel(String level){
		switch(level) {
		case "finest" :
			return FINEST;
		case "fine" :
			return FINE;
		case "debug" :
			return DEBUG;
		case "info" :
			return INFO;
		case "warn" :
			return WARN;
		case "error" :
			return ERROR;
		case "fatal" :
			return FATAL;
		case "off" :
			return OFF;
		default: 
			return DEBUG;
		}
	}
}

/*public enum LogLevel {
	FINEST(0, "FINEST"),
	FINE(1, "FINE"),
	DEBUG(2, "DEBUG"),
	INFO(4, "INFO"),
	WARN(6, "WARN"),
	ERROR(7, "ERROR"),
	FATAL(8, "FATAL"),
	OFF(10, "OFF");
	
	int value;
	String name;

	private LogLevel(int value, String name) {
		this.value = value;
		this.name = name;
	}
	
	public int getLevel() {
		return this.value;
	}
	
	public String getName() {
		return this.name();
	}
}*/