package com.sillywater.taf.base;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import org.testng.ITestNGListener;
import org.testng.TestNG;

import com.sillywater.taf.log.LogContextManager;
import com.sillywater.taf.log.Logger;
import com.sillywater.taf.report.CReporter;

public class TestRunner {
	private static Logger logger = new Logger(TestRunner.class);

	public static void main(String[] args) throws Exception {
		TestNG test = new TestNG();
		List<String> suites = new ArrayList<String>();
		
		if (Configuration.getConfig().getTestSuitesToRun().size() == 0) {
			throw new Exception("ERROR: \"test_suites\" value is empty or not provided in the conf file "
					+ Configuration.getConfig().getRunnerProperty("test_conf_file") + ". No test suites available for running.");
		}
		for (String test_suite : Configuration.getConfig().getTestSuitesToRun()) {
			if (test_suite.isEmpty()) {
				continue; // Just ignore the empty value or warn the user.
			}
			suites.add(System.getProperty("user.dir") + File.separator + "suites" + File.separator + test_suite);
		}
		test.addListener((ITestNGListener) new LogContextManager());
		test.addListener((ITestNGListener) new CReporter());
		test.addListener((ITestNGListener) new TestListener());
		test.setTestSuites(suites);

		if (Configuration.getConfig().getRunnerProperty("enable_testng_report") != null
				&& Configuration.getConfig().getRunnerProperty("enable_testng_report").equalsIgnoreCase("true")) {
			test.setUseDefaultListeners(true);
			test.setOutputDirectory(logger.getResultDir() + File.separator + "testngReport");
		} else {
			test.setUseDefaultListeners(false);
		}
		test.run();
	}
}