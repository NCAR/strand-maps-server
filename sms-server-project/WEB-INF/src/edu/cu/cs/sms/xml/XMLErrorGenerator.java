/* 
 * Copyright 2002-2005 Boulder Learning Technologies Lab & American Association for the Advancement of Science, 
 * DLC-1B20, Department of Computer Science, University of Colorado at Boulder,
 * CO-80309, Tel: 303-492-0916, email: fahmad@colorado.edu
 * 
 * This file is part of the Concept Map Service Software Project.
 * 
 * The Concept Map Service Project is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of the
 * License, or (at your option) any later version.
 * 
 * The Concept Map Service OAI Project is distributed in the hope that it will be
 * useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with The Concept Map Service System; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
 * USA
 * 
 * Author: Faisal Ahmad
 * Date  : Sept 14, 2005
 * email : fahmad@colorado.edu
 */

package edu.cu.cs.sms.xml;

import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Enumeration;
import java.util.PropertyResourceBundle;

import org.apache.struts.util.MessageResources;
import org.apache.xerces.parsers.DOMParser;
import org.w3c.dom.Attr;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import edu.cu.cs.sms.ExtendedActionServlet;
import edu.cu.cs.sms.DTO.ErrorBean;
import edu.cu.cs.sms.util.WriteXML;

public class XMLErrorGenerator {
    private ErrorBean eb;

    public XMLErrorGenerator(ErrorBean dataBean) {
        eb = dataBean;
    }

    public String populate(String xmlTemplateFile) {
        String sb = null;
        DOMParser errDoc = new DOMParser();
        Document doc;
        MessageResources mr = (MessageResources) ExtendedActionServlet.cxt
                .getAttribute("TagNames");

        try {
            PropertyResourceBundle rb = new PropertyResourceBundle(
                    new BufferedInputStream(this.getClass().getClassLoader().getResourceAsStream("edu/cu/cs/sms/XMLTagNames.properties")));
            Enumeration keys = rb.getKeys();

            errDoc.parse(xmlTemplateFile);
            doc = errDoc.getDocument();

            for (; keys.hasMoreElements();) {
                NodeList nl = doc.getElementsByTagName((String) rb
                        .handleGetObject(keys.nextElement().toString()));

                for (int loopIndex = 0; loopIndex < nl.getLength(); loopIndex++) {
                    Node n = nl.item(loopIndex);

                    if (n.getNodeName().equalsIgnoreCase(
                            mr.getMessage("Error.Root"))
                            && n.getAttributes() != null)
                        fillError(n);
                    else if (n.getNodeName().equalsIgnoreCase(
                            mr.getMessage("Error.Root.Child1")))
                        fillDescription(n, doc);
                    else if (n.getNodeName().equalsIgnoreCase(
                            mr.getMessage("Error.Root.Child2")))
                        fillLocation(n, doc);
                    else if (n.getNodeName().equalsIgnoreCase(
                            mr.getMessage("Error.Root.Child3")))
                        fillProblems(n, doc, mr
                                .getMessage("Error.Root.Child3.Child"));
                }
            }

            sb = (new WriteXML()).writeXML(errDoc.getDocument());
        } catch (FileNotFoundException e1) {
            e1.printStackTrace();
        } catch (SAXException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

        return sb;
    }

    private void fillProblems(Node n, Document doc, String tagName) {
        String p = eb.getProblem();
		if(p == null)
			p = "No information available";
		
		Element problem = doc.createElement(tagName);
		problem.setTextContent(p.replaceAll("<","&lt;").replaceAll(">","&gt;"));
		n.appendChild(problem);
    }

    private void fillDescription(Node n, Document doc) {
        n.appendChild(doc.createTextNode(eb.getDescription()));
    }

    private void fillError(Node n) {
        int len = n.getAttributes().getLength();
        Attr[] at = new Attr[len];

        for (int counter = 0; counter < len; counter++) {
            at[counter] = (Attr) n.getAttributes().item(counter);
            at[counter].setValue(String.valueOf(eb.getCode()));
        }
    }

    private void fillLocation(Node n, Document doc) {
        int len = n.getAttributes().getLength();
        Attr[] at = new Attr[len];

        for (int counter = 0; counter < len; counter++) {
            at[counter] = (Attr) n.getAttributes().item(counter);
            at[counter].setValue(String.valueOf(eb.getLineNo()));
        }

        n.appendChild(doc.createTextNode(eb.getLocation()));
    }
}
