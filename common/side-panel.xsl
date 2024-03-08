<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sw="https://sillywaterwalk.com/2023/XMLSchema">
	<xsl:output method="html"/>
	<xsl:variable name="pass_color">92D794</xsl:variable>
	<xsl:variable name="fail_color">F4A1A1</xsl:variable>
	<xsl:variable name="warn_color">FBD07B</xsl:variable>
	<xsl:variable name="nr_color">D5D4A0</xsl:variable>
	
	<xsl:variable name="totaltests" select="count(//sw:report//sw:suite/sw:testset//sw:test)"/>
	<xsl:variable name="passedtest" select="count(//sw:report//sw:suite/sw:testset//sw:test[@result='Passed'])"/>					
	<xsl:variable name="failedtest" select="count(//sw:report//sw:suite/sw:testset//sw:test[@result='Failed'])"/>	
	<xsl:variable name="cnrtest" select="count(//sw:report//sw:suite/sw:testset//sw:test[@result='CNR'])"/>
	<xsl:variable name="warntest" select="count(//sw:report//sw:suite/sw:testset//sw:test[@result='Warning'])"/>
	
	<xsl:variable name="charttype" select="//sw:report/sw:reportcharttype"/>
	
	<xsl:template name="Root" match="/sw:report">
    	<xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
		<html>
          	<xsl:call-template name="html-header"/>
			<body>
					<xsl:call-template name="top-banner"/>
                    <div class="left-panel">
                        <!-- Left panel content goes here -->
						<xsl:call-template name="AllSuites"/>
                    </div>
                    <div class="right-panel">
                        <!-- Right panel content goes here -->
						<xsl:call-template name="AllSuitesRight"/>
                    </div>
	
			</body>
		</html>
	</xsl:template>
	
	<xsl:template name="html-header">
		<head>
			<meta http-equiv="Content-Type" content="text/html;CHARSET=iso-8859-1"/>
			<title>Report - <xsl:value-of select="//sw:report/sw:starttime"/></title>
			<link type="text/css" href="side-panel.css" rel="stylesheet"/>
			<script src="chart.min.js"></script>
			<script type="text/javascript" src="side-panel.js"></script>
		</head>
	</xsl:template>
	
	<xsl:template name="top-banner">
		<div class="top-banner">
	      <a name="top"><span class="top-banner-title">Report</span> <span class="top-banner-time"> - <xsl:value-of select="//sw:report/sw:starttime"/></span></a>
	      
	    </div>
	</xsl:template>

	<!-- Left Panel -->
	<!-- All Test Suites Section -->
	<xsl:template name="AllSuites">
		<xsl:variable name="allSuites" select="//sw:report//sw:suite" />

		<div class="AllSuiteTreeSwitcher">
			<xsl:attribute name="onclick">
				<!-- clearRightPanel() -->
				switchdiv(this, 'allSuites', "+ All Test Suites","- All Test Suites")
				<!-- createchart('<xsl:value-of select="$charttype"/>', 'swchart', <xsl:value-of select="$passedtest"/>, <xsl:value-of select="$failedtest"/>, <xsl:value-of select="$warntest"/>, <xsl:value-of select="$cnrtest"/>, '<xsl:value-of select="concat('#', $pass_color)"/>', '<xsl:value-of select="concat('#', $fail_color)"/>', '<xsl:value-of select="concat('#', $warn_color)"/>', '<xsl:value-of select="concat('#', $nr_color)"/>')
				updateExecutionDetails("{<xsl:call-template name="ExecutionDetails"/>}")
				location.reload(); -->
				switchdivright(this, 'allsuites-right')
			</xsl:attribute>
			- All Test Suites
		</div>
		<div id="allSuites">
			<xsl:for-each select="$allSuites">
				<xsl:call-template name="Suite"/>
			</xsl:for-each>
		</div>
	</xsl:template>

	<!-- Test Suites Section -->
	<xsl:template name="Suite">
		<xsl:variable name="allTestSets" select="./sw:testset" />
		<xsl:variable name="suitepassedtest" select="count(./sw:testset//sw:test[@result='Passed'])"/>					
		<xsl:variable name="suitefailedtest" select="count(./sw:testset//sw:test[@result='Failed'])"/>	
		<xsl:variable name="suitecnrtest" select="count(./sw:testset//sw:test[@result='CNR'])"/>
		<xsl:variable name="suitewarntest" select="count(./sw:testset//sw:test[@result='Warning'])"/>
		<xsl:variable name="suiteID" select="sw:name"/>
		<xsl:variable name="suite-switch-on">+ Test Suite: <xsl:value-of select="$suiteID"/></xsl:variable>
		<xsl:variable name="suite-switch-off">- Test Suite: <xsl:value-of select="$suiteID"/></xsl:variable>
		<xsl:variable name="unqId" select="generate-id(.)" />

		<div class="TestSuiteTreeSwitcher">
			<xsl:attribute name="onclick">
				switchdiv(this, 'suite<xsl:value-of select="$suiteID"/><xsl:value-of select="$unqId"/>', "<xsl:value-of select="$suite-switch-on"/>", "<xsl:value-of select="$suite-switch-off"/>")
				<!-- clearRightPanel()
				createchart('<xsl:value-of select="$charttype"/>', 'swchart', <xsl:value-of select="$suitepassedtest"/>, <xsl:value-of select="$suitefailedtest"/>, <xsl:value-of select="$suitewarntest"/>, <xsl:value-of select="$suitecnrtest"/>, '<xsl:value-of select="concat('#', $pass_color)"/>', '<xsl:value-of select="concat('#', $fail_color)"/>', '<xsl:value-of select="concat('#', $warn_color)"/>', '<xsl:value-of select="concat('#', $nr_color)"/>')
				-->
				switchdivright(this, 'suite<xsl:value-of select="$suiteID"/><xsl:value-of select="$unqId"/>-right')
			</xsl:attribute>
			<xsl:value-of select="$suite-switch-on"/>
		</div>
		<div id="suite{$suiteID}{$unqId}" style="display:block;">
			<xsl:for-each select="$allTestSets">
				<xsl:call-template name="TestSet"/>
			</xsl:for-each>
		</div>
	</xsl:template>

	<!-- Test Set Section -->
	<xsl:template name="TestSet">
    	<xsl:param name="testset" />
		<xsl:variable name="allTests" select="./sw:test" />
		<xsl:variable name="testpassedtest" select="count(./sw:test[@result='Passed'])"/>					
		<xsl:variable name="testfailedtest" select="count(./sw:test[@result='Failed'])"/>	
		<xsl:variable name="testcnrtest" select="count(./sw:test[@result='CNR'])"/>
		<xsl:variable name="testwarntest" select="count(./sw:test[@result='Warning'])"/>
		<xsl:variable name="testsetId" select="sw:name"/>
		<xsl:variable name="testset-switch-on">+ Test Set: <xsl:value-of select="$testsetId"/></xsl:variable>
		<xsl:variable name="testset-switch-off">- Test Set: <xsl:value-of select="$testsetId"/></xsl:variable>
		<xsl:variable name="unqId" select="generate-id(.)" />
		
		<div class="TestSetTreeSwitcher">
			<xsl:attribute name="onclick">
				switchdiv(this, 'testset<xsl:value-of select="$testsetId"/><xsl:value-of select="$unqId"/>', "<xsl:value-of select="$testset-switch-on"/>", "<xsl:value-of select="$testset-switch-off"/>")
				<!-- clearRightPanel()
				createchart('<xsl:value-of select="$charttype"/>', 'swchart', <xsl:value-of select="$testpassedtest"/>, <xsl:value-of select="$testfailedtest"/>, <xsl:value-of select="$testwarntest"/>, <xsl:value-of select="$testcnrtest"/>, '<xsl:value-of select="concat('#', $pass_color)"/>', '<xsl:value-of select="concat('#', $fail_color)"/>', '<xsl:value-of select="concat('#', $warn_color)"/>', '<xsl:value-of select="concat('#', $nr_color)"/>')
				-->
				switchdivright(this, 'testset<xsl:value-of select="$testsetId"/><xsl:value-of select="$unqId"/>-right')
			</xsl:attribute>
			<xsl:value-of select="$testset-switch-on"/>
		</div>
		<div id="testset{$testsetId}{$unqId}" style="display:none;">
			<xsl:for-each select="$allTests">
				<xsl:call-template name="Test"/>
			</xsl:for-each>
		</div>
	</xsl:template>

	<!-- Test -->
	<xsl:template name="Test">
		<xsl:variable name="testName" select="sw:name"/>
		<xsl:variable name="testId" select="sw:name"/>
		<xsl:variable name="unqId" select="generate-id(.)" />
		<xsl:variable name="test-switch-on">Test: <xsl:value-of select="$testId"/></xsl:variable>
		<xsl:variable name="test-switch-off">Test: <xsl:value-of select="$testId"/></xsl:variable>
		<div class="TestTreeSwitcher">
			<xsl:attribute name="onclick">
				<!-- switchdiv(this, 'test<xsl:value-of select="$testId"/><xsl:value-of select="$unqId"/>', "<xsl:value-of select="$test-switch-on"/>", "<xsl:value-of select="$test-switch-off"/>")
				--><!-- clearRightPanel() -->
				switchdivright(this, 'test<xsl:value-of select="$testId"/><xsl:value-of select="$unqId"/>-right')
			</xsl:attribute>
			<xsl:value-of select="$test-switch-on"/>
		</div>
		<!--<div id="test{$testId}{$unqId}" style="display:none;">
			<xsl:value-of select="$testName"/>
		</div> -->
	</xsl:template>
	
	<!-- Execution Details -->
	<xsl:template name="ExecutionDetails">
		<div class="execution-details">
			<a name="top" class="exec-details-heading">
				<xsl:text>Execution Details</xsl:text>
			</a>
			
			<div class="execution-details-info">
				<div class="info-item">
					<span>Start Time:</span>
					<xsl:value-of select="//sw:report/sw:starttime" />
				</div>
				<div class="info-item">
					<span>End Time:</span>
					<xsl:value-of select="//sw:report/sw:endtime" />
				</div>
				<div class="info-item">
					<span>User:</span>
					<xsl:value-of select="//sw:report/sw:tester" />
				</div>
				<div class="info-item">
					<span>OS:</span>
					<xsl:value-of select="//sw:report/sw:system/sw:OS" />
					<xsl:text>, </xsl:text>
					<xsl:value-of select="//sw:report/sw:system/sw:OS-version"/>
				</div>
				<div class="info-item">
					<span>Duration:</span>
					<xsl:variable name="exec_time" select="//sw:report/sw:elapse"/>
					<xsl:choose>
						<xsl:when test="$exec_time &gt; 3600">
							<xsl:value-of select="floor($exec_time div 3600)"/> hr <xsl:value-of select="floor(($exec_time mod 3600) div 60)"/> min <xsl:value-of select="$exec_time mod 60"/> sec
						</xsl:when>
						<xsl:when test="$exec_time &gt; 60">
							<xsl:value-of select="floor($exec_time div 60)"/> min <xsl:value-of select="$exec_time mod 60"/> sec
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$exec_time"/> sec
						</xsl:otherwise>
					</xsl:choose>
				</div>
				<div class="info-item">
					<a id="openpopupwindow" type="button" class="btn" onclick="openDialog()" href="#">Open Test Config</a>
					<div class="popupwindow" id="popupwindow">
						<span class="closepopupwindow" onclick="closeDialog()">&#x2716;</span>
						<h3>Test Configuration</h3>
						<xsl:for-each select="//sw:report//sw:config//sw:param">
							<span style="font-weight:bold"><xsl:value-of select="@name"/></span> : <xsl:value-of select="@value"/><br/>
						</xsl:for-each>
						<button class="closepopupwindowbutton" type="button" onclick="closeDialog()">Close</button>
					</div>
				</div>
				<div class="info-item">
					<a href="../TestRunner.log.0" target="_new">Open Detailed Log</a>
				</div>
				<div class="info-item">
					<a href="../" target="_new">Open Results Directory</a>
				</div>
			</div>
		</div>
	</xsl:template>

	<!-- Right Panel -->
	<!-- All Suites Right -->
	<xsl:template name="AllSuitesRight">
		<xsl:variable name="allSuites" select="//sw:report//sw:suite" />
		<div id="allsuites-right" class="right-hide">
			<table class="allsuites-table">
				<tr>
					<td>
					<xsl:call-template name="ExecutionDetails"/>
					</td>
					<td>
					<xsl:if test="$charttype != 'none'">
						<div class="chart-canvas"><canvas id="swchart-allsuites" ></canvas></div>
						<script>createchart('<xsl:value-of select="$charttype"/>', 'swchart-allsuites', <xsl:value-of select="$passedtest"/>, <xsl:value-of select="$failedtest"/>, <xsl:value-of select="$warntest"/>, <xsl:value-of select="$cnrtest"/>, '<xsl:value-of select="concat('#', $pass_color)"/>', '<xsl:value-of select="concat('#', $fail_color)"/>', '<xsl:value-of select="concat('#', $warn_color)"/>', '<xsl:value-of select="concat('#', $nr_color)"/>')</script>
					</xsl:if>
					</td>
				</tr>
			</table>
			<div class="lower-right-panel">
				<!-- TODO: Add Summary Table -->
			</div>
		</div>

		<xsl:for-each select="$allSuites">
			<xsl:call-template name="SuiteRight"/>
		</xsl:for-each>
	</xsl:template>

	<!-- Test Suite Right -->
	<xsl:template name="SuiteRight">
		<xsl:variable name="allTestSets" select="./sw:testset" />
		<xsl:variable name="suitepassedtest" select="count(./sw:testset//sw:test[@result='Passed'])"/>					
		<xsl:variable name="suitefailedtest" select="count(./sw:testset//sw:test[@result='Failed'])"/>	
		<xsl:variable name="suitecnrtest" select="count(./sw:testset//sw:test[@result='CNR'])"/>
		<xsl:variable name="suitewarntest" select="count(./sw:testset//sw:test[@result='Warning'])"/>
		<xsl:variable name="suiteID" select="sw:name"/>
		<xsl:variable name="suite-switch-on">+ Test Suite: <xsl:value-of select="$suiteID"/></xsl:variable>
		<xsl:variable name="suite-switch-off">- Test Suite: <xsl:value-of select="$suiteID"/></xsl:variable>
		<xsl:variable name="unqId" select="generate-id(.)" />

		<div id="suite{$suiteID}{$unqId}-right" class="right-hide">
			<xsl:if test="$charttype != 'none'">
				<div class="chart-canvas"><canvas id="swchart-suite{$suiteID}{$unqId}" ></canvas></div>
				<script>createchart('<xsl:value-of select="$charttype"/>', 'swchart-suite<xsl:value-of select="$suiteID"/><xsl:value-of select="$unqId"/>', <xsl:value-of select="$suitepassedtest"/>, <xsl:value-of select="$suitefailedtest"/>, <xsl:value-of select="$suitewarntest"/>, <xsl:value-of select="$suitecnrtest"/>, '<xsl:value-of select="concat('#', $pass_color)"/>', '<xsl:value-of select="concat('#', $fail_color)"/>', '<xsl:value-of select="concat('#', $warn_color)"/>', '<xsl:value-of select="concat('#', $nr_color)"/>')</script>
				<!-- <div class="lower-right-panel">
					<xsl:call-template name="ExecutionDetails"/>
					Add the summary table here
				</div> -->
			</xsl:if>
		</div>
		<xsl:for-each select="$allTestSets">
			<xsl:call-template name="TestSetRight"/>
		</xsl:for-each>
	</xsl:template>

	<!-- Test Set Right -->

	<xsl:template name="TestSetRight">
		<xsl:variable name="allTests" select="./sw:test" />
		<xsl:variable name="testpassedtest" select="count(./sw:test[@result='Passed'])"/>					
		<xsl:variable name="testfailedtest" select="count(./sw:test[@result='Failed'])"/>	
		<xsl:variable name="testcnrtest" select="count(./sw:test[@result='CNR'])"/>
		<xsl:variable name="testwarntest" select="count(./sw:test[@result='Warning'])"/>
		<xsl:variable name="testsetId" select="sw:name"/>
		<xsl:variable name="testset-switch-on">+ Test Set: <xsl:value-of select="$testsetId"/></xsl:variable>
		<xsl:variable name="testset-switch-off">- Test Set: <xsl:value-of select="$testsetId"/></xsl:variable>
		<xsl:variable name="unqId" select="generate-id(.)" />
		
		<div id="testset{$testsetId}{$unqId}-right" class="right-hide">
			<xsl:if test="$charttype != 'none'">
				<div class="chart-canvas"><canvas id="swchart-testset{$testsetId}{$unqId}" ></canvas></div>
				<script>createchart('<xsl:value-of select="$charttype"/>', 'swchart-testset<xsl:value-of select="$testsetId"/><xsl:value-of select="$unqId"/>', <xsl:value-of select="$testpassedtest"/>, <xsl:value-of select="$testfailedtest"/>, <xsl:value-of select="$testwarntest"/>, <xsl:value-of select="$testcnrtest"/>, '<xsl:value-of select="concat('#', $pass_color)"/>', '<xsl:value-of select="concat('#', $fail_color)"/>', '<xsl:value-of select="concat('#', $warn_color)"/>', '<xsl:value-of select="concat('#', $nr_color)"/>')</script>
				<!-- <div class="lower-right-panel">
					<xsl:call-template name="ExecutionDetails"/>
					Add the summary table here
				</div> -->
			</xsl:if>
		</div>
		<xsl:for-each select="$allTests">
			<xsl:call-template name="TestRight"/>
		</xsl:for-each>
	</xsl:template>

	<!-- Test Right-->
	<xsl:template name="TestRight">
		<xsl:variable name="testName" select="sw:name"/>
		<xsl:variable name="testId" select="sw:name"/>
		<xsl:variable name="unqId" select="generate-id(.)" />

		<div id="test{$testId}{$unqId}-right" class="right-hide">
			<xsl:value-of select="$testName"/>
		</div>
	</xsl:template>

</xsl:stylesheet>