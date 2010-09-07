/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package convert;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JTextArea;
import org.omg.PortableInterceptor.SYSTEM_EXCEPTION;

/**
 *
 * @author Admin
 */
public class InputStreamListener implements Runnable {
    Process proc;
    JTextArea jTextArea1;
    Thread isdlThread;

    InputStreamListener(Process proc, JTextArea jTextArea1, Thread isdlThread) {
             this.proc = proc;
             this.jTextArea1 = jTextArea1;
             this.isdlThread = isdlThread;
    }

    public void run() {
       InputStream istr = proc.getErrorStream();
       BufferedReader br = new BufferedReader(new InputStreamReader(istr));
       String str;
        try {
            while ((str = br.readLine()) != null) {
                jTextArea1.append(str + "\r\n");                
            }
        } catch (IOException ex) {
            Logger.getLogger(InputStreamListener.class.getName()).log(Level.SEVERE, null, ex);
        }
       
       try { proc.waitFor(); }
       catch (InterruptedException e) { }
        try {
            br.close();
            istr.close();
        } catch (IOException ex) {
            Logger.getLogger(InputStreamListener.class.getName()).log(Level.SEVERE, null, ex);
        }
       isdlThread.interrupt();
       isdlThread = null;
    }
}
