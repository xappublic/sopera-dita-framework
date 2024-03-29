package org.sopera.dita.framework;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.StringReader;
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
	String separator = "\\";
	
	String outFolder = "in" + separator;

	public UpdateSourceThrd(JTextArea shortLogTextArea, JFileChooser chooser) {
		textArea = shortLogTextArea;
		this.chooser = chooser;
		separator = String.valueOf(File.separatorChar);
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
			//if selected node is element node then create text such as <node attr1="val1" /> and remove all fm_ attrs 
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

	//I think we have to add 0-width spaces manually to DITA source code and do not use this function
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
				//if selected node is element node then create text such as <node attr1="val1" /> and remove all fm_ attrs 
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
		new File(path).getParentFile().mkdirs();
		textArea.append("[SAVE FILE] '" + path + "'" + "\r\n");
		// CharsetEncoder encoder = Charset.forName("US-ASCII").newEncoder();
		CharsetEncoder encoder = Charset.forName("UTF-8").newEncoder();
		OutputStreamWriter f = new OutputStreamWriter(new FileOutputStream(path, false), encoder);
		
		String dt = "";
		if (doctype == "topic")
			dt = "<?xml version=\"1.0\"?>\r\n<!DOCTYPE topic PUBLIC \"-//OASIS//DTD DITA topic//EN\" \"DITA-OT/dtd/technicalContent/dtd/topic.dtd\">";
		if (doctype == "task")
			dt = "<?xml version=\"1.0\"?>\r\n<!DOCTYPE task PUBLIC \"-//OASIS//DTD DITA task//EN\" \"DITA-OT/dtd/technicalContent/dtd/task.dtd\">";
		if (doctype == "map")
			dt = "<?xml version=\"1.0\"?>\r\n<!DOCTYPE map PUBLIC \"-//OASIS//DTD DITA map//EN\" \"DITA-OT/dtd/technicalContent/dtd/map.dtd\">";
		if (doctype == "concept")
			dt = "<?xml version=\"1.0\"?>\r\n<!DOCTYPE concept PUBLIC \"-//OASIS//DTD DITA Concept//EN\" \"DITA-OT/dtd/technicalContent/dtd/concept.dtd\">";
		if (doctype == "reference")
			dt = "<?xml version=\"1.0\"?>\r\n<!DOCTYPE reference PUBLIC \"-//OASIS//DTD DITA Reference//EN\" \"DITA-OT/dtd/technicalContent/dtd/reference.dtd\">";
		if (doctype == "glossary")
			dt = "<?xml version=\"1.0\"?>\r\n<!DOCTYPE glossary PUBLIC \"-//OASIS//DTD DITA Glossary//EN\" \"DITA-OT/dtd/technicalContent/dtd/glossary.dtd\">";
		char[] buf = new char[dt.length()];
		dt.getChars(0, buf.length, buf, 0);
		f.write(buf, 0, buf.length);
		
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

		char[] bufcontent = new char[content.length()];
		content.getChars(0, bufcontent.length, bufcontent, 0);
		f.write(bufcontent, 0, bufcontent.length);
		f.flush();
		f.close();
	}

	public void run() {
		List<String> ditamaps = new ArrayList<String>();
		mapFolder = chooser.getSelectedFile().getAbsolutePath() + separator;
		FindDitaMapsOld(chooser.getSelectedFile(), ditamaps);
		textArea.append("Found maps:\r\n");
		for (int mapindex = 0; mapindex < ditamaps.size(); mapindex++) {
			textArea.append(ditamaps.get(mapindex) + "\r\n");
			System.out.println("Map: " + ditamaps.get(mapindex));
			textArea.append("\r\n------------------------------\r\n");
			String mapFilePath = ditamaps.get(mapindex);
			// Rename ditamap file from _main.xml to .ditamap
			mapFilePath = renameDitamapFile(mapFilePath);
			File mapFile = new File(mapFilePath);
			//Copy images to output directory
			try {
				textArea.append("[COPY IMAGES] " + mapFile.getParent() + "\r\n");
				String dest = mapFile.getParent().replace(chooser.getSelectedFile().getAbsolutePath(), "in");
				if(dest.endsWith(separator)) dest += "images";
				else  dest += separator + "images";
				new File(dest).mkdirs();
				CopyFiles(new File(mapFile.getParent() + separator + "images"), new File(dest));
				textArea.append("[END COPY IMAGES] " + mapFile.getParent() + "\r\n");
			} catch (Exception e1) {
				e1.printStackTrace();
			}
			
			List<FilesListUpdateMaps> files = new ArrayList<FilesListUpdateMaps>();
			files.add(new FilesListUpdateMaps(mapFile.getParent() + separator,
					mapFilePath, "map", "")); // Add ditamap to files list
			int count = 0;

			//Files contains path to files which we found in sources. When we found reference to file in topic we add this reference to files variable
			while (files.size() > 0) {
				try {
					count++;
					System.out.println(count); //Count files which we transform
					String filetype = files.get(0).fileType;
					textArea.append("[FILETYPE FROM FILE] " + filetype + "\r\n");
					textArea.append("[PARENT] " + files.get(0).parentLink + "\r\n");
					textArea.append("[FILE] " + files.get(0).filePath + "\r\n");
					DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
					factory.setValidating(false);
					factory.setNamespaceAware(true); // never forget this!
					DocumentBuilder builder = factory.newDocumentBuilder();
					builder.setEntityResolver(new EntityResolver() {
						public InputSource resolveEntity(String publicId,
								String systemId) throws SAXException,
								IOException {
							return new InputSource(new StringReader(""));
						}
					});
					org.w3c.dom.Document doc = builder.parse(files.get(0).filePath);

					// Compare file type received from reference with file doctype
					filetype = compareDoctypes(filetype, doc);

					XPathFactory xPathFactory = XPathFactory.newInstance();
					XPath xpath = xPathFactory.newXPath();

					findFileReferencesInXML(files, doc, xpath, "//topicref");
					findFileReferencesInXML(files, doc, xpath, "//topic");
					findFileReferencesInXML(files, doc, xpath, "//concept");
					findFileReferencesInXML(files, doc, xpath, "//task");
					findFileReferencesInXML(files, doc, xpath, "//reference");

					// Modifying DOM file
					if (filetype == "map") {
						//if opened file is ditamap
						NodeList n = doc.getChildNodes();
						//Rename and fix old ditamap nodes to new format
						processOldMapFileNodes(doc, n);
					} else {
						fixLinks(doc, xpath);
						// Searching subtopics, split subtopics on topicref and others
						// Find topic in file
						XPathExpression tref = xpath.compile("/topic/topic|/topic/task|/topic/concept|/topic/reference|/topic/glossary|" +
															 "/task/topic|/task/task|/task/concept|/task/reference|/task/glossary|" +
															 "/concept/topic|/concept/task|/concept/concept|/concept/reference|/concept/glossary|" +
															 "/reference/topic|/reference/task|/reference/concept|/reference/reference|/reference/glossary|" +
															 "/glossary/topic|/glossary/task|/glossary/concept|/glossary/reference|/glossary/glossary");
							Object tresult = tref.evaluate(doc, XPathConstants.NODESET);
							NodeList tnodes = (NodeList) tresult;

							for (int i = 0; i < tnodes.getLength(); i++) {
								String href = "";
								// Check if topic contains conref
								if (tnodes.item(i).getAttributes().getNamedItem("conref") != null) {
									href = tnodes.item(i).getAttributes().getNamedItem("conref").getNodeValue().replace("/", separator);
								} else {
									// If topic not contain conref extract content to separate file and add to href variable path to file
									href = tnodes.item(i).getAttributes().getNamedItem("id").getNodeValue()	+ ".xml";
									String topicText = XmlNodesToString(tnodes.item(i), 1, false);
									DocumentBuilderFactory factory1 = DocumentBuilderFactory.newInstance();
									factory1.setValidating(false);
									factory1.setNamespaceAware(true);
									DocumentBuilder builder1 = factory.newDocumentBuilder();

									org.w3c.dom.Document doc1 = builder1.parse(new ByteArrayInputStream(topicText.getBytes("UTF-8")));
									textArea.append("[EXTRACT TO FILE] " + files.get(0).rootCatalogpath	+ href + "\r\n");
									writeXMLToFile(tnodes.item(i).getLocalName(), doc1, files.get(0).rootCatalogpath + href);
									files.add(new FilesListUpdateMaps(files.get(0).rootCatalogpath, 
																	  files.get(0).rootCatalogpath + href, 
																	  "topic", 
																	  files.get(0).filePath.replace(mapFolder, outFolder)));
								}
								if (href != "") {
									// Opening ditamap
									DocumentBuilderFactory factory1 = DocumentBuilderFactory.newInstance();
									factory1.setValidating(false);
									factory1.setNamespaceAware(true);
									DocumentBuilder builder1 = factory1.newDocumentBuilder();
									builder1.setEntityResolver(new EntityResolver() {
										public InputSource resolveEntity(
												String publicId, String systemId)
												throws SAXException,
												IOException {
											return new InputSource(
													new StringReader(""));
										}
									});

									String newMap = mapFile.getAbsolutePath().replace(mapFolder, outFolder);
									org.w3c.dom.Document doc1 = builder1.parse(newMap);

									XPathFactory xPathFactory1 = XPathFactory.newInstance();
									XPath xpath1 = xPathFactory1.newXPath();
									//find file in ditamap
									XPathExpression expr1 = xpath1.compile("//*[contains(@href, '" + files.get(0).filePath.replace(mapFile.getParent()+ separator, "") + "')]");
									Object result1 = expr1.evaluate(doc1, XPathConstants.NODESET);
									NodeList nodes1 = (NodeList) result1;
									textArea.append("Search in ditamap *[contains(@href, '" + files.get(0).filePath.replace(mapFile.getParent() + separator, "") + "')]" + "\r\n");
									for (int k = 0; k < nodes1.getLength(); k++) {
										//Add topicref to map
										org.w3c.dom.Element el = doc1.createElement("topicref");
										el.setAttribute("href", href);
										nodes1.item(0).appendChild(el);
									}
									writeXMLToFile("map", doc1, newMap);
								}
							}
							for (int i = 0; i < tnodes.getLength(); i++) {
								// Deleting topic in this file (Which we found and for which we copied link)
								Node n = tnodes.item(i);
								n.getParentNode().removeChild(n);
							}
					}
					// Add 0 width spaces to dita sources
					// XmlNodesAddSpaces(doc.getLastChild().getChildNodes());
					// Save file if needed (if we do changes in this file and
					// save subfile which we extract from this file)
					writeXMLToFile(filetype, doc, files.get(0).filePath.replace(mapFolder, outFolder));

					textArea.append("" + "\r\n");
					textArea.append("Remove " + files.get(0).filePath + " from list" + "\r\n");
					textArea.append(files.size() + " files remain" + "\r\n");
					textArea.append("-----------------------------" + "\r\n");
					//Remove reference to updated file from files variable
					files.remove(0);
				} catch (Exception e) {
					System.err.println("Error in file:" + files.get(0).filePath);
					files.remove(0);
				}
				textArea.setCaretPosition(textArea.getDocument().getLength());
			}
			textArea.append("[TOTAL FILES] " + count);
		}
	}

	private void fixLinks(org.w3c.dom.Document doc, XPath xpath)
			throws XPathExpressionException {
		XPathExpression tref = xpath.compile("//xref");
		Object tresult = tref.evaluate(doc, XPathConstants.NODESET);
		NodeList tnodes = (NodeList) tresult;
		for (int i = 0; i < tnodes.getLength(); i++) {
			Attr attr = null;
			for (int l = 0; l < tnodes.item(i).getAttributes().getLength(); l++) {
				if (tnodes.item(i).getAttributes().item(l).getNodeName() == "href") {
					attr = (Attr) tnodes.item(i).getAttributes().item(l);
				}
			}
			if (attr.getNodeValue().startsWith("#"))
				attr.setValue(attr.getNodeValue().replaceAll("#(.+)", "$1.xml#$1"));
			if (!attr.getNodeValue().startsWith("#"))
				if (attr.getNodeValue().indexOf("/") != -1)	
					attr.setValue(attr.getNodeValue().replaceAll("([a-zA-Z0-9_]+)/[a-zA-Z0-9_]+(\\.[a-z]{3})(#)([a-zA-Z0-9_]+)(/)([a-zA-Z0-9_]+)", "$1$2$3$4$5$6"));
		}
	}

	private void processOldMapFileNodes(org.w3c.dom.Document doc, NodeList n) {
		for (int i = 0; i < n.getLength(); i++) {
			if (n.item(i).getLocalName() == "dita") {
				doc.renameNode(n.item(i), "", "map");
			}
			NodeList t = n.item(i).getChildNodes();
			for (int j = 0; j < t.getLength(); j++) {
				if ((t.item(j).getLocalName() == "topic") | 
						(t.item(j).getLocalName() == "concept") | 
						(t.item(j).getLocalName() == "task") | 
						(t.item(j).getLocalName() == "reference")) {
					while (t.item(j).getChildNodes().getLength() > 0) {
						t.item(j).removeChild(t.item(j).getChildNodes().item(0));
					}
					// Attr conref change to href
					for (int j2 = 0; j2 < t.item(j).getAttributes().getLength(); j2++) {
						if (t.item(j).getAttributes().item(j2).getLocalName() == "conref") {
							// rename attribute "conref" to "href" in "topicref" element
							doc.renameNode(t.item(j).getAttributes().item(j2),"", "href");
						} else {
							// delete all attributes in "topicref" except "href"
							t.item(j).getAttributes().removeNamedItem(t.item(j).getAttributes().item(j2).getLocalName());
						}
					}
					doc.renameNode(t.item(j), "", "topicref");
				}
			}
		}
	}

	private String compareDoctypes(String filetype, org.w3c.dom.Document doc) {
		textArea.append("[DOCTYPE TYPE] " + doc.getDoctype().getName() + "\r\n");
		String[] patterns = { "topic", "task", "map", "concept", "reference", "glossary" };
		for (String t : patterns) {
			Pattern topicPattern = Pattern.compile(t, Pattern.CASE_INSENSITIVE | Pattern.DOTALL | Pattern.MULTILINE);
			if (topicPattern.matcher(doc.getDoctype().getName()).matches()) {
				if (filetype != t) {
					//here we can set what we can do if doctype from reference not equals doctype from <!DOCTYPE> 
					filetype = doc.getDoctype().getName();
				}
			}
		}
		return filetype;
	}

	private String renameDitamapFile(String mapFilePath) {
		if (mapFilePath.endsWith("_main.xml")) {
			File mapfile = new File(mapFilePath);
			mapFilePath = mapFilePath.replace("_main.xml", ".ditamap");
			mapfile.renameTo(new File(mapFilePath));
		}
		// Rename ditamap file from .xml to .ditamap
		if (mapFilePath.endsWith(".xml")) {
			File mapfile = new File(mapFilePath);
			mapFilePath = mapFilePath.replace(".xml", ".ditamap");
			mapfile.renameTo(new File(mapFilePath));
		}
		return mapFilePath;
	}

	private void findFileReferencesInXML(List<FilesListUpdateMaps> files,
			org.w3c.dom.Document doc, XPath xpath, String xpathQuery)
			throws XPathExpressionException {
		XPathExpression expr = xpath.compile(xpathQuery);
		Object result = expr.evaluate(doc, XPathConstants.NODESET);
		NodeList nodes = (NodeList) result;
		String attr = "conref";
		String doctype = "";
		if(xpathQuery == "//topicref") { doctype = "topic"; attr = "href"; }
		if(xpathQuery == "//topic") doctype = "topic";
		if(xpathQuery == "//concept") doctype = "concept";
		if(xpathQuery == "//task") doctype = "task";
		if(xpathQuery == "//reference") doctype = "reference";
		
		textArea.append("[INFO] Found " + nodes.getLength() + " " + xpathQuery + "/@" + attr + " in '" + files.get(0).filePath + "' file" + "\r\n");
		for (int i = 0; i < nodes.getLength(); i++) {
			if (nodes.item(i).getAttributes().getNamedItem(attr) != null) {
				String href = nodes.item(i).getAttributes().getNamedItem(attr).getNodeValue().replace("/", separator);
				File hrefFile = new File(files.get(0).rootCatalogpath + href);
				files.add(new FilesListUpdateMaps(hrefFile.getParent() + separator, hrefFile.getParent()	+ separator + href, doctype,	files.get(0).filePath));
			}
		}
	}
}
