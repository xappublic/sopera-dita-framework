/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package getimagelist;

import java.awt.Image;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.List;
import javax.imageio.ImageIO;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;
import org.w3c.dom.NodeList;
import org.xml.sax.EntityResolver;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

/**
 *
 * @author Администратор
 */
public class Main {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws SAXException, ParserConfigurationException, XPathExpressionException, IOException {
        String mapFilePath = "";
        if(args.length == 0) { System.out.println("add arg with path to xml file"); return; }
        else mapFilePath = args[0];
        //mapFilePath = "C:\\bin\\sopera-dita-framework\\in\\bpm_users_guide.ditamap";

        File mapFile = new File(mapFilePath);
        List<FilesList> files = new ArrayList<FilesList>();

        files.add(new FilesList(mapFile.getParent() + "\\", mapFilePath)); // Добавляем первый файл в список файлов

        
        //Создаем начало файла
        {
            String res = "<?xml version=\"1.0\" encoding=\"utf-8\" ?>\r\n<images>\r\n";
            OutputStreamWriter f = new OutputStreamWriter(new FileOutputStream("images.xml", false), "UTF8");
            char[] buflast = new char[res.length()];
            res.getChars(0, buflast.length, buflast, 0);
            f.write(buflast, 0, buflast.length);
            f.flush();
            f.close();
        }

        while(files.size() > 0)
        {
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            factory.setValidating(false);
            factory.setNamespaceAware(true); // never forget this!
            DocumentBuilder builder = factory.newDocumentBuilder();
            builder.setEntityResolver(new EntityResolver() {
                @Override
                public InputSource resolveEntity(String publicId, String systemId)
                        throws SAXException, IOException {
                    System.out.println("Ignoring " + publicId + ", " + systemId);
                    return new InputSource(new StringReader(""));
                }
            });
            org.w3c.dom.Document doc = builder.parse(files.get(0).filePath);
            XPathFactory xPathFactory = XPathFactory.newInstance();
            XPath xpath = xPathFactory.newXPath();
            XPathExpression expr = xpath.compile("//image");
            Object result = expr.evaluate(doc, XPathConstants.NODESET);
            NodeList nodes = (NodeList) result;

            XPathExpression expr2 = xpath.compile("//topicref");
            Object result2 = expr2.evaluate(doc, XPathConstants.NODESET);
            NodeList nodes2 = (NodeList) result2;

            for (int i = 0; i < nodes2.getLength(); i++)
            {
                String href = nodes2.item(i).getAttributes().getNamedItem("href").getNodeValue().replace('/', '\\');
                File hrefFile = new File(files.get(0).rootCatalogpath + href);
                files.add(new FilesList(hrefFile.getParent() + "\\", hrefFile.getParent() + "\\" + href)); // Добавляем первый файл в список файлов
            }

            //////////////////////////////////////////////////////
            {
                String res = "";
                OutputStreamWriter f = new OutputStreamWriter(new FileOutputStream("images.xml", true), "UTF8");
                try {
                    for (int i = 0; i < nodes.getLength(); i++) {
                        res += "<image href=\"";
                        String href = nodes.item(i).getAttributes().getNamedItem("href").getNodeValue().replace('/', '\\');
                        res += href;
                        res += "\"";
                        //////////////////////////////////
                        System.out.println(files.get(0).rootCatalogpath + href);
                        File inFile = new File(files.get(0).rootCatalogpath + href);
                        Image image = (Image) ImageIO.read(inFile);
                        res += " width=\"" + image.getWidth(null) + "\"";
                        res += " height=\"" + image.getHeight(null) + "\"";
                        //////////////////////////////////
                        res += " />\r\n";
                    }
                    char[] buflast = new char[res.length()];
                    res.getChars(0, buflast.length, buflast, 0);
                    f.write(buflast, 0, buflast.length);
                    f.flush();
                }
                catch (IOException e) {
                  try {f.close();} catch (Exception e1) {};
                  return;
                 }
                f.close();
            }
            files.remove(0);
        }
        
        // End of file
        {
            String res2 = "</images>";
            OutputStreamWriter f = new OutputStreamWriter(new FileOutputStream("images.xml", true), "UTF8");
            char[] buflast = new char[res2.length()];
            res2.getChars(0, buflast.length, buflast, 0);
            f.write(buflast, 0, buflast.length);
            f.flush();
            f.close();
        }
    }
}
