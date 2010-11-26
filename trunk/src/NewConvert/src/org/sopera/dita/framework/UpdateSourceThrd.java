package org.sopera.dita.framework;

import java.io.BufferedInputStream;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.StringReader;
import java.nio.channels.FileChannel;
import java.nio.charset.Charset;
import java.nio.charset.CharsetEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

import javax.swing.JFileChooser;
import javax.swing.JTextArea;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
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

public class UpdateSourceThrd implements Runnable {

	static JTextArea textArea;
	JFileChooser chooser;
	String mapFolder = "";
	String outFolder = "in\\";

	public UpdateSourceThrd(JTextArea shortLogTextArea, JFileChooser chooser) {
		textArea = shortLogTextArea;
		this.chooser = chooser;
	}

	private void FindDitaMapsOld(File files, List<String> mapfiles) {
		File[] fList;
		fList = files.listFiles();
		for (int i = 0; i < fList.length; i++) {
			if (fList[i].isFile()) {
				if (fList[i].getAbsolutePath().endsWith(".ditamap"))
					mapfiles.add(fList[i].getAbsolutePath());
				if (fList[i].getAbsolutePath().endsWith("_main.xml"))
					mapfiles.add(fList[i].getAbsolutePath());
				if (fList[i].getAbsolutePath().endsWith("_merged.xml"))
					fList[i].delete();
			} else {
				FindDitaMapsOld(fList[i], mapfiles);
			}
		}
	}

//	public static void CopyFile(String nameFrom, String nameTo) throws Exception {
//		FileChannel source = new FileInputStream(new File(nameFrom))
//				.getChannel();
//		FileChannel dest = new FileOutputStream(new File(nameTo)).getChannel();
//		try {
//			source.transferTo(0, source.size(), dest);
//		} finally {
//			source.close();
//			dest.close();
//		}
//		System.out.println("File '" + nameFrom + "' copied to '" + nameTo + "'");
//	}

	 public void CopyFiles(File sourceLocation , File targetLocation)
	    throws IOException {
	        
	        if (sourceLocation.isDirectory()) {
	            if (!targetLocation.exists()) {
	                targetLocation.mkdir();
	            }
	            
	            String[] children = sourceLocation.list();
	            for (int i=0; i<children.length; i++) {
	            	CopyFiles(new File(sourceLocation, children[i]),
	                        new File(targetLocation, children[i]));
	            }
	        } else {
	            
	            InputStream in = new FileInputStream(sourceLocation);
	            OutputStream out = new FileOutputStream(targetLocation);
	            
//	            System.out.println();
//	            System.out.println("to");
//	            System.out.println();
//	            
//	            try {
//					CopyFile(sourceLocation.getAbsolutePath(), targetLocation.getAbsolutePath());
//				} catch (Exception e) {
//					// TODO Auto-generated catch block
//					e.printStackTrace();
//				}
	            // Copy the bits from instream to outstream
	            
	            byte[] buf = new byte[1024];
	            int len;
	            while ((len = in.read(buf)) > 0) {
	                out.write(buf, 0, len);
	            }
	            in.close();	            
	            out.close();
	        }
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
		// path = path.replace(mapFolder, outFolder);

		new File(path).getParentFile().mkdirs();

		textArea.append("[SAVE FILE] '" + path + "'" + "\r\n");
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

	public void run() {
		List<String> ditamaps = new ArrayList<String>();
		mapFolder = chooser.getSelectedFile().getAbsolutePath() + "\\";
		FindDitaMapsOld(chooser.getSelectedFile(), ditamaps);
		textArea.append("Found maps:\r\n");
		for (int mapindex = 0; mapindex < ditamaps.size(); mapindex++) {
			textArea.append(ditamaps.get(mapindex) + "\r\n");
			System.out.println("Map: " + ditamaps.get(mapindex));
			textArea.append("\r\n------------------------------\r\n");
			String mapFilePath = ditamaps.get(mapindex);
			// Rename ditamap file from _main.xml to .ditamap
			if (mapFilePath.endsWith("_main.xml")) {
				File mapfile = new File(mapFilePath);
				mapFilePath = mapFilePath.replace("_main.xml", ".ditamap");
				mapfile.renameTo(new File(mapFilePath));
			}
			if (mapFilePath.endsWith(".xml")) {
				File mapfile = new File(mapFilePath);
				mapFilePath = mapFilePath.replace(".xml", ".ditamap");
				mapfile.renameTo(new File(mapFilePath));
			}
			File mapFile = new File(mapFilePath);
			
			
			try {
				textArea.append("[COPY IMAGES] " + mapFile.getParent() + "\r\n");
				String dest = mapFile.getParent().replace(chooser.getSelectedFile().getAbsolutePath(), "in");
				if(dest.endsWith("\\")) dest += "images";
				else  dest += "\\images";
				new File(dest).mkdirs();
				CopyFiles(new File(mapFile.getParent() + "\\images"), new File(dest));
				textArea.append("[END COPY IMAGES] " + mapFile.getParent() + "\r\n");
			} catch (Exception e1) {
				e1.printStackTrace();
			}
			
			List<FilesListUpdateMaps> files = new ArrayList<FilesListUpdateMaps>();
			files.add(new FilesListUpdateMaps(mapFile.getParent() + "\\",
					mapFilePath, "map", "")); // Add ditamap to files list
			int count = 0;

			while (files.size() > 0) {
				try {
					count++;
					System.out.println(count);
					String filetype = files.get(0).fileType;
					textArea.append("[FILETYPE FROM FILE] " + filetype + "\r\n");
					textArea.append("[PARENT] " + files.get(0).parentLink
							+ "\r\n");
					textArea.append("[FILE] " + files.get(0).filePath + "\r\n");
					DocumentBuilderFactory factory = DocumentBuilderFactory
							.newInstance();
					factory.setValidating(false);
					factory.setNamespaceAware(true); // never forget this!
					DocumentBuilder builder = factory.newDocumentBuilder();
					builder.setEntityResolver(new EntityResolver() {
						public InputSource resolveEntity(String publicId,
								String systemId) throws SAXException,
								IOException {
							// System.out.println("Ignoring " + publicId + ", "
							// + systemId);
							return new InputSource(new StringReader(""));
						}
					});
					org.w3c.dom.Document doc = builder
							.parse(files.get(0).filePath);

					// CHECK FILE TYPE FROM DOCTYPE
					textArea.append("[DOCTYPE TYPE] "
							+ doc.getDoctype().getName() + "\r\n");
					String[] patterns = { "topic", "task", "map", "concept",
							"reference", "glossary" };
					for (String t : patterns) {
						Pattern topicPattern = Pattern.compile(t,
								Pattern.CASE_INSENSITIVE | Pattern.DOTALL
										| Pattern.MULTILINE);
						if (topicPattern.matcher(doc.getDoctype().getName())
								.matches()) {
							if (filetype != t) {
								filetype = doc.getDoctype().getName(); // update
																		// doctype
								// System.err.println("[ERROR] type from doctype and from reference not equals ("
								// + t + " and " + files.get(0).fileType + ")");
								// System.err.println("for file " +
								// files.get(0).filePath);
								// System.err.println("parent " +
								// files.get(0).parentLink);
							}
						}
					}

					XPathFactory xPathFactory = XPathFactory.newInstance();
					XPath xpath = xPathFactory.newXPath();

					XPathExpression expr = xpath.compile("//topicref");
					Object result = expr.evaluate(doc, XPathConstants.NODESET);
					NodeList nodes = (NodeList) result;

					textArea.append("[INFO] Found " + nodes.getLength()
							+ " topicref/@href in '" + files.get(0).filePath
							+ "' file" + "\r\n");
					for (int i = 0; i < nodes.getLength(); i++) {
						if (nodes.item(i).getAttributes().getNamedItem("href") != null) {
							String href = nodes.item(i).getAttributes()
									.getNamedItem("href").getNodeValue()
									.replace('/', '\\');
							File hrefFile = new File(
									files.get(0).rootCatalogpath + href);
							files.add(new FilesListUpdateMaps(hrefFile
									.getParent() + "\\", hrefFile.getParent()
									+ "\\" + href, "topic",
									files.get(0).filePath));
						}
					}

					XPathExpression expr2 = xpath.compile("//topic");
					Object result2 = expr2
							.evaluate(doc, XPathConstants.NODESET);
					NodeList nodes2 = (NodeList) result2;

					textArea.append("[INFO] Found " + nodes2.getLength()
							+ " topic/@conref in '" + files.get(0).filePath
							+ "' file" + "\r\n");
					for (int i = 0; i < nodes2.getLength(); i++) {
						if (nodes2.item(i).getAttributes()
								.getNamedItem("conref") != null) {
							String href = nodes2.item(i).getAttributes()
									.getNamedItem("conref").getNodeValue()
									.replace('/', '\\');
							File hrefFile = new File(
									files.get(0).rootCatalogpath + href);
							files.add(new FilesListUpdateMaps(hrefFile
									.getParent() + "\\", hrefFile.getParent()
									+ "\\" + href, "topic",
									files.get(0).filePath));
						}
					}

					XPathExpression expr3 = xpath.compile("//concept");
					Object result3 = expr3
							.evaluate(doc, XPathConstants.NODESET);
					NodeList nodes3 = (NodeList) result3;

					textArea.append("[INFO] Found " + nodes3.getLength()
							+ " concept/@conref in '" + files.get(0).filePath
							+ "' file" + "\r\n");
					for (int i = 0; i < nodes3.getLength(); i++) {
						if (nodes3.item(i).getAttributes()
								.getNamedItem("conref") != null) {
							String href = nodes3.item(i).getAttributes()
									.getNamedItem("conref").getNodeValue()
									.replace('/', '\\');
							File hrefFile = new File(
									files.get(0).rootCatalogpath + href);
							files.add(new FilesListUpdateMaps(hrefFile
									.getParent() + "\\", hrefFile.getParent()
									+ "\\" + href, "concept",
									files.get(0).filePath));
						}
					}

					XPathExpression expr4 = xpath.compile("//task");
					Object result4 = expr4
							.evaluate(doc, XPathConstants.NODESET);
					NodeList nodes4 = (NodeList) result4;

					textArea.append("[INFO] Found " + nodes4.getLength()
							+ " task/@conref in '" + files.get(0).filePath
							+ "' file" + "\r\n");
					for (int i = 0; i < nodes4.getLength(); i++) {
						if (nodes4.item(i).getAttributes()
								.getNamedItem("conref") != null) {
							String href = nodes4.item(i).getAttributes()
									.getNamedItem("conref").getNodeValue()
									.replace('/', '\\');
							File hrefFile = new File(
									files.get(0).rootCatalogpath + href);
							files.add(new FilesListUpdateMaps(hrefFile
									.getParent() + "\\", hrefFile.getParent()
									+ "\\" + href, "task",
									files.get(0).filePath));
						}
					}

					XPathExpression expr5 = xpath.compile("//reference");
					Object result5 = expr5
							.evaluate(doc, XPathConstants.NODESET);
					NodeList nodes5 = (NodeList) result5;

					textArea.append("[INFO] Found " + nodes5.getLength()
							+ " reference/@conref in '" + files.get(0).filePath
							+ "' file" + "\r\n");
					for (int i = 0; i < nodes5.getLength(); i++) {
						if (nodes5.item(i).getAttributes()
								.getNamedItem("conref") != null) {
							String href = nodes5.item(i).getAttributes()
									.getNamedItem("conref").getNodeValue()
									.replace('/', '\\');
							File hrefFile = new File(
									files.get(0).rootCatalogpath + href);
							files.add(new FilesListUpdateMaps(hrefFile
									.getParent() + "\\", hrefFile.getParent()
									+ "\\" + href, "reference",
									files.get(0).filePath));
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
									while (t.item(j).getChildNodes()
											.getLength() > 0) {
										t.item(j).removeChild(
												t.item(j).getChildNodes()
														.item(0));
									}
									// Attr conref change to href
									for (int j2 = 0; j2 < t.item(j)
											.getAttributes().getLength(); j2++) {
										if (t.item(j).getAttributes().item(j2)
												.getLocalName() == "conref") {
											// rename attribute "conref" to
											// "href" in "topicref" element
											doc.renameNode(t.item(j)
													.getAttributes().item(j2),
													"", "href");
										} else {
											// delete all attributes in
											// "topicref" except "href"
											t.item(j)
													.getAttributes()
													.removeNamedItem(
															t.item(j)
																	.getAttributes()
																	.item(j2)
																	.getLocalName());
										}
									}
									doc.renameNode(t.item(j), "", "topicref");
								}
								// Concept
								if (t.item(j).getLocalName() == "concept") {
									while (t.item(j).getChildNodes()
											.getLength() > 0) {
										t.item(j).removeChild(
												t.item(j).getChildNodes()
														.item(0));
									}
									// Attr conref change to href
									for (int j2 = 0; j2 < t.item(j)
											.getAttributes().getLength(); j2++) {
										if (t.item(j).getAttributes().item(j2)
												.getLocalName() == "conref") {
											// rename attribute "conref" to
											// "href" in "topicref" element
											doc.renameNode(t.item(j)
													.getAttributes().item(j2),
													"", "href");
										} else {
											// delete all attributes in
											// "topicref" except "href"
											t.item(j)
													.getAttributes()
													.removeNamedItem(
															t.item(j)
																	.getAttributes()
																	.item(j2)
																	.getLocalName());
										}
									}
									doc.renameNode(t.item(j), "", "topicref");
								}
								// Task
								if (t.item(j).getLocalName() == "task") {
									while (t.item(j).getChildNodes()
											.getLength() > 0) {
										t.item(j).removeChild(
												t.item(j).getChildNodes()
														.item(0));
									}
									// Attr conref change to href
									for (int j2 = 0; j2 < t.item(j)
											.getAttributes().getLength(); j2++) {
										if (t.item(j).getAttributes().item(j2)
												.getLocalName() == "conref") {
											// rename attribute "conref" to
											// "href" in "topicref" element
											doc.renameNode(t.item(j)
													.getAttributes().item(j2),
													"", "href");
										} else {
											// delete all attributes in
											// "topicref" except "href"
											t.item(j)
													.getAttributes()
													.removeNamedItem(
															t.item(j)
																	.getAttributes()
																	.item(j2)
																	.getLocalName());
										}
									}
									doc.renameNode(t.item(j), "", "topicref");
								}
								// Task
								if (t.item(j).getLocalName() == "reference") {
									while (t.item(j).getChildNodes()
											.getLength() > 0) {
										t.item(j).removeChild(
												t.item(j).getChildNodes()
														.item(0));
									}
									// Attr conref change to href
									for (int j2 = 0; j2 < t.item(j)
											.getAttributes().getLength(); j2++) {
										if (t.item(j).getAttributes().item(j2)
												.getLocalName() == "conref") {
											// rename attribute "conref" to
											// "href" in "topicref" element
											doc.renameNode(t.item(j)
													.getAttributes().item(j2),
													"", "href");
										} else {
											// delete all attributes in
											// "topicref" except "href"
											t.item(j)
													.getAttributes()
													.removeNamedItem(
															t.item(j)
																	.getAttributes()
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
							Object tresult = tref.evaluate(doc,
									XPathConstants.NODESET);
							NodeList tnodes = (NodeList) tresult;
							for (int i = 0; i < tnodes.getLength(); i++) {
								Attr attr = null;
								for (int l = 0; l < tnodes.item(i)
										.getAttributes().getLength(); l++) {
									if (tnodes.item(i).getAttributes().item(l)
											.getNodeName() == "href") {
										attr = (Attr) tnodes.item(i)
												.getAttributes().item(l);
									}
								}
								if (attr.getNodeValue().startsWith("#"))
									attr.setValue(attr.getNodeValue()
											.replaceAll("#(.+)", "$1.xml#$1"));
								if (!attr.getNodeValue().startsWith("#"))
									if (attr.getNodeValue().indexOf("/") != -1)
										attr.setValue(attr
												.getNodeValue()
												.replaceAll(
														"([a-zA-Z0-9_]+)/[a-zA-Z0-9_]+(\\.[a-z]{3})(#)([a-zA-Z0-9_]+)(/)([a-zA-Z0-9_]+)",
														"$1$2$3$4$5$6"));
							}
						}
						// Поиск субтопиков, разделение субтопиков на topicref и
						// другие
						{
							// Находим топик в файле
							XPathExpression tref = xpath
									.compile("//topic//topic|//topic//task|//topic//concept|//topic//reference|//topic//glossary|//task//topic|//task//task|//task//concept|//task//reference|//task//glossary|//concept//topic|//concept//task|//concept//concept|//concept//reference|//concept//glossary|//reference//topic|//reference//task|//reference//concept|//reference//reference|//reference//glossary|//glossary//topic|//glossary//task|//glossary//concept|//glossary//reference|//glossary//glossary");
							Object tresult = tref.evaluate(doc,
									XPathConstants.NODESET);
							NodeList tnodes = (NodeList) tresult;

							for (int i = 0; i < tnodes.getLength(); i++) {
								String href = "";
								// Проверяем есть ли у него conref или href
								if (tnodes.item(i).getAttributes()
										.getNamedItem("conref") != null) {
									// Если есть запоминаем ссылку
									href = tnodes.item(i).getAttributes()
											.getNamedItem("conref")
											.getNodeValue().replace('/', '\\');
								} else {
									// Если нет то выносим содержимое в
									// отдельный файл с именем = ID топика и
									// запоминаем ссылку
									href = tnodes.item(i).getAttributes()
											.getNamedItem("id").getNodeValue()
											+ ".xml";
									String topicText = XmlNodesToString(
											tnodes.item(i), 1, false);
									DocumentBuilderFactory factory1 = DocumentBuilderFactory
											.newInstance();
									factory1.setValidating(false);
									factory1.setNamespaceAware(true);
									DocumentBuilder builder1 = factory
											.newDocumentBuilder();

									org.w3c.dom.Document doc1 = builder1
											.parse(new ByteArrayInputStream(
													topicText.getBytes("UTF-8")));
									textArea.append("[EXTRACT TO FILE] "
											+ files.get(0).rootCatalogpath
											+ href + "\r\n");
									writeXMLToFile(tnodes.item(i)
											.getLocalName(), doc1,
											files.get(0).rootCatalogpath + href);

									files.add(new FilesListUpdateMaps(files
											.get(0).rootCatalogpath, files
											.get(0).rootCatalogpath + href,
											"topic", files.get(0).filePath
													.replace(mapFolder,
															outFolder)));
								}
								if (href != "") {
									// Открываем дитамап
									DocumentBuilderFactory factory1 = DocumentBuilderFactory
											.newInstance();
									factory1.setValidating(false);
									factory1.setNamespaceAware(true); // never
																		// forget
																		// this!
									DocumentBuilder builder1 = factory1
											.newDocumentBuilder();
									builder1.setEntityResolver(new EntityResolver() {
										public InputSource resolveEntity(
												String publicId, String systemId)
												throws SAXException,
												IOException {
											// System.out.println("Ignoring " +
											// publicId + ", " + systemId);
											return new InputSource(
													new StringReader(""));
										}
									});

									String newMap = mapFile.getAbsolutePath()
											.replace(mapFolder, outFolder);
									org.w3c.dom.Document doc1 = builder1
											.parse(newMap);

									XPathFactory xPathFactory1 = XPathFactory
											.newInstance();
									XPath xpath1 = xPathFactory1.newXPath();

									// Находим в нем текущий файл
									XPathExpression expr1 = xpath1
											.compile("//*[contains(@href, '"
													+ files.get(0).filePath.replace(
															mapFile.getParent()
																	+ "\\", "")
													+ "')]");
									Object result1 = expr1.evaluate(doc1,
											XPathConstants.NODESET);
									NodeList nodes1 = (NodeList) result1;
									textArea.append("Search in ditamap *[contains(@href, '"
											+ files.get(0).filePath.replace(
													mapFile.getParent() + "\\",
													"") + "')]" + "\r\n");
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
								// Удаляем содержимое топика и сам топик в
								// текущем файле (который нашли и на который
								// скопировали ссылку)
								Node n = tnodes.item(i);
								n.getParentNode().removeChild(n);
							}
						}
						// /////FOR TOPICREF////
						// {
						// //Находим топик в файле
						// XPathExpression tref =
						// xpath.compile("//topic//topicref|//task//topicref|//concept//topicref|//reference//topicref|//glossary//topicref");
						// Object tresult = tref.evaluate(doc,
						// XPathConstants.NODESET);
						// NodeList tnodes = (NodeList) tresult;
						//
						// for (int i = 0; i < tnodes.getLength(); i++)
						// {
						// String href = "";
						// //Проверяем есть ли у него conref или href
						// if(tnodes.item(i).getAttributes().getNamedItem("href")
						// != null)
						// {
						// //Если есть запоминаем ссылку
						// href =
						// tnodes.item(i).getAttributes().getNamedItem("id").getNodeValue().replace('/',
						// '\\');
						//
						// }
						// else
						// {
						// //Если нет то выносим содержимое в отдельный файл с
						// именем = ID топика и запоминаем ссылку
						// href =
						// tnodes.item(i).getAttributes().getNamedItem("id").getNodeValue()
						// + ".xml";
						// String topicText = XmlNodesToString(tnodes.item(i),
						// 1, false);
						// DocumentBuilderFactory factory1 =
						// DocumentBuilderFactory.newInstance();
						// factory1.setValidating(false);
						// factory1.setNamespaceAware(true);
						// DocumentBuilder builder1 =
						// factory.newDocumentBuilder();
						// textArea.append("[EXTRACT TO FILE] " +
						// files.get(0).rootCatalogpath + href);
						// org.w3c.dom.Document doc1 = builder1.parse(new
						// ByteArrayInputStream(topicText.getBytes("UTF-8")));
						// writeXMLToFile("topic", doc1,
						// files.get(0).rootCatalogpath + href);
						//
						// files.add(new FilesList(files.get(0).rootCatalogpath,
						// files.get(0).rootCatalogpath + href, "topic",
						// files.get(0).filePath.replace(mapFolder,
						// outFolder)));
						// }
						// if(href!="")
						// {
						// //Открываем дитамап
						// DocumentBuilderFactory factory1 =
						// DocumentBuilderFactory.newInstance();
						// factory1.setValidating(false);
						// factory1.setNamespaceAware(true); // never forget
						// this!
						// DocumentBuilder builder1 =
						// factory1.newDocumentBuilder();
						// builder1.setEntityResolver(new EntityResolver() {
						// public InputSource resolveEntity(String publicId,
						// String systemId)
						// throws SAXException, IOException {
						// //System.out.println("Ignoring " + publicId + ", " +
						// systemId);
						// return new InputSource(new StringReader(""));
						// }
						// });
						//
						// String newMap =
						// mapFile.getAbsolutePath().replace(mapFolder,
						// outFolder);
						// org.w3c.dom.Document doc1 = builder1.parse(newMap);
						//
						// XPathFactory xPathFactory1 =
						// XPathFactory.newInstance();
						// XPath xpath1 = xPathFactory1.newXPath();
						//
						// // Находим в нем текущий файл
						// XPathExpression expr1 =
						// xpath1.compile("//*[contains(@href, '" +
						// files.get(0).filePath.replace(mapFile.getParent() +
						// "\\", "") + "')]");
						// Object result1 = expr1.evaluate(doc1,
						// XPathConstants.NODESET);
						// NodeList nodes1 = (NodeList) result1;
						// System.out.println("Search in ditamap *[contains(@href, '"
						// + files.get(0).filePath.replace(mapFile.getParent() +
						// "\\", "") + "')]");
						// for (int k = 0; k < nodes1.getLength(); k++) {
						// // Добавляем в него ссылку
						// org.w3c.dom.Element el =
						// doc1.createElement("topicref");
						// el.setAttribute("href", href);
						// nodes1.item(0).appendChild(el);
						// }
						// writeXMLToFile("map", doc1, newMap);
						// //Добавляем файл href в список файлов
						// //files.add(new
						// FilesList(files.get(0).rootCatalogpath,
						// files.get(0).rootCatalogpath + href, "topic",
						// files.get(0).filePath.replace(mapFolder,
						// outFolder)));
						// }
						// //System.err.println(href);
						// }
						// for (int i = 0; i < tnodes.getLength(); i++)
						// {
						// //Удаляем содержимое топика и сам топик в текущем
						// файле (который нашли и на который скопировали ссылку)
						// Node n = tnodes.item(i);
						// n.getParentNode().removeChild(n);
						// }
						// }
					}
					// Add 0 width spaces to dita sources
					// XmlNodesAddSpaces(doc.getLastChild().getChildNodes());
					// Save file if needed (if we do changes in this file and
					// save subfile which we extract from this file)
					writeXMLToFile(filetype, doc,
							files.get(0).filePath.replace(mapFolder, outFolder));

					textArea.append("" + "\r\n");
					textArea.append("Remove " + files.get(0).filePath
							+ " from list" + "\r\n");
					textArea.append(files.size() + " files remain" + "\r\n");
					textArea.append("-----------------------------" + "\r\n");

					files.remove(0);
				} catch (Exception e) {
					System.err.println("Error");
				}
				textArea.setCaretPosition(textArea.getDocument().getLength());
			}
			textArea.append("[TOTAL FILES] " + count);
			// XXX
		}
	}
}
