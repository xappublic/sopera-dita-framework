/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package searchgen;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import javax.swing.text.Document;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

/**
 *
 * @author Admin
 */
public class Main {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws ParserConfigurationException, SAXException, IOException, XPathExpressionException {
        if(args.length < 2)
        {
            System.out.println("Add args\r\nFirst arg - path to ditamap\r\nSecond arg - path to out directory with last slash");
            return;
        }
        String pathDitamap = args[0];
        String pathOut = args[1];

        System.out.println(pathDitamap);
        System.out.println(pathOut);

        String map = loadFileAsString(pathDitamap, "UTF8");
        map = map.replaceFirst("<!DOCTYPE(.*?)>", "");
        OutputStreamWriter fmap = new OutputStreamWriter(new FileOutputStream("tmpmap.xml"), "UTF8");
        char[] bufmap = new char[map.length()];
        map.getChars(0, bufmap.length, bufmap, 0);
        fmap.write(bufmap, 0, bufmap.length);
        fmap.close();

        System.out.println("Generated tempmap.xml (ditamap without doctype)");

        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        factory.setValidating(false);
        factory.setNamespaceAware(true); // never forget this!
        DocumentBuilder builder = factory.newDocumentBuilder();
        ErrorChecker errors = new ErrorChecker();
        builder.setErrorHandler(errors);
        org.w3c.dom.Document doc = builder.parse("tmpmap.xml");

        XPathFactory xPathFactory = XPathFactory.newInstance();
        XPath xpath = xPathFactory.newXPath();
        XPathExpression expr = xpath.compile("//topicref/@href");
        Object result = expr.evaluate(doc, XPathConstants.NODESET);
        NodeList nodes = (NodeList) result;

        System.out.println("Start writing");

        String res = "<?xml version=\"1.0\" encoding=\"utf-8\" ?>\r\n<files>";
        OutputStreamWriter f = new OutputStreamWriter(new FileOutputStream(pathOut + "searchdata.xml"), "UTF8");
        try {
            char[] buffirst = new char[res.length()];
            res.getChars(0, buffirst.length, buffirst, 0);
            f.write(buffirst, 0, buffirst.length);
            for (int i = 0; i < nodes.getLength(); i++) {
                //System.out.println(nodes.item(i).getNodeValue());
                //System.out.println("\r\n----------------------------------------\r\n");
                String body = loadFileAsString(pathOut + nodes.item(i).getNodeValue().replaceAll(".xml", ".html"), "UTF8");
                String title = body.substring(body.indexOf("<title>") + 7, body.indexOf("</title>"));
                //System.out.println(title);
                //System.out.println("\r\n----------------------------------------\r\n");
                //System.out.println(body);
                res = "\r\n\t<file>";
                res += "\r\n\t\t<name>";
                res += title;
                res += "</name>";
                res += "\r\n\t\t<text><![CDATA[\r\n";
                res += body;
                res += "]]>\r\n</text>";
                res += "\r\n\t</file>";
                char[] buf = new char[res.length()];
                res.getChars(0,buf.length,buf,0);
                f.write(buf, 0, buf.length);
            }
            res = "\r\n</files>";
            char[] buflast = new char[res.length()];
            res.getChars(0, buflast.length, buflast, 0);
            f.write(buflast, 0, buflast.length);
        }
        catch (IOException e) {
          try {f.close();} catch (Exception e1) {};
          return;
         }
         f.close();
         System.out.println("End writing");
         System.out.println("Delete tmpmap");
         File fTmpMap = new File("tmpmap.xml");
         fTmpMap.delete();
    }

    private static String loadFileAsString(String file, String encoding) throws FileNotFoundException, UnsupportedEncodingException, IOException {
        InputStreamReader f = encoding ==null?
        new FileReader(file):
        new InputStreamReader(
        new FileInputStream(file),encoding);

        StringBuilder sb = new StringBuilder();

        try {
          char[] buf= new char[32768];
          int len;
          while ((len=f.read(buf,0,buf.length))>=0) {
            sb.append(buf,0,len);
          }
          return sb.toString();
        }
        finally {
                  try {f.close();} catch (Exception e) {};
        }
    }
}
