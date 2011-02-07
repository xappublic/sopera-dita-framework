import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.StringReader;
import java.nio.charset.Charset;
import java.nio.charset.CharsetEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.Attr;
import org.w3c.dom.Node;
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
		// mapFilePath =
		// "C:\\bin\\sopera-dita-framework\\inOld\\iop_installation_operations_guide_main.ditamap";
		File merged = new File(mapFilePath.replace("_main", "_merged").replace(
				".ditamap", ".xml"));
		merged.delete();
		if (mapFilePath.endsWith(".xml")) {
			File mapfile = new File(mapFilePath);
			mapFilePath = mapFilePath.replace(".xml", ".ditamap");
			mapfile.renameTo(new File(mapFilePath));
		}
		// try
		// {
		// File mapfile = new File(mapFilePath);
		// File images = new File(mapfile.getParent() + File.separatorChar +
		// "images");
		// images.renameTo(new File(mapfile.getParent().replace("inOld", "in") +
		// File.separatorChar + "images"));
		// }
		// catch(Exception ee)
		// {
		//
		// }
		File mapFile = new File(mapFilePath);
		List<FilesList> files = new ArrayList<FilesList>();

		files.add(new FilesList(mapFile.getParent() + File.separatorChar,
				mapFilePath, "map", "")); // Добавляем первый файл в список
											// файлов

		int count = 0;

		while (files.size() > 0) {
			count++;
			String filetype = files.get(0).fileType;
			System.out.println("[FILETYPE FROM FILE] " + filetype);
			System.out.println("[PARENT] " + files.get(0).parentLink);
			System.out.println("[FILE] " + files.get(0).filePath);
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

			// CHECK FILE TYPE FROM DOCTYPE
			System.out.println("[DOCTYPE TYPE] " + doc.getDoctype().getName());
			String[] patterns = { "topic", "task", "map", "concept",
					"reference", "glossary" };
			for (String t : patterns) {
				Pattern topicPattern = Pattern.compile(t,
						Pattern.CASE_INSENSITIVE | Pattern.DOTALL
								| Pattern.MULTILINE);
				if (topicPattern.matcher(doc.getDoctype().getName()).matches()) {
					if (filetype != t) {
						filetype = doc.getDoctype().getName(); // update doctype
					}
				}
			}

			XPathFactory xPathFactory = XPathFactory.newInstance();
			XPath xpath = xPathFactory.newXPath();

			XPathExpression expr = xpath.compile("//topicref");
			Object result = expr.evaluate(doc, XPathConstants.NODESET);
			NodeList nodes = (NodeList) result;

			System.out
					.println("[INFO] Finded " + nodes.getLength()
							+ " topicref/@href in '" + files.get(0).filePath
							+ "' file");
			for (int i = 0; i < nodes.getLength(); i++) {
				if (nodes.item(i).getAttributes().getNamedItem("href") != null) {
					String href = nodes.item(i).getAttributes()
							.getNamedItem("href").getNodeValue()
							.replace('/', File.separatorChar).trim();
					File hrefFile = new File(files.get(0).rootCatalogpath
							+ href);
					files.add(new FilesList(hrefFile.getParent()
							+ File.separatorChar, hrefFile.getParent()
							+ File.separatorChar + href, "topic",
							files.get(0).filePath)); // Добавляем первый файл в
														// список файлов
				}
			}

			XPathExpression expr2 = xpath.compile("//topic");
			Object result2 = expr2.evaluate(doc, XPathConstants.NODESET);
			NodeList nodes2 = (NodeList) result2;

			System.out.println("[INFO] Finded " + nodes2.getLength()
					+ " topic/@conref in '" + files.get(0).filePath + "' file");
			for (int i = 0; i < nodes2.getLength(); i++) {
				if (nodes2.item(i).getAttributes().getNamedItem("conref") != null) {
					String href = nodes2.item(i).getAttributes()
							.getNamedItem("conref").getNodeValue()
							.replace('/', File.separatorChar).trim();
					File hrefFile = new File(files.get(0).rootCatalogpath
							+ href);
					files.add(new FilesList(hrefFile.getParent()
							+ File.separatorChar, hrefFile.getParent()
							+ File.separatorChar + href, "topic",
							files.get(0).filePath));
				}
			}

			XPathExpression expr3 = xpath.compile("//concept");
			Object result3 = expr3.evaluate(doc, XPathConstants.NODESET);
			NodeList nodes3 = (NodeList) result3;

			System.out.println("[INFO] Finded " + nodes3.getLength()
					+ " concept/@conref in '" + files.get(0).filePath
					+ "' file");
			for (int i = 0; i < nodes3.getLength(); i++) {
				if (nodes3.item(i).getAttributes().getNamedItem("conref") != null) {
					String href = nodes3.item(i).getAttributes()
							.getNamedItem("conref").getNodeValue()
							.replace('/', File.separatorChar).trim();
					File hrefFile = new File(files.get(0).rootCatalogpath
							+ href);
					files.add(new FilesList(hrefFile.getParent()
							+ File.separatorChar, hrefFile.getParent()
							+ File.separatorChar + href, "concept", files
							.get(0).filePath));
				}
			}

			XPathExpression expr4 = xpath.compile("//task");
			Object result4 = expr4.evaluate(doc, XPathConstants.NODESET);
			NodeList nodes4 = (NodeList) result4;

			System.out.println("[INFO] Finded " + nodes4.getLength()
					+ " task/@conref in '" + files.get(0).filePath + "' file");
			for (int i = 0; i < nodes4.getLength(); i++) {
				if (nodes4.item(i).getAttributes().getNamedItem("conref") != null) {
					String href = nodes4.item(i).getAttributes()
							.getNamedItem("conref").getNodeValue()
							.replace('/', File.separatorChar).trim();
					File hrefFile = new File(files.get(0).rootCatalogpath
							+ href);
					files.add(new FilesList(hrefFile.getParent()
							+ File.separatorChar, hrefFile.getParent()
							+ File.separatorChar + href, "task",
							files.get(0).filePath));
				}
			}

			XPathExpression expr5 = xpath.compile("//reference");
			Object result5 = expr5.evaluate(doc, XPathConstants.NODESET);
			NodeList nodes5 = (NodeList) result5;

			System.out.println("[INFO] Finded " + nodes5.getLength()
					+ " reference/@conref in '" + files.get(0).filePath
					+ "' file");
			for (int i = 0; i < nodes5.getLength(); i++) {
				if (nodes5.item(i).getAttributes().getNamedItem("conref") != null) {
					String href = nodes5.item(i).getAttributes()
							.getNamedItem("conref").getNodeValue()
							.replace('/', File.separatorChar).trim();
					File hrefFile = new File(files.get(0).rootCatalogpath
							+ href);
					files.add(new FilesList(hrefFile.getParent()
							+ File.separatorChar, hrefFile.getParent()
							+ File.separatorChar + href, "reference", files
							.get(0).filePath));
				}
			}

			// glossary

			// Modifying DOM file

			if (filetype == "map") {
				NodeList n = doc.getChildNodes();
				for (int i = 0; i < n.getLength(); i++) {
					if (n.item(i).getLocalName() == "dita") {
						doc.renameNode(n.item(i), "", "map");
					}
					NodeList t = n.item(i).getChildNodes();
					for (int j = 0; j < t.getLength(); j++) {
						// Topic
						if (t.item(j).getLocalName() == "topic") {
							while (t.item(j).getChildNodes().getLength() > 0) {
								t.item(j).removeChild(
										t.item(j).getChildNodes().item(0));
							}
							// Attr conref change to href
							for (int j2 = 0; j2 < t.item(j).getAttributes()
									.getLength(); j2++) {
								if (t.item(j).getAttributes().item(j2)
										.getLocalName() == "conref") {
									// rename attribute "conref" to "href" in
									// "topicref" element
									doc.renameNode(t.item(j).getAttributes()
											.item(j2), "", "href");
								} else {
									// delete all attributes in "topicref"
									// except "href"
									t.item(j)
											.getAttributes()
											.removeNamedItem(
													t.item(j).getAttributes()
															.item(j2)
															.getLocalName());
								}
							}
							doc.renameNode(t.item(j), "", "topicref");
						}
						// Concept
						if (t.item(j).getLocalName() == "concept") {
							while (t.item(j).getChildNodes().getLength() > 0) {
								t.item(j).removeChild(
										t.item(j).getChildNodes().item(0));
							}
							// Attr conref change to href
							for (int j2 = 0; j2 < t.item(j).getAttributes()
									.getLength(); j2++) {
								if (t.item(j).getAttributes().item(j2)
										.getLocalName() == "conref") {
									// rename attribute "conref" to "href" in
									// "topicref" element
									doc.renameNode(t.item(j).getAttributes()
											.item(j2), "", "href");
								} else {
									// delete all attributes in "topicref"
									// except "href"
									t.item(j)
											.getAttributes()
											.removeNamedItem(
													t.item(j).getAttributes()
															.item(j2)
															.getLocalName());
								}
							}
							doc.renameNode(t.item(j), "", "topicref");
						}
						// Task
						if (t.item(j).getLocalName() == "task") {
							while (t.item(j).getChildNodes().getLength() > 0) {
								t.item(j).removeChild(
										t.item(j).getChildNodes().item(0));
							}
							// Attr conref change to href
							for (int j2 = 0; j2 < t.item(j).getAttributes()
									.getLength(); j2++) {
								if (t.item(j).getAttributes().item(j2)
										.getLocalName() == "conref") {
									// rename attribute "conref" to "href" in
									// "topicref" element
									doc.renameNode(t.item(j).getAttributes()
											.item(j2), "", "href");
								} else {
									// delete all attributes in "topicref"
									// except "href"
									t.item(j)
											.getAttributes()
											.removeNamedItem(
													t.item(j).getAttributes()
															.item(j2)
															.getLocalName());
								}
							}
							doc.renameNode(t.item(j), "", "topicref");
						}
						// Task
						if (t.item(j).getLocalName() == "reference") {
							while (t.item(j).getChildNodes().getLength() > 0) {
								t.item(j).removeChild(
										t.item(j).getChildNodes().item(0));
							}
							// Attr conref change to href
							for (int j2 = 0; j2 < t.item(j).getAttributes()
									.getLength(); j2++) {
								if (t.item(j).getAttributes().item(j2)
										.getLocalName() == "conref") {
									// rename attribute "conref" to "href" in
									// "topicref" element
									doc.renameNode(t.item(j).getAttributes()
											.item(j2), "", "href");
								} else {
									// delete all attributes in "topicref"
									// except "href"
									t.item(j)
											.getAttributes()
											.removeNamedItem(
													t.item(j).getAttributes()
															.item(j2)
															.getLocalName());
								}
							}
							doc.renameNode(t.item(j), "", "topicref");
						}
					}
				}
			} else {
				{
					XPathExpression tref = xpath.compile("//xref");
					Object tresult = tref.evaluate(doc, XPathConstants.NODESET);
					NodeList tnodes = (NodeList) tresult;
					for (int i = 0; i < tnodes.getLength(); i++) {
						Attr attr = null;
						for (int l = 0; l < tnodes.item(i).getAttributes()
								.getLength(); l++) {
							if (tnodes.item(i).getAttributes().item(l)
									.getNodeName() == "href") {
								attr = (Attr) tnodes.item(i).getAttributes()
										.item(l);
							}
						}
						if (attr.getNodeValue().startsWith("#"))
							attr.setValue(attr.getNodeValue().replaceAll(
									"#(.+)", "$1.xml#$1"));
						if (!attr.getNodeValue().startsWith("#"))
							if (attr.getNodeValue().indexOf("/") != -1)
								attr.setValue(attr
										.getNodeValue()
										.replaceAll(
												"([a-zA-Z0-9_]+)/[a-zA-Z0-9_]+(\\.[a-z]{3})(#)([a-zA-Z0-9_]+)(/)([a-zA-Z0-9_]+)",
												"$1$2$3$4$5$6"));
					}
				}
				// Поиск субтопиков, разделение субтопиков на topicref и другие
				{
					// Находим топик в файле
					XPathExpression tref = xpath
							.compile("//topic//topic|//topic//task|//topic//concept|//topic//reference|//topic//glossary|//task//topic|//task//task|//task//concept|//task//reference|//task//glossary|//concept//topic|//concept//task|//concept//concept|//concept//reference|//concept//glossary|//reference//topic|//reference//task|//reference//concept|//reference//reference|//reference//glossary|//glossary//topic|//glossary//task|//glossary//concept|//glossary//reference|//glossary//glossary");
					Object tresult = tref.evaluate(doc, XPathConstants.NODESET);
					NodeList tnodes = (NodeList) tresult;

					for (int i = 0; i < tnodes.getLength(); i++) {
						String href = "";
						// Проверяем есть ли у него conref или href
						if (tnodes.item(i).getAttributes()
								.getNamedItem("conref") != null) {
							// Если есть запоминаем ссылку
							href = tnodes.item(i).getAttributes()
									.getNamedItem("conref").getNodeValue()
									.replace('/', File.separatorChar);
						} else {
							// Если нет то выносим содержимое в отдельный файл с
							// именем = ID топика и запоминаем ссылку
							href = tnodes.item(i).getAttributes()
									.getNamedItem("id").getNodeValue()
									+ ".xml";
							String topicText = XmlNodesToString(tnodes.item(i),
									1, false);
							DocumentBuilderFactory factory1 = DocumentBuilderFactory
									.newInstance();
							factory1.setValidating(false);
							factory1.setNamespaceAware(true);
							DocumentBuilder builder1 = factory
									.newDocumentBuilder();

							org.w3c.dom.Document doc1 = builder1
									.parse(new ByteArrayInputStream(topicText
											.getBytes("UTF-8")));
							System.out.println("[EXTRACT TO FILE] "
									+ files.get(0).rootCatalogpath + href);
							writeXMLToFile(tnodes.item(i).getLocalName(), doc1,
									files.get(0).rootCatalogpath + href);

							files.add(new FilesList(
									files.get(0).rootCatalogpath,
									files.get(0).rootCatalogpath + href,
									"topic", files.get(0).filePath.replaceAll(
											"inOld", "in")));
						}
						if (href != "") {
							// Открываем дитамап
							DocumentBuilderFactory factory1 = DocumentBuilderFactory
									.newInstance();
							factory1.setValidating(false);
							factory1.setNamespaceAware(true); // never forget
																// this!
							DocumentBuilder builder1 = factory1
									.newDocumentBuilder();
							builder1.setEntityResolver(new EntityResolver() {
								public InputSource resolveEntity(
										String publicId, String systemId)
										throws SAXException, IOException {
									// System.out.println("Ignoring " + publicId
									// + ", " + systemId);
									return new InputSource(new StringReader(""));
								}
							});

							String newMap = mapFile.getAbsolutePath()
									.replaceAll("inOld", "in");
							org.w3c.dom.Document doc1 = builder1.parse(newMap);

							XPathFactory xPathFactory1 = XPathFactory
									.newInstance();
							XPath xpath1 = xPathFactory1.newXPath();

							// Находим в нем текущий файл
							XPathExpression expr1 = xpath1
									.compile("//*[contains(@href, '"
											+ files.get(0).filePath.replace(
													mapFile.getParent()
															+ File.separatorChar,
													"") + "')]");
							Object result1 = expr1.evaluate(doc1,
									XPathConstants.NODESET);
							NodeList nodes1 = (NodeList) result1;
							System.out
									.println("Search in ditamap *[contains(@href, '"
											+ files.get(0).filePath.replace(
													mapFile.getParent()
															+ File.separatorChar,
													"") + "')]");
							for (int k = 0; k < nodes1.getLength(); k++) {
								// Добавляем в него ссылку
								org.w3c.dom.Element el = doc1
										.createElement("topicref");
								el.setAttribute("href", href);
								nodes1.item(0).appendChild(el);
							}
							writeXMLToFile("map", doc1, newMap);
						}
					}
					for (int i = 0; i < tnodes.getLength(); i++) {
						// Удаляем содержимое топика и сам топик в текущем файле
						// (который нашли и на который скопировали ссылку)
						Node n = tnodes.item(i);
						n.getParentNode().removeChild(n);
					}
				}
			}
			// Add 0 width spaces to dita sources
			// XmlNodesAddSpaces(doc.getLastChild().getChildNodes());
			// Save file if needed (if we do changes in this file and save
			// subfile which we extract from this file)
			writeXMLToFile(filetype, doc,
					files.get(0).filePath.replaceAll("inOld", "in"));

			System.out.println("");
			System.out
					.println("Remove " + files.get(0).filePath + " from list");
			System.out.println(files.size() + " files remain");
			System.out.println("-----------------------------");

			files.remove(0);
		}
		System.out.println("[TOTAL FILES] " + count);
	}

	static String XmlNodesToString(Node nodes, int level, Boolean isMap) {
		String content = "";

		if (nodes.getNodeType() == org.w3c.dom.Document.ELEMENT_NODE) {
			if (isMap)
				content += "\r\n";
			content += "<" + nodes.getNodeName();
			for (int i1 = 0; i1 < nodes.getAttributes().getLength(); i1++) {
				if (!nodes.getAttributes().item(i1).getNodeName().toLowerCase()
						.startsWith("fm_")) {
					content += " "
							+ nodes.getAttributes().item(i1).getNodeName()
							+ "=\""
							+ nodes.getAttributes().item(i1).getNodeValue()
							+ "\"";
				}
			}
			if (nodes.hasChildNodes()) {
				content += ">";
				NodeList subnodes = nodes.getChildNodes();
				// codeblock codeph = cut
				content += XmlNodesToString(subnodes, level + 1, isMap);
				if (isMap)
					content += "\r\n";
				content += "</" + nodes.getNodeName() + ">";
			} else {
				content += " />";
			}
		} else if (nodes.getNodeType() == org.w3c.dom.Document.TEXT_NODE) {
			if (!isMap) {
				if (nodes.getNodeValue().trim() != "") {
					content += nodes.getNodeValue().replace("&", "&amp;")
							.replace("<", "&lt;").replace(">", "&gt;")
							.replace("&amp;#x200B;", "&#x200B;");
				}
			}
		}
		return content;
	}

	static void XmlNodesAddSpaces(NodeList nodes) {
		// Add 0 width spaces to dita sources
		for (int i = 0; i < nodes.getLength(); i++) {
			String tmp = nodes.item(i).getNodeValue();
			if (tmp != null
					&& tmp.replace("\r", "").replace("\n", "").trim()
							.equals("") == false) {
				// int x = 0;
				String tmpNew = "";
				for (int j = 0; j < tmp.length(); j++) {
					tmpNew += String.valueOf(tmp.charAt(j));
					// if(tmp.charAt(j) == '\n') x = 0;
					// if(tmp.charAt(j) == ' ') x = 0;
					if (tmp.charAt(j) == '_') {
						tmpNew += "&#x200B;";
						// x = 0;
					}
					// if(x >= 10)
					// {
					// tmpNew += "&#x200B;";
					// x = 0;
					// }
					// x++;
				}
				nodes.item(i).setNodeValue(tmpNew);
			}
			if (nodes.item(i).hasChildNodes())
				XmlNodesAddSpaces(nodes.item(i).getChildNodes());
		}
	}

	static String XmlNodesToString(NodeList nodes, int level, Boolean isMap) {
		String content = "";
		for (int i = 0; i < nodes.getLength(); i++) {
			if (nodes.item(i).getNodeType() == org.w3c.dom.Document.ELEMENT_NODE) {
				if (isMap)
					content += "\r\n";
				content += "<" + nodes.item(i).getNodeName();
				for (int i1 = 0; i1 < nodes.item(i).getAttributes().getLength(); i1++) {
					if (!nodes.item(i).getAttributes().item(i1).getNodeName()
							.toLowerCase().startsWith("fm_")) {
						content += " "
								+ nodes.item(i).getAttributes().item(i1)
										.getNodeName()
								+ "=\""
								+ nodes.item(i).getAttributes().item(i1)
										.getNodeValue() + "\"";
					}
				}
				if (nodes.item(i).hasChildNodes()) {
					content += ">";
					NodeList subnodes = nodes.item(i).getChildNodes();
					// codeblock codeph = cut
					content += XmlNodesToString(subnodes, level + 1, isMap);
					if (isMap)
						content += "\r\n";
					content += "</" + nodes.item(i).getNodeName() + ">";
				} else {
					content += " />";
				}
			} else if (nodes.item(i).getNodeType() == org.w3c.dom.Document.TEXT_NODE) {
				if (!isMap) {
					if (nodes.item(i).getNodeValue().trim() != "") {
						String tmp = nodes.item(i).getNodeValue();
						content += tmp.replace("&", "&amp;")
								.replace("<", "&lt;").replace(">", "&gt;")
								.replace("&amp;#x200B;", "&#x200B;");
					}
				}
			}
		}
		return content;
	}

	static void writeXMLToFile(String doctype, org.w3c.dom.Document doc,
			String path) throws IOException, XPathExpressionException {
		// path = path.replaceAll("inOld", "in");

		new File(path).getParentFile().mkdirs();

		System.out.println("[SAVE FILE] '" + path + "'");
		// CharsetEncoder encoder = Charset.forName("US-ASCII").newEncoder();
		CharsetEncoder encoder = Charset.forName("UTF-8").newEncoder();
		OutputStreamWriter f = new OutputStreamWriter(new FileOutputStream(
				path, false), encoder);

		{
			String dt = "";
			if (doctype == "topic")
				dt = "<?xml version=\"1.0\"?>\r\n<!DOCTYPE topic PUBLIC \"-//OASIS//DTD DITA 1.2 topic//EN\" \"DITA-OT/dtd/technicalContent/dtd/topic.dtd\">";
			if (doctype == "task")
				dt = "<?xml version=\"1.0\"?>\r\n<!DOCTYPE task PUBLIC \"-//OASIS//DTD DITA 1.2 task//EN\" \"DITA-OT/dtd/technicalContent/dtd/task.dtd\">";
			if (doctype == "map")
				dt = "<?xml version=\"1.0\"?>\r\n<!DOCTYPE map PUBLIC \"-//OASIS//DTD DITA map//EN\" \"DITA-OT/dtd/technicalContent/dtd/map.dtd\">";
			if (doctype == "concept")
				dt = "<?xml version=\"1.0\"?>\r\n<!DOCTYPE concept PUBLIC \"-//OASIS//DTD DITA 1.2 Concept//EN\" \"DITA-OT/dtd/technicalContent/dtd/concept.dtd\">";
			if (doctype == "reference")
				dt = "<?xml version=\"1.0\"?>\r\n<!DOCTYPE reference PUBLIC \"-//OASIS//DTD DITA 1.2 Reference//EN\" \"DITA-OT/dtd/technicalContent/dtd/reference.dtd\">";
			if (doctype == "glossary")
				dt = "<?xml version=\"1.0\"?>\r\n<!DOCTYPE glossary PUBLIC \"-//OASIS//DTD DITA 1.2 Glossary//EN\" \"DITA-OT/dtd/technicalContent/dtd/glossary.dtd\">";
			char[] buf = new char[dt.length()];
			dt.getChars(0, buf.length, buf, 0);
			f.write(buf, 0, buf.length);
		}
		String content = "\r\n\r\n<" + doc.getLastChild().getNodeName();
		for (int i = 0; i < doc.getLastChild().getAttributes().getLength(); i++) {
			content += " "
					+ doc.getLastChild().getAttributes().item(i).getNodeName()
					+ "=\""
					+ doc.getLastChild().getAttributes().item(i).getNodeValue()
					+ "\"";
		}
		content += ">";
		NodeList nodes = doc.getLastChild().getChildNodes();

		content += XmlNodesToString(nodes, 1, doctype == "map");

		content += "\r\n</" + doc.getLastChild().getNodeName() + ">";
		// System.err.println(content);

		char[] bufcontent = new char[content.length()];
		content.getChars(0, bufcontent.length, bufcontent, 0);
		f.write(bufcontent, 0, bufcontent.length);

		f.flush();
		f.close();
		// System.exit(0);
	}
}
