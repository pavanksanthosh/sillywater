package com.sillywater.taf.base;

import java.io.PrintWriter;
import java.io.StringWriter;

import org.testng.IExecutionListener;
import org.testng.IInvokedMethod;
import org.testng.IInvokedMethodListener;
import org.testng.ISuite;
import org.testng.ISuiteListener;
import org.testng.ITestContext;
import org.testng.ITestListener;
import org.testng.ITestResult;
import org.testng.TestListenerAdapter;

import com.sillywater.taf.log.LogLevel;
import com.sillywater.taf.log.Logger;

class TestListener extends TestListenerAdapter implements ITestListener, ISuiteListener, IInvokedMethodListener, IExecutionListener {
	private static Logger logger = new Logger(TestListener.class);
	
	@Override
	public void onTestSuccess(ITestResult tr) {
		logger.pritToConsole("[PASS] Finished running method = " + tr.getMethod().getMethodName(),
				LogLevel.INFO);
	}

	@Override
	public void onTestFailure(ITestResult tr) {
		if (tr.getThrowable() != null) {
			StringWriter sw = new StringWriter();
			tr.getThrowable().printStackTrace(new PrintWriter(sw));
			logger.pritToConsole(
					"Exception while running method = " + tr.getMethod().getMethodName() + "\n " + sw.toString(),
					LogLevel.FATAL);
		}
		logger.pritToConsole("[FAIL] Finished running method = " + tr.getMethod().getMethodName(),
				LogLevel.ERROR);
	}

	@Override
	public void onTestSkipped(ITestResult tr) {
		logger.pritToConsole("[SKIP] Finished running method = " + tr.getMethod().getMethodName(),
				LogLevel.INFO);
	}

	@Override
	public void onStart(ITestContext testContext) {
		logger.pritToConsole("Starting running test = " + testContext.getName(), LogLevel.INFO);
	}

	@Override
	public void onFinish(ITestContext testContext) {
		logger.pritToConsole("Finished running test = " + testContext.getName(), LogLevel.INFO);
	}

	@Override
	public void beforeInvocation(IInvokedMethod method, ITestResult testResult) {
		logger.pritToConsole("Starting running method = " + method.getTestMethod().getMethodName(), LogLevel.INFO);
	}

	@Override
	public void afterInvocation(IInvokedMethod method, ITestResult testResult) {
		logger.pritToConsole("Finished running method = " + method.getTestMethod().getMethodName(), LogLevel.INFO);
	}

	@Override
	public void onStart(ISuite suite) {
		logger.pritToConsole("Starting running suite = " + suite.getName(), LogLevel.INFO);
	}

	@Override
	public void onFinish(ISuite suite) {
		logger.pritToConsole("Finished running suite = " + suite.getName(), LogLevel.INFO);
	}

	@Override
	public void onExecutionStart() {
		logger.pritToConsole("Started execution", LogLevel.INFO);
		TestRunUtils.setUp();
	}

	@Override
	public void onExecutionFinish() {
		//logger.pritToConsole("[TestManager] Number of requests failed = " + TestManager.getNoOfRequestsFailed());
		logger.pritToConsole("Finished execution", LogLevel.INFO);
		TestRunUtils.cleanUp();
	}
}
