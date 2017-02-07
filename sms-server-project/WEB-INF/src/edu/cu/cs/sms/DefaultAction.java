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

import java.util.logging.Logger;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import edu.cu.cs.sms.DTO.ErrorBean;

// this servlet deals with all the requests that are not part of CSIP services
// it returns an appropriate error
public class DefaultAction extends SMSAction {

    public ActionForward execute(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        MessageResources information = getResources(request, "Info");
        MessageResources code = getResources(request, "ErrorCodes");
        MessageResources description = getResources(request,
                "ErrorDescriptions");
        MessageResources transfer = getResources(request, "Transfer");

        ErrorBean error = new ErrorBean(Integer.parseInt(code.getMessage(
                "InvalidServiceRequest").trim()), description.getMessage(
                "InvalidServiceRequest", request.getContextPath()
                        + (request.getPathInfo() == null ? "" : request
                                .getPathInfo())), null, 0, null, null, null);

        request.setAttribute(transfer.getMessage("ErrorBean"), error);

        ((Logger) ExtendedActionServlet.cxt.getAttribute("logger")).info(error
                .toString()
                + " IP Address:" + request.getRemoteAddr());

        return mapping.findForward(information
                .getMessage("Error.ResponseServlet"));
    }

}
