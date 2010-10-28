package org.sopera.dita.framework;

import java.awt.TextArea;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JProgressBar;

public class InputStreamDataListener implements Runnable {
    Process proc;
    TextArea logTextArea;
    JProgressBar progressBar;
    int i = 0;

    InputStreamDataListener(Process proc, TextArea logTextArea, JProgressBar progressBar, int i) {
             this.proc = proc;
             this.logTextArea = logTextArea;
             this.progressBar = progressBar;
             this.i = i;
    }

    public void run() {
        try {
            InputStream istr = proc.getInputStream();
            BufferedReader br = new BufferedReader(new InputStreamReader(istr));
            String str;
            progressBar.setValue(1);
            while ((str = br.readLine()) != null) {
            	logTextArea.append(str + "\r\n");
                if (str.indexOf("dita2pdf:") >= 0) {
                    progressBar.setValue(10 + (i * 100));
                }
                if (str.indexOf("check-arg:") >= 0) {
                    progressBar.setValue(20 + (i * 100));
                }
                if (str.indexOf("conref-check:") >= 0) {
                    progressBar.setValue(30 + (i * 100));
                }
                if (str.indexOf("map2pdf2:") >= 0) {
                    progressBar.setValue(40 + (i * 100));
                }
                if (str.indexOf("transform.topic2fo:") >= 0) {
                    progressBar.setValue(50 + (i * 100));
                }
                if (str.indexOf("checkFOPLib:") >= 0) {
                    progressBar.setValue(60 + (i * 100));
                }
            }
            try {
                proc.waitFor();
            } catch (InterruptedException e) {
            	logTextArea.append("Error\r\n");
            }
            br.close();
            istr.close();
            progressBar.setValue(100);
        } catch (IOException ex) {
            Logger.getLogger(InputStreamDataListener.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}