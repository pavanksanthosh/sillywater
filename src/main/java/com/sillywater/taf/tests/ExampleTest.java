package com.sillywater.taf.tests;

import org.testng.annotations.Test;

import com.sillywater.taf.base.BaseTest;


public class ExampleTest extends BaseTest {
	
	@Test(description = "Prepare the Envionment.")
	public void test00_prepare() throws Exception {
		info("From test 00");
	}
	
	@Test(description = "Run the test01", invocationCount = 1, threadPoolSize = 1)
	public void test01_dosomething() throws Exception {
		info("From test 01");	
	}
	
	@Test(description = "Run the test03 2 times", invocationCount = 2, threadPoolSize = 1)
	public void test02_dosomething() throws Exception {
		info("From test 02");
	}
	
	@Test(description = "Run the test03 4 times in parallell with 4 threads", invocationCount = 4, threadPoolSize = 4)
	public void test03_dosomething() throws Exception {
		info("From test 03");
	}
	
	public static void main(String [] args) throws Exception {
		ExampleTest test = new ExampleTest();
		test.test01_dosomething();
	}

}
