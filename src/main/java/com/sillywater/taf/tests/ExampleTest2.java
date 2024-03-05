package com.sillywater.taf.tests;

import org.testng.annotations.Test;

import com.sillywater.taf.base.BaseTest;


public class ExampleTest2 extends BaseTest {
	
	@Test(description = "Prepare the Envionment.")
	public void test200_prepare() throws Exception {
		info("From test 00");
	}
	
	@Test(description = "Run the test01", invocationCount = 1, threadPoolSize = 1)
	public void test201_dosomething() throws Exception {
		info("From test 01");
		Thread.sleep(1 * 1000);
		this.reportFail("Sure Problem");
	}
	
	@Test(description = "Run the test03 2 times", invocationCount = 2, threadPoolSize = 1)
	public void test202_dosomething() throws Exception {
		//this.assertFail("problem");
		info("From test 02");
	}
	
	@Test(description = "Run the test03 4 times in parallell with 4 threads", invocationCount = 4, threadPoolSize = 4, dependsOnMethods = { "test201_dosomething" })
	public void test203_dosomething() throws Exception {
		info("From test 03");
	}
	
	public static void main(String [] args) throws Exception {
		ExampleTest2 test = new ExampleTest2();
		test.test201_dosomething();
	}

}
