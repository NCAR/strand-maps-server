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

import java.io.PrintWriter;
//import java.util.logging.Logger;
import java.util.Date;
import java.text.SimpleDateFormat;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;


// this servlet is used to respond to every kind of query
// a final XML (SVG,XTM,SMS) will be passed to this servlet and it will send it
// to client
public class ResponseAction extends SMSAction {

    // --------------------------------------------------------- Instance
    // Variables

    // --------------------------------------------------------- Methods

    public ActionForward execute(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        Date lastModified = (Date) request.getAttribute("lastModified");
		if(lastModified != null){
			SimpleDateFormat df = new SimpleDateFormat("EEE, d MMM yyyy HH:mm:ss 'GMT'");			
			response.setHeader("Last-Modified", df.format(lastModified));	
		}					
				
        //Logger log = (Logger) ExtendedActionServlet.cxt.getAttribute("logger");
        MessageResources transfer = getResources(request, "Transfer");
        
        PrintWriter pw = response.getWriter();
        byte[] responseDoc = (byte[]) request.getAttribute(transfer
                .getMessage("OKResponse"));
        String mimeType = (String) request.getAttribute(transfer
                .getMessage("mimeType"));

        response.setContentType(mimeType != null ? mimeType : "text/xml");	
		
        // System.out.println(new String(responseDoc));
		
		String output;
		
        // Add a call back function for JSON responses, if requested:
		String callBackFunction = (String) request.getAttribute("callBackFunction");
		if(callBackFunction == null){
			output = new String(responseDoc);
		} else {
			output = callBackFunction + "(" + new String(responseDoc) + ");";
		}
        
        pw.print(output);
        pw.close();

        return null;
    }

}
