package com.sillywater.taf.report;

import java.util.ArrayList;
import java.util.List;

import com.sillywater.taf.base.Configuration;

public class ReporterFactory {

	static List<IReporter> getReporters() {
		List<IReporter> reporters = new ArrayList<IReporter>();
		String reportTypes = Configuration.getConfig().getReportType().toLowerCase();
		reporters.add(new XMLReporter());
		if (reportTypes.contains("html")) {
			reporters.add(new HTMLReporter());
		}
		if (reportTypes.contains("json")) {
			reporters.add(new JsonReporter());
		}
		if (reportTypes.contains("text")) {
			reporters.add(new TextReporter());
		}
		return reporters;
	}
}
