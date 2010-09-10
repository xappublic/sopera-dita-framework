package mapgen;

import java.io.*;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.util.regex.Pattern;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;
import org.w3c.dom.Node;
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
    static String result = "";

    public static void main(String[] args) throws FileNotFoundException, UnsupportedEncodingException, IOException, ParserConfigurationException, SAXException, XPathExpressionException {
        String mapFileForFixing = "";
        if(args.length == 0)
        {
            File f = new File(".");
            System.out.println("add arg with path to map file");
            return;            
        }
        else mapFileForFixing = args[0];


        String map = loadFileAsString(mapFileForFixing, "UTF8");
        Pattern patt = Pattern.compile("<!DOCTYPE(.*?)>", Pattern.CASE_INSENSITIVE | Pattern.DOTALL | Pattern.MULTILINE);
        map = patt.matcher(map).replaceAll("");
        //map = map.replaceFirst("<!DOCTYPE(.*?)>", "");
        OutputStreamWriter fmap = new OutputStreamWriter(new FileOutputStream("tmpditamap.xml"), "UTF8");
        char[] bufmap = new char[map.length()];
        map.getChars(0, bufmap.length, bufmap, 0);
        fmap.write(bufmap, 0, bufmap.length);
        fmap.close();

        System.out.println("Temp file was generated");

        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        factory.setValidating(false);
        factory.setNamespaceAware(true); // never forget this!
        DocumentBuilder builder = factory.newDocumentBuilder();
        org.w3c.dom.Document doc = builder.parse("tmpditamap.xml");


        result = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n<!DOCTYPE map PUBLIC \"-//OASIS//DTD DITA Map//EN\" \"../../DITA-OT1.5.1/dtd/technicalContent/dtd/map.dtd\">";
        NodeList nodes = doc.getElementsByTagName("map");
        for(int i = 0; i < nodes.getLength(); i++)
        {
            Node currMap = nodes.item(i);
            processing(currMap);
        }

        //XPathFactory xPathFactory = XPathFactory.newInstance();
        //XPath xpath = xPathFactory.newXPath();
        //XPathExpression expr = xpath.compile("//topicref/@href");
        //Object result = expr.evaluate(doc, XPathConstants.NODESET);
        //NodeList nodes = (NodeList) result;

        OutputStreamWriter res = new OutputStreamWriter(new FileOutputStream(mapFileForFixing), "UTF8");
        char[] bufmap2 = new char[result.length()];
        result.getChars(0, bufmap2.length, bufmap2, 0);
        res.write(bufmap2, 0, bufmap2.length);
        res.close();
    }

    public static void processing(Node node) throws FileNotFoundException, UnsupportedEncodingException, IOException, ParserConfigurationException, SAXException
    {
        if(node.getNodeType() == 1)
        {
            if(node.getNodeName().equals("topicref"))
            {
                if(node.getAttributes().getNamedItem("href") != null)
                {
                    if(node.getAttributes().getNamedItem("href").getNodeValue().indexOf("_map.xml") != -1)
                    {
                        File file = new File(node.getAttributes().getNamedItem("href").getNodeValue());
                        if(file.exists())
                        {
                            String tmpMapFile = loadFileAsString(node.getAttributes().getNamedItem("href").getNodeValue(), "UTF8");
                            Pattern patt = Pattern.compile("<!DOCTYPE(.*?)>", Pattern.CASE_INSENSITIVE | Pattern.DOTALL | Pattern.MULTILINE);
                            tmpMapFile = patt.matcher(tmpMapFile).replaceAll("");
                            //tmpMapFile = tmpMapFile.replaceFirst("<!DOCTYPE(.*?)>", "");
                            OutputStreamWriter fmap = new OutputStreamWriter(new FileOutputStream("tmpditamap2.xml"), "UTF8");
                            char[] bufmap = new char[tmpMapFile.length()];
                            tmpMapFile.getChars(0, bufmap.length, bufmap, 0);
                            fmap.write(bufmap, 0, bufmap.length);
                            fmap.close();

                            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
                            factory.setValidating(false);
                            factory.setNamespaceAware(true); // never forget this!
                            DocumentBuilder builder = factory.newDocumentBuilder();
                            org.w3c.dom.Document doc = builder.parse("tmpditamap2.xml");

                            NodeList nodes = doc.getElementsByTagName("map");
                            for (int i = 0; i < nodes.getLength(); i++) {
                                Node n = nodes.item(i);
                                NodeList topics = n.getChildNodes();
                                for (int j= 0; j < topics.getLength(); j++) {
                                    Node t = topics.item(j);
                                    if(t.getNodeType() == 1)
                                    {
                                        processing(t);
                                    }
                                }
                            }
                        }
                    }
                    else
                    {
                        result += "\r\n<" + node.getNodeName() + " href=\"" + node.getAttributes().getNamedItem("href").getNodeValue() + "\">";
                    }
                }
                else
                {
                    result += "\r\n<" + node.getNodeName() + ">";
                }
            }
            else
            {
                result += "\r\n<" + node.getNodeName() + ">";
            }
            if(node.hasChildNodes())
            {
                  NodeList topicNodes = node.getChildNodes();
                  for (int j = 0; j < topicNodes.getLength(); j++) {
                      Node currTopicRef = topicNodes.item(j);
                      if(currTopicRef.getNodeType() == 1)
                      {
                          processing(currTopicRef);
                      }
                  }
            }

            if(node.getNodeName().equals("topicref"))
            {
                if(node.getAttributes().getNamedItem("href") != null)
                {
                    if(node.getAttributes().getNamedItem("href").getNodeValue().indexOf("_map.xml") != -1)
                    {

                    }
                    else result += "\r\n</" + node.getNodeName() + ">";
                }
                else result += "\r\n</" + node.getNodeName() + ">";
            }
            else result += "\r\n</" + node.getNodeName() + ">";
        }
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
