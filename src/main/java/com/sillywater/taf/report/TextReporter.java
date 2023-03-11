package com.sillywater.taf.report;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.PrintWriter;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.testng.ISuite;
import org.testng.ISuiteResult;
import org.testng.ITestResult;
import org.testng.Reporter;

import com.sillywater.taf.base.Configuration;
import com.sillywater.taf.log.Logger;

public class TextReporter implements IReporter {
	private static Logger logger = new Logger(TextReporter.class);

	public void generateReportText(PrintWriter pw, List<ISuite> suites) throws FileNotFoundException {
		for (ISuite suite : suites) {
			generateReportText(pw, suite);
		}
	}

	private void generateReportText(PrintWriter pw, ISuite suite) {
		pw.println("Suite:");
		pw.println("\tName=" + suite.getName());

		Map<String, ISuiteResult> resultMap = suite.getResults();
		for (Map.Entry<String, ISuiteResult> result : resultMap.entrySet()) {
			generateReportText(pw, result);
		}
	}

	private void generateReportText(PrintWriter pw, Map.Entry<String, ISuiteResult> test) {
		pw.println("\tTestset:");
		pw.println("\t\tName=" + test.getKey());
		pw.println("\t\tId=" + test.getKey());
		pw.println("\t\tDuration=" + (test.getValue().getTestContext().getEndDate().getTime()
				- test.getValue().getTestContext().getStartDate().getTime()) / 1000L);

		List<ITestResult> results = new ArrayList<ITestResult>();
		results.addAll(test.getValue().getTestContext().getPassedTests().getAllResults());
		results.addAll(test.getValue().getTestContext().getFailedTests().getAllResults());
		results.addAll(test.getValue().getTestContext().getSkippedTests().getAllResults());
		results.addAll(test.getValue().getTestContext().getFailedButWithinSuccessPercentageTests().getAllResults());

		if (true) {
			@SuppressWarnings({ "unchecked", "rawtypes" })
			Comparator<? super ITestResult> timeComparator = new Comparator() {
				@Override
				public int compare(Object o1, Object o2) {
					ITestResult m1 = (ITestResult) o1;
					ITestResult m2 = (ITestResult) o2;
					try {
						if (Configuration.getConfig().getRunnerProperty("report_sorting_method").toLowerCase()
								.equals("timebased")) {
							return (m1.getStartMillis() > m2.getStartMillis()) ? 1
									: (m1.getStartMillis() < m2.getStartMillis()) ? -1 : 0;
						}
					} catch (Exception e) {
					}
					return m1.getMethod().getMethodName().compareTo(m2.getMethod().getMethodName());
				}
			};
			Collections.sort(results, timeComparator);
		}

		for (ITestResult method : results) {
			generateReportText(pw, method);
		}
	}

	private void generateReportText(PrintWriter pw, ITestResult method) {
		pw.println("\t\tTest:");
		pw.println("\t\t\tName=" + method.getName());
		pw.println("\t\t\tTimestamp=\""
				+ DateFormat.getDateTimeInstance(3, 3, Locale.ENGLISH).format(new Date(method.getStartMillis())));
		
		pw.println("\t\t\tDuration=" + (method.getEndMillis() - method.getStartMillis()) / 1000L);
		pw.println("\t\t\tResult=" + this.getStatusString(method));
		pw.println("\t\t\tDescription=" + ((method.getMethod().getDescription() != null) ? method.getMethod().getDescription()
				: "Not Available"));

		StringBuilder ConvertedLog = new StringBuilder();
		for (String output : Reporter.getOutput(method)) {
			ConvertedLog.append("\t\t\t\t" + output);
			ConvertedLog.append("\n");
		}
		pw.println("\t\t\tOutput:");
		pw.println(ConvertedLog.toString());
		pw.println("\t\t\tTestLogPath=" + (String) method.getAttribute("relateivelogpath"));
		pw.println("\t\t\tTestScreenshotPath=" + (String) method.getAttribute("screenshots"));
		pw.flush();
	}

	private String getStatusString(ITestResult result) {
		switch (result.getStatus()) {
		case ITestResult.CREATED:
			return "created";
		case ITestResult.SUCCESS:
			return "Passed";
		case ITestResult.FAILURE:
			return "Failed";
		case ITestResult.SKIP:
			return "CNR";
		case ITestResult.STARTED:
			return "started";
		case ITestResult.SUCCESS_PERCENTAGE_FAILURE:
			return "Warning";
		default:
			return "unknown";
		}
	}

	private Long getStartTime(List<ISuite> suites) {
		long startTime = Long.MAX_VALUE;
		for (ISuite suite : suites) {
			Long suiteStartTime = this.getStartTime(suite);
			if (startTime > suiteStartTime) {
				startTime = suiteStartTime;
			}
		}
		return startTime;
	}

	private Long getStartTime(ISuite suite) {
		return (Long) suite.getAttribute("start_time");
	}

	private Long getEndTime(List<ISuite> suites) {
		long endTime = Long.MIN_VALUE;
		for (ISuite suite : suites) {
			Long suiteStartTime = this.getEndTime(suite);
			if (endTime < suiteStartTime) {
				endTime = suiteStartTime;
			}
		}
		return endTime;
	}

	private Long getEndTime(ISuite suite) {
		return (Long) suite.getAttribute("end_time");
	}

	@Override
	public void generate(List<ISuite> suites, String logDir, String reportFileName) throws FileNotFoundException {
		long startTime = this.getStartTime(suites);
		long endTime = this.getEndTime(suites);

		SimpleDateFormat df = new SimpleDateFormat("MM/dd/yy HH:mm:ss");
		String starttime = df.format(new Date(startTime));
		String endtime = df.format(new Date(endTime));
		String reportName = logDir + File.separator + reportFileName + ".text";
		StringBuffer config = new StringBuffer();
		for (String key : Configuration.getConfig().getAllTestProperties().keySet()) {
			config.append("\t" + key + "="
					+ Configuration.getConfig().getAllTestProperties().get(key).toString() + "\n");
		}
		PrintWriter pw = new PrintWriter(new FileOutputStream(reportName));
		try {
			pw.println("TestClient=" + InetAddress.getLocalHost().getHostName());
		} catch (UnknownHostException e) {
		}
		pw.println("ReportChartType=" + Configuration.getConfig().getReportChartType());
		pw.println("StartTime=" + starttime);
		pw.println("EndTime=" + endtime);
		pw.println("TotalTime=" + (endTime - startTime) / 1000L );
		pw.println("System Details:");
		pw.println("\tOS=" + System.getProperty("os.name"));
		pw.println("\tOSVersion=" + System.getProperty("os.version"));
		pw.println("\tOSArch=" + System.getProperty("os.arch"));
		pw.println("\tJavaVersion=" + System.getProperty("java.version"));
		pw.println("\tJavaVendor=" + System.getProperty("java.vendor"));

		pw.println("Tester=" + System.getProperty("user.name"));
		pw.println("Config: \n" + config);
		
		generateReportText(pw, suites);
		pw.flush();
		pw.close();
		logger.log("Generated Text report.");
	}
}
