package com.sillywater.taf.base;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import org.testng.ITestNGListener;
import org.testng.TestNG;

import com.sillywater.taf.log.CustomListener;
import com.sillywater.taf.log.CLogger;
import com.sillywater.taf.report.CReporter;

public class TestRunner {

	public static void main(String[] args) {
		TestNG test = new TestNG();
		List<String> suites = new ArrayList<String>();
		/*try {
			suites.add(System.getProperty("user.dir") + File.separator + "suites" + File.separator
					+ Configuration.getConfig().getStringProperty("test_suite"));
		} catch (Exception e) {
			CLogger.getLogger().log(Utils.getStackTrace(e), LogLevel.FATAL);
			return;
		}*/
		suites.add(System.getProperty("user.dir") + File.separator + "suites" + File.separator
				+ Configuration.getConfig().getStringProperty("test_suite"));
		test.addListener((ITestNGListener) new CustomListener());
		test.addListener((ITestNGListener) new CReporter());
		test.addListener((ITestNGListener) new TestListener());
		test.setUseDefaultListeners(true);
		test.setTestSuites(suites);
		test.setOutputDirectory(CLogger.getLogger().getResultDir() + File.separator + "testngReport");
		test.run();
	}
}