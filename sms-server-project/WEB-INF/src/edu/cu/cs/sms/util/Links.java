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
 * The Concept Map Service Project is distributed in the hope that it will be
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

package edu.cu.cs.sms.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.StringReader;
import java.io.StringWriter;
import java.sql.SQLException;
import java.util.LinkedList;
import java.util.List;

import org.apache.xerces.dom.DocumentImpl;
import org.apache.xerces.parsers.DOMParser;
import org.apache.xml.serialize.XMLSerializer;
import org.w3c.dom.Attr;
import org.w3c.dom.DOMException;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.apache.xml.serialize.OutputFormat;


import edu.cu.cs.sms.ExtendedActionServlet;
import edu.cu.cs.sms.Database.QueryEngine;
import edu.cu.cs.sms.Database.QueryExecutor;
import edu.cu.cs.sms.Database.SMSResultSet;
import edu.cu.cs.sms.Exceptions.CorruptDataException;

public class Links
{

	List		removedNodeList	= new LinkedList();

	QueryEngine	runQuery		= (QueryExecutor) ExtendedActionServlet.cxt
										.getAttribute("SQL");

	public byte[] LinkMaker(String result, SMSResultSet info)
			throws SAXException, SQLException, IOException,
			CorruptDataException
	{
		SMSResultSet smsRS = null;
		String sqlQuery = null;
		boolean match = false;
		Attr ID = null;
		removedNodeList.clear();

		boolean isRemoveAll = false;

		if (info.getDefaultALLQueryExpander() == null
				&& info.getDefaultATLQueryExpander() == null
				&& info.getDefaultBMKQueryExpander() == null
				&& info.getDefaultCHPQueryExpander() == null
				&& info.getDefaultCLSQueryExpander() == null
				&& info.getDefaultGRDQueryExpander() == null
				&& info.getDefaultMAPQueryExpander() == null
				&& info.getDefaultSECQueryExpander() == null
				&& info.getDefaultSFAAQueryExpander() == null
				&& info.getDefaultSTDQueryExpander() == null)
			isRemoveAll = true;

		QueryExpander DQE = null;
		DOMParser parser = new DOMParser();
		parser.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd",false);
		parser.setFeature("http://xml.org/sax/features/validation", false);
		parser.setFeature("http://xml.org/sax/features/namespaces", false);

		parser.parse(new InputSource(new BufferedReader(new StringReader(result))));

		DocumentImpl doc = (DocumentImpl) parser.getDocument();
		NodeList nList = doc.getElementsByTagName("a");
		int len = nList.getLength();

		for (int index = 0; index < len; index++)
		{
			Node tNode = nList.item(index);

			if (tNode != null)
			{
				Node gNode = tNode.getFirstChild(); 
				NamedNodeMap attrs = tNode.getAttributes();
				Node link = attrs.getNamedItem("xlink:href");

				if(gNode.getNodeName().equals("g"))
					((Element) (gNode)).setAttributeNS("http://sms.dlese.org","OID",link.getNodeValue());

				if (isRemoveAll)
				{
					if (link != null)
					{
						String value = link.getNodeValue();
						if (value.matches("SMS-[a-zA-Z]{3}-[0-9]{4}")
								|| value.trim().equals(""))
							removeNode(tNode);
					} else
						removeNode(tNode);
				} 
				else
				{
					if (link == null
							|| link.getNodeValue().trim().equalsIgnoreCase(""))
						removeNode(tNode);
					else
					{
						match = false;
						DQE = null;
						String value = link.getNodeValue().trim();

						if (value.matches("SMS-BMK-[0-9]{4}"))
						{
							DQE = info.getDefaultBMKQueryExpander();
							match = true;
						} else if (value.matches("SMS-STD-[0-9]{4}"))
						{
							DQE = info.getDefaultSTDQueryExpander();
							match = true;
						} else if (value.matches("SMS-GRD-[0-9]{4}"))
						{
							DQE = info.getDefaultGRDQueryExpander();
							match = true;
						} else if (value.matches("SMS-MAP-[0-9]{4}"))
						{
							DQE = info.getDefaultMAPQueryExpander();
							match = true;
						} else if (value.matches("SMS-CLS-[0-9]{4}"))
						{
							DQE = info.getDefaultCLSQueryExpander();
							match = true;
						} else if (value.matches("SMS-ATL-[0-9]{4}"))
						{
							DQE = info.getDefaultATLQueryExpander();
							match = true;
						} else if (value.matches("SMS-CHP-[0-9]{4}"))
						{
							DQE = info.getDefaultCHPQueryExpander();
							match = true;
						} else if (value.matches("SMS-SEC-[0-9]{4}"))
						{
							DQE = info.getDefaultSECQueryExpander();
							match = true;
						} else if (value.matches("SMS-SFA-[0-9]{4}"))
						{
							DQE = info.getDefaultSFAAQueryExpander();
							match = true;
						}

						if (DQE == null)
							DQE = info.getDefaultALLQueryExpander();

						if (match && DQE == null)
							removeNode(tNode);

						if (DQE != null)
						{
							// Sets the ID for Concept nodes that can be
							// valuable for SVG post processing
							if (tNode.getNodeType() == tNode.ELEMENT_NODE)
								((Element) (tNode)).setAttribute("id",value);

							sqlQuery = "select * from objects O, relation R where (Object_id='"
									+ value + "') and R.itemid1=O.object_id";
							smsRS = runQuery.executeSearch(sqlQuery);
							if (smsRS.getTotalObjects() > 0)
								value = DQE.getDLquery(smsRS.getObject(0));
							else
								value = "";

							link.setNodeValue(value);
						}
					}

				}
			}
		}

		batchRemoveNode();

		StringWriter  strWriter   	= new StringWriter();
		XMLSerializer returnString 	= new XMLSerializer();
		OutputFormat  outFormat   	= new OutputFormat();

		// Setup format settings
	    outFormat.setEncoding("UTF-8");
	    outFormat.setIndenting(true);
	    outFormat.setOmitXMLDeclaration(true);
	    
        // Define a Writer
	    returnString.setOutputCharStream(strWriter);

	    // Apply the format settings
	    returnString.setOutputFormat(outFormat); 
	    returnString.setNamespaces(true);
	    	    
	    // Serialize XML Document
	    returnString.serialize(doc);
	    result = strWriter.toString();
	    strWriter.close();

//		result = doc.saveXML(null);

		return result.getBytes();
	}

	private void removeNode(Node tNode) throws DOMException
	{
		removedNodeList.add(tNode);
	}

	private void batchRemoveNode() throws DOMException
	{
		for (int index = 0; index < removedNodeList.size(); index++)
		{
			Node tNode = (Node) removedNodeList.get(index);
			NodeList rnList = tNode.getChildNodes();

			for (int check = 0; check < rnList.getLength(); check++)
				tNode.getParentNode().appendChild(
						rnList.item(check).cloneNode(true));

			tNode.getParentNode().removeChild(tNode);

		}
	}
}
