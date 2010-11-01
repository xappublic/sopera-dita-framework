package org.sopera.dita.framework;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JProgressBar;
import javax.swing.JTextArea;

public class InputStreamDataListener implements Runnable {
    Process proc;
    JTextArea logTextArea;
    JTextArea shortLogTextArea;
    JProgressBar progressBar;
    JProgressBar shortLogProgressBar;
    int i = 0;
    int countFiles = 0;
    InputStreamDataListener(Process proc, JTextArea logTextArea, JProgressBar progressBar, int i, JTextArea shortLogTextArea, JProgressBar shortLogProgressBar, int countFiles) {
             this.proc = proc;
             this.logTextArea = logTextArea;
             this.shortLogTextArea = shortLogTextArea;
             this.shortLogProgressBar = shortLogProgressBar;
             this.progressBar = progressBar;
             this.i = i;
             this.countFiles = countFiles;
    }

    private void shortLog(String str)
    {
    	if (str.indexOf("java -jar GetImageList.jar") >= 0) {
            shortLogTextArea.append("Creates a list of images from a file and determines their size\r\n");
        }
    	if (str.indexOf("get info image:") >= 0) {
    		shortLogTextArea.append("Getting information about image " + str.replace("get info image:", "") + "\r\n");
    	}
    	if (str.indexOf("cant open img:") >= 0) {
    		shortLogTextArea.append("Can't open image " + str.replace("cant open img:", "") + "\r\n");
    	}
    	if (str.indexOf("createAll:") >= 0) {
            shortLogTextArea.append("Started preparations for the transformation\r\n");
        }
    	if (str.indexOf("xmlvalidate") >= 0) {
            shortLogTextArea.append("began the process of validation files\r\n");
        }
    	if (str.indexOf("have been successfully validated") >= 0) {
            shortLogTextArea.append("Validation have been successfully completed\r\n");
        }
    	if (str.indexOf("data2pdf:") >= 0) {
            shortLogTextArea.append("Preparations for the transformation of PDF\r\n");
        }
    	if (str.indexOf("check-arg:") >= 0) {
            shortLogTextArea.append("Checking of arguments passed\r\n");
        }
    	if (str.startsWith("preprocess:")) {
            shortLogTextArea.append("Transformation\r\n");
        }
    	if (str.indexOf("clean-temp:") >= 0) {
            shortLogTextArea.append("Delete temporary files\r\n");
        }
    	if (str.indexOf("data2eclipsehelp:") >= 0) {
    		shortLogTextArea.append("Preparations for the transformation of Eclipse Help\r\n");
        }
    	if (str.indexOf("data2xhtml:") >= 0) {
    		shortLogTextArea.append("Preparations for the transformation of xHTML\r\n");
        }
    	if (str.indexOf("BUILD SUCCESSFUL") >= 0) {
    		shortLogTextArea.append("BUILD SUCCESSFUL\r\n");
        }
    	if (str.indexOf("Total time:") >= 0) {
    		shortLogTextArea.append(str + "\r\n");
        }
    }
    
    public void run() {
        try {
            InputStream istr = proc.getInputStream();
            BufferedReader br = new BufferedReader(new InputStreamReader(istr));
            String str;
            progressBar.setValue(1);
            shortLogProgressBar.setValue(1);
            while ((str = br.readLine()) != null) {
            	logTextArea.append(str + "\r\n");
            	logTextArea.setCaretPosition(logTextArea.getDocument().getLength());
            	shortLog(str);
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
                shortLogProgressBar.setValue(progressBar.getValue());
            }
            try {
                proc.waitFor();
            } catch (InterruptedException e) {
            	logTextArea.append("Error\r\n");
            	logTextArea.setCaretPosition(logTextArea.getDocument().getLength());
            }
            br.close();
            istr.close();
            progressBar.setValue(100 * countFiles);
            shortLogProgressBar.setValue(progressBar.getValue());            
        } catch (IOException ex) {
            Logger.getLogger(InputStreamDataListener.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}