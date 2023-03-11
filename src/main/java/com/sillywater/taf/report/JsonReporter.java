package com.sillywater.taf.report;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;

import org.json.JSONException;
import org.json.JSONObject;
import org.json.XML;
import org.testng.ISuite;

import com.sillywater.taf.log.Logger;

public class JsonReporter implements IReporter {
	private static Logger logger = new Logger(JsonReporter.class);

	@Override
	public void generate(List<ISuite> suites, String logDir, String reportFileName) throws JSONException, IOException {
		String inputXmlFile = logger.getReportDir() + File.separator + reportFileName + ".xml";
		String outputJsonFile = logger.getReportDir() + File.separator + "Report.json";

		JSONObject xmlJSONObj = XML.toJSONObject(new String(Files.readAllBytes(Paths.get(inputXmlFile))));
		BufferedWriter writer = new BufferedWriter(new FileWriter(outputJsonFile));
		writer.write(xmlJSONObj.toString(4));
		writer.close();

		logger.log("Generated Json Report.");
	}
}
