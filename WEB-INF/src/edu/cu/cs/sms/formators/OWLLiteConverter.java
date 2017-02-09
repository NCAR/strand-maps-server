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

package edu.cu.cs.sms.formators;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.StringReader;
import java.io.StringWriter;
import java.util.List;
import java.util.Properties;
import java.util.Date;

import org.apache.xerces.dom.DocumentImpl;
import org.apache.xerces.parsers.DOMParser;
import org.apache.xml.serialize.OutputFormat;
import org.apache.xml.serialize.XMLSerializer;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.xml.sax.InputSource;

import edu.cu.cs.sms.ExtendedActionServlet;
import edu.cu.cs.sms.DTO.SMSData;
import edu.cu.cs.sms.Database.SMSResultSet;
import edu.cu.cs.sms.xml.GenerateXML;

public class OWLLiteConverter implements GenerateXML {
    private static Properties owlProp = null;

    public OWLLiteConverter() {
        super();
    }

    public String getFormat() {
        return "OWLLite";
    }

    public boolean isBinary() {
        return false;
    }

    public String mimeType() {
        return "text/xml";
    }

    public byte[] populate(SMSResultSet data) throws Exception {
        DOMParser parser = new DOMParser();
        Node root = null;
        Document doc = null;

        if (owlProp == null) {
            owlProp = new Properties();
            owlProp.load(new BufferedInputStream(this.getClass().getClassLoader().getResourceAsStream("edu/cu/cs/sms/formators/OWLLite.properties")));
        }

        parser.setFeature("http://xml.org/sax/features/namespaces", true);
        parser
                .parse(new InputSource(
                        new BufferedReader(
                                new StringReader(
                                        fileContent(new BufferedInputStream(this.getClass().getClassLoader().getResourceAsStream
                                                ("edu/cu/cs/sms/formators/"
                                                        + owlProp
                                                                .getProperty("OWLLiteHeader"))))))));

        doc = parser.getDocument();
        root = doc.getElementsByTagNameNS(
                "http://www.w3.org/1999/02/22-rdf-syntax-ns#", "RDF").item(0);

        if (data.getTotalObjects() > 0)
            for (int counter = 0; counter < data.getTotalObjects(); counter++)
                root.appendChild(commonObjectProperties(doc, data
                        .getObject(counter), data.getObject(counter)
                        .getObject_type().replaceAll(" ", "_")));

		StringWriter  strWriter   	= new StringWriter();
		XMLSerializer returnString 	= new XMLSerializer();
		OutputFormat  outFormat   	= new OutputFormat();
		String result				= null;

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


        return result.getBytes();
    }

    private Element commonObjectProperties(Document doc, SMSData object,
            String eName) {
        Element ele = doc.createElement(eName);
        Element temp;
        // Defining the rdf resource attribute
        ele.setAttribute("rdf:resource", object.getObject_id());
        // Making the Language Node
        temp = doc.createElement("Language");
        temp.setAttribute("rdf:datatype",
                "http://www.w3.org/2001/XMLSchema#string");
        temp.appendChild(doc.createTextNode(object.getLang()));
        ele.appendChild(temp);
        // Making the Name Node
        temp = doc.createElement("Name");
        temp.setAttribute("rdf:datatype",
                "http://www.w3.org/2001/XMLSchema#string");
        temp.appendChild(doc.createTextNode(object.getName()));
        ele.appendChild(temp);
        // Making the Source Node
        temp = doc.createElement("Source");
        temp.setAttribute("rdf:datatype",
                "http://www.w3.org/2001/XMLSchema#string");
        temp.appendChild(doc.createTextNode(object.getSource()));
        ele.appendChild(temp);
        // Making the Description Node
        temp = doc.createElement("Description");
        temp.setAttribute("rdf:datatype",
                "http://www.w3.org/2001/XMLSchema#string");
        temp.appendChild(doc.createTextNode(object.getDescription()));
        ele.appendChild(temp);
        // Making the GradeRange Node
        temp = doc.createElement("GradeRange");
        temp.setAttribute("rdf:datatype",
                "http://www.w3.org/2001/XMLSchema#string");
        temp.appendChild(doc.createTextNode(object.getPrimary_grade()));
        ele.appendChild(temp);
        // Making the NarrativeInstructional Node
        temp = doc.createElement("NarrativeInstructional");
        temp.setAttribute("rdf:datatype",
                "http://www.w3.org/2001/XMLSchema#string");
        temp.appendChild(doc.createTextNode(object.getStudent_conceptions()));
        ele.appendChild(temp);
        // Making the FullText Node
        temp = doc.createElement("FullText");
        temp.setAttribute("rdf:datatype",
                "http://www.w3.org/2001/XMLSchema#string");
        temp.appendChild(doc.createTextNode(object.getFull_text()));
        ele.appendChild(temp);
        // Making the ExternalStandardRelationship Node
        temp = doc.createElement("ExternalStandardRelationship");
        temp.setAttribute("rdf:datatype",
                "http://www.w3.org/2001/XMLSchema#string");
        temp.appendChild(doc.createTextNode(object.getStandards().replaceAll(
                "###start###", "").replaceAll("\\?\\?\\?sep\\?\\?\\?", " ")
                .replaceAll("###end###", "\n").replaceAll(
                        "\\^\\^\\^l-next\\^\\^\\^", " ")));
        ele.appendChild(temp);
        // Making the ExternalResourceRelationship Node
        temp = doc.createElement("ExternalResourceRelationship");
        temp.setAttribute("rdf:datatype",
                "http://www.w3.org/2001/XMLSchema#string");
        temp.appendChild(doc.createTextNode(object.getResources()));
        ele.appendChild(temp);
        // Making the Keywords Node
        temp = doc.createElement("Keywords");
        temp.setAttribute("rdf:datatype",
                "http://www.w3.org/2001/XMLSchema#string");
        temp.appendChild(doc.createTextNode(object.getKeywords()));
        ele.appendChild(temp);
        // Making the NarrativeStudentIdeas Node
        temp = doc.createElement("NarrativeStudentIdeas");
        temp.setAttribute("rdf:datatype",
                "http://www.w3.org/2001/XMLSchema#string");
        temp.appendChild(doc.createTextNode(object.getExamples()));
        ele.appendChild(temp);
        // Making the NarrativeAssessment Node
        temp = doc.createElement("NarrativeAssessment");
        temp.setAttribute("rdf:datatype",
                "http://www.w3.org/2001/XMLSchema#string");
        temp.appendChild(doc.createTextNode(object.getAssessments()));
        ele.appendChild(temp);
        // Making the Subjects Node
        temp = doc.createElement("Subjects");
        temp.setAttribute("rdf:datatype",
                "http://www.w3.org/2001/XMLSchema#string");
        temp.appendChild(doc.createTextNode(object.getSubjects()));
        ele.appendChild(temp);
        // Making the AAASCode Node
        temp = doc.createElement("AAASCode");
        temp.setAttribute("rdf:datatype",
                "http://www.w3.org/2001/XMLSchema#string");
        temp.appendChild(doc.createTextNode(object.getAaas_code()));
        ele.appendChild(temp);
        // Making the ObjectType Node
        temp = doc.createElement("ObjectType");
        temp.setAttribute("rdf:datatype",
                "http://www.w3.org/2001/XMLSchema#string");
        temp.appendChild(doc.createTextNode(object.getObject_type()));
        ele.appendChild(temp);
        // Making the NarrativeClarification Node
        temp = doc.createElement("NarrativeClarification");
        temp.setAttribute("rdf:datatype",
                "http://www.w3.org/2001/XMLSchema#string");
        temp.appendChild(doc.createTextNode(object.getInstructional_information()));
        ele.appendChild(temp);
        // Making the NarrativeExamples Node
        temp = doc.createElement("NarrativeExamples");
        temp.setAttribute("rdf:datatype",
                "http://www.w3.org/2001/XMLSchema#string");
        temp.appendChild(doc.createTextNode(object.getClarification()));
        ele.appendChild(temp);
        // Making the Relation Nodes
        List as = object.getRelationType();
        List objs = object.getItemID2();
        for (int c = 0; c < as.size(); c++) {
            String relation = as.get(c).toString().replaceAll(" ", "")
                    .toLowerCase();
            temp = doc.createElement(relation);
            temp.setAttribute("rdf:resource", "#"
                    + objs.get(c).toString().replaceAll(" ", "_"));
            temp.appendChild(doc.createTextNode(object.getClarification()));
            ele.appendChild(temp);
        }
        return ele;
    }

    private String fileContent(BufferedInputStream fileStream) throws IOException 
    {
        byte[] b = new byte[fileStream.available()];

        fileStream.read(b);

        return new String(b);
    }
	
	public Date getLastModifiedDate() {
		return new Date(); 
	}	
}
