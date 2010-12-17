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
	 * @param args
	 *            the command line arguments
	 */
	public static void main(String[] args) throws SAXException,
			ParserConfigurationException, XPathExpressionException, IOException {
		String mapFilePath = "";
		if (args.length == 0) {
			System.out.println("add arg with path to xml file");
			return;
		} else
			mapFilePath = args[0];
		 //mapFilePath = "C:\\bin\\sopera-dita-framework\\in\\SOP_DITAMAPS\\iop_installation_operations_guide.ditamap";
		String separator = "/";
		if (System.getProperties().getProperty("os.name").indexOf("indows") > 0) {
			separator = "\\";
		}
		File mapFile = new File(mapFilePath);
		List<FilesList> files = new ArrayList<FilesList>();

		files.add(new FilesList(mapFile.getParent() + "\\", mapFilePath)); // Добавляем
																			// первый
																			// файл
																			// в
																			// список
																			// файлов

		// Создаем начало файла
		{
			String res = "<?xml version=\"1.0\" encoding=\"utf-8\" ?>\r\n<images>\r\n";
			OutputStreamWriter f = new OutputStreamWriter(new FileOutputStream(
					"images.xml", false), "UTF8");
			char[] buflast = new char[res.length()];
			res.getChars(0, buflast.length, buflast, 0);
			f.write(buflast, 0, buflast.length);
			f.flush();
			f.close();
		}

		while (files.size() > 0) {
			DocumentBuilderFactory factory = DocumentBuilderFactory
					.newInstance();
			factory.setValidating(false);
			factory.setNamespaceAware(true); // never forget this!
			DocumentBuilder builder = factory.newDocumentBuilder();
			builder.setEntityResolver(new EntityResolver() {
				public InputSource resolveEntity(String publicId,
						String systemId) throws SAXException, IOException {
					// System.out.println("Ignoring " + publicId + ", " +
					// systemId);
					return new InputSource(new StringReader(""));
				}
			});
			org.w3c.dom.Document doc = builder.parse(files.get(0).filePath);
			XPathFactory xPathFactory = XPathFactory.newInstance();
			XPath xpath = xPathFactory.newXPath();
			XPathExpression expr = xpath.compile("//image");
			Object result = expr.evaluate(doc, XPathConstants.NODESET);
			NodeList nodes = (NodeList) result;

			XPathExpression expr2z = xpath.compile("//topicref");
			Object result2z = expr2z.evaluate(doc, XPathConstants.NODESET);
			NodeList nodes2z = (NodeList) result2z;

			for (int i = 0; i < nodes2z.getLength(); i++) {
				if (nodes2z.item(i).getAttributes().getNamedItem("href") != null) {
					String href = nodes2z.item(i).getAttributes()
							.getNamedItem("href").getNodeValue()
							.replace('/', '\\');
					File hrefFile = new File(files.get(0).rootCatalogpath
							+ href);
					files.add(new FilesList(hrefFile.getParent() + separator, hrefFile.getAbsolutePath())); // Добавляем первый файл в список файлов
				}
			}

			XPathExpression expr2 = xpath.compile("//topic");
            Object result2 = expr2.evaluate(doc, XPathConstants.NODESET);
            NodeList nodes2 = (NodeList) result2;

            for (int i = 0; i < nodes2.getLength(); i++)
            {
            	if(nodes2.item(i).getAttributes().getNamedItem("conref") != null)
                {
                    String href = nodes2.item(i).getAttributes().getNamedItem("conref").getNodeValue().replace("/", separator);
                    File hrefFile = new File(files.get(0).rootCatalogpath + href);
                    files.add(new FilesList(hrefFile.getParent() + separator, hrefFile.getAbsolutePath())); // Добавляем первый файл в список файлов
                }
            }
            
            XPathExpression expr3 = xpath.compile("//concept");
            Object result3 = expr3.evaluate(doc, XPathConstants.NODESET);
            NodeList nodes3 = (NodeList) result3;

            for (int i = 0; i < nodes3.getLength(); i++)
            {
            	if(nodes3.item(i).getAttributes().getNamedItem("conref") != null)
                {
                    String href = nodes3.item(i).getAttributes().getNamedItem("conref").getNodeValue().replace("/", separator);
                    File hrefFile = new File(files.get(0).rootCatalogpath + href);
                    files.add(new FilesList(hrefFile.getParent() + separator, hrefFile.getAbsolutePath())); // Добавляем первый файл в список файлов
                }
            }
            
            XPathExpression expr4 = xpath.compile("//task");
            Object result4 = expr4.evaluate(doc, XPathConstants.NODESET);
            NodeList nodes4 = (NodeList) result4;

            for (int i = 0; i < nodes4.getLength(); i++)
            {
            	if(nodes4.item(i).getAttributes().getNamedItem("conref") != null)
                {
                    String href = nodes4.item(i).getAttributes().getNamedItem("conref").getNodeValue().replace("/", separator);
                    File hrefFile = new File(files.get(0).rootCatalogpath + href);
                    files.add(new FilesList(hrefFile.getParent() + separator, hrefFile.getAbsolutePath())); // Добавляем первый файл в список файлов
                }
            }

            XPathExpression expr5 = xpath.compile("//reference");
            Object result5 = expr5.evaluate(doc, XPathConstants.NODESET);
            NodeList nodes5 = (NodeList) result5;

            for (int i = 0; i < nodes5.getLength(); i++)
            {
            	if(nodes5.item(i).getAttributes().getNamedItem("conref") != null)
                {
                    String href = nodes5.item(i).getAttributes().getNamedItem("conref").getNodeValue().replace("/", separator);
                    File hrefFile = new File(files.get(0).rootCatalogpath + href);
                    files.add(new FilesList(hrefFile.getParent() + separator, hrefFile.getAbsolutePath())); // Добавляем первый файл в список файлов
                }
            }
            
			// ////////////////////////////////////////////////////
			{
				String res = "";
				OutputStreamWriter f = new OutputStreamWriter(new FileOutputStream("images.xml", true), "UTF8");
				for (int i = 0; i < nodes.getLength(); i++) {
					if(nodes.item(i).getAttributes().getNamedItem("href") != null)
					{
						String href = nodes.item(i).getAttributes().getNamedItem("href").getNodeValue().replace("/", separator);
						System.out.println("get info image: '" + href+ "'");
						try {
							String resTmp = "";
							resTmp += "<image href=\"";
							resTmp += href;
							resTmp += "\"";
							//////////////////////////////////
							System.out.println(files.get(0).rootCatalogpath + href);
							File inFile = new File(files.get(0).rootCatalogpath	+ href);
							Image image = (Image) ImageIO.read(inFile);
							resTmp += " width=\"" + image.getWidth(null) + "\"";
							resTmp += " height=\"" + image.getHeight(null) + "\"";
							//////////////////////////////////
							resTmp += " />\r\n";
							res += resTmp;
						} catch (IOException e) {
							System.err.println("cant open img: '" + href+ "'");
						}
					}
				}
				char[] buflast = new char[res.length()];
				res.getChars(0, buflast.length, buflast, 0);
				f.write(buflast, 0, buflast.length);
				f.flush();
				f.close();
			}
			files.remove(0);
		}

		// End of file
		{
			String res2 = "</images>";
			OutputStreamWriter f = new OutputStreamWriter(new FileOutputStream(
					"images.xml", true), "UTF8");
			char[] buflast = new char[res2.length()];
			res2.getChars(0, buflast.length, buflast, 0);
			f.write(buflast, 0, buflast.length);
			f.flush();
			f.close();
		}
	}
}