package com.sillywater.taf.report;

import java.util.List;

import org.testng.IReporter;
import org.testng.ISuite;
import org.testng.xml.XmlSuite;

import com.sillywater.taf.log.LogLevel;
import com.sillywater.taf.log.Logger;

public class CReporter implements IReporter {
	private static Logger logger = new Logger(CReporter.class);

	@Override
	public void generateReport(List<XmlSuite> xmlSuites, List<ISuite> suites, String outputDirectory) {
		logger.log("Generating the Report...");
		try {
			for (com.sillywater.taf.report.IReporter reporter : ReporterFactory.getReporters()) {
				reporter.generate(suites, logger.getReportDir(), "Report");
			}
			//logger.log("Successfully generated all the reports.");
		} catch (Exception e) {
			logger.log(LogLevel.ERROR, "Problem encountered while generating the report");
			logger.log(LogLevel.ERROR, e);
		}
	}
}
