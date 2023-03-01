package com.sillywater.taf.log;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

class LoggingOutputStream extends ByteArrayOutputStream {
	private Logger logger;
	private String lineSeparator = System.getProperty("line.separator");

	public LoggingOutputStream(Logger logger) {
		this.logger = logger;
	}

	public void flush() throws IOException {
		synchronized (this) {
			super.flush();
			String record = this.toString();
			super.reset();
			if (record.length() != 0 && !record.equals(this.lineSeparator)) {
				this.logger.logp(Level.INFO, "", "", record);
			}
		}
	}
}