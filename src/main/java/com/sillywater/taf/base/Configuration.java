package com.sillywater.taf.base;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import com.sillywater.taf.log.LogLevel;
import com.sillywater.taf.log.Logger;
import com.sillywater.taf.utils.JsonLoader;

public class Configuration {
	private static Configuration env = null;
	protected Properties runner_prop = new Properties();
	// private Properties test_prop = new Properties();
	protected Map<String, Object> test_prop;
	protected String home_dir;
	protected static Logger logger = new Logger(Configuration.class);

	private Configuration() throws FileNotFoundException, IOException {
		this.init(); 
	}
	
	public synchronized static Configuration getConfig() {
		if (env == null) {
			try {
				env = new Configuration();
			} catch (Exception e) {
				System.out.println("[ERROR] Error while reading the configuration file. " + e.getMessage());
				e.printStackTrace();
				//logger.log(LogLevel.ERROR, e);
			}				
		}
		return env;
	}
	
	public String getRunnerProperty(String property) {
		return this.runner_prop.getProperty(property);				
	}

	public String getStringProperty(String property) {
		String defaultValue = "";
		if (this.getStringPropertyInternal(property) != null && !this.getStringPropertyInternal(property).isEmpty())
			defaultValue = this.getStringPropertyInternal(property);
		else {
			defaultValue = getFromEnv(property);
		}
		if (defaultValue.isEmpty()) {
			logger.log(LogLevel.WARN, "Empty setup of property: " + property);
		}
		return defaultValue;
	}

	private String getStringPropertyInternal(String property) {
		if (this.test_prop.get(property) != null) {
			return this.test_prop.get(property).toString();
		}
		return null;
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getMapProperty(String property) {
		if (this.test_prop.get(property) != null && this.test_prop.get(property) instanceof Map) {
			return (Map<String, Object>) this.test_prop.get(property);
		}
		return null;
	}

	@SuppressWarnings("unchecked")
	public List<Object> getListProperty(String property) {
		if (this.test_prop.get(property) != null && this.test_prop.get(property) instanceof List) {
			return (List<Object>) this.test_prop.get(property);
		}
		return null;
	}

	protected void init() throws FileNotFoundException, IOException {
		this.home_dir = System.getProperty("user.dir");
		this.runner_prop.load(new FileInputStream(
				this.home_dir + File.separator + "config" + java.io.File.separator + "runner.conf"));
		// this.test_prop.loadFromXML(new FileInputStream(
		// this.home_dir + File.separator + "config" + java.io.File.separator +
		// "test_conf.xml"));
		this.test_prop = JsonLoader.jsonToMap(
				new File(this.home_dir + File.separator + "config" + java.io.File.separator + "test_conf.json"));
		this.overrideWithEnvValues();
		this.configureProxy();
	}

	private void overrideWithEnvValues() {
		for (String key : this.test_prop.keySet()) {
			if (this.getFromEnv(key) != null && !this.getFromEnv(key).isEmpty()) {
				this.test_prop.put(key, this.getFromEnv(key));
			}
		}
	}

	private String getFromEnv(String property) {
		String defaultValue = "";
		if (System.getProperty(property) != null && !System.getProperty(property).isEmpty())
			defaultValue = System.getProperty(property);
		else if (System.getenv(property) != null && !System.getenv(property).isEmpty())
			defaultValue = System.getenv(property);
		return defaultValue;
	}
	
	private void configureProxy() throws MalformedURLException {
		/*if(System.getProperty("http.proxyHost") == null || System.getProperty("http.proxyHost").isEmpty()) {
			System.setProperty("java.net.useSystemProxies", "true");
		}*/
		if(System.getProperty("http.proxyHost") == null || System.getProperty("http.proxyHost").isEmpty()) {
			if(System.getenv("http_proxy") != null && !System.getenv("http_proxy").isEmpty()) {
				URL url = new URL(System.getenv("http_proxy"));
				System.setProperty("http.proxyHost", url.getHost());
				System.setProperty("http.proxyPort", String.valueOf(url.getPort()));
			}
		}
		if(System.getProperty("https.proxyHost") == null || System.getProperty("https.proxyHost").isEmpty()) {
			if(System.getenv("https_proxy") != null && !System.getenv("https_proxy").isEmpty()) {
				URL url = new URL(System.getenv("https_proxy"));
				System.setProperty("https.proxyHost", url.getHost());
				System.setProperty("https.proxyPort", String.valueOf(url.getPort()));
			}
		}
	}
	
	boolean isCleanupDisabled() {
		return ((String) this.runner_prop.get("cleanup_resources")).toLowerCase().contains("false");
	}
}