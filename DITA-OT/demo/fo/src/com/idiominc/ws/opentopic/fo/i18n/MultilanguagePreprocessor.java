package com.idiominc.ws.opentopic.fo.i18n;

import org.w3c.dom.*;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import java.util.List;
import java.util.ArrayList;

import com.idiominc.ws.opentopic.fo.i18n.Alphabet;
import com.idiominc.ws.opentopic.fo.i18n.Configuration;

/*
Copyright (c) 2004-2006 by Idiom Technologies, Inc. All rights reserved. 
IDIOM is a registered trademark of Idiom Technologies, Inc. and WORLDSERVER
and WORLDSTART are trademarks of Idiom Technologies, Inc. All other 
trademarks are the property of their respective owners. 

IDIOM TECHNOLOGIES, INC. IS DELIVERING THE SOFTWARE "AS IS," WITH 
ABSOLUTELY NO WARRANTIES WHATSOEVER, WHETHER EXPRESS OR IMPLIED,  AND IDIOM
TECHNOLOGIES, INC. DISCLAIMS ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING
BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR 
PURPOSE AND WARRANTY OF NON-INFRINGEMENT. IDIOM TECHNOLOGIES, INC. SHALL NOT
BE LIABLE FOR INDIRECT, INCIDENTAL, SPECIAL, COVER, PUNITIVE, EXEMPLARY,
RELIANCE, OR CONSEQUENTIAL DAMAGES (INCLUDING BUT NOT LIMITED TO LOSS OF 
ANTICIPATED PROFIT), ARISING FROM ANY CAUSE UNDER OR RELATED TO  OR ARISING 
OUT OF THE USE OF OR INABILITY TO USE THE SOFTWARE, EVEN IF IDIOM
TECHNOLOGIES, INC. HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES. 

Idiom Technologies, Inc. and its licensors shall not be liable for any
damages suffered by any person as a result of using and/or modifying the
Software or its derivatives. In no event shall Idiom Technologies, Inc.'s
liability for any damages hereunder exceed the amounts received by Idiom
Technologies, Inc. as a result of this transaction.

These terms and conditions supersede the terms and conditions in any
licensing agreement to the extent that such terms and conditions conflict
with those set forth herein.

This file is part of the DITA Open Toolkit project hosted on Sourceforge.net. 
See the accompanying license.txt file for applicable licenses.
*/public class MultilanguagePreprocessor {
    private static final String NAMESPACE_URL = "http://www.idiominc.com/opentopic/i18n";
    private static final String PREFIX = "opentopic-i18n";

    private final Configuration configuration;


    public MultilanguagePreprocessor(Configuration theTheConfiguration) {
        if (null == theTheConfiguration) {
            throw new NullPointerException("configuration");
        }
        this.configuration = theTheConfiguration;
    }


    public Document process(Document theInput)
            throws ProcessException {
        DocumentBuilderFactory documentBuilderFactory = DocumentBuilderFactory.newInstance();
        DocumentBuilder documentBuilder = null;
        try {
            documentBuilder = documentBuilderFactory.newDocumentBuilder();
        } catch (ParserConfigurationException e) {
            e.printStackTrace();
        }
        Document doc = documentBuilder.newDocument();

        Node rootElement = theInput.getDocumentElement();


        Node node = processCurrNode(rootElement, doc)[0];

        doc.appendChild(node);

        doc.getDocumentElement().setAttribute("xmlns:" + PREFIX, NAMESPACE_URL);

        return doc;
    }


    private Node[] processCurrNode(Node theNode, Document theTargetDocument) {
        if (theNode.getNodeType() == Node.TEXT_NODE) {
            return processTextNode(theNode, theTargetDocument);
        } else {
            Node result = theTargetDocument.importNode(theNode, false);
            NodeList childNodes = theNode.getChildNodes();
            for (int i = 0; i < childNodes.getLength(); i++) {
                Node[] processedNodes = processCurrNode(childNodes.item(i), theTargetDocument);
                for (int j = 0; j < processedNodes.length; j++) {
                    Node node = processedNodes[j];
                    result.appendChild(node);
                }
            }
            return new Node[]{result};
        }
    }


    private Node[] processTextNode(Node theTextNode, Document theTargetDocument) {
        //        Element processedText = theTargetDocument.createElementNS(NAMESPACE_URL, "processed-text");
        //        processedText.setPrefix(PREFIX);
        List resultNodeList = new ArrayList();

        String nodeValue = theTextNode.getNodeValue();
        if (null != nodeValue) {
            int processedPosition = 0;

            Alphabet currentAlphabet = null;

            char[] chars = nodeValue.toCharArray();
            for (int i = 0; i < chars.length; i++) {
                char aChar = chars[i];
                Alphabet alphabetForChar = this.configuration.getAlphabetForChar(aChar);
                if (null != alphabetForChar && alphabetForChar.equals(currentAlphabet)) {
                    continue;
                } else if (null == alphabetForChar && null == currentAlphabet) {
                    continue;
                } else {
                    String string = nodeValue.substring(processedPosition, i);

                    Node child = createChildNode(currentAlphabet, theTargetDocument, string);

                    resultNodeList.add(child);

                    currentAlphabet = alphabetForChar;

                    processedPosition = i;
                }
            }
            Node childNode = createChildNode(currentAlphabet, theTargetDocument, nodeValue.substring(processedPosition));
            resultNodeList.add(childNode);
        }
        return (Node[]) resultNodeList.toArray(new Node[resultNodeList.size()]);
    }


    private Node createChildNode(Alphabet theCurrentAlphabet, Document theTargetDocument, String theString) {
        Node child;
        if (null != theCurrentAlphabet) {
            Element element = theTargetDocument.createElementNS(NAMESPACE_URL, "text-fragment");
            element.setPrefix(PREFIX);

            String charSet = theCurrentAlphabet.getName();
            element.setAttribute("char-set", charSet);
            Text textNode = theTargetDocument.createTextNode(theString);
            element.appendChild(textNode);
            child = element;
        } else {
            child = theTargetDocument.createTextNode(theString);
        }
        return child;
    }
}
