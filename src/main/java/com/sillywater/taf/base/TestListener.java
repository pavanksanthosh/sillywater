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

import com.sillywater.taf.log.CLogger;
import com.sillywater.taf.log.LogLevel;

class TestListener extends TestListenerAdapter implements ITestListener, ISuiteListener, IInvokedMethodListener, IExecutionListener {

	@Override
	public void onTestSuccess(ITestResult tr) {
		CLogger.getLogger().print("[PASS] Finished running method = " + tr.getMethod().getMethodName(),
				LogLevel.INFO);
	}

	@Override
	public void onTestFailure(ITestResult tr) {
		if (tr.getThrowable() != null) {
			StringWriter sw = new StringWriter();
			tr.getThrowable().printStackTrace(new PrintWriter(sw));
			CLogger.getLogger().print(
					"Exception while running method = " + tr.getMethod().getMethodName() + "\n " + sw.toString(),
					LogLevel.FATAL);
		}
		CLogger.getLogger().print("[FAIL] Finished running method = " + tr.getMethod().getMethodName(),
				LogLevel.ERROR);
	}

	@Override
	public void onTestSkipped(ITestResult tr) {
		CLogger.getLogger().print("[SKIP] Finished running method = " + tr.getMethod().getMethodName(),
				LogLevel.INFO);
	}

	@Override
	public void onStart(ITestContext testContext) {
		CLogger.getLogger().print("Starting running test = " + testContext.getName(), LogLevel.INFO);
	}

	@Override
	public void onFinish(ITestContext testContext) {
		CLogger.getLogger().print("Finished running test = " + testContext.getName(), LogLevel.INFO);
	}

	@Override
	public void beforeInvocation(IInvokedMethod method, ITestResult testResult) {
		CLogger.getLogger().print("Starting running method = " + method.getTestMethod().getMethodName(), LogLevel.INFO);
	}

	@Override
	public void afterInvocation(IInvokedMethod method, ITestResult testResult) {
		CLogger.getLogger().print("Finished running method = " + method.getTestMethod().getMethodName(), LogLevel.INFO);
	}

	@Override
	public void onStart(ISuite suite) {
		CLogger.getLogger().print("Starting running suite = " + suite.getName(), LogLevel.INFO);
	}

	@Override
	public void onFinish(ISuite suite) {
		CLogger.getLogger().print("Finished running suite = " + suite.getName(), LogLevel.INFO);
	}

	@Override
	public void onExecutionStart() {
		CLogger.getLogger().print("Started execution", LogLevel.INFO);
		TestRunUtils.setUp();
	}

	@Override
	public void onExecutionFinish() {
		//CLogger.getLogger().log("[TestManager] Number of requests failed = " + TestManager.getNoOfRequestsFailed());
		CLogger.getLogger().print("Finished execution", LogLevel.INFO);
		TestRunUtils.cleanUp();
	}
}
