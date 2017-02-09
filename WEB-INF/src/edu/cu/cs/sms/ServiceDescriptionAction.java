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

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.PrintWriter;
import java.io.StringReader;
import java.sql.ResultSet;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;
import java.util.logging.Logger;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;
import org.apache.xerces.parsers.DOMParser;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.w3c.dom.Text;
import org.xml.sax.InputSource;

import edu.cu.cs.sms.Database.QueryEngine;
import edu.cu.cs.sms.Database.QueryExecutor;
import edu.cu.cs.sms.Exceptions.EmptyServiceDescriptionFile;
import edu.cu.cs.sms.util.WriteXML;
import edu.cu.cs.sms.xml.QueryErrorHandler;

// This servlet serves the ServiceDescriptionrequest
public class ServiceDescriptionAction extends SMSAction {
    // The schema location for varification
    static private String CSIPSchemaLocation = null;

    // --------------------------------------------------------- Instance
    // Variables

    // --------------------------------------------------------- Methods

    public ActionForward execute(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        byte[] inFile = null;
        String[] allFormats = (String[]) ExtendedActionServlet.cxt
                .getAttribute("supportedFormats");

        MessageResources information = getResources(request, "Info");
        String FileNamePath = ExtendedActionServlet.cxt.getRealPath(information
                .getMessage("ServiceDescription.Location")
                + information.getMessage("ServiceDescription.FileName"));
        Set uniqueLibraries = new HashSet();
        Iterator it = null;
        BufferedInputStream SDFile1 = new BufferedInputStream(
                new FileInputStream(new File(FileNamePath)));

        inFile = new byte[SDFile1.available()];

        if (inFile.length == 0)
            throw new EmptyServiceDescriptionFile(new Exception(
                    "No content in ServiceDescription.xml"));

        SDFile1.read(inFile);

        DOMParser parser = new DOMParser();

        // Location of CSIP schema
        if (CSIPSchemaLocation == null)
            CSIPSchemaLocation = "http://sms.dlese.org "
                    + (ExtendedActionServlet.cxt.getRealPath(getResources(
                            request, "Info").getMessage("Schema.Location")))
                            .replaceAll(" ", "%20");

        parser.setFeature("http://xml.org/sax/features/namespaces", true);
        parser.setFeature("http://xml.org/sax/features/validation", true);
        parser.setFeature("http://apache.org/xml/features/validation/schema",
                true);
        parser
                .setProperty(
                        "http://apache.org/xml/properties/schema/external-schemaLocation",
                        CSIPSchemaLocation);
        parser.setErrorHandler(new QueryErrorHandler());

        parser.parse(new InputSource(new BufferedReader(new StringReader(
                new String(inFile)))));

        Document doc = parser.getDocument();

        NodeList nList = doc.getElementsByTagName("SupportedLibrarySearch");

        Node sls = nList.item(0);

        String SQLquery = "select PublishedName from registeredqueries where Status <> 'Disable'";
        QueryEngine runQuery = (QueryExecutor) ExtendedActionServlet.cxt
                .getAttribute(information.getMessage("QueryEngine").trim());
        ResultSet rs = runQuery.executeRawSearch(SQLquery);

        while (rs.next())
            uniqueLibraries.add(rs.getString(1));

        it = uniqueLibraries.iterator();

        while (it.hasNext()) {
            Element tEle = doc.createElement("Library");
            Text tNode = doc.createTextNode((String) it.next());
            tEle.appendChild(tNode);

            sls.appendChild(tEle);
        }

        nList = doc.getElementsByTagName("SupportedReplyFormats");
        sls = nList.item(0);

        for (int counter = 0; counter < allFormats.length; counter++) {
            Element ele = doc.createElement("Format");
            Text tNode = doc.createTextNode(allFormats[counter]);
            ele.appendChild(tNode);
            sls.appendChild(ele);
        }

        PrintWriter reply = response.getWriter();
        response.setContentType("text/xml");

        reply.print(new WriteXML().writeXML(doc));

        SDFile1.close();
        reply.close();

        String logString = request.getRequestURL() + " IP Address:"
                + request.getRemoteAddr();

        ((Logger) ExtendedActionServlet.cxt.getAttribute("logger"))
                .info(logString);

        return null;
    }

}
