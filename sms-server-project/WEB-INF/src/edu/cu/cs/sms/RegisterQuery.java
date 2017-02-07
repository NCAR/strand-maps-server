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

package edu.cu.cs.sms;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.StringReader;
import java.io.UnsupportedEncodingException;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.logging.Logger;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;
import org.apache.xerces.parsers.DOMParser;
import org.w3c.dom.Attr;
import org.w3c.dom.Document;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import edu.cu.cs.sms.Database.QueryEngine;
import edu.cu.cs.sms.Database.QueryExecutor;
import edu.cu.cs.sms.Exceptions.CorruptDataException;
import edu.cu.cs.sms.Exceptions.DuplicateQueryRegisterationException;
import edu.cu.cs.sms.Exceptions.IllegalServiceRequestCombinaition;
import edu.cu.cs.sms.util.ListMessage;
import edu.cu.cs.sms.util.Message;
import edu.cu.cs.sms.util.NotificationCenter;
import edu.cu.cs.sms.util.RegisterQueryNormalMessage;
import edu.cu.cs.sms.util.WriteXML;
import edu.cu.cs.sms.xml.ER;
import edu.cu.cs.sms.xml.QueryErrorHandler;

/**
 * @author Faisal Ahmad
 * 
 * 
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class RegisterQuery extends SMSAction
{

	// This variable contains the application properties information
	MessageResources		information			= null;

	// The schema location for varification
	static private String	CSIPSchemaLocation	= null;

	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception
	{
		MessageResources transfer 	= getResources(request, "Transfer");// Transfer property keys
		String XMLRequest 			= getQuery(request);// Extract the XML request
		Message messege 			= null;
		DOMParser parser 			= new DOMParser();

		// Location of CSIP schema
		if (CSIPSchemaLocation == null)
			CSIPSchemaLocation = getResources(request, "Info").getMessage("Schema.NameSpace")+ " "+ (ExtendedActionServlet.cxt.getRealPath(getResources(request, "Info").getMessage("Schema.Location"))).replaceAll(" ", "%20");

		// validating the incoming query registration request
		validateDocument(parser, CSIPSchemaLocation, XMLRequest);

		// Loading the properties
		information = getResources(request, "Info");

		// Processing the request and getting back the response
		messege = initCommand(parser);

		// Transforming and saving the response in XML format
		request.setAttribute(transfer.getMessage("OKResponse"), messege.createResponse().getBytes());

		// Logging the request
		String logString = XMLRequest + " IP Address:"+ request.getRemoteAddr();
		((Logger) ExtendedActionServlet.cxt.getAttribute("logger")).info(logString);

		// Forwarding the XML document to response servlet
		return mapping.findForward(information.getMessage("Normal.ResponseServlet"));
	}

	/**
	 * This function branches to appropriate service handler
	 */
	private Message initCommand(DOMParser parser) throws SAXException,
			IllegalServiceRequestCombinaition, FileNotFoundException,
			CorruptDataException, SQLException, InstantiationException,
			IllegalAccessException, ClassNotFoundException, IOException
	{
		Document doc 	= parser.getDocument();
		NodeList nList 	= doc.getElementsByTagName("Operation");
		String op 		= null;
		String messege 	= null;
		Message reply 	= null;

		if (nList.getLength() == 0 || nList == null)
			throw new IllegalServiceRequestCombinaition();

		op = nList.item(0).getFirstChild().getNodeValue().trim();

		if (op.matches("Add Query String"))
			reply = addQuery(doc);
		else if (op.matches("Update Query String"))
			reply = updateQuery(doc);
		else if (op.matches("Change Authentication Code"))
			reply = changeAuthenticationCode(doc);
		else if (op.matches("Remove"))
			reply = removeQuery(doc);
		else if (op.matches("Disable") || op.matches("Enable"))
			reply = changeStatus(doc, op);
		else if (op.matches("Find"))
			reply = find(doc);
		else if (op.matches("List"))
			reply = list(doc);

		return reply;
	}

	/**
	 * @param doc
	 * @return Message
	 * 
	 * This function retrives list of all the registered queries
	 */
	private Message list(Document doc) throws CorruptDataException,
			FileNotFoundException, SQLException, InstantiationException,
			IllegalAccessException, ClassNotFoundException, IOException
	{
		String SQLquery = "select * from registeredqueries";
		QueryEngine runQuery = (QueryExecutor) ExtendedActionServlet.cxt
				.getAttribute(information.getMessage("QueryEngine").trim());
		ResultSet rs = runQuery.executeRawSearch(SQLquery);
		ResultSetMetaData meta = rs.getMetaData();
		int numCols = meta.getColumnCount();
		String colNames[] = new String[numCols];
		ListMessage lm = null;
		String c1, c2, c3, c4, c5 = null;

		for (int x = 0; x < numCols; x++)
			colNames[x] = meta.getColumnName(x + 1);

		while (rs.next())
		{
			if (lm == null)
				lm = new ListMessage("Success:Found DL queries");

			c1 = rs.getString("PublishedName");
			c2 = rs.getString("QueryHost");
			c3 = rs.getString("QueryString");
			c4 = rs.getString("Status");
			c5 = rs.getString("ObjectName");

			lm.addPubName(c1 == null ? "" : c1);
			lm.addQueryHost(c2 == null ? "" : c2);
			lm.addQueryString(c3 == null ? "" : c3);
			lm.addStatus(c4 == null ? "" : c4);
			lm.addObjectName(c5 == null ? "" : c5);
		}

		if (lm != null)
			return lm;

		return new RegisterQueryNormalMessage("Failure:No DL queries found");
	}

	/**
	 * @param doc
	 * @return Message
	 * 
	 * This function locates a queries matching term
	 */
	private Message find(Document doc) throws CorruptDataException,
			FileNotFoundException, SQLException, InstantiationException,
			IllegalAccessException, ClassNotFoundException, IOException
	{
		String term = getInner(doc.getElementsByTagName("Term").item(0));
		String SQLquery = "select * from registeredqueries where (PublishedName regexp '"
				+ term
				+ "' or QueryHost regexp '"
				+ term
				+ "' or QueryString regexp '" + term + "')";
		QueryEngine runQuery = (QueryExecutor) ExtendedActionServlet.cxt
				.getAttribute(information.getMessage("QueryEngine").trim());
		ResultSet rs = runQuery.executeRawSearch(SQLquery);
		ResultSetMetaData meta = rs.getMetaData();
		int numCols = meta.getColumnCount();
		String colNames[] = new String[numCols];
		ListMessage lm = null;
		String c1, c2, c3, c4, c5 = null;

		for (int x = 0; x < numCols; x++)
			colNames[x] = meta.getColumnName(x + 1);

		while (rs.next())
		{
			if (lm == null)
				lm = new ListMessage("Success:Found DL queries");

			c1 = rs.getString("PublishedName");
			c2 = rs.getString("QueryHost");
			c3 = rs.getString("QueryString");
			c4 = rs.getString("Status");
			c5 = rs.getString("ObjectName");

			lm.addPubName(c1 == null ? "" : c1);
			lm.addQueryHost(c2 == null ? "" : c2);
			lm.addQueryString(c3 == null ? "" : c3);
			lm.addStatus(c4 == null ? "" : c4);
			lm.addObjectName(c5 == null ? "" : c5);
		}

		if (lm != null)
			return lm;

		return new RegisterQueryNormalMessage(
				"Failure:No matching DL query found");
	}

	private Message changeStatus(Document doc, String string)
			throws SQLException, IOException, CorruptDataException
	{
		String publishedName = getInner(doc.getElementsByTagName("PublishName")
				.item(0));
		String AuthenticationCode = getInner(doc.getElementsByTagName(
				"AuthenticationCode").item(0));
		NodeList ObjectType = doc.getElementsByTagName("ObjectType");
		String ObjectName = null;

		if (ObjectType.getLength() > 0)
			ObjectName = getInner(ObjectType.item(0));

		int changed = 0;
		String SQLquery = "update low_priority registeredqueries set Status='"
				+ string
				+ "' where PublishedName='"
				+ publishedName
				+ "' and AuthenticationCode='"
				+ AuthenticationCode
				+ "'"
				+ (ObjectName == null ? "" : " and ObjectName='" + ObjectName
						+ "'");

		changed = playQuery(SQLquery);

		if (changed == 0)
			return new RegisterQueryNormalMessage(
					"Failure:Unable to change query status, unknown query name or authentication failed");
		else
		{
			return new RegisterQueryNormalMessage("Success:" + publishedName
					+ " Query " + string + "d");
		}
	}

	private Message removeQuery(Document doc) throws SQLException, IOException,
			CorruptDataException
	{
		String publishedName = getInner(doc.getElementsByTagName("PublishName")
				.item(0));
		String AuthenticationCode = getInner(doc.getElementsByTagName(
				"AuthenticationCode").item(0));
		NodeList ObjectType = doc.getElementsByTagName("ObjectType");
		String ObjectName = null;

		if (ObjectType.getLength() > 0)
			ObjectName = getInner(ObjectType.item(0));

		String SQLquery = "delete low_priority from registeredqueries where PublishedName='"
				+ publishedName
				+ "' and AuthenticationCode='"
				+ AuthenticationCode
				+ "'"
				+ (ObjectName == null ? "" : " and ObjectName='" + ObjectName
						+ "'");

		int deleted = 0;

		deleted = playQuery(SQLquery);

		if (deleted == 0)
			return new RegisterQueryNormalMessage(
					"Failure:Can't delete query, unknown published name or authentication failed");
		else
		{
			return new RegisterQueryNormalMessage(
					"Success:Query successfully deleted");
		}
	}

	private Message changeAuthenticationCode(Document doc) throws SQLException,
			IOException, CorruptDataException
	{
		String publishedName = getInner(doc.getElementsByTagName("PublishName")
				.item(0));
		String AuthenticationCode = getInner(doc.getElementsByTagName(
				"AuthenticationCode").item(0));
		String NewAuthenticationCode = getInner(doc.getElementsByTagName(
				"NewAuthenticationCode").item(0));
		int changed = 0;
		String SQLquery = "update low_priority registeredqueries set AuthenticationCode='"
				+ NewAuthenticationCode
				+ "' where PublishedName='"
				+ publishedName
				+ "'and AuthenticationCode='"
				+ AuthenticationCode + "'";

		changed = playQuery(SQLquery);

		return changed == 0 ? new RegisterQueryNormalMessage(
				"Failure:Unknown query published name, authentication code not changed")
				: new RegisterQueryNormalMessage(
						"Success:Authentication code changed successfully");
	}

	private Message updateQuery(Document doc) throws SQLException, IOException,
			CorruptDataException
	{
		Node RQuery = doc.getElementsByTagName("RegisterQuery").item(0);
		String publishedName = getInner(doc.getElementsByTagName("PublishName")
				.item(0));
		String AuthenticationCode = getInner(doc.getElementsByTagName(
				"AuthenticationCode").item(0));
		String QueryHost = getInner(doc.getElementsByTagName("QueryHost").item(
				0));
		String QueryString = getInner(doc.getElementsByTagName("QueryString")
				.item(0));
		String ObjectType = getInner(doc.getElementsByTagName("ObjectType")
				.item(0));
		String encoding = "UTF-8";

		if (RQuery.hasAttributes())
		{
			NamedNodeMap attrs = RQuery.getAttributes();
			Attr tEncoding = (Attr) attrs.getNamedItem("CharacterEncoding");
			encoding = tEncoding.getValue().trim();
			int re = playQuery("update low_priority registeredqueries set Encoding='"
					+ encoding
					+ "' where PublishedName='"
					+ publishedName
					+ "' and AuthenticationCode='"
					+ AuthenticationCode
					+ "' and ObjectName='" + ObjectType + "'");

			if (re == 0)
				return new RegisterQueryNormalMessage(
						"Failure:Encoding not changed, unknown publised query / authentication failed");
		}

		String SQLquery = "update low_priority registeredqueries set QueryHost='"
				+ QueryHost
				+ "',QueryString='"
				+ QueryString
				+ "' where PublishedName='"
				+ publishedName
				+ "' and AuthenticationCode='"
				+ AuthenticationCode
				+ "' and ObjectName='" + ObjectType + "'";
		String SQLqueryNH = "update low_priority registeredqueries set QueryString='"
				+ QueryString
				+ "' where PublishedName='"
				+ publishedName
				+ "' and AuthenticationCode='"
				+ AuthenticationCode
				+ "' and ObjectName='" + ObjectType + "'";

		if (QueryHost == null)
		{
			int ret = playQuery(SQLqueryNH);
			if (ret == 0)
				return new RegisterQueryNormalMessage(
						"Failure:Query String not changed, unknown publised query / authentication failed");
			else
			{
				return new RegisterQueryNormalMessage(
						"Success:Query String updated successfully");
			}

		} else
		{
			int ret = playQuery(SQLquery);

			if (ret == 0)
				return new RegisterQueryNormalMessage(
						"Failure:Query String/Host not changed, unknown publised query / authentication failed");
			else
			{
				return new RegisterQueryNormalMessage(
						"Success:Query String and host updated successfully");
			}
		}
	}

	private Message addQuery(Document doc) throws FileNotFoundException,
			CorruptDataException, SQLException, InstantiationException,
			IllegalAccessException, ClassNotFoundException, IOException
	{
		Node RQuery = doc.getElementsByTagName("RegisterQuery").item(0);
		String publishedName = getInner(doc.getElementsByTagName("PublishName")
				.item(0));
		String AuthenticationCode = getInner(doc.getElementsByTagName(
				"AuthenticationCode").item(0));
		String QueryHost = getInner(doc.getElementsByTagName("QueryHost").item(
				0));
		String QueryString = getInner(doc.getElementsByTagName("QueryString")
				.item(0));
		String ObjectType = getInner(doc.getElementsByTagName("ObjectType")
				.item(0));
		String encoding = "UTF-8";

		if (RQuery.hasAttributes())
		{
			NamedNodeMap attrs = RQuery.getAttributes();
			Attr tEncoding = (Attr) attrs.getNamedItem("CharacterEncoding");
			encoding = tEncoding.getValue().trim();
		}

		checkExist(publishedName, ObjectType);

		String SQLquery = "insert into registeredqueries values ('"
				+ publishedName + "','" + (QueryHost == null ? "" : QueryHost)
				+ "','" + QueryString + "','" + AuthenticationCode + "','"
				+ encoding + "','Enable','" + ObjectType + "')".trim();
		int added = playQuery(SQLquery);

		if (added == 0)
			return new RegisterQueryNormalMessage(
					"Failure:Unable to register query");
		else
		{
			return new RegisterQueryNormalMessage(
					"Success:Query Registered successfully");
		}
	}

	private void checkExist(String publishedName, String objectType)
			throws CorruptDataException, FileNotFoundException, SQLException,
			InstantiationException, IllegalAccessException,
			ClassNotFoundException, IOException
	{
		String tsql = "select * from registeredqueries where PublishedName='"
				+ publishedName + "' and ObjectName='" + objectType + "'";
		QueryEngine runQuery = (QueryExecutor) ExtendedActionServlet.cxt
				.getAttribute(information.getMessage("QueryEngine").trim());

		ResultSet rs = runQuery.executeRawSearch(tsql);

		if (rs.next())
			throw new DuplicateQueryRegisterationException();
	}

	private int playQuery(String SQLquery) throws SQLException, IOException,
			CorruptDataException
	{
		QueryEngine runQuery = (QueryExecutor) ExtendedActionServlet.cxt
				.getAttribute(information.getMessage("QueryEngine").trim());
		return runQuery.executeUpdate(SQLquery);
	}

	/**
	 * @param inNode
	 * @return String
	 * 
	 * This function extracts inner content of any XML Node
	 */
	private String getInner(Node inNode)
	{
		if (inNode == null)
			return null;

		String reply = null;
		WriteXML nodeWriter = new WriteXML();

		reply = nodeWriter.writeXML(inNode);
		reply = reply.substring(getStart(inNode, reply), getEnd(inNode, reply));

		return reply;
	}

	private int getEnd(Node publishedNameNode, String publishedName)
	{
		int end = publishedName.lastIndexOf("</"
				+ publishedNameNode.getLocalName() + ">");
		return end;
	}

	private int getStart(Node publishedNameNode, String publishedName)
	{
		int start = publishedName.indexOf("<"
				+ publishedNameNode.getLocalName() + ">")
				+ ("<" + publishedNameNode.getLocalName() + ">").length();
		return start;
	}

	private String getQuery(HttpServletRequest request) throws IOException,
			UnsupportedEncodingException
	{
		StringBuffer query = new StringBuffer();
		BufferedReader inQuery;
		String xmlLine;
		// Getting input stream for http post request
		Enumeration params = request.getParameterNames();

		if (params.hasMoreElements())
		{
			String pName = request.getParameter("RegisterQuery");

			if (pName != null)
				inQuery = new BufferedReader(new StringReader(pName));
			else
				inQuery = request.getReader();
		} else
			inQuery = request.getReader();

		// Filling query with http post body content that contains XML query
		// request
		while ((xmlLine = inQuery.readLine()) != null)
			query.append(xmlLine.trim().replaceAll("'", "&apos;&apos;"));

		return query.toString();
	}

	private void validateDocument(DOMParser parser, String CSIPSchemaLocation,
			String query) throws SAXException, IOException
	{
		// System.out.println("Schema Location : "+CSIPSchemaLocation);
		// Configuring Xerces validation features for DOM parser
		parser.setFeature("http://xml.org/sax/features/namespaces", true);
		parser.setFeature("http://xml.org/sax/features/validation", true);
		parser.setFeature("http://apache.org/xml/features/validation/schema",
				true);
		parser
				.setProperty(
						"http://apache.org/xml/properties/schema/external-schemaLocation",
						CSIPSchemaLocation);

		// Installing custom error handler for parser
		parser.setErrorHandler(new QueryErrorHandler());
		parser.setEntityResolver(new ER());

		// Parsing the query and validating
		if (parser == null)
			System.err.println("\n\nBig Trouble\n\n");

		parser.parse(new InputSource(
				new BufferedReader(new StringReader(query))));
	}

}
