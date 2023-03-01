package com.sillywater.taf.report;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.testng.IReporter;
import org.testng.ISuite;
import org.testng.ISuiteResult;
import org.testng.ITestResult;
import org.testng.Reporter;
import org.testng.xml.XmlSuite;

import com.sillywater.taf.base.Configuration;
import com.sillywater.taf.log.CLogger;

public class CReporter implements IReporter {

	@Override
	public void generateReport(List<XmlSuite> xmlSuites, List<ISuite> suites, String outputDirectory) {
		CLogger.getLogger().log("Generating the Report...");
		try {
			generateReportXml(suites);
			generateHTML();
		} catch (FileNotFoundException | UnsupportedEncodingException | TransformerException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public void generateSummaryXml(List<ISuite> suites) {
	}

	public void generateReportXml(List<ISuite> suites) throws FileNotFoundException {
		long startTime = this.getStartTime(suites);
		long endTime = this.getEndTime(suites);

		SimpleDateFormat df = new SimpleDateFormat("MM/dd/yy HH:mm:ss");
		String starttime = df.format(new Date(startTime));
		String endtime = df.format(new Date(endTime));
		String reportName = CLogger.getLogger().getReportDir() + File.separator + "Report.xml";
		PrintWriter pw = new PrintWriter(new FileOutputStream(reportName));
		pw.println("<?xml version=\"1.0\" encoding = \"UTF-8\"?>");
		pw.println("<?xml-stylesheet type=\"text/xsl\" href=\"../../common/test-reporting.xsl\"?>");
		pw.println("<report xmlns=\"http://www.oracle.com/cloud9/qa/framework/junit/schema\">");
		pw.println("<client></client>");
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
		pw.println("<language>" + "</language>");
		pw.println("<script>Java</script>");
		pw.println("<build>" + "</build>");
		pw.println("<config>" + "</config>");
		pw.println("<suites>");
		pw.println("<name>" + "TESTNG_EXECUTION" + "</name>");

		for (ISuite suite : suites) {
			generateReportXml(pw, suite);
		}

		pw.println("</suites>");
		pw.println("</report>");
		pw.flush();
		pw.close();

	}

	private void generateReportXml(PrintWriter pw, ISuite suite) {
		pw.println("<suite>");
		pw.println("<name>" + suite.getName() + "</name>");

		Map<String, ISuiteResult> resultMap = suite.getResults();
		for (Map.Entry<String, ISuiteResult> result : resultMap.entrySet()) {
			generateReportXml(pw, result);
		}

		/*
		 * for (ISuiteResult eachResult : suite.getResults().values()) {
		 * ITestContext ctx = eachResult.getTestContext(); generateReportXml(pw,
		 * ctx); }
		 */
		pw.println("</suite>");

	}

	private void generateReportXml(PrintWriter pw, Map.Entry<String, ISuiteResult> test) {
		pw.println("<testcase>");
		pw.println("<name>" + test.getKey() + "</name>");
		pw.println("<id>" + test.getKey() + "</id>");		
		pw.println("<elapse>" + (test.getValue().getTestContext().getEndDate().getTime()
				- test.getValue().getTestContext().getStartDate().getTime()) /1000L + "</elapse>");

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
						if(Configuration.getConfig().getRunnerProperty("report_sorting_method").toLowerCase().equals("timebased")) {
							return (m1.getStartMillis() > m2.getStartMillis()) ? 1
									: (m1.getStartMillis() < m2.getStartMillis()) ? -1 : 0;
						}
					} catch (Exception e) {}
					return m1.getMethod().getMethodName().compareTo(m2.getMethod().getMethodName());
				}
			};
			Collections.sort(results, timeComparator);
		}

		for (ITestResult method : results) {
			generateReportXml(pw, method);
		}

		pw.println("</testcase>");
	}

	private void generateReportXml(PrintWriter pw, ITestResult method) {
		String msg = "";
		String err = "";

		pw.println("<test timestamp=\""
				+ DateFormat.getDateTimeInstance(3, 3, Locale.ENGLISH).format(new Date(method.getStartMillis()))
				+ "\" elapsed=\"" + (method.getEndMillis() - method.getStartMillis()) / 1000L + "\" result=\""
				+ this.getStatusString(method) + "\">");
		pw.println("<name>" + method.getName() + "</name>");
		pw.println("<desc>" + ((method.getMethod().getDescription() != null) ? method.getMethod().getDescription()
				: "Not Available") + "</desc>");
		pw.println("<level></level>");
		pw.println("<type></type>");

		for (String output : Reporter.getOutput(method)) {
			StringBuilder ConvertedLog = new StringBuilder(output.length() * 7);

			for (int j = 0; j < output.length(); ++j) {
				ConvertedLog.append("&#x");
				ConvertedLog.append(Integer.toHexString(output.charAt(j)));
				ConvertedLog.append(";");
			}
			//msg = msg + ConvertedLog.toString() + "\n";
			if (!output.startsWith("[FAIL]")) {
				msg = msg + ConvertedLog.toString() + "\n";
			} else {
				err = err + ConvertedLog.toString() + "\n";
			}
		}
		pw.println("<output>");
		pw.println(msg);
		pw.println("</output>");
		if (method.getStatus() == ITestResult.FAILURE) {
			pw.println("<error failure=\"true\" type=\"failure\">");
			pw.println(err);
			pw.println("</error>");
		}

		pw.println("<system-out href=\"" + (String) method.getAttribute("relateivelogpath") + "\">log</system-out>");
		pw.println("<screenshot href=\"" + (String) method.getAttribute("screenshots") + "\">screenshots</screenshot>");
		pw.println("</test>");
		pw.flush();
	}
	
	private String getStatusString(ITestResult result) {
		switch(result.getStatus()){
		case ITestResult.CREATED :
			return "created";
		case ITestResult.SUCCESS :
			return "Passed";
		case ITestResult.FAILURE :
			return "Failed";
		case ITestResult.SKIP :
			return "CNR";
		case ITestResult.STARTED :
			return "started";
		case ITestResult.SUCCESS_PERCENTAGE_FAILURE :
			return "Warning";
		default :
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
		/*long startTime = Long.MAX_VALUE;
		for (ISuiteResult eachResult : suite.getResults().values()) {
			ITestContext ctx = eachResult.getTestContext();
			long testStartTime = ctx.getStartDate().getTime();
			if (startTime > testStartTime) {
				startTime = testStartTime;
			}
		}
		return startTime;*/
		return (Long)suite.getAttribute("start_time");
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
		/*long endTime = Long.MIN_VALUE;
		for (ISuiteResult eachResult : suite.getResults().values()) {
			ITestContext ctx = eachResult.getTestContext();
			long testEndTime = ctx.getEndDate().getTime();
			if (endTime < testEndTime) {
				endTime = testEndTime;
			}
		}
		return endTime;*/	
		return (Long)suite.getAttribute("end_time");
	}
	
	void generateHTML() throws UnsupportedEncodingException, FileNotFoundException, TransformerException {
		String reportName = CLogger.getLogger().getReportDir() + File.separator + "Report.xml";
		String reportNameHtml = CLogger.getLogger().getReportDir() + File.separator + "Report.html";

		TransformerFactory arg8 = TransformerFactory.newInstance();
		Transformer transformer = arg8.newTransformer(new StreamSource(CLogger.getLogger().getHomeDir()
				+ File.separator + "common" + File.separator + "test-reporting.xsl"));
		transformer.transform(new StreamSource(reportName),
				new StreamResult(new OutputStreamWriter(new FileOutputStream(reportNameHtml), "UTF-16")));
	}
}
