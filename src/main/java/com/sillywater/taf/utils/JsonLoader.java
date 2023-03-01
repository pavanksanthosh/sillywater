package com.sillywater.taf.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.json.Json;
import javax.json.JsonArray;
import javax.json.JsonException;
import javax.json.JsonObject;
import javax.json.JsonReader;

public class JsonLoader {

	public static Map<String, Object> jsonToMap(File jsonFile) throws JsonException, FileNotFoundException {
		JsonReader reader = Json.createReader(new FileInputStream(jsonFile));
		JsonObject json = reader.readObject();
		return jsonToMap(json);
	}

	public static Map<String, Object> jsonToMap(JsonObject json) throws JsonException {
		Map<String, Object> retMap = new HashMap<String, Object>();

		if (json != JsonObject.NULL) {
			retMap = convertToMap(json);
		}
		return retMap;
	}

	public static Map<String, Object> convertToMap(JsonObject object) throws JsonException {
		Map<String, Object> map = new HashMap<String, Object>();
		Iterator<String> keysItr = object.keySet().iterator();
		while (keysItr.hasNext()) {
			String key = keysItr.next();
			Object value = object.get(key);

			if (value instanceof JsonArray) {
				value = convertToList((JsonArray) value);
				map.put(key, value);
			} else if (value instanceof JsonObject) {
				value = convertToMap((JsonObject) value);
				map.put(key, value);
			} else {
				map.put(key, object.getString(key));
			}
		}
		return map;
	}

	public static List<Object> convertToList(JsonArray array) throws JsonException {
		List<Object> list = new ArrayList<Object>();
		for (int i = 0; i < array.size(); i++) {
			Object value = array.get(i);
			if (value instanceof JsonArray) {
				value = convertToList((JsonArray) value);
				list.add(value);
			} else if (value instanceof JsonObject) {
				value = convertToMap((JsonObject) value);
				list.add(value);
			} else {
				list.add(String.valueOf(array.get(i)).replaceAll("^\"|\"$", ""));				
			}
		}
		return list;
	}

}
