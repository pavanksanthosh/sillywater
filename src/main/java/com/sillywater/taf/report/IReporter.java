package com.sillywater.taf.report;

import java.io.FileNotFoundException;
import java.util.List;

import org.testng.ISuite;

interface IReporter {
	void generate(List<ISuite> suites, String logDir, String reportFileName) throws FileNotFoundException, Exception;
}
