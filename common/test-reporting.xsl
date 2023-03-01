<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:test="http://www.oracle.com/cloud9/qa/framework/junit/schema" >
	<xsl:output method="html"/>
	<xsl:template name="Root" match="/test:report">
		<html>
			<xsl:call-template name="html-head"/>
			<!--xsl:call-template name="javascript"/-->
			<body link="663300" alink="#FF6600" vlink="#996633" bgcolor="#ffffff">
				<xsl:call-template name="Header"/>
				<div class="Heading">
				<br/>
				<table cellpadding="0" cellspacing="0" border="0" width="100%">
							<tr>
								<td class="Heading">Summary <xsl:value-of select="test:name"/>
								</td>
								<td align="right">
									<a href="../Summary.xml">back to main</a>
								</td>
							</tr>
						</table>
				</div>
				<xsl:call-template name="SummaryTable"/>
				
				<div class="Heading"><br/><br/>Details</div>
				<xsl:for-each select="//test:report//test:testcase">
					<xsl:variable name="testID" select="test:id"/>
					<div id="{$testID}" style="margin-bottom:15px">
						<table cellpadding="0" cellspacing="0" border="0" width="100%">
							<tr>
								<td class="TableTitle"><a> <xsl:attribute name="name"><xsl:value-of select="test:name"/></xsl:attribute><b>Test Set: <xsl:value-of select="test:name"/></b></a>
								</td>
								<td align="right">
									<a href="#top">
										<div align="right">top</div>
									</a>
								</td>
							</tr>
						</table>
						<xsl:call-template name="TestCaseTable"/>
					</div>
				</xsl:for-each>
			</body>
		</html>
	</xsl:template>
	<xsl:template name="html-head">
		<head>
			<meta http-equiv="Content-Type" content="text/html;CHARSET=iso-8859-1"/>
			<title>Test Report - <xsl:value-of select="//test:report/test:time"/>
			</title>
			<!--Javascript for expand and collapse of test info / error trace -->
			<script language="JavaScript">
				// hides or shows given div and change contents of the switcher itself
				function switchdiv(switcher, sw, closedname, openedname) {
					//alert("Switcher: " + switcher.tagName + " Switched: " + switched.tagName + "." + switched.id);
					switched = document.getElementById(sw);
					if (switched.style.display == "none") {
						switched.style.display = "block";
						switched.style.marginLeft = "10px";
						switcher.innerText = openedname;
					}  else {
						switched.style.display = "none";
						switcher.innerText = closedname;
					}
					window.event.cancelBubble = true;
					return false;
				}
		    </script>
		    <!-- CSS styles definitions -->
			<style type="text/css">
			        BODY	{  BACKGROUND-REPEAT: no-repeat; FONT-FAMILY: Arial, Helvetica, sans-serif; BACKGROUND-COLOR: #ffffff } 
					.PageTitle { PADDING-BOTTOM: 8px;FONT-WEIGHT: bold; FONT-SIZE: medium; COLOR: #336699;  FONT-FAMILY: Arial, Times New Roman, Times, serif }
					.PageTitleSmall { PADDING-RIGHT: 8px; FONT-WEIGHT: bold; FONT-SIZE: x-small; COLOR: #336699; FONT-FAMILY: Arial, Times New Roman, Times, serif }
					.Heading { MARGIN-BOTTOM: 10px; MARGIN-TOP:15px; FONT-SIZE:medium; FONT-FAMILY: Arial, Helvetica, sans-serif; COLOR:#336699 }
					.TableTitle { PADDING-TOP: 8px;FONT-SIZE: small; COLOR: #336699; FONT-FAMILY: Arial,Helvetica,Geneva,sans-serif; BACKGROUND-COLOR: #ffffff }
					.LargeTable { BORDER-RIGHT: #cccccc 1px solid; PADDING-RIGHT: 4px; BORDER-TOP: #cccccc 1px solid; PADDING-LEFT: 4px; BORDER-LEFT: #cccccc 1px solid; BORDER-BOTTOM: #cccccc 1px solid; BORDER-COLLAPSE: collapse;  BACKGROUND-COLOR: #999966 }
					.LargeTableHeader {FONT-WEIGHT: bold; FONT-SIZE: x-small; VERTICAL-ALIGN: bottom;  FONT-FAMILY: Arial,Helvetica,Geneva,sans-serif; BACKGROUND-COLOR: #93a9d5 }
					.LargeTableText { FONT-SIZE: x-small;  MARGIN-BOTTOM: 0px; PADDING-BOTTOM: 1px; VERTICAL-ALIGN: top; COLOR: #000000; PADDING-TOP: 2px; FONT-FAMILY: Arial,Helvetica,Geneva,sans-serif; BORDER-COLLAPSE: collapse; BACKGROUND-COLOR: #f7f7e7 }
					.LargeTableSideHeader { WIDTH: 150px ; FONT-WEIGHT: bold; FONT-SIZE: x-small; VERTICAL-ALIGN: middle; FONT-FAMILY: Arial,Helvetica,Geneva,sans-serif; BACKGROUND-COLOR: #93a9d5 }
					.SmallTable { BORDER-RIGHT: #000000 1px; BORDER-TOP: #000000 1px; MARGIN: 0px; BORDER-LEFT: #000000 1px; BORDER-BOTTOM: #000000 1px; BORDER-COLLAPSE: collapse }
					.SmallTableHeader { FONT-SIZE: xx-small; VERTICAL-ALIGN: bottom; TEXT-ALIGN: left }
					.SmallTableText { FONT-SIZE: x-small; VERTICAL-ALIGN: top;  COLOR: #555555 }
					.Timestamp {  }
					.EventName { COLOR: #003366 }
					.NameValueTable { PADDING-RIGHT: 0px; PADDING-LEFT: 0px; FONT-SIZE: x-small;  PADDING-BOTTOM: 0px; MARGIN: 0px; WIDTH: 100%;    BORDER-TOP-STYLE: none; PADDING-TOP: 0px; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-COLLAPSE: collapse; BORDER-BOTTOM-STYLE: none }
					.TreeSwitcher { FONT-WEIGHT: bold; FONT-SIZE: x-small; VERTICAL-ALIGN: top;CURSOR: pointer }
					.BigValue { BORDER-RIGHT: #cccccc 1px solid; PADDING-RIGHT: 2px;BORDER-TOP: #cccccc 1px solid; PADDING-LEFT: 2px;FONT-SIZE: x-small;   PADDING-BOTTOM: 2px; BORDER-LEFT: #cccccc 1px solid; WIDTH: 100%; PADDING-TOP: 2px; BORDER-BOTTOM: #cccccc 1px solid; BORDER-COLLAPSE: collapse}
					.ValueName { PADDING-RIGHT: 4px; FONT-SIZE: x-small; WIDTH: 100px }
					.ValueText { FONT-SIZE: x-small;  WIDTH: 100%; COLOR: #555555 }
					.TestInfoHeader { FONT-WEIGHT: bold;FONT-SIZE: x-small; VERTICAL-ALIGN: middle; WIDTH: 100px; FONT-FAMILY: Arial,Helvetica,Geneva,sans-serif;BACKGROUND-COLOR: #eeee99 }
					.InnerTestInfoHeader { FONT-WEIGHT: bold;FONT-SIZE: xx-small; VERTICAL-ALIGN: middle; WIDTH: 100px; FONT-FAMILY: Arial,Helvetica,Geneva,sans-serif;BACKGROUND-COLOR: #eeee99 }
					.InnerValueText { FONT-SIZE: xx-small;  WIDTH: 100%; COLOR: #555555 }
					.TestMethodTable {  PADDING-RIGHT: 4px; PADDING-LEFT: 4px; BORDER-COLLAPSE: collapse; BACKGROUND-COLOR: #9999ee }
			</style>
		</head>
	</xsl:template>
	<xsl:template name="Header">
	        <br/>
		<table cellpadding="0" cellspacing="0" border="0">
			<tr class="PageTitle">
				<td colspan="2">
					<a name="top">
					   <!--<xsl:value-of select="//test:component"/>-->
					   <xsl:text>OCI Automation</xsl:text>
					    
					</a>
				</td>
			</tr>
			<tr><td><br/></td></tr>
			<tbody class="PageTitleSmall">
				<tr>
					<td>Environment:</td>
					<td>
					  <xsl:value-of select="//test:report/test:build"/>
					</td>
				</tr>
				<tr>
					<td>Start Time:</td>
					<td>
					  <xsl:value-of select="//test:report/test:starttime"/>
					</td>
				</tr>
				<tr>
					<td>End Time:</td>
					<td>
					  <xsl:value-of select="//test:report/test:endtime"/>
					</td>
				</tr>
				<tr>
					<td>Testing Account:</td>
					<td>
                        <xsl:value-of select="//test:report/test:tester"/>					
					</td>
				</tr>
				<tr>
					<td>Browser:</td>	<td>Firefox 14.0.1</td>							
				</tr>
				<tr>
					<td>OS:</td>
					<td>
						<xsl:value-of select="//test:report/test:system/test:OS"/>
						<xsl:text>, </xsl:text>
						<xsl:value-of select="//test:report/test:system/test:OS-version"/>
					</td>
				</tr>
				<tr>
					<td>Testing Language:</td>
					<td>
						    <xsl:value-of select="//test:report/test:language"/>
					</td>
				</tr>							
				<tr>
					<td>Time Elapsed:</td>
					<td>
						<xsl:variable name="exec_time" select="//test:report/test:elapse"/>
						
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
					</td>
				</tr>	
				<tr>
					<td>Config:</td>
					<td>
					<div class="TreeSwitcher" style="margin-left:6px">
					<xsl:attribute name="onclick">
					  switchdiv(this, 'configuration_secion', "+Show","-Hide")
                   			 </xsl:attribute>  
                   			 +Show
                   			 </div>
                   			 <div style="display:none" width="100%" class="ValueText" id='configuration_secion'>
						<xsl:for-each select="//test:report//test:config//test:param">
							<xsl:choose>
							  <xsl:when test="contains(@name,'QTP_SERVER')">
							    SELENIUM_SERVER=<xsl:value-of select="@value"/><br/>
							  </xsl:when>
							  <xsl:otherwise>
							     <xsl:value-of select="@name"/>=<xsl:value-of select="@value"/><br/>
							  </xsl:otherwise>
							</xsl:choose>						
						</xsl:for-each>
					 </div>
						
					</td>
				</tr>
				<tr>
				</tr>
			</tbody>
		</table>
	</xsl:template>
	
	<xsl:template name="SummaryTable">
		<table id="TestSuiteTable" class="LargeTable" border="1" cellpadding="0" width="100%">
			<thead>
				<tr class="LargeTableHeader">
					<th HEIGHT='20px'>Test Set</th>
				  <th HEIGHT='20px'>Pass</th>					
					<th HEIGHT='20px'>Fail</th>					
					<th HEIGHT='20px'>Can Not Run (CNR)</th>	
					<th HEIGHT='20px'>Warning</th>					
				</tr>
			</thead>
			<tbody class="LargeTableText">
				<xsl:variable name="totaltests" select="count(//test:test)"/>
				<xsl:variable name="passedtest" select="count(//test:test[@result='Passed'])"/>					
				<xsl:variable name="failedtest" select="count(//test:test[@result='Failed'])"/>	
				<xsl:variable name="cnrtest" select="count(//test:test[@result='CNR'])"/>
				<xsl:variable name="warntest" select="count(//test:test[@result='Warning'])"/>
				<xsl:for-each select="//test:testcase">					
					<xsl:variable name="casetotaltests" select="count(./test:test)"/>
					<xsl:variable name="casepassedtest" select="count(./test:test[@result='Passed'])"/>					
					<xsl:variable name="casefailedtest" select="count(./test:test[@result='Failed'])"/>
					<xsl:variable name="casecnrtest" select="count(./test:test[@result='CNR'])"/>						
					<xsl:variable name="casewarntest" select="count(./test:test[@result='Warning'])"/>						
					<tr onmouseover="this.bgColor='#eeeeaa'" onmouseout="this.bgColor='#f7f7e7'">
						<td>
							<a>
								<xsl:attribute name="href"><xsl:value-of select="concat('#',test:name)"/></xsl:attribute>								
								<xsl:value-of select="test:name"/>
							</a>
						</td>
						<td align="center">							
						     <table border="0"><tr><td align="left">
							<xsl:value-of select="$casepassedtest"/>
							</td><td></td><td align="right">
							<xsl:text>[</xsl:text>
							<xsl:value-of select="floor($casepassedtest div $casetotaltests * 100+ 0.5)"/>
							<xsl:text>%</xsl:text>
							<xsl:text>]</xsl:text>
							</td></tr></table>
						</td>						
						<td align="center">
							<xsl:if test="$casefailedtest &gt; 0">
								<xsl:attribute name="bgcolor">#ffcccc</xsl:attribute>
							</xsl:if>
							<table border="0"><tr><td align="left">
							<xsl:value-of select="$casefailedtest"/>
							</td><td></td><td align="right">
							<xsl:text>[</xsl:text>
							<xsl:value-of select="floor($casefailedtest div $casetotaltests * 100+ 0.5)"/>
							<xsl:text>%</xsl:text>
							<xsl:text>]</xsl:text>
							</td></tr></table>
						</td>
						<td align="center">
							<xsl:if test="$casecnrtest &gt; 0">
								<xsl:attribute name="bgcolor">#ffd24d</xsl:attribute>
							</xsl:if>
							<table border="0"><tr><td align="left">
							<xsl:value-of select="$casecnrtest"/>
							</td><td></td><td align="right">
							<xsl:text>[</xsl:text>
							<xsl:value-of select="floor($casecnrtest div $casetotaltests * 100+ 0.5)"/>
							<xsl:text>%</xsl:text>
							<xsl:text>]</xsl:text>
							</td></tr></table>
						</td>
						<td align="center">
							<xsl:if test="$casewarntest &gt; 0">
								<xsl:attribute name="bgcolor">#ffd24d</xsl:attribute>
							</xsl:if>
							<table border="0"><tr><td align="left">
							<xsl:value-of select="$casewarntest"/>
							</td><td></td><td align="right">
							<xsl:text>[</xsl:text>
							<xsl:value-of select="floor($casewarntest div $casetotaltests * 100+ 0.5)"/>
							<xsl:text>%</xsl:text>
							<xsl:text>]</xsl:text>
							</td></tr></table>
						</td>
					</tr>
				</xsl:for-each>
				<tr onmouseover="this.bgColor='#eeeeaa'" onmouseout="this.bgColor='#f7f7e7'">
						<td>
							<a>
								<!--<xsl:attribute name="href">#</xsl:attribute>		-->						
								Total
							</a>
						</td>
						<td align="center">							
						     <table border="0"><tr><td align="left">
							<xsl:value-of select="$passedtest"/>
							</td><td></td><td align="right">
							<xsl:text>[</xsl:text>
							<xsl:value-of select="floor($passedtest div $totaltests * 100+ 0.5)"/>
							<xsl:text>%</xsl:text>
							<xsl:text>]</xsl:text>
							</td></tr></table>
						</td>	
						<td align="center">
							<xsl:if test="$failedtest &gt; 0">
								<xsl:attribute name="bgcolor">#ffcccc</xsl:attribute>
							</xsl:if>
							<table border="0"><tr><td align="left">
							<xsl:value-of select="$failedtest"/>
							</td><td></td><td align="right">
							<xsl:text>[</xsl:text>
							<xsl:value-of select="floor($failedtest div $totaltests * 100+ 0.5)"/>
							<xsl:text>%</xsl:text>
							<xsl:text>]</xsl:text>
							</td></tr></table>
						</td>
						<td align="center">
							<xsl:if test="$cnrtest &gt; 0">
								<xsl:attribute name="bgcolor">#ffd24d</xsl:attribute>
							</xsl:if>
							<table border="0"><tr><td align="left">
							<xsl:value-of select="$cnrtest"/>
							</td><td></td><td align="right">
							<xsl:text>[</xsl:text>
							<xsl:value-of select="floor($cnrtest div $totaltests * 100+ 0.5)"/>
							<xsl:text>%</xsl:text>
							<xsl:text>]</xsl:text>
							</td></tr></table>
						</td>
						<td align="center">
							<xsl:if test="$warntest &gt; 0">
								<xsl:attribute name="bgcolor">#ffd24d</xsl:attribute>
							</xsl:if>
							<table border="0"><tr><td align="left">
							<xsl:value-of select="$warntest"/>
							</td><td></td><td align="right">
							<xsl:text>[</xsl:text>
							<xsl:value-of select="floor($warntest div $totaltests * 100+ 0.5)"/>
							<xsl:text>%</xsl:text>
							<xsl:text>]</xsl:text>
							</td></tr></table>
						</td>
				</tr>
			</tbody>
		</table>
		
	</xsl:template>
	<xsl:template name="TestCaseTable">
		<xsl:variable name="testID" select="test:id"/>
		<xsl:variable name="elapsed" select="test:elapse"/>
		<table class="LargeTable" width="100%" border="1" cellpadding="0">
			<tbody class="LargeTableText">
				
				<tr>
					<td class="LargeTableSideHeader">Overall Result</td>
					<td>
						<xsl:choose>
							<xsl:when test="test:test[@result='Failed']">
								<xsl:attribute name="bgcolor">#ffcccc</xsl:attribute>
								<xsl:text>Failed</xsl:text>
							</xsl:when>
							<xsl:when test="test:test[@result='CNR']">
									<xsl:attribute name="bgcolor">#ffcccc</xsl:attribute>
									<xsl:text>Failed</xsl:text>
							</xsl:when>
							<xsl:when test="test:test[@result='Warning']">
									<xsl:attribute name="bgcolor">#ccffcc</xsl:attribute>
									<xsl:text>Warning</xsl:text>
							</xsl:when>
							<xsl:otherwise>								
								<xsl:if test="test:test[@result='Passed']">
									<xsl:attribute name="bgcolor">#ccffcc</xsl:attribute>
									<xsl:text>Passed</xsl:text>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:if test="test:test[@result='Failed']">
							<xsl:attribute name="bgcolor">#ffcccc</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="@result"/>
					</td>
				</tr>
				
								
				<!--<xsl:apply-templates select="test:component"/>
				<xsl:apply-templates select="test:subcomponent"/>
				<xsl:apply-templates select="test:area"/>-->
				<xsl:apply-templates select="test:description"/>	
				<tr>
					<td class="LargeTableSideHeader">Execution Elapsed</td>
					<td>
						<xsl:choose>
							<xsl:when test="$elapsed &gt; 3600">
								<xsl:value-of select="floor($elapsed div 3600)"/> hr <xsl:value-of select="floor(($elapsed mod 3600) div 60)"/> min <xsl:value-of select="$elapsed mod 60"/> sec
							</xsl:when>
							<xsl:when test="$elapsed &gt; 60">
								<xsl:value-of select="floor($elapsed div 60)"/> min <xsl:value-of select="$elapsed mod 60"/> sec
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$elapsed"/> sec
							</xsl:otherwise>
						</xsl:choose>						
					</td>
				</tr>			
				<tr>
					<td class="LargeTableSideHeader">Tests</td>
					<td>
						<table class="LargeTable" cellpadding="0" border="1" width="100%">
							<tbody class="LargeTableText">
								<xsl:apply-templates select="test:test"/>
							</tbody>
						</table>
					</td>
				</tr>
			</tbody>
		</table>
	</xsl:template>
	
	<xsl:template match="test:component">
		<tr>
			<td class="LargeTableSideHeader">Component</td>
			<td>
				<xsl:value-of select="text()"/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="test:subcomponent">
		<tr>
			<td class="LargeTableSideHeader">Sub-component</td>
			<td>
				<xsl:value-of select="text()"/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="test:area">
		<tr>
			<td class="LargeTableSideHeader">Area</td>
			<td>
				<xsl:value-of select="text()"/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="test:description">
		<tr>
			<td class="LargeTableSideHeader">Description</td>
			<td>
				<xsl:value-of select="text()"/>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="test:test">
		<tr>
			<td width="100%">
				<xsl:if test="@result='Passed'">
					<xsl:attribute name="bgcolor">#ccffcc</xsl:attribute>
				</xsl:if>
				<xsl:if test="@result='Failed'">
					<xsl:attribute name="bgcolor">#ffcccc</xsl:attribute>
				</xsl:if>
				<xsl:if test="@result='CNR'">
					<xsl:attribute name="bgcolor">#ffd24d</xsl:attribute>
				</xsl:if>
				<xsl:if test="@result='Warning'">
					<xsl:attribute name="bgcolor">#ffd24d</xsl:attribute>
				</xsl:if>
				<xsl:variable name="first-line">
					<xsl:choose>					
					<xsl:when test="@result='Failed'">
						<xsl:value-of select="test:name"/>&#32;&#45;&#32;<xsl:text>Failed</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="@result='CNR'">
							<xsl:value-of select="test:name"/>&#32;&#45;&#32;<xsl:text>Can Not Run (CNR)</xsl:text>
						</xsl:if>
						<xsl:if test="@result='Passed'">
							<xsl:value-of select="test:name"/>&#32;&#45;&#32;<xsl:text>Passed</xsl:text>
						</xsl:if>
						<xsl:if test="@result='Warning'">
							<xsl:value-of select="test:name"/>&#32;&#45;&#32;<xsl:text>Warning</xsl:text>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
				</xsl:variable>
				<xsl:variable name="switch-on">+<xsl:value-of select="$first-line"/>
				</xsl:variable>
				<xsl:variable name="switch-off">-<xsl:value-of select="$first-line"/>
				</xsl:variable>
				<div width="100%">
				   <xsl:variable name="unqId" select="generate-id(.)"/>
					<div class="TreeSwitcher" style="margin-left:6px">
					<xsl:attribute name="onclick">
					  switchdiv(this, '<xsl:value-of select="$unqId"/>', "<xsl:value-of select="$switch-on"/>","<xsl:value-of select="$switch-off"/>")
                    </xsl:attribute>  
				    <xsl:value-of select="$switch-on"/>
					</div>
					<div style="display:none" width="100%" class="ValueText">
					    <xsl:attribute name="id"><xsl:value-of select="$unqId"/></xsl:attribute> 
						<table class="LargeTable" cellpadding="0" cellspacing="0" border="1" width="100%">
							<tbody class="LargeTableText">
								
								<tr>
									<td class="InnerTestInfoHeader">Time Elapsed</td>
									<td class="InnerValueText">
										<xsl:choose>
											<xsl:when test="@elapsed &gt; 3600">
												<xsl:value-of select="floor(@elapsed div 3600)"/> hr <xsl:value-of select="floor((@elapsed mod 3600) div 60)"/> min <xsl:value-of select="@elapsed mod 60"/> sec
											</xsl:when>
											<xsl:when test="@elapsed &gt; 60">
												<xsl:value-of select="floor(@elapsed div 60)"/> min <xsl:value-of select="@elapsed mod 60"/> sec
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="@elapsed"/> sec
											</xsl:otherwise>
										</xsl:choose>										
									</td>
								</tr>
								
								<xsl:if test="test:desc">
								
									<tr>
										<td class="InnerTestInfoHeader">
											<b>Description</b>
										</td>
										<td class="InnerValueText" style="white-space:pre">
											<xsl:value-of select="test:desc"/>
										</td>
									</tr>
								
								</xsl:if>
								
								<xsl:if test="test:output">
								
									<tr>
										<td class="InnerTestInfoHeader">
											<b>Message</b>
										</td>
										<td class="InnerValueText" style="white-space:pre">
											<xsl:variable name="output" select="test:output" />
											<xsl:call-template name="LineBreaker">
												<xsl:with-param name="line" select="substring-after($output, '&#xA;')"/>
												<xsl:with-param name="separator" select="'&#xA;'"/>
											</xsl:call-template>
										</td>
									</tr>
								
								</xsl:if>
								<xsl:if test="test:error">
								
									<tr>
										<td class="InnerTestInfoHeader">
											<b>Failure</b>
										</td>
										<td class="InnerValueText" style="white-space:pre">
											<xsl:variable name="error" select="test:error" />
											<xsl:call-template name="LineBreaker">
												<xsl:with-param name="line" select="substring-after($error, '&#xA;')"/>
												<xsl:with-param name="separator" select="'&#xA;'"/>
											</xsl:call-template>
										</td>
									</tr>
								
								</xsl:if>
								<xsl:if test="test:system-out">
									<tr>
										<td class="InnerTestInfoHeader">
											<b>Log</b>
										</td>
										<td class="InnerValueText">
											<a>
												<xsl:attribute name="href"><xsl:value-of select="test:system-out/@href"/></xsl:attribute>
												<xsl:attribute name="target">_new</xsl:attribute>
												Test Log
											</a></td>
									</tr>
								</xsl:if>
								<xsl:if test="test:testrunner-log">
									<tr>
										<td class="InnerTestInfoHeader">
											<b>Run Log</b>
										</td>
										<td class="InnerValueText">
											<a>
												<xsl:attribute name="href">../../../artifact/build/test/opccomputeqa/results/TestRunner.log.0/*view*</xsl:attribute>
												<xsl:attribute name="target">_new</xsl:attribute>
												Run Log
											</a></td>
									</tr>
								</xsl:if>
								<xsl:if test="test:screenshot">
									<tr>
										<td class="InnerTestInfoHeader">
											<b>Screenshot</b>
										</td>
										<td class="InnerValueText">
											<a>
												<xsl:attribute name="href"><xsl:value-of select="test:screenshot/@href"/></xsl:attribute>
												<xsl:attribute name="target">_new</xsl:attribute>
												Screenshots
											</a></td>
									</tr>
								</xsl:if>
							</tbody>
						</table>
					</div>
				</div>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="text()"/>

	<xsl:template name="LineBreaker">

		<xsl:param name="line"/>
		<xsl:param name="separator"/>
		<xsl:value-of select="substring-before($line, $separator)"/>
		<br/>
				
		<xsl:choose>	
			<xsl:when test="string-length(substring-after($line, $separator)) != 0">
	
				<xsl:call-template name="LineBreaker">
					<xsl:with-param name="line" select="substring-after($line, $separator)"/>
					<xsl:with-param name="separator" select="$separator"/>
				</xsl:call-template>	
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
					
		
	</xsl:template>

</xsl:stylesheet>
