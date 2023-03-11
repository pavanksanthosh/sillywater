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

public class XMLReporter implements IReporter {
	private static Logger logger = new Logger(XMLReporter.class);

	public void generateReportXml(PrintWriter pw, List<ISuite> suites) throws FileNotFoundException {	
		pw.println("<suites>");
		pw.println("<name>" + "TEST SUITES" + "</name>");
		for (ISuite suite : suites) {
			generateReportXml(pw, suite);
		}
		pw.println("</suites>");
	}

	private void generateReportXml(PrintWriter pw, ISuite suite) {
		pw.println("<suite>");
		pw.println("<name>" + suite.getName() + "</name>");

		Map<String, ISuiteResult> resultMap = suite.getResults();
		for (Map.Entry<String, ISuiteResult> result : resultMap.entrySet()) {
			generateReportXml(pw, result);
		}
		pw.println("</suite>");
	}

	private void generateReportXml(PrintWriter pw, Map.Entry<String, ISuiteResult> test) {
		pw.println("<testset>");
		pw.println("<name>" + test.getKey() + "</name>");
		pw.println("<id>" + test.getKey() + "</id>");
		pw.println("<elapse>" + (test.getValue().getTestContext().getEndDate().getTime()
				- test.getValue().getTestContext().getStartDate().getTime()) / 1000L + "</elapse>");

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
			generateReportXml(pw, method);
		}

		pw.println("</testset>");
	}

	private void generateReportXml(PrintWriter pw, ITestResult method) {
		//String msg = "";
		//String err = "";

		pw.println("<test timestamp=\""
				+ DateFormat.getDateTimeInstance(3, 3, Locale.ENGLISH).format(new Date(method.getStartMillis()))
				+ "\" elapsed=\"" + (method.getEndMillis() - method.getStartMillis()) / 1000L + "\" result=\""
				+ this.getStatusString(method) + "\">");
		pw.println("<name>" + method.getName() + "</name>");
		pw.println("<desc>" + ((method.getMethod().getDescription() != null) ? method.getMethod().getDescription()
				: "Not Available") + "</desc>");
		pw.println("<level></level>");
		pw.println("<type></type>");

		StringBuilder ConvertedLog = new StringBuilder();
		for (String output : Reporter.getOutput(method)) {
			ConvertedLog.append(output);
			ConvertedLog.append("\n");
		}
		pw.println("<output>");
		pw.println(ConvertedLog.toString());
		pw.println("</output>");
		/*
		 * if (method.getStatus() == ITestResult.FAILURE) {
		 * pw.println("<error failure=\"true\" type=\"failure\">"); pw.println(err);
		 * pw.println("</error>"); }
		 */

		pw.println("<system-out href=\"" + (String) method.getAttribute("relateivelogpath") + "\">log</system-out>");
		pw.println("<screenshot href=\"" + (String) method.getAttribute("screenshots") + "\">screenshots</screenshot>");
		pw.println("</test>");
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
		String reportName = logDir + File.separator + reportFileName + ".xml";
		StringBuffer config = new StringBuffer();
		for (String key : Configuration.getConfig().getAllTestProperties().keySet()) {
			config.append("<param name=\"" + key + "\" value=\""
					+ Configuration.getConfig().getAllTestProperties().get(key).toString() + "\" />\n");
		}
		PrintWriter pw = new PrintWriter(new FileOutputStream(reportName));
		pw.println("<?xml version=\"1.0\" encoding = \"UTF-8\"?>");
		pw.println("<?xml-stylesheet type=\"text/xsl\" href=\"../../common/"
				+ Configuration.getConfig().getReportTheme() + ".xsl\"?>");
		pw.println("<report xmlns=\"https://sillywaterwalk.com/2023/XMLSchema\">");
		try {
			// Alternate to get the hostname.new BufferedReader(new
			// InputStreamReader(Runtime.getRuntime().exec("hostname").getInputStream())).readLine()
			pw.println("<testclient>" + InetAddress.getLocalHost().getHostName() + "</testclient>");
		} catch (UnknownHostException e) {
		}
		pw.println("<reportcharttype>" + Configuration.getConfig().getReportChartType() + "</reportcharttype>");
		pw.println("<starttime>" + starttime + "</starttime>");
		pw.println("<endtime>" + endtime + "</endtime>");
		pw.println("<elapse>" + (endTime - startTime) / 1000L + "</elapse>");
		pw.println("<system>");
		pw.println("<OS>" + System.getProperty("os.name") + "</OS>");
		pw.println("<OS-version>" + System.getProperty("os.version") + "</OS-version>");
		pw.println("<OS-arch>" + System.getProperty("os.arch") + "</OS-arch>");
		pw.println("<java-version>" + System.getProperty("java.version") + "</java-version>");
		pw.println("<java-vendor>" + System.getProperty("java.vendor") + "</java-vendor>");
		pw.println("</system>");
		pw.println("<tester>" + System.getProperty("user.name") + "</tester>");
		// pw.println("<language>" + "</language>"); // TODO
		// pw.println("<script></script>"); // TODO
		// pw.println("<build>" + "</build>"); // TODO
		pw.println("<config><input>" + config +"</input></config>");
		
		generateReportXml(pw, suites);

		pw.println("</report>");
		pw.flush();
		pw.close();
		logger.log("Generated XML report.");
	}
}
