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
			<body link="663300" alink="#FF6600" vlink="#996633" bgcolor="#F5F2EF">
				<table><tr><xsl:call-template name="top-banner"/></tr></table>
				<br/><br/>
					<table class="ChartParentTable">
						<tr><td><xsl:call-template name="environment"/></td>
						<td>
							<xsl:if test="$charttype != 'none'">
								<div class="ChartCanvas"><canvas id="swchart" ></canvas></div>
								<script>createchart('<xsl:value-of select="$charttype"/>', 'swchart', <xsl:value-of select="$passedtest"/>, <xsl:value-of select="$failedtest"/>, <xsl:value-of select="$warntest"/>, <xsl:value-of select="$cnrtest"/>, '<xsl:value-of select="concat('#', $pass_color)"/>', '<xsl:value-of select="concat('#', $fail_color)"/>', '<xsl:value-of select="concat('#', $warn_color)"/>', '<xsl:value-of select="concat('#', $nr_color)"/>')</script>
							</xsl:if>
						</td>
					</tr></table>
				<!-- <xsl:call-template name="configurations"/> -->
			<!-- Add the Chart Here -->
			    
				<xsl:variable name="noofsuites" select="count(//sw:suite)"/>
				<xsl:choose>
					<xsl:when test="$noofsuites &gt; 1">
						<table cellpadding="0" cellspacing="0" border="0" width="100%" class="LargeTable">
							<tr><td class="SummaryTitle"> Summary </td></tr>
					   		<xsl:call-template name="OverallSummaryTable"/>
						</table>
						<br/>
						<table cellpadding="0" cellspacing="0" border="0" width="100%" class="LargeTable">
							<tr><td><div class="TestSuiteTreeSwitcher" style="text-align:left">
								<xsl:attribute name="onclick">
									switchdiv(this, 'testsuitessummarytable', "+TestSuites Summary","-TestSuites Summary")
					            </xsl:attribute>
								+TestSuites Summary
							</div></td></tr>
							<tr><td><div style="display:none;font-size: medium; margin-left: 10px" width="100%"
								class="TestSuiteTreeSwitcher" id='testsuitessummarytable'>
									<xsl:call-template name="TestSetsSummaryTable" />
							</div></td></tr>
						</table>
					</xsl:when>
					<xsl:otherwise>
						<table cellpadding="0" cellspacing="0" border="0"
							width="100%">
							<tr>
								<td class="SummaryTitle"> Summary  </td>
							</tr>
							<xsl:call-template name="TestSetsSummaryTable" />
						</table>
					</xsl:otherwise>
				</xsl:choose>
				<br/>
				
				<table cellpadding="0" cellspacing="0" border="0" width="100%" class="LargeTable">
					<tr><td><div class="TestSuiteTreeSwitcher" style="text-align:left">
						<xsl:attribute name="onclick">
							switchdiv(this, 'detailedresultstable', "+Detailed Results","-Detailed Results")
			            </xsl:attribute>
						-Detailed Results
					</div></td></tr>
					<tr><td><div style="display:block;font-size: medium; margin-left: 10px" width="100%"
						class="TestSuiteTreeSwitcher" id='detailedresultstable'>
						<xsl:for-each select="//sw:report//sw:suite">
							<xsl:variable name="suiteID" select="sw:name"/>
							
							<xsl:variable name="switch-on">+Test Suite: <xsl:value-of select="$suiteID"/>
							</xsl:variable>
							<xsl:variable name="switch-off">-Test Suite: <xsl:value-of select="$suiteID"/>
							</xsl:variable>
							
							<table cellpadding="0" cellspacing="0" border="0" width="100%" class="LargeTable">
								<tr><td><div class="TestSuiteTreeSwitcher" style="text-align:left">
									<xsl:attribute name="onclick">
										switchdiv(this, 'suite<xsl:value-of select="$suiteID"/>', "<xsl:value-of select="$switch-on"/>", "<xsl:value-of select="$switch-off"/>")
						            </xsl:attribute>
									<xsl:value-of select="$switch-off"/>
								</div></td></tr>
								<tr><td><div style="display:block;font-size: medium; margin-left: 10px" width="100%" class="TestSuiteTreeSwitcher" id="suite{$suiteID}">
									<xsl:for-each select="./sw:testset">
										<xsl:variable name="testsetID" select="sw:id" />
										<div id="{$suiteID}{$testsetID}" style="margin-bottom:15px">
											<table cellpadding="0" cellspacing="0" border="0" width="100%" class="LargeTable">
												<tr>
													<td class="TableTitle">
															<xsl:attribute name="name"><xsl:value-of select="sw:name"/></xsl:attribute><b>Test Set: <xsl:value-of select="concat($suiteID, '/', sw:name)"/></b>
													</td>
													<td align="right"><a href="#top1"><div align="right">top</div></a></td>
												</tr>
											</table>
											<xsl:call-template name="TestCaseTable"/>
										</div>
									</xsl:for-each>
								</div></td></tr>
							</table>
						</xsl:for-each>
					</div></td></tr>
				</table>
			</body>
		</html>
	</xsl:template>

	<xsl:template name="html-header">
		<head>
			<meta http-equiv="Content-Type" content="text/html;CHARSET=UTF-8"/>
			<title>Report - <xsl:value-of select="//sw:report/sw:starttime"/></title>
			<script src="./chart.min.js"></script>
			<script>
			//<![CDATA[
			      window.onclick = function(event) {
					  if ((event.target != document.getElementById('popupwindow')) && (event.target != document.getElementById('openpopupwindow'))) {
					    closeDialog();
					  }
					}
			      function openDialog() {
					let popup = document.getElementById('popupwindow')
			      	popup.classList.add("openpopupwindow")
			      }
			      function closeDialog() {
					let popup = document.getElementById('popupwindow')
			      	popup.classList.remove("openpopupwindow")
			      }
			//]]>
			</script>
			<script language="JavaScript">
				function switchdiv(switcher, sw, closedname, openedname) {
					//alert("Switcher: " + switcher.tagName + " Switched: " + switched.tagName + "." + switched.id);
					console.log("switchdiv function called");
					console.log("element:", switcher);
					  console.log("targetId:", sw);
					  console.log("expandText:", openedname);
					  console.log("collapseText:", closedname);
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
				<script>
				function createchart(type, element, passcount, failcount, warncount, nrcount, passcolor, failcolor, warncolor, nrcolor) {
					console.log("type:", type);
					console.log("element:", element);
					console.log("passcount:", passcount);
					console.log("failcount:", failcount);
					console.log("warncount:", warncount);
					console.log("nrcount:", nrcount);
					const ctx = document.getElementById(element);
					const data = {
					  labels: ['Pass', 'Fail', 'Warning', 'Not Run'],
					  datasets: [{
					    label: 'Test Results',
					    data: [passcount, failcount, warncount, nrcount],
					    backgroundColor: [
					      passcolor,
					      failcolor,
					      warncolor,
					      nrcolor
					    ],
					    borderColor: [
					      '#92D794',
					      '#F4A1A1',
					      '#FBD07B',
					      '#D5D4A0'
					    ],
					    borderWidth: 1
					  }]
					};
					const options = {
					  responsive: true,
					  plugins: { legend: { position: 'right', align:'center' }},
					  maintainAspectRatio : false
					};
					return new Chart(ctx, {
					    type: type,
					    data: data,
					    options: options
					});
				}
			</script>
			<!-- CSS styles definitions -->
			<style type="text/css">
			        BODY	{  height: 100%; BACKGROUND-REPEAT: no-repeat; FONT-FAMILY: Arial, Helvetica, sans-serif; BACKGROUND-COLOR: #F5F2EF } 
					.PageTitle { PADDING-BOTTOM: 2px; FONT-SIZE: 26px; COLOR: #ffffff;  FONT-FAMILY: Arial, Times New Roman, Times, serif; top: 0;}
					.PageTitleTime { COLOR: #ffffff; }
					.PageTitleSmall { PADDING-RIGHT: 10px; FONT-SIZE: small; COLOR: #336699; FONT-FAMILY: Arial, Times New Roman, Times, serif }
					.ConfigTreeSwitcher { FONT-WEIGHT: bold; FONT-SIZE: small; VERTICAL-ALIGN: center; CURSOR: pointer; COLOR: #336699}
					.TestSuiteTreeSwitcher { FONT-WEIGHT: bold; FONT-SIZE: large; VERTICAL-ALIGN: bottom; CURSOR: pointer; COLOR: #336699; FONT-FAMILY: Arial,Helvetica,Geneva,sans-serif; BACKGROUND-COLOR: #F5F2EF}
					.Heading { MARGIN-BOTTOM: 10px; MARGIN-TOP:2px; FONT-SIZE:medium;FONT-WEIGHT: bold; FONT-FAMILY: Arial, Helvetica, sans-serif; COLOR:#336699 }
					.SummaryTitle { PADDING-TOP: 8px; FONT-WEIGHT: bold; FONT-SIZE: large; COLOR: #336699; FONT-FAMILY: Arial,Helvetica,Geneva,sans-serif; BACKGROUND-COLOR: #F5F2EF }
					.SummaryTableText { FONT-SIZE: medium;  MARGIN-BOTTOM: 0px; PADDING-LEFT: 4px; PADDING-BOTTOM: 1px; VERTICAL-ALIGN: top; COLOR: #000000; PADDING-TOP: 2px; FONT-FAMILY: Arial,Helvetica,Geneva,sans-serif; BORDER-COLLAPSE: collapse; BACKGROUND-COLOR: #E5E5E1 }
					.TableTitle { PADDING-TOP: 8px;FONT-SIZE: medium; COLOR: #336699; FONT-FAMILY: Arial,Helvetica,Geneva,sans-serif; BACKGROUND-COLOR: #F5F2EF }
					.LargeTable { BORDER-RIGHT: #cccccc 1px solid; PADDING-RIGHT: 4px; BORDER-TOP: #cccccc 1px solid; PADDING-LEFT: 4px; BORDER-LEFT: #cccccc 1px solid; BORDER-BOTTOM: #cccccc 1px solid; BORDER-COLLAPSE: collapse;  BACKGROUND-COLOR: #F5F2EF; table-layout: fixed; width: 100%; border-radius: 4px; overflow: hidden; transition: max-height 0.5s ease-out;}
					.LargeTableHeader {FONT-WEIGHT: bold; FONT-SIZE: medium; VERTICAL-ALIGN: bottom;  FONT-FAMILY: Arial,Helvetica,Geneva,sans-serif; BACKGROUND-COLOR: #AECAD8 }
					.LargeTableText { FONT-SIZE: small;  MARGIN-BOTTOM: 0px; PADDING-LEFT: 4px; PADDING-BOTTOM: 1px; VERTICAL-ALIGN: top; COLOR: #000000; PADDING-TOP: 2px; FONT-FAMILY: Arial,Helvetica,Geneva,sans-serif; BORDER-COLLAPSE: collapse; BACKGROUND-COLOR: #E5E5E1 }
					.LargeTableSideHeader { WIDTH: 150px ; FONT-SIZE: medium; VERTICAL-ALIGN: middle; FONT-FAMILY: Arial,Helvetica,Geneva,sans-serif; PADDING-LEFT: 4px; BACKGROUND-COLOR: #E5EAF4 }
					.SmallTable { BORDER-RIGHT: #000000 1px; BORDER-TOP: #000000 1px; MARGIN: 0px; BORDER-LEFT: #000000 1px; BORDER-BOTTOM: #000000 1px; BORDER-COLLAPSE: collapse; transition: max-height 0.5s ease-out; }
					.SmallTableHeader { FONT-SIZE: small; VERTICAL-ALIGN: bottom; TEXT-ALIGN: left }
					.SmallTableText { FONT-SIZE: small; VERTICAL-ALIGN: top;  COLOR: #000000 }
					.Timestamp {  }
					.EventName { COLOR: #003366 }
					.NameValueTable { PADDING-RIGHT: 0px; PADDING-LEFT: 0px; FONT-SIZE: x-small;  PADDING-BOTTOM: 0px; MARGIN: 0px; WIDTH: 100%;    BORDER-TOP-STYLE: none; PADDING-TOP: 0px; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-COLLAPSE: collapse; BORDER-BOTTOM-STYLE: none }
					.TreeSwitcher { FONT-WEIGHT: bold; FONT-SIZE: small; VERTICAL-ALIGN: top;CURSOR: pointer }
					.BigValue { BORDER-RIGHT: #cccccc 1px solid; PADDING-RIGHT: 2px;BORDER-TOP: #cccccc 1px solid; PADDING-LEFT: 2px;FONT-SIZE: x-small;   PADDING-BOTTOM: 2px; BORDER-LEFT: #cccccc 1px solid; WIDTH: 100%; PADDING-TOP: 2px; BORDER-BOTTOM: #cccccc 1px solid; BORDER-COLLAPSE: collapse}
					.ValueName { PADDING-RIGHT: 4px; FONT-SIZE: x-small; WIDTH: 100px }
					.ValueText { FONT-SIZE: x-small;  WIDTH: 100%; COLOR: #555555 }
					.TestInfoHeader { FONT-WEIGHT: bold;FONT-SIZE: x-small; VERTICAL-ALIGN: center; WIDTH: 100px; FONT-FAMILY: Arial,Helvetica,Geneva,sans-serif;BACKGROUND-COLOR: #D0D0CC }
					.InnerTestInfoHeader { FONT-WEIGHT: bold;FONT-SIZE: small; VERTICAL-ALIGN: center; WIDTH: 100px; FONT-FAMILY: Arial,Helvetica,Geneva,sans-serif;BACKGROUND-COLOR: #D0D0CC; padding-left: 8px }
					.InnerValueText { FONT-SIZE: small;  WIDTH: 100%; COLOR: #000000; BACKGROUND-COLOR: #E5E5E1; padding-left: 8px; VERTICAL-ALIGN: center; MARGIN-BOTTOM: 0px; PADDING-BOTTOM: 1px; PADDING-TOP: 2px; FONT-FAMILY: Arial,Helvetica,Geneva,sans-serif; BORDER-COLLAPSE: collapse; }
					.testCellText { FONT-SIZE: small;  WIDTH: 100%; COLOR: #000000; BORDER-COLLAPSE: collapse }
					.TestMethodTable {  PADDING-RIGHT: 4px; PADDING-LEFT: 4px; BORDER-COLLAPSE: collapse; BACKGROUND-COLOR: #9999ee }
					.top-banner-root { background-color:#01836D; border-radius=10px; position: absolute;    top: 0;left: 0;    right: 0;    padding: 5px;    margin: 0 0 5px 0; font-family: Arial, Times New Roman, Times, serif; text-align: center; font-size: large}
					.testsetheader {FONT-WEIGHT: bold; FONT-SIZE: small; VERTICAL-ALIGN: bottom }
					.ConfigTableText { FONT-SIZE: small;  MARGIN-BOTTOM: 0px; PADDING-BOTTOM: 1px; VERTICAL-ALIGN: top; COLOR: #000000; PADDING-TOP: 2px; FONT-FAMILY: Arial,Helvetica,Geneva,sans-serif; BORDER-COLLAPSE: collapse; BACKGROUND-COLOR: #E1E7E1 }
					table, th, td {border: 1px solid #F5F2EF; border-radius: 10px}
					.ChartParentTable { table-layout: fixed; width: 100%; background-color:#F5F2EF; align:top}
					.ChartCanvas { height: 30vh; width: 100%; }
					.popupwindow { COLOR: #000000; background: #D9DCD9; border-radius: 6px; position: absolute; top: 10%; left: 15%;  width: 60%; height: 80%; z-index:60; text-align: left; padding: 0 30px 30px; visibility: hidden; transition: transform 0.4s top 0.4s; BORDER-RIGHT: #cccccc 1px solid; BORDER-TOP: #cccccc 1px solid; BORDER-LEFT: #cccccc 1px solid; BORDER-BOTTOM: #cccccc 1px solid;}
					.openpopupwindow { visibility: visible; overflow-y: scroll;}
					.popupwindow h3 { font-size: 16px; font-weight: bold; margin: 30px 0 10px; COLOR: #000000;}
					.popupwindow button { float: right; width: 52px; margin-top: 50px; padding: 10px 0; background: #AEAFAE; color: #232B5A; border: 0; outline: none; font-size: 12px; border-radius: 4px; cursor: pointer; box-shadow: 0 2px 5px rgba(0,0,0, 0.2);}
					.closepopupwindow { color: #aaaaaa; float: right; font-size: 28px; font-weight: bold; }
					.closepopupwindow:hover,
					.closepopupwindow:focus { color: #000; text-decoration: none; cursor: pointer; }
			</style>
		</head>
	</xsl:template>
	
	<xsl:template name="top-banner">
		<div class="top-banner-root">
	      <a name="top1"><span class="PageTitle center">SillyWater Report</span> <span class="PageTitleTime"> - <xsl:value-of select="//sw:report/sw:starttime"/></span></a>
	      <br/>
	    </div>
	</xsl:template>

	<xsl:template name="environment">
		<table cellpadding="0" cellspacing="0" border="0">
			<tr class="Heading">
				<td colspan="2">
					<a name="top">
						<xsl:text>Execution Details</xsl:text>
					</a>
				</td>
			</tr>
			<!-- <tr><td><br/></td></tr> -->
			<tbody class="PageTitleSmall">
				<tr>
					<td>Start Time:</td>
					<td>
						<xsl:value-of select="//sw:report/sw:starttime" />
					</td>
				</tr>
				<tr>
					<td>End Time:</td>
					<td>
						<xsl:value-of select="//sw:report/sw:endtime" />
					</td>
				</tr>
				<tr>
					<td>User:</td>
					<td>
						<xsl:value-of select="//sw:report/sw:tester" />
					</td>
				</tr>
				<tr>
					<td>OS:</td>
					<td>
						<xsl:value-of select="//sw:report/sw:system/sw:OS" />
						<xsl:text>, </xsl:text>
						<xsl:value-of select="//sw:report/sw:system/sw:OS-version"/>
					</td>
				</tr>
				<tr>
					<td>Duration:</td>
					<td>
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
					</td>
				</tr>
				<tr>
					<td>
						<a id="openpopupwindow" type="button" class="btn" onclick="openDialog()" href="#">Open Test Config</a>
						<div class="popupwindow" id="popupwindow">
							<span class="closepopupwindow" onclick="closeDialog()">&#x2716;</span>
							<h3>Test Configuration</h3>
							<xsl:for-each select="//sw:report//sw:config//sw:param">
							 	<span style="font-weight:bold"><xsl:value-of select="@name"/></span> : <xsl:value-of select="@value"/><br/>
							</xsl:for-each>
							<button type="button" onclick="closeDialog()">Close</button>
						</div>
					</td>
				</tr>
				<tr>
					<td>
						<a>
						<xsl:attribute name="href">../TestRunner.log.0</xsl:attribute>
						<xsl:attribute name="target">_new</xsl:attribute>
							Open Detailed Log
						</a>
					</td>
				</tr>
				<tr>
					<td>
						<a>
						<xsl:attribute name="href">../</xsl:attribute>
						<xsl:attribute name="target">_new</xsl:attribute>
							Open Results Directory
						</a>
					</td>
				</tr>
			</tbody>
		</table>
	</xsl:template>

	<xsl:template name="configurations">
		<table cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td><div class="ConfigTreeSwitcher" style="text-align:left">
					<xsl:attribute name="onclick">
						switchdiv(this, 'configuration_secion', "+Test Configuration","-Test Configuration")
			               	</xsl:attribute>  
			               	+Test Configuration
			              	</div>
			    <div style="display:none;font-size: medium" width="100%" class="ValueText" id='configuration_secion'>
				    <div class="ConfigTableText">
						<xsl:for-each select="//sw:report//sw:config//sw:param">
							 <xsl:value-of select="@name"/> = <xsl:value-of select="@value"/><br/>
						</xsl:for-each>
					</div>
				</div></td>
			</tr>
			<tr></tr>
		</table>
	</xsl:template>

	<xsl:template name="OverallSummaryTable">
		<table id="TestSuiteTable" class="LargeTable" border="1" cellpadding="0" width="100%">
			<thead>
				<tr class="LargeTableHeader" style="line-height:24px">
					<th HEIGHT='20px'>Test Suite</th>
					<th HEIGHT='20px'>Pass</th>
					<th HEIGHT='20px'>Fail</th>
					<th HEIGHT='20px'>Warning</th>
					<th HEIGHT='20px'>Not Run (NR)</th>
				</tr>
			</thead>
			<tbody class="SummaryTableText">
				<xsl:for-each select="//sw:suite">	
					<xsl:variable name="casetotaltests" select="count(./sw:testset//sw:test)"/>
					<xsl:variable name="casepassedtest" select="count(./sw:testset//sw:test[@result='Passed'])"/>					
					<xsl:variable name="casefailedtest" select="count(./sw:testset//sw:test[@result='Failed'])"/>
					<xsl:variable name="casecnrtest" select="count(./sw:testset//sw:test[@result='CNR'])"/>						
					<xsl:variable name="casewarntest" select="count(./sw:testset//sw:test[@result='Warning'])"/>	
					<tr onmouseover="this.bgColor='#eeeeaa'" onmouseout="this.bgColor='#f7f7e7'" style="line-height:24px">
						<td class="LargeTableSideHeader">
							<a>
								<xsl:attribute name="href">#suite<xsl:value-of select="sw:name"/></xsl:attribute>
								<xsl:value-of select="sw:name"/>
							</a>
						</td>
						<td align="center">
							<xsl:attribute name="bgcolor">#<xsl:value-of select="$pass_color"/></xsl:attribute>
							<xsl:value-of select="$casepassedtest"/>
							<xsl:text> [</xsl:text>
							<xsl:value-of select="floor($casepassedtest div $casetotaltests * 100+ 0.5)"/>
							<xsl:text>%</xsl:text>
							<xsl:text>]</xsl:text>
						</td>
						<td align="center">
							<xsl:attribute name="bgcolor">#<xsl:value-of select="$fail_color"/></xsl:attribute>
							<xsl:value-of select="$casefailedtest"/>
							<xsl:text> [</xsl:text>
							<xsl:value-of select="floor($casefailedtest div $casetotaltests * 100+ 0.5)"/>
							<xsl:text>%</xsl:text>
							<xsl:text>]</xsl:text>
						</td>
						<td align="center">
							<xsl:attribute name="bgcolor">#<xsl:value-of select="$warn_color"/></xsl:attribute>
							<xsl:value-of select="$casewarntest"/>
							<xsl:text> [</xsl:text>
							<xsl:value-of select="floor($casewarntest div $casetotaltests * 100+ 0.5)"/>
							<xsl:text>%</xsl:text>
							<xsl:text>]</xsl:text>
						</td>
						<td align="center">
							<xsl:attribute name="bgcolor">#<xsl:value-of select="$nr_color"/></xsl:attribute>
							<xsl:value-of select="$casecnrtest"/>
							<xsl:text> [</xsl:text>
							<xsl:value-of select="floor($casecnrtest div $casetotaltests * 100+ 0.5)"/>
							<xsl:text>%</xsl:text>
							<xsl:text>]</xsl:text>
						</td>
					</tr>
				</xsl:for-each>
				<tr onmouseover="this.bgColor='#eeeeaa'" onmouseout="this.bgColor='#f7f7e7'" style="line-height:24px">
						<td class="LargeTableSideHeader">
							<a>
								<!--<xsl:attribute name="href">#</xsl:attribute>		-->						
								Total
							</a>
						</td>
						<td align="center">			
							<xsl:attribute name="bgcolor">#<xsl:value-of select="$pass_color"/></xsl:attribute>
							<xsl:value-of select="$passedtest"/>
							<xsl:text> [</xsl:text>
							<xsl:value-of select="floor($passedtest div $totaltests * 100+ 0.5)"/>
							<xsl:text>%</xsl:text>
							<xsl:text>]</xsl:text>
						</td>	
						<td align="center">
								<xsl:attribute name="bgcolor">#<xsl:value-of select="$fail_color"/></xsl:attribute>
							<xsl:value-of select="$failedtest"/>
							<xsl:text> [</xsl:text>
							<xsl:value-of select="floor($failedtest div $totaltests * 100+ 0.5)"/>
							<xsl:text>%</xsl:text>
							<xsl:text>]</xsl:text>
						</td>
						<td align="center">
								<xsl:attribute name="bgcolor">#<xsl:value-of select="$warn_color"/></xsl:attribute>
							<xsl:value-of select="$warntest"/>
							<xsl:text> [</xsl:text>
							<xsl:value-of select="floor($warntest div $totaltests * 100+ 0.5)"/>
							<xsl:text>%</xsl:text>
							<xsl:text>]</xsl:text>
						</td>
						<td align="center">
							<xsl:attribute name="bgcolor">#<xsl:value-of select="$nr_color"/></xsl:attribute>
							<xsl:value-of select="$cnrtest"/>
							<xsl:text> [</xsl:text>
							<xsl:value-of select="floor($cnrtest div $totaltests * 100+ 0.5)"/>
							<xsl:text>%</xsl:text>
							<xsl:text>]</xsl:text>
						</td>
				</tr>
			</tbody>
		</table>
	</xsl:template>

	<xsl:template name="TestSetsSummaryTable">
	<xsl:for-each select="//sw:suite">
		<xsl:variable name="testsuiteID" select="sw:name"/>
		<div id="{$testsuiteID}" class="TableTitle">
			<table cellpadding="0" cellspacing="0" border="0" width="100%">
				<tr>
					<td class="Heading">Test Suite: <xsl:value-of select="./sw:name"/></td>
				</tr>
			</table>
		</div>
		<table id="TestSetTable" class="LargeTable" border="1" cellpadding="0" width="100%">
			<thead>
				<tr class="LargeTableHeader" style="line-height:24px">
					<th HEIGHT='20px'>Test Set</th>
				  <th HEIGHT='20px'>Pass</th>
					<th HEIGHT='20px'>Fail</th>
					<th HEIGHT='20px'>Warning</th>
					<th HEIGHT='20px'>Not Run (NR)</th>			
				</tr>
			</thead>
			<tbody class="SummaryTableText">
				<xsl:for-each select="./sw:testset">					
					<xsl:variable name="casetotaltests" select="count(./sw:test)"/>
					<xsl:variable name="casepassedtest" select="count(./sw:test[@result='Passed'])"/>					
					<xsl:variable name="casefailedtest" select="count(./sw:test[@result='Failed'])"/>
					<xsl:variable name="casecnrtest" select="count(./sw:test[@result='CNR'])"/>						
					<xsl:variable name="casewarntest" select="count(./sw:test[@result='Warning'])"/>
											
					<tr onmouseover="this.bgColor='#eeeeaa'" onmouseout="this.bgColor='#f7f7e7'" style="line-height:24px">
						<td class="LargeTableSideHeader">
							<a>
								<xsl:attribute name="href"><xsl:value-of select="concat('#',$testsuiteID,sw:id)"/></xsl:attribute>								
								<xsl:value-of select="sw:name"/>
							</a>
						</td>
						<td align="center">
							<xsl:attribute name="bgcolor">#<xsl:value-of select="$pass_color"/></xsl:attribute>	
							<xsl:value-of select="$casepassedtest"/>
							<xsl:text> [</xsl:text>
							<xsl:value-of select="floor($casepassedtest div $casetotaltests * 100+ 0.5)"/>
							<xsl:text>%</xsl:text>
							<xsl:text>]</xsl:text>
						</td>						
						<td align="center">
							<xsl:attribute name="bgcolor">#<xsl:value-of select="$fail_color"/></xsl:attribute>
							<xsl:value-of select="$casefailedtest"/>
							<xsl:text> [</xsl:text>
							<xsl:value-of select="floor($casefailedtest div $casetotaltests * 100+ 0.5)"/>
							<xsl:text>%</xsl:text>
							<xsl:text>]</xsl:text>
						</td>
						<td align="center">
							<xsl:attribute name="bgcolor">#<xsl:value-of select="$warn_color"/></xsl:attribute>
							<xsl:value-of select="$casewarntest"/>
							<xsl:text> [</xsl:text>
							<xsl:value-of select="floor($casewarntest div $casetotaltests * 100+ 0.5)"/>
							<xsl:text>%</xsl:text>
							<xsl:text>]</xsl:text>
						</td>
						<td align="center">
							<xsl:attribute name="bgcolor">#<xsl:value-of select="$nr_color"/></xsl:attribute>
							<xsl:value-of select="$casecnrtest"/>
							<xsl:text> [</xsl:text>
							<xsl:value-of select="floor($casecnrtest div $casetotaltests * 100+ 0.5)"/>
							<xsl:text>%</xsl:text>
							<xsl:text>]</xsl:text>
						</td>
					</tr>
				</xsl:for-each>
				<tr onmouseover="this.bgColor='#eeeeaa'" onmouseout="this.bgColor='#f7f7e7'" style="line-height:24px">
						<td class="LargeTableSideHeader">
							<a>
								Total
							</a>
						</td>
						<td align="center">	
							<xsl:attribute name="bgcolor">#<xsl:value-of select="$pass_color"/></xsl:attribute>
							<xsl:value-of select="$passedtest"/>
							<xsl:text> [</xsl:text>
							<xsl:value-of select="floor($passedtest div $totaltests * 100+ 0.5)"/>
							<xsl:text>%</xsl:text>
							<xsl:text>]</xsl:text>
						</td>	
						<td align="center">
							<xsl:attribute name="bgcolor">#<xsl:value-of select="$fail_color"/></xsl:attribute>
							<xsl:value-of select="$failedtest"/>
							<xsl:text> [</xsl:text>
							<xsl:value-of select="floor($failedtest div $totaltests * 100+ 0.5)"/>
							<xsl:text>%</xsl:text>
							<xsl:text>]</xsl:text>
						</td>
						<td align="center">
							<xsl:attribute name="bgcolor">#<xsl:value-of select="$warn_color"/></xsl:attribute>
							<xsl:value-of select="$warntest"/>
							<xsl:text> [</xsl:text>
							<xsl:value-of select="floor($warntest div $totaltests * 100+ 0.5)"/>
							<xsl:text>%</xsl:text>
							<xsl:text>]</xsl:text>
						</td>
						<td align="center">
							<xsl:attribute name="bgcolor">#<xsl:value-of select="$nr_color"/></xsl:attribute>
							<xsl:value-of select="$cnrtest"/>
							<xsl:text> [</xsl:text>
							<xsl:value-of select="floor($cnrtest div $totaltests * 100+ 0.5)"/>
							<xsl:text>%</xsl:text>
							<xsl:text>]</xsl:text>
						</td>
					</tr>
				</tbody>
			</table>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="TestCaseTable">
		<xsl:variable name="elapsed" select="sw:elapse"/>
		<table class="LargeTable" width="100%" border="1" cellpadding="0">
			<tbody class="LargeTableText">
				<tr>
					<td>
						<xsl:choose>
							<xsl:when test="sw:test[@result='Failed']">
								<xsl:attribute name="bgcolor">#<xsl:value-of select="$fail_color"/></xsl:attribute>
								<span class="testsetheader" style="padding-left: 8px">Result:</span><xsl:text>Failed</xsl:text>
							</xsl:when>
							<xsl:when test="sw:test[@result='CNR']">
								<xsl:attribute name="bgcolor">#<xsl:value-of select="$nr_color"/></xsl:attribute>
								<span class="testsetheader" style="padding-left: 8px">Result:</span><xsl:text>Not Run</xsl:text>
							</xsl:when>
							<xsl:when test="sw:test[@result='Warning']">
								<xsl:attribute name="bgcolor">#<xsl:value-of select="$warn_color"/></xsl:attribute>
								<span class="testsetheader" style="padding-left: 8px">Result:</span><xsl:text>Warning</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="sw:test[@result='Passed']">
									<xsl:attribute name="bgcolor">#<xsl:value-of select="$pass_color"/></xsl:attribute>
									<span class="testsetheader" style="padding-left: 8px">Result:</span><xsl:text>Passed</xsl:text>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
						<!-- Commented by pavanks: This doesn't work with saxon-->
						<!-- <xsl:if test="sw:test[@result='Failed']">
							<xsl:attribute name="bgcolor">#ffcccc</xsl:attribute>
						</xsl:if> -->
					</td>
				</tr>
				
								
				<!--<xsl:apply-templates select="sw:component"/>
				<xsl:apply-templates select="sw:subcomponent"/>
				<xsl:apply-templates select="sw:area"/>-->
				<xsl:apply-templates select="sw:description"/>	
				<tr>
					<td><span class="testsetheader" style="padding-left: 8px">Duration: </span>
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
					<td>
						<table class="LargeTable" cellpadding="0" border="1" width="100%" float="right">
							<tbody class="LargeTableText">
								<xsl:apply-templates select="sw:test"/>
							</tbody>
						</table>
					</td>
				</tr>
			</tbody>
		</table>
	</xsl:template>

	<xsl:template match="sw:component">
		<tr>
			<td class="LargeTableSideHeader">Component</td>
			<td>
				<xsl:value-of select="text()" />
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="sw:subcomponent">
		<tr>
			<td class="LargeTableSideHeader">Sub-component</td>
			<td>
				<xsl:value-of select="text()" />
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="sw:area">
		<tr>
			<td class="LargeTableSideHeader">Area</td>
			<td>
				<xsl:value-of select="text()" />
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="sw:description">
		<tr>
			<td class="LargeTableSideHeader">Description</td>
			<td>
				<xsl:value-of select="text()" />
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="sw:test">
		<tr>
			<td width="100%">
				<xsl:if test="@result='Passed'">
					<xsl:attribute name="bgcolor">#<xsl:value-of select="$pass_color"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="@result='Failed'">
					<xsl:attribute name="bgcolor">#<xsl:value-of select="$fail_color"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="@result='CNR'">
					<xsl:attribute name="bgcolor">#<xsl:value-of select="$nr_color"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="@result='Warning'">
					<xsl:attribute name="bgcolor">#<xsl:value-of select="$warn_color"/></xsl:attribute>
				</xsl:if>
				<xsl:variable name="first-line">
					<xsl:choose>					
					<xsl:when test="@result='Failed'">
						<xsl:value-of select="sw:name"/> <!-- &#32;&#45;&#32;<xsl:text>Failed</xsl:text>  -->
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="@result='CNR'">
							<xsl:value-of select="sw:name"/> <!-- &#32;&#45;&#32;<xsl:text>Can Not Run (CNR)</xsl:text>  -->
						</xsl:if>
						<xsl:if test="@result='Passed'">
							<xsl:value-of select="sw:name"/> <!-- &#32;&#45;&#32;<xsl:text>Passed</xsl:text>  -->
						</xsl:if>
						<xsl:if test="@result='Warning'">
							<xsl:value-of select="sw:name"/> <!-- &#32;&#45;&#32;<xsl:text>Warning</xsl:text>  -->
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
				</xsl:variable>
				<xsl:variable name="switch-on">+<xsl:value-of select="$first-line"/>
				</xsl:variable>
				<xsl:variable name="switch-off">-<xsl:value-of select="$first-line"/>
				</xsl:variable>
				<div width="100%">
					<xsl:variable name="unqId" select="generate-id(.)" />
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
									<td class="InnerTestInfoHeader">Duration</td>
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

								<xsl:if test="sw:desc">

									<tr>
										<td class="InnerTestInfoHeader">
											<b>Description</b>
										</td>
										<td class="InnerValueText" style="white-space:pre">
											<xsl:value-of select="sw:desc" />
										</td>
									</tr>

								</xsl:if>
								<xsl:if test="sw:system-out">
									<tr>
										<td class="InnerTestInfoHeader">
											<b>Log</b>
										</td>
										<td class="InnerValueText">
											<a>
												<xsl:attribute name="href"><xsl:value-of select="sw:system-out/@href"/></xsl:attribute>
												<xsl:attribute name="target">_new</xsl:attribute>
												Test Log
											</a></td>
									</tr>
								</xsl:if>
								<xsl:if test="sw:testrunner-log">
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
								<xsl:if test="sw:screenshot">
									<tr>
										<td class="InnerTestInfoHeader">
											<b>Screenshots</b>
										</td>
										<td class="InnerValueText">
											<a>
												<xsl:attribute name="href"><xsl:value-of select="sw:screenshot/@href"/></xsl:attribute>
												<xsl:attribute name="target">_new</xsl:attribute>
												Screenshots
											</a></td>
									</tr>
								</xsl:if>
								<xsl:if test="sw:output">
									<tr>
										<td class="InnerTestInfoHeader">
											<b>Messages</b>
										</td>
										<td class="InnerValueText" style="white-space:pre">
											<xsl:variable name="output" select="sw:output" />
											<xsl:call-template name="LineBreaker">
												<xsl:with-param name="line" select="substring-after($output, '&#xA;')"/>
												<xsl:with-param name="separator" select="'&#xA;'"/>
											</xsl:call-template>
										</td>
									</tr>

								</xsl:if>
								<xsl:if test="sw:error">
									<tr>
										<td class="InnerTestInfoHeader">
											<b>Failure</b>
										</td>
										<td class="InnerValueText" style="white-space:pre">
											<xsl:variable name="error" select="sw:error" />
											<xsl:call-template name="LineBreaker">
												<xsl:with-param name="line" select="substring-after($error, '&#xA;')"/>
												<xsl:with-param name="separator" select="'&#xA;'"/>
											</xsl:call-template>
										</td>
									</tr>
								</xsl:if>
							</tbody>
						</table>
					</div>
				</div>
			</td>
		</tr>
	</xsl:template>

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
			<xsl:otherwise />
		</xsl:choose>


	</xsl:template>
</xsl:stylesheet>