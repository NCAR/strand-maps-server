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

package edu.cu.cs.sms;

import java.io.OutputStream;
import java.util.logging.Logger;
import java.util.Date;
import java.text.SimpleDateFormat;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

public class BinaryResponseAction extends SMSAction {
    public ActionForward execute(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        Date lastModified = (Date) request.getAttribute("lastModified");
		if(lastModified != null){
			SimpleDateFormat df = new SimpleDateFormat("EEE, d MMM yyyy HH:mm:ss 'GMT'");			
			response.setHeader("Last-Modified", df.format(lastModified));	
		}				
				
        Logger log = (Logger) ExtendedActionServlet.cxt.getAttribute("logger");
        MessageResources transfer = getResources(request, "Transfer");
        OutputStream os = response.getOutputStream();
        byte[] responseDoc = (byte[]) request.getAttribute(transfer
                .getMessage("OKResponse"));
        String mimeType = (String) request.getAttribute(transfer
                .getMessage("mimeType"));

		if(mimeType != null)
		{
			response.setContentType(mimeType);
			response.setHeader("Content-Disposition","filename=map."+mimeType.split("/")[1]);
		}
		else
			response.setContentType("application/octet-stream");
		
		log.info(response.getContentType());

		os.write(responseDoc);
		os.flush();
		os.close();
				
        return null;
    }

}
