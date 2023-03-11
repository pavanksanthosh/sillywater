package com.sillywater.taf.report;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.util.List;

import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.apache.commons.io.FileUtils;
import org.testng.ISuite;

import com.sillywater.taf.base.Configuration;
import com.sillywater.taf.log.Logger;

public class HTMLReporter implements IReporter {
	private static Logger logger = new Logger(HTMLReporter.class);

	@Override
	public void generate(List<ISuite> suites, String logDir, String reportFileName) throws Exception {
		String inputXmlFile = logger.getReportDir() + File.separator + reportFileName + ".xml";
		String outputHtmlFile = logger.getReportDir() + File.separator + "Report.html";

		TransformerFactory tfactory = TransformerFactory.newInstance();
		try {
			FileUtils.copyFile(
					new File(logger.getHomeDir() + File.separator + "common" + File.separator
							+ Configuration.getConfig().getReportTheme() + ".css"),
					new File(logger.getReportDir() + File.separator + Configuration.getConfig().getReportTheme()
							+ ".css"));
			FileUtils.copyFile(
					new File(logger.getHomeDir() + File.separator + "common" + File.separator
							+ Configuration.getConfig().getReportTheme() + ".js"),
					new File(logger.getReportDir() + File.separator + Configuration.getConfig().getReportTheme()
							+ ".js"));
		} catch (FileNotFoundException e) {
		}
		FileUtils.copyFile(new File(logger.getHomeDir() + File.separator + "common" + File.separator + "chart.min.js"),
				new File(logger.getReportDir() + File.separator + "chart.min.js"));

		Transformer transformer = tfactory.newTransformer(new StreamSource(logger.getHomeDir() + File.separator
				+ "common" + File.separator + Configuration.getConfig().getReportTheme() + ".xsl"));
		transformer.transform(new StreamSource(inputXmlFile),
				new StreamResult(new OutputStreamWriter(new FileOutputStream(outputHtmlFile), "UTF-8")));

		/*
		 * TransformerFactory factory = new net.sf.saxon.TransformerFactoryImpl();
		 * StreamSource inputXml = new StreamSource(new File(inputXmlFile));
		 * StreamSource xslt = new StreamSource(new File(logger.getHomeDir() +
		 * File.separator + "common" + File.separator +
		 * Configuration.getConfig().getRunnerProperty("report_theme")));
		 * 
		 * StreamResult output = new StreamResult(new File(outputHtmlFile)); Transformer
		 * transformer = factory.newTransformer(xslt); transformer.transform(inputXml,
		 * output);
		 */
		logger.log("Generated HTML Report.");
	}
}
