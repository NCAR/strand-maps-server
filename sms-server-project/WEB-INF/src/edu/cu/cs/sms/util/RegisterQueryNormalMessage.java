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

package edu.cu.cs.sms.util;

import java.io.IOException;
import java.io.StringWriter;

import org.apache.xerces.dom.DocumentImpl;
import org.apache.xml.serialize.OutputFormat;
import org.apache.xml.serialize.XMLSerializer;
import org.w3c.dom.Attr;
import org.w3c.dom.Element;
import org.w3c.dom.Text;

public class RegisterQueryNormalMessage extends Message {
    public RegisterQueryNormalMessage(String text) {
        this.text = text;
    }

    public String createResponse() {
        DocumentImpl response = new DocumentImpl();
        Element root = response.createElement("SMS-CSIP");
        Element registrationResponse = response
                .createElement("QueryRegistrationResponse");
        Element result = response.createElement("Result");
        Element message = response.createElement("Messege");
        Attr nameSpace = response.createAttribute("xmlns");
        Text resultText = response.createTextNode(text.split(":")[0]);
        Text messegeText = response.createTextNode(text.split(":")[1]);
        String sb = null;

        nameSpace.setValue("http://sms.dlese.org");
        result.appendChild(resultText);
        message.appendChild(messegeText);
        root.setAttributeNode(nameSpace);
        root.appendChild(registrationResponse);
        registrationResponse.appendChild(result);
        registrationResponse.appendChild(message);
        response.appendChild(root);

		StringWriter  strWriter   	= new StringWriter();
		XMLSerializer returnString 	= new XMLSerializer();
		OutputFormat  outFormat   	= new OutputFormat();
		String tResult				= null;

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
	    try
		{
			returnString.serialize(response);
		    tResult = strWriter.toString();
		    strWriter.close();
		} 
	    catch (IOException e){e.printStackTrace();}

	    return tResult;
    }
}
