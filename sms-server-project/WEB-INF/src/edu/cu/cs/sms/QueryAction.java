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

import edu.cu.cs.sms.Exceptions.DissiminatorInstantiationException;
import edu.cu.cs.sms.Exceptions.DissiminatorClassNotFoundException;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.StringReader;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;
import java.util.logging.Logger;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.apache.commons.pool.KeyedObjectPool;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;
import org.apache.xerces.parsers.DOMParser;
import org.w3c.dom.DOMException;
import org.w3c.dom.Document;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;

import edu.cu.cs.sms.DTO.ConCache;
import edu.cu.cs.sms.DTO.ErrorBean;
import edu.cu.cs.sms.Database.QueryEngine;
import edu.cu.cs.sms.Database.QueryExecutor;
import edu.cu.cs.sms.Database.SMSResultSet;
import edu.cu.cs.sms.Exceptions.CorruptDataException;
import edu.cu.cs.sms.Exceptions.IllegalServiceRequestCombinaition;
import edu.cu.cs.sms.Exceptions.UnsupportedFormatException;
import edu.cu.cs.sms.formators.JPEGConverter;
import edu.cu.cs.sms.util.QueryExpander;
import edu.cu.cs.sms.xml.GenerateXML;
import edu.cu.cs.sms.xml.QueryErrorHandler;


// this servlet recives all queries
public class QueryAction extends SMSAction
{

	
    // --------------------------------------------------------- Instance
    // Variables

    // --------------------------------------------------------- Static
    // Variables

    // static public int flagID = 0;
    // static public MessageResources BMKtoNSES = null;
	static private String			CSIPSchemaLocation	= null;

    static private MessageResources information = null;

    // --------------------------------------------------------- Methods

    public ActionForward execute(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
				
        MessageResources code = getResources(request, "ErrorCodes");
        MessageResources description = getResources(request,
                "ErrorDescriptions");
        MessageResources transfer = getResources(request, "Transfer");
        // BMKtoNSES = getResources(request, "DLESEQuery");
				
        DOMParser parser = new DOMParser();
        String xmlLine = null;
        String query = null;
        ErrorBean error = null;
        UnsupportedFormatException expG = null;
        String[] returnFormats = null;
        String[] DLQueries = null;
        String graphType = null;
        String color = null;
        float imageScale;
        int conceptSize;

        boolean flag = true;
        byte[] resp = null;
        KeyedObjectPool pTemp = (KeyedObjectPool) ExtendedActionServlet.cxt
                .getAttribute("dissPool");
        String cacheKey = null;
        ConCache lookupResult = null;
        String mimeType = null;
		Date lastModified = null;
        SMSResultSet smsRS = null;
        boolean binary = false;
				
        Logger log = (Logger) ExtendedActionServlet.cxt.getAttribute("logger");
        information = getResources(request, "Info");

    	// Check if query is provided by js api action handler:
        query = (String)request.getAttribute("js-query");
    	if(query == null) {	
	        // extracts the CSIP query from Get or Post request
	        query = getQuery(request);
	        
    	}
		//System.out.println("Query requested: " + query);
        
        cacheKey = query.replaceAll(" |\n|\r", "");

        // Cache intrevention
        lookupResult = ExtendedActionServlet.iStore.lookup(cacheKey);
        // Location of CSIP schema
        if (CSIPSchemaLocation == null)
            CSIPSchemaLocation = getResources(request, "Info").getMessage(
                    "Schema.NameSpace")
                    + " "
                    + (ExtendedActionServlet.cxt.getRealPath(getResources(
                            request, "Info").getMessage("Schema.Location")))
                            .replaceAll(" ", "%20");
                            
                            

        if (lookupResult == null) {
			
				
            // Validates the incoming query against schema
    	    try{
				//System.out.println(new Date() + " Validating query: '" + query + "' CSIPSchemaLocation:'" + CSIPSchemaLocation + "'");
				validateDocument(parser, CSIPSchemaLocation, query);

			} catch (SAXParseException e) {
				//System.out.println("Error: Invalid query: " + query + " " + e);
				throw new SAXParseException("Query not valid: " + e.getMessage() + ". Query provided was: " + query,e.getPublicId(),e.getSystemId(),e.getLineNumber(),e.getColumnNumber());
			} catch (SAXException e2) {
				//System.out.println("Error: Invalid query: " + query + " " + e2);
				throw new SAXException("Query not valid: " + e2.getMessage() + ". Query provided was: " + query);
			}

            // extracts the return format types for the response
            returnFormats = extractAttributeList(parser, "Format");
            DLQueries = extractAttributeList(parser, "ThirdPartyQuery");
            color = extractAttribute(parser, "Query", "Color");
            graphType = extractNodeValue(parser, "Navigational-Query");
            imageScale		= Float.parseFloat(extractAttribute(parser, "Query", "ImageScale"))/new Float(100.00);
            conceptSize		= Integer.parseInt(extractAttribute(parser, "Query", "ConceptSize"));

            if (extractNodeValue(parser, "ObjectID") == null
                    || isNavigational(parser)) {
                // executing query
                QueryEngine runQuery = (QueryEngine) ExtendedActionServlet.cxt
                        .getAttribute(information.getMessage("QueryEngine")
                                .trim());

                smsRS = runQuery.executeSearch(translateQuery(parser.getDocument(),runQuery.getKey()));

            } else
                smsRS = getwithdepth(parser);

            smsRS.setDetail(extractAttribute(parser, "Query", "DetailLevel"));

            setObjectID(parser, smsRS);
            smsRS.setGraphType((graphType == null) ? 0 : 1);
            smsRS.setColor(color);
            smsRS.setImageScale(imageScale);
            smsRS.setConceptSize(conceptSize);
            setResultSetDLQueries(smsRS, DLQueries == null ? new String[0] : DLQueries);
            // fitforSVG(smsRS,parser);	
            for (int counter = 0; counter < returnFormats.length && flag; counter++) {
				
                Class dClass = (Class)ExtendedActionServlet.cxt
                        .getAttribute(returnFormats[counter]);

				GenerateXML gTemp = null;
				try {
					gTemp = (GenerateXML) dClass.newInstance();
				} catch (InstantiationException exp) {
					throw new DissiminatorInstantiationException(
							"Server internal error, unable to create dissiminator classes, please check JVM/TOMCAT configurattion: " + exp.getMessage());
				}

                if (gTemp != null) {
                    try {
                        resp = gTemp.populate(smsRS);
                        binary = gTemp.isBinary();
                        flag = false;
                        mimeType = gTemp.mimeType();
						lastModified = gTemp.getLastModifiedDate();
                        request.setAttribute("lastModified", lastModified);
                        request.setAttribute(transfer.getMessage("mimeType"),
                        		mimeType);	
                    } catch (UnsupportedFormatException exp) {
                        flag = true;
                        if (counter == returnFormats.length - 1)
                            throw exp;
                    } finally {
                        pTemp.returnObject(dClass, gTemp);
                    }
                }
            }	
            // Resetting the Xerces parser
            parser.reset();

            if (flag)
                throw new UnsupportedFormatException(
                        "Requested return format not supported : Reply format handler not registered");
						
            // Saving the result for use in successeding queries
            ExtendedActionServlet.iStore.save(cacheKey, resp, binary, mimeType, lastModified);
        } else {
			
			// If we have a cached version, use it:			
            resp = lookupResult.getResponse();
            binary = lookupResult.isBinary();
            
            request.setAttribute(transfer.getMessage("mimeType"),
            		lookupResult.getMimeType());
					
			request.setAttribute("lastModified", lookupResult.getLastModifiedDate());
        }
		
		// Debugging output:
		if(false) {
			if(resp == null)
				System.out.println("Generated response is null");
			else
				System.out.println("Generated response size is:" + resp.length);
		}
		
        request.setAttribute(transfer.getMessage("OKResponse"), resp);

        String logString = query + " IP Address:" + request.getRemoteAddr();
       ((Logger) ExtendedActionServlet.cxt.getAttribute("logger"))
                .info(logString);
		
        if (binary)
            return mapping.findForward(information
                    .getMessage("Binary.ResponseServlet"));
        else
            return mapping.findForward(information
                    .getMessage("Normal.ResponseServlet"));
    }

    private void setObjectID(DOMParser parser, SMSResultSet smsRS) {
        smsRS.setObjectID(extractNodeValue(parser, "ObjectID"));
        if (smsRS.getObjectID() == null)
            smsRS.setObjectID(getRelationID(parser));
    }

    /**
     * @param parser
     * @return
     */
    private String getRelationID(DOMParser parser) {
        Document doc = parser.getDocument();
        NodeList nIRList = doc.getElementsByTagName("InternalRelationship");
        int index = 0;
        Node temp = null;
        StringBuffer sb = new StringBuffer();

        if (doc.getElementsByTagName("AND").getLength() != 0
                || doc.getElementsByTagName("OR").getLength() != 0
                || doc.getElementsByTagName("NOT-AND").getLength() != 0
                || doc.getElementsByTagName("OR-AND").getLength() != 0)
            return null;

        if (nIRList.getLength() == 2)
            for (; index < nIRList.getLength(); index++) {
                temp = nIRList.item(index).getAttributes().getNamedItem(
                        "Object");
                sb.append(temp.getNodeValue());

                if (index < nIRList.getLength() - 1)
                    sb.append(":");
            }

        if (sb.toString().length() > 0)
            return sb.toString();
        else
            return null;
    }

    private boolean isNavigational(DOMParser parser) {
        Document doc = parser.getDocument();
        NodeList nList = doc.getElementsByTagName("Navigational-Query");

        if (nList.getLength() > 0)
            return true;

        return false;
    }

    private void fitforSVG(SMSResultSet smsRS, DOMParser parser) {
        Document doc = parser.getDocument();

        NodeList cqnList = doc.getElementsByTagName("Content-Query");
        NodeList nqnList = doc.getElementsByTagName("Navigational-Query");
        NodeList aqnList = doc.getElementsByTagName("ASNLookup-Query");

        if (smsRS.getObjectID() != null)
            if (cqnList.getLength() > 0) {
                NodeList tl = doc.getElementsByTagName("ObjectID");

                if (tl.getLength() > 0) {
                    Node ii = tl.item(0);
                    Node text = ii.getFirstChild();
                    String nv = text.getNodeValue();

                    if (nv.matches("SMS-MAP-[0-9]{4}")
                            || nv.matches("SMS-STD-[0-9]{4}")
                            || nv.matches("SMS-GRD-[0-9]{4}"))
                        smsRS.setSuitableforSVG(true);
                    else
                        smsRS.setSuitableforSVG(false);
                } else
                    smsRS.setSuitableforSVG(false);
            } else if (nqnList.getLength() > 0) {
                NodeList acList = doc.getElementsByTagName("AND");
                NodeList ocList = doc.getElementsByTagName("OR");
                NodeList nocList = doc.getElementsByTagName("NOT-OR");
                NodeList nacList = doc.getElementsByTagName("NOT-AND");
                NodeList nabcList = doc.getElementsByTagName("Neighbor");

                if (acList.getLength() > 0 || ocList.getLength() > 0
                        || nocList.getLength() > 0 || nacList.getLength() > 0)
                    smsRS.setSuitableforSVG(false);
                else if (nabcList.getLength() > 0) {
                    NodeList tl = doc.getElementsByTagName("ObjectID");

                    if (tl.getLength() > 0) {
                        Node ii = tl.item(0);
                        Node text = ii.getFirstChild();
                        String nv = text.getNodeValue();

                        if (nv.matches("SMS-BMK-[0-9]{4}"))
                            smsRS.setSuitableforSVG(true);
                        else
                            smsRS.setSuitableforSVG(false);
                    } else
                        smsRS.setSuitableforSVG(false);
                } else
                    smsRS.setSuitableforSVG(false);

            }
    }

    private SMSResultSet getwithdepth(DOMParser parser)
            throws NumberFormatException, IllegalServiceRequestCombinaition,
            DOMException, TransformerException, FileNotFoundException,
            CorruptDataException, SQLException, InstantiationException,
            IllegalAccessException, ClassNotFoundException, IOException {
        String dp = extractAttribute(parser, "ObjectID", "Depth");
        int depth = Integer.parseInt(dp == null ? "0" : dp);

        if (depth > 50)
            throw new NumberFormatException();

        String objectID = extractNodeValue(parser, "ObjectID");

        if (depth == 0)
            return DepthZeroRetrival(objectID);
        else
            return VariableDepthRetrival(depth, objectID);
    }

    private SMSResultSet VariableDepthRetrival(int depth, String objectID)
            throws CorruptDataException, FileNotFoundException, SQLException,
            InstantiationException, IllegalAccessException,
            ClassNotFoundException, IOException {
        SMSResultSet smsRS;
        String SQLQuery;
        ResultSet rs;
        String dir1;
        String dir2;
        Set[] ids = new HashSet[Math.abs(depth) + 1];
        final String con = " R.ItemID";
        final String fcon = " O.object_ID='";
        StringBuffer subQuery = new StringBuffer();
        StringBuffer fSubQuery = new StringBuffer();
        QueryEngine runQuery = (QueryExecutor) ExtendedActionServlet.cxt
                .getAttribute(information.getMessage("QueryEngine").trim());

        if (depth > 0) {
            dir1 = "2";
            dir2 = "1";
        } else {
            dir1 = "1";
            dir2 = "2";
        }

        depth = Math.abs(depth);

        for (int index = 0; index < depth + 1; index++)
            ids[index] = new HashSet();

        ids[0].add(objectID);

        for (int index = 0; index < depth; index++)
            if (ids[index].size() != 0) {
                subQuery.delete(0, subQuery.length());

                Iterator it = ids[index].iterator();

                while (it.hasNext()) {
                    subQuery.append(con + dir1 + "='" + it.next() + "'");
                    if (it.hasNext())
                        subQuery.append(" or ");
                }

                SQLQuery = "select O.object_ID from objects O, relation R where ("
                        + subQuery.toString()
                        + ") and R.relationtype='Is part of' and R.ItemID"
                        + dir2 + "=O.object_ID";
                        
                        
                rs = runQuery.executeRawSearch(SQLQuery);

                if (index < depth)
                    while (rs.next())
                        ids[index + 1].add(rs.getString(1));
            }

        for (int index = 0; index < depth + 1; index++) {
            Iterator it = ids[index].iterator();

            if (index > 0 && it.hasNext())
                fSubQuery.append(" or ");

            while (it.hasNext()) {
                fSubQuery.append(fcon + it.next() + "'");
                if (it.hasNext())
                    fSubQuery.append(" or ");
            }
        }
 		/* Sharon modified on 2013-03-19 to extra asn ids */
 		/*
        SQLQuery = "select * from objects O, relation R where ("
                + fSubQuery.toString() + ") and O.object_ID=R.ItemID1";
        */
        SQLQuery = "select * from objects O INNER JOIN relation RO ON RO.ItemID1 = O.object_ID LEFT OUTER JOIN smstoasn SA ON SA.SMS_ID=O.object_ID LEFT OUTER JOIN smstongss NGSS ON NGSS.SMS_ID = O.object_ID  where ("
                + fSubQuery.toString() + ")";
               
        smsRS = runQuery.executeSearch(SQLQuery);
        return smsRS;
    }

    private SMSResultSet DepthZeroRetrival(String objectID)
            throws SQLException, IOException, CorruptDataException {
        SMSResultSet smsRS;
        String SQLQuery;
        
        /* Sharon modified on 2013-03-19 to extra asn ids */
        /*
        SQLQuery = "select * from objects O, relation R0 where O.object_ID='"
                + objectID + "' and ( R0.ItemID1 = O.object_ID )";
        */
        SQLQuery = "SELECT * FROM objects O INNER JOIN relation RO ON RO.ItemID1 = O.object_ID LEFT OUTER JOIN smstoasn SA ON SA.SMS_ID=O.object_ID LEFT OUTER JOIN smstongss NGSS ON NGSS.SMS_ID = O.object_ID WHERE O.object_ID='"
                + objectID + "'";  

       /*SQLQuery = "select * from objects O, relation R0 where O.object_ID='"
                + objectID + "' and ( R0.ItemID1 = O.object_ID )";
        */
        QueryEngine runQuery = (QueryExecutor) ExtendedActionServlet.cxt
                .getAttribute(information.getMessage("QueryEngine").trim());
        smsRS = runQuery.executeSearch(SQLQuery);
        return smsRS;
    }

    private void setResultSetDLQueries(SMSResultSet smsRS, String[] queries)
            throws CorruptDataException, FileNotFoundException, SQLException,
            InstantiationException, IllegalAccessException,
            ClassNotFoundException, IOException {
        QueryEngine runQuery = (QueryExecutor) ExtendedActionServlet.cxt
                .getAttribute(information.getMessage("QueryEngine").trim());
        String SQLquery = null;
        ResultSet rs = null;
        QueryExpander qe = null;

        for (int index = 0; index < queries.length; index++) {
            if (queries[0].equalsIgnoreCase("all"))
                SQLquery = "select QueryHost,QueryString,Encoding,ObjectName from registeredqueries where Status='Enable'";
            else
                SQLquery = "select QueryHost,QueryString,Encoding,ObjectName from registeredqueries where PublishedName='"
                        + queries[index] + "' and Status='Enable'";


            rs = runQuery.executeRawSearch(SQLquery);

            while (rs.next()) {
                String qh = rs.getString("QueryHost");
                String qs = rs.getString("QueryString");
                String en = rs.getString("Encoding");
                String on = rs.getString("ObjectName");
                qe = new QueryExpander(queries[index], (qh == null ? "" : qh)
                        + (qs == null ? "" : qs), (en == null ? "UTF-8" : en));

                if (on.equalsIgnoreCase("Benchmark"))
                    smsRS.addBMKDLQuery(qe);
                else if (on.equalsIgnoreCase("Grade group"))
                    smsRS.addGRDDLQuery(qe);
                else if (on.equalsIgnoreCase("Strand"))
                    smsRS.addSTDDLQuery(qe);
                else if (on.equalsIgnoreCase("Map"))
                    smsRS.addMAPDLQuery(qe);
                else if (on.equalsIgnoreCase("Cluster"))
                    smsRS.addCLSDLQuery(qe);
                else if (on.equalsIgnoreCase("Chapter"))
                    smsRS.addCHPDLQuery(qe);
                else if (on.equalsIgnoreCase("Atlas"))
                    smsRS.addATLDLQuery(qe);
                else if (on.equalsIgnoreCase("Section"))
                    smsRS.addSECDLQuery(qe);
                else if (on
                        .equalsIgnoreCase("Science for all americans paragraph"))
                    smsRS.addSFAADLQuery(qe);
                else if (on.equalsIgnoreCase("ALL"))
                    smsRS.addALLDLQuery(qe);

            }
        }

    }

    private String extractNodeValue(DOMParser parser, String nodeName) {
        Document qDoc = parser.getDocument();
        NodeList nList = qDoc.getElementsByTagName(nodeName);

        if (nList == null || nList.getLength() == 0)
            return null;

        if (nList.item(0).getFirstChild() == null)
            return null;

        if (nList.item(0).getFirstChild().getNodeValue() == null)
            return null;

        return nList.item(0).getFirstChild().getNodeValue().trim();
    }

    private String[] extractAttributeList(DOMParser parser, String attrName)
            throws IllegalServiceRequestCombinaition {
        // Getting list of requested formats in prefernce
        String value = extractAttribute(parser, "Query", attrName);

        if (value == null)
            return null;

        String[] format = value.split("[+]");

        for (int t = 0; t < format.length; t++)
            format[t] = format[t].trim();

        return format;
    }

    private String extractAttribute(DOMParser parser, String nodeName,
            String attrName) throws IllegalServiceRequestCombinaition {
        Document qDoc = parser.getDocument();
        NodeList qDetail = qDoc.getElementsByTagName(nodeName);

        if (qDetail == null || qDetail.getLength() == 0)
            throw new IllegalServiceRequestCombinaition();

        Node gAtts = qDetail.item(0);
        NamedNodeMap attrs = gAtts.getAttributes();
        Node detail = attrs.getNamedItem(attrName);

        return detail == null ? null : detail.getNodeValue().trim();
    }

	private String translateQuery(Document doc, String key)	throws TransformerException
	{
		StringWriter SQLWriter = new StringWriter();
		DOMSource xmlDomSource = new DOMSource(doc);
		
		Transformer transformer = (Transformer) ExtendedActionServlet.cxt
				.getAttribute("XSLT:" + key.trim());
		
		// using transformer for query translation
		transformer.transform(xmlDomSource, new StreamResult(SQLWriter));
		
		return SQLWriter.toString();
	}

    private String getQuery(HttpServletRequest request) throws IOException,
            UnsupportedEncodingException {
    	
        StringBuffer query = new StringBuffer();
        BufferedReader inQuery;
        String xmlLine;
        // Getting input stream for http post request
        Enumeration params = request.getParameterNames();

        if (params.hasMoreElements()) {
            String pName = request.getParameter("Query");

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
            String query) throws SAXException, IOException {
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
        // parser.setEntityResolver(new ER());

        // Parsing the query and validating
        if (parser == null)
            System.err.println("\n\nBig Trouble\n\n");

        parser.parse(new InputSource(
                new BufferedReader(new StringReader(query))));
    }

}

