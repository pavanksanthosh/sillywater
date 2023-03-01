package com.sillywater.taf.log;

import java.io.PrintWriter;
import java.io.StringWriter;

import org.testng.IInvokedMethod;
import org.testng.IInvokedMethodListener;
import org.testng.ISuite;
import org.testng.ISuiteListener;
import org.testng.ITestContext;
import org.testng.ITestListener;
import org.testng.ITestResult;
import org.testng.Reporter;
import org.testng.TestListenerAdapter;

public class CustomListener extends TestListenerAdapter implements ITestListener, ISuiteListener, IInvokedMethodListener {


	@Override
	public void onStart(ITestContext testContext) {
		testContext.setAttribute("start_time", System.currentTimeMillis());
	}

	@Override
	public void onFinish(ITestContext testContext) {
		testContext.setAttribute("end_time", System.currentTimeMillis());
	}

	@Override
	public void beforeInvocation(IInvokedMethod method, ITestResult testResult) {
		CLogger.getLogger().setContextTest(Reporter.getCurrentTestResult().getTestContext());
		CLogger.getLogger().setContextClass(Reporter.getCurrentTestResult().getMethod().getTestClass());
		CLogger.getLogger().setContextMethod(Reporter.getCurrentTestResult().getMethod());
		
		Reporter.setCurrentTestResult(testResult);
	}

	@Override
	public void afterInvocation(IInvokedMethod method, ITestResult testResult) {
		CLogger.getLogger().flushAll();
		if (testResult.getThrowable() != null) {
			StringWriter sw = new StringWriter();
			testResult.getThrowable().printStackTrace(new PrintWriter(sw));
			CLogger.getLogger().reportException(testResult.getThrowable());
		}

		testResult.setAttribute("logfile", CLogger.getLogger().getContextLogFile());
		testResult.setAttribute("screenshots", CLogger.getLogger().getContextScreenShotsDir());
		testResult.setAttribute("relateivelogpath", CLogger.getLogger().getFromContext("relateivelogpath"));
		CLogger.getLogger().clearContext();
	}

	@Override
	public void onStart(ISuite suite) {
		suite.setAttribute("start_time", System.currentTimeMillis());
	}

	@Override
	public void onFinish(ISuite suite) {
		suite.setAttribute("end_time", System.currentTimeMillis());
	}
}