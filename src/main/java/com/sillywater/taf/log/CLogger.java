package com.sillywater.taf.log;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.TimeZone;
import java.util.logging.ConsoleHandler;
import java.util.logging.FileHandler;
import java.util.logging.Formatter;
import java.util.logging.LogManager;
import java.util.logging.LogRecord;
import java.util.logging.Logger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.io.FileUtils;
import org.testng.Assert;
import org.testng.ITestClass;
import org.testng.ITestContext;
import org.testng.ITestNGMethod;
import org.testng.ITestResult;
import org.testng.Reporter;

import com.sillywater.taf.base.Configuration;

public class CLogger {
	private static CLogger logger = null;
	protected String home_dir;
	protected static final String log_file = "TestRunner.log";
	protected LogLevel logLevel = LogLevel.FINEST;
	private transient ThreadLocal<HashMap<String, Object>> context = new InheritableThreadLocal<HashMap<String, Object>> ();
	private final int MAX_LOG_SIZE = 1024;

	private CLogger(){
		init();
	}
	
	public static CLogger getLogger() {
		if(logger == null){
			logger = new CLogger();
		}
		try {
			logger.logLevel = LogLevel.getLogLevel(Configuration.getConfig().getRunnerProperty("log_level").toLowerCase());
		} catch (Exception e) {}
		return logger;
	}
	
	private void init() {
		//String date = DateFormat.getDateTimeInstance(DateFormat.DEFAULT,DateFormat.DEFAULT, Locale.ENGLISH).format(new Date());
		this.home_dir = System.getProperty("user.dir");
		try {
			FileUtils.forceDelete(new File(this.getResultDir()));
		} catch(FileNotFoundException e) {			
		} catch (IOException e) {
			System.out.println("[CLogger][init] Unable to delete folder " + home_dir + File.separator + "results");
			e.printStackTrace();
		}
		(new File(this.getResultDir())).mkdirs();
		(new File(this.getReportDir())).mkdirs();
		setupLog(getResultDir() + File.separator + log_file);
	}
	
	private void setupLog(String logFile) {
		try {
			LogManager ign = LogManager.getLogManager();
			ign.reset();
			//ign.readConfiguration(new FileInputStream(this.home_dir + File.separator + "resources" + File.separator + "logging.properties"));
			FileHandler fileHandler = new FileHandler(logFile, 104857600, 10, true);
			//fileHandler.setFormatter(new SimpleFormatter());
			fileHandler.setFormatter(new CFormatter());
			
			ConsoleHandler consHandler = new ConsoleHandler();
			consHandler.setFormatter(new CFormatter());
			
			Logger logger1 = Logger.getLogger("");
			logger1.setUseParentHandlers(false);
			logger1.addHandler(fileHandler);
			logger1.addHandler(consHandler);
			
			Logger logger = Logger.getLogger("stdout");
			LoggingOutputStream los = new LoggingOutputStream(logger);
			System.setOut(new PrintStream(los, true));
			logger = Logger.getLogger("stderr");
			los = new LoggingOutputStream(logger);
			System.setErr(new PrintStream(los, true));
		} catch (Exception e) {
			System.out.println("[CLogger][init] Error during setup log: " + e.getMessage());
		}
	}
	
	public String getHomeDir() {
		return this.home_dir;
	}
	
	public String getResultDir() {
		return this.home_dir + File.separator + "results";
	}
	
	public String getReportDir() {
		return this.getResultDir() + File.separator + "Report";
	}

	protected ITestResult getCurrentResult() {
		return Reporter.getCurrentTestResult();
	}
	
	protected String getLogStamp() {
		SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss.SSS");
		dateFormat.setTimeZone(TimeZone.getTimeZone("UTC"));
		return dateFormat.format(new Date()) + " UTC" + "[Thread:" + Thread.currentThread().getId() + "] - ";
	}
	
	public void print(String message, LogLevel level) {
		if(logLevel.getLevel() > level.getLevel()){
			return;
		}
		System.out.print("[" + level.getName() + "]" + message);
	}

	public void print(String message) {
		this.print(message, LogLevel.INFO);
	}

	/** 
	 * @param message The message to log
	 */
	public void log(String message) {
		log(message, LogLevel.INFO);
	}

	/** 
	 * @param message The message to log
	 */
	public void log(String message, LogLevel level) {
		if(logLevel.getLevel() > level.getLevel()){
			return;
		}
		write("[" + level.getName() + "]" + message);
	}

	/** 
	 * @param Exception The exception to log
	 */
    public void log(Throwable e) {
		if (e == null) {
			return;
		}
		StringWriter sw = new StringWriter();
		e.printStackTrace(new PrintWriter(sw));
		log(sw.toString());
	}
    
    public void log(Throwable e, LogLevel level) {
		if (e == null) {
			return;
		}
		StringWriter sw = new StringWriter();
		e.printStackTrace(new PrintWriter(sw));
		log(sw.toString(), level);
	}
    
    public void logScreenshot(File file) {
    	if(file == null) {
    		return;
    	}
		try {
			FileUtils.copyFile(file, new File(getCurrentScreenShotDir() + File.separator + file.getName()));
		} catch (IOException e) {
			log(e, LogLevel.WARN);
		}		
	}

	public void logScreenshot(byte[] byteArray) {
		if (byteArray == null) {
			return;
		}
		try {
			FileUtils
					.writeByteArrayToFile(
							new File(getCurrentScreenShotDir() + File.separator + "ss_"
									+ (new Date()).toString().replaceAll(":", "_").replaceAll(" ", "_") + ".png"),
							byteArray);
		} catch (IOException e) {
			log(e, LogLevel.WARN);
		}
	}

	public void logScreenshot(byte[] byteArray, String fileName) {
		if (byteArray == null) {
			return;
		}
		try {
			FileUtils.writeByteArrayToFile(new File(getCurrentScreenShotDir() + File.separator + fileName + ".png"),
					byteArray);
		} catch (IOException e) {
			log(e, LogLevel.WARN);
		}
	}

	/**
	 * Log the passed string to the HTML reports
	 * 
	 * @param message The message to log
	 */
	public void logHTML(String message) {
		logHTML(message, LogLevel.INFO);
	}

	/**
	 * Log the passed string to the HTML reports
	 * 
	 * @param message The message to log
	 */
	public void logHTML(String message, LogLevel level) {
		write("[" + level.getName() + "]" + message);
		Reporter.log(message, level.getLevel());
	}
	
	void reportINFO(String message) {
		write("[INFO] " + message);
		//Reporter.log("[INFO]" +message, LogLevel.INFO.getLevel());
		Reporter.log("[INFO] " +message);
	}
	
	void reportPASS(String message) {
		write("[PASS] " + message);
		//Reporter.log("[PASS]" +message, LogLevel.INFO.getLevel());
		Reporter.log("[PASS] " +message);
	}
	
	void reportFAIL(String message) {
		write("[FAIL] " + message);
		Reporter.log("[FAIL] " + message);
		this.setTestStatus(ITestResult.FAILURE);
	}
	
	void assertFAIL(String message) {
		write("[FAIL] " + message);
		//Reporter.log("[FAIL]" + message, LogLevel.ERROR.getLevel());
		//Reporter.log("[FAIL] " + message);
		Assert.fail("[FAIL] " + message);
	}
	
	void reportSKIP(String message) {
		write("[SKIP] " + message);
		Reporter.log("[SKIP] " + message);
		this.setTestStatus(ITestResult.SKIP);
	}
	
	void reportWARN(String message) {
		write("[WARN] " + message);
		Reporter.log("[WARN] " + message);
		this.setTestStatus(ITestResult.SUCCESS_PERCENTAGE_FAILURE);
	}
	
	void reportException(Throwable e) {
		Reporter.log("[EXCEPTION] " +e.getMessage());
		StringWriter sw = new StringWriter();
		e.printStackTrace(new PrintWriter(sw));
		write(sw.toString());
	}

	// ThreadLocal interface
	//--------------------------------------------------------------------------------
	protected ITestNGMethod getContextMethod() {
		HashMap<String, Object> _context = (HashMap<String, Object>) this.context.get();
		return _context == null ? null : (ITestNGMethod) _context.get("method");
	}

	// TODO: Should the type be ICalss? ITestClass implements IClass
	protected ITestClass getContextClass() {
		HashMap<String, Object> _context = (HashMap<String, Object>) this.context.get();
		return _context == null ? null : (ITestClass) _context.get("class");
	}

	protected ITestContext getContextTest() {
		HashMap<String, Object> _context = (HashMap<String, Object>) this.context.get();
		return _context == null ? null : (ITestContext) _context.get("test");
	}

	protected String getContextLogFile() {
		HashMap<String, Object> _context = (HashMap<String, Object>) this.context.get();
		return _context == null ? null : (String) _context.get("logfile");
	}

	protected String getContextLogDir() {
		HashMap<String, Object> _context = (HashMap<String, Object>) this.context.get();
		return _context == null ? null : (String) _context.get("logDir");
	}

	private StringBuilder getContextLog() {
		HashMap<String, Object> _context = (HashMap<String, Object>) this.context.get();
		return _context == null ? null : (StringBuilder) _context.get("log");
	}

	protected String getContextScreenShotsDir() {
		HashMap<String, Object> _context = (HashMap<String, Object>) this.context.get();
		return _context == null ? null : (String) _context.get("screenshots");
	}

	protected void setContextMethod(ITestNGMethod method) {
		this.addToContext("method", method);
	}

	void setContextClass(ITestClass classObj) {
		this.addToContext("class", classObj);
	}

	void setContextTest(ITestContext test) {
		this.addToContext("test", test);
	}

	void setContextLogFile(String logfile) {
		this.addToContext("logfile", logfile);
	}

	void setContextLogDir(String logDir) {
		this.addToContext("logDir", logDir);
	}

	private void setContextLog(StringBuilder log) {
		this.addToContext("log", log);
	}

	void setContextScreenShotsDir(String screenshotsDir) {
		this.addToContext("screenshots", screenshotsDir);
	}
	
	void appendContextLog(String log) {
		if(null == getContextLog()) {
			StringBuilder sb = new StringBuilder();
			sb.append(log);
			addToContext("log", sb);
		}
	}
	
	protected void addToContext(String key, Object value){
        HashMap<String, Object> _context = this.context.get();;
        if(_context == null){
	        _context = new HashMap<String, Object>();
        }
        _context.put(key, value);
        this.context.set(_context);
	}
	
	protected Object getFromContext(String key) {
		return ((HashMap<String, Object>) this.context.get()).get(key);
	}
	
	void clearContext() {
		this.print("Clear Context " + Thread.currentThread().getId(), LogLevel.FINEST);
		this.flushAll();
		this.context.remove();
	}
	
	private boolean isContextEnabled() {
		if(this.getContextTest() == null || this.getContextClass() == null || this.getContextMethod() == null){
			return false;
		}
		return true;
	}
	//--------------------------------------------------------------------------------

	protected synchronized void write(String message) {
		StringBuilder log;
		if (this.isContextEnabled()) {
			log = (this.getContextLog() == null) ? new StringBuilder() : this.getContextLog();
			if (log.append(this.getLogStamp() + message + "\n").length() < this.MAX_LOG_SIZE) {
				this.setContextLog(log);
				return;
			}
			flush(this.getCurrentLogFile(), log.toString());
			this.setContextLog(new StringBuilder());
		} else {
			System.out.print(message);		
		}
	}
	
	private void flush(String logFile, String message) {
        try {
			FileWriter fw = new FileWriter(new File(logFile).getAbsoluteFile(), true);
			fw.write(message);
			fw.close();
		} catch (IOException e) {
			System.out.println("[CLogger][write] Unable to create file " + logFile);
			e.printStackTrace();
			return;
		}
	}
	
	protected void flushAll() {
		if(this.getContextLog() != null && this.getContextLog().length() > 0){
			this.flush(this.getCurrentLogFile(), this.getContextLog().toString());
			this.setContextLog(null);
		}		
	}
	
	private synchronized String getCurrentLogDir() {
		if(!this.isContextEnabled()) {
			return getResultDir();
		}

		if(this.getContextLogDir() != null && !this.getContextLogDir().isEmpty()){
			return this.getContextLogDir();
		}
		
		String testName = this.getContextTest().getName();
		String className = this.getContextClass().getName();
		String methodName = this.getContextMethod().getMethodName();
		
		// Create folder with test name
		String logPath = this.getReportDir() + File.separator + testName;
		if (!new File(logPath).exists()) {
			new File(logPath).mkdir();
		}

		// Create folder with class name
		logPath = logPath + File.separator + className + File.separator + methodName;
		
		for (int index = 1; new File(logPath).exists(); index++) {
			Matcher matcher = Pattern.compile("(\\.\\d+)$").matcher(logPath);
			if (matcher.find()) {
				logPath = logPath.replace(logPath.substring(logPath.lastIndexOf(matcher.group(1)), logPath.length()),
						"." + index);
			} else {
				logPath = logPath + "." + index;
			}
		}
		
		if (!new File(logPath).exists()) {
			new File(logPath).mkdirs();
		}
		this.setContextLogDir(logPath);
		return logPath;
	}
	
	private String getCurrentLogFile() {
		if(!this.isContextEnabled()) {
			return getCurrentLogDir() + File.separator + log_file;
		}

		if(this.getContextLogFile() != null && !this.getContextLogFile().isEmpty()){
			return this.getContextLogFile();
		}
		/*if(!this.isContextEnabled()) {
			return getResultDir() + File.separator + log_file;
		}

		if(this.getContextLogFile() != null && !this.getContextLogFile().isEmpty()){
			return this.getContextLogFile();
		}
		
		String testName = this.getContextTest().getName();
		String className = this.getContextClass().getName();
		String methodName = this.getContextMethod().getMethodName();
		
		// Create folder with test name
		String logPath = this.getReportDir() + File.separator + testName;
		if (!new File(logPath).exists()) {
			new File(logPath).mkdir();
		}

		// Create folder with class name
		logPath = logPath + File.separator + className;
		if (!new File(logPath).exists()) {
			new File(logPath).mkdir();
		}

		// Create the file with method name
		String logFile = logPath + File.separator + methodName + ".log";
		for (int index = 1; new File(logFile).exists(); index++) {
			Matcher matcher = Pattern.compile("(\\.\\d+)$").matcher(logFile);
			if (matcher.find()) {
				logFile = logFile.replace(logFile.substring(logFile.lastIndexOf(matcher.group(1)), logFile.length()),
						"." + index);
			} else {
				logFile = logFile + "." + index;
			}
		}*/
		String logFile = this.getCurrentLogDir() + File.separator + "test.log";
		this.addToContext("relateivelogpath", logFile.substring(this.getReportDir().length() + 1));
		this.setContextLogFile(logFile);
		return logFile;
	}

	private String getCurrentScreenShotDir() {
		if(this.getContextScreenShotsDir() != null && !this.getContextScreenShotsDir().isEmpty()){
			return this.getContextScreenShotsDir();
		}
		String ssDir = getCurrentLogDir() + File.separator + "screenshots";
		if (!new File(ssDir).exists()) {
			new File(ssDir).mkdir();
		}
		this.setContextScreenShotsDir(ssDir);
		return ssDir;
	}

	private static class CFormatter extends Formatter {
		@Override
		public String format(LogRecord record) {
			SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss.SSS");
			dateFormat.setTimeZone(TimeZone.getTimeZone("UTC"));
			return dateFormat.format(new Date(record.getMillis())) + " UTC [Thread:" + record.getThreadID() + "] - "
					+ record.getMessage() + "\n";
		}
	}

	private void setTestStatus(int statusCode) {
		int status = this.getCurrentResult().getStatus();
		if (status == ITestResult.FAILURE) {
			return;
		} else if (statusCode == ITestResult.FAILURE) {
			this.getCurrentResult().setStatus(ITestResult.FAILURE);
		} else if (status == ITestResult.SUCCESS_PERCENTAGE_FAILURE) {
			return;
		} else if (statusCode == ITestResult.SUCCESS_PERCENTAGE_FAILURE) {
			this.getCurrentResult().setStatus(ITestResult.SUCCESS_PERCENTAGE_FAILURE);
		} else if (status == ITestResult.SKIP) {
			return;
		} else if (statusCode == ITestResult.SKIP) {
			this.getCurrentResult().setStatus(ITestResult.SKIP);
		}
		this.getCurrentResult().setStatus(statusCode);
	}
}