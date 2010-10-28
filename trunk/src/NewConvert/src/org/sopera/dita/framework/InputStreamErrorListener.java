package org.sopera.dita.framework;

import java.awt.TextArea;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.logging.Level;
import java.util.logging.Logger;

public class InputStreamErrorListener implements Runnable {
	Process proc;
	TextArea logTextArea;
	Thread isdlThread;

	InputStreamErrorListener(Process proc, TextArea logTextArea, Thread isdlThread) {
		this.proc = proc;
		this.logTextArea = logTextArea;
		this.isdlThread = isdlThread;
	}

	public void run() {
		InputStream istr = proc.getErrorStream();
		BufferedReader br = new BufferedReader(new InputStreamReader(istr));
		String str;
		try {
			while ((str = br.readLine()) != null) {
				logTextArea.append(str + "\r\n");
			}
		} catch (IOException ex) {
			Logger.getLogger(InputStreamErrorListener.class.getName()).log(
					Level.SEVERE, null, ex);
		}

		try {
			proc.waitFor();
		} catch (InterruptedException e) {
		}
		try {
			br.close();
			istr.close();
		} catch (IOException ex) {
			Logger.getLogger(InputStreamErrorListener.class.getName()).log(
					Level.SEVERE, null, ex);
		}
		isdlThread.interrupt();
		isdlThread = null;
	}
}