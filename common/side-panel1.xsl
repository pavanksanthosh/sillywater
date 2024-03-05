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
				
	
	
	
			</body>
		</html>
	</xsl:template>
	
	
	<xsl:template name="html-header">
		<head>
			<meta http-equiv="Content-Type" content="text/html;CHARSET=iso-8859-1"/>
			<title>SillyWater Report - <xsl:value-of select="//sw:report/sw:starttime"/></title>
			<link type="text/css" href="side-panel1.css" rel="stylesheet"/>
			<script src="./chart.min.js"></script>
		</head>
	</xsl:template>
	
	<xsl:template name="top-banner">
		<div class="top-banner">
	      <a name="top"><span class="top-banner-title">SillyWater Report</span> <span class="top-banner-time"> - <xsl:value-of select="//sw:report/sw:starttime"/></span></a>
	      <br/>
	    </div>
	</xsl:template>
	
</xsl:stylesheet>