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

package edu.cu.cs.sms.Exceptions.Handlers;

import java.util.MissingResourceException;
import java.util.logging.Logger;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.config.ExceptionConfig;

import edu.cu.cs.sms.ExtendedActionServlet;
import edu.cu.cs.sms.DTO.ErrorBean;
import java.util.Arrays;

public class GeneralExceptionHandler extends SMSBaseExceptionHandler {

    public ActionForward execute(Exception ex, ExceptionConfig ae,
            ActionMapping mapping, ActionForm formInstance,
            HttpServletRequest request, HttpServletResponse response)
            throws javax.servlet.ServletException {
        Exception test = initResourceBundles();
        ErrorBean error = null;
        String reply = "errorResponse";
        String save = "Error";

        System.err.println("Entering Generic Exception handler : " + ex);
		//ex.printStackTrace();

        if (test != null) {
            error = new ErrorBean(302,
                    "Strand Map Service Configuration Error", null, 0,
                    test.getMessage(),ex.getStackTrace(),request);
            ((Logger) ExtendedActionServlet.cxt.getAttribute("logger"))
            .severe(error.toString());
        } else {
            String errorClass = ex.getClass().getName();
            String possibleProblems = null;

            if (ex.getMessage() != null)
                possibleProblems = ex.getMessage();

            //System.out.println(request.getPathInfo() + "." + errorClass);

            int errorCode = 0;
            String des = null;

            try {
                errorCode = Integer.parseInt(code.getString(
                        request.getPathInfo() + "." + errorClass).trim());
                des = description.getString(
                        request.getPathInfo() + "." + errorClass).trim();
            } catch (MissingResourceException exp) {
                errorCode = 302;
                des = "Strand Map Service Configuration Error";
                possibleProblems = "Missing key :" + exp.getKey();
            } catch (Exception exp) {
                errorCode = 302;
                des = "Strand Map Service Configuration Error";
                possibleProblems = null;
                System.out.println(exp.getMessage() + " : " + exp.getClass().getName());
                exp.printStackTrace();
            }

            error = new ErrorBean(errorCode, des, null, 0, possibleProblems,ex.getStackTrace(),request);
            reply = information.getString("Error.ResponseServlet");
            save = transfer.getString("ErrorBean");
            ((Logger) ExtendedActionServlet.cxt.getAttribute("logger"))
                    .severe(error.toString());
        }

        request.setAttribute(save, error);

        return mapping.findForward(reply);
    }
}
