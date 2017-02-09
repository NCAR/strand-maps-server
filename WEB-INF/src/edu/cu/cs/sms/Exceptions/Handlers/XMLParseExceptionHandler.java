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
import java.util.Arrays;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.config.ExceptionConfig;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;

import edu.cu.cs.sms.ExtendedActionServlet;
import edu.cu.cs.sms.DTO.ErrorBean;

/**
 *  Handles org.xml.sax.SAXException errors encountered when the SMS query is not valid.
 *
 */
public class XMLParseExceptionHandler extends SMSBaseExceptionHandler {
	public ActionForward execute(Exception ex, ExceptionConfig ae,
			ActionMapping mapping, ActionForm formInstance,
			HttpServletRequest request, HttpServletResponse response)
			 throws javax.servlet.ServletException {
		Exception test = initResourceBundles();
		ErrorBean error = null;
		String reply = "errorResponse";
		String save = "Error";

		int columnNumber = -1;
		int lineNumber = -1;
		
		if (ex instanceof SAXParseException) {
			SAXParseException spe = (SAXParseException) ex;
			if(spe != null) {
				columnNumber = spe.getColumnNumber();
				lineNumber = spe.getLineNumber();					
			}				
			
		}

		if (test != null) {
			String possibleProblems = test.getMessage();

			error = new ErrorBean(302,
					"Invalid query", null, 0,
					possibleProblems, ex.getStackTrace(), request);
			((Logger) ExtendedActionServlet.cxt.getAttribute("logger")).warning("Invalid query received: " + error.getProblem());
		}
		else {
			String errorClass = ex.getClass().getName();
			String possibleProblems = null;
			if (ex != null && ex.getMessage() != null)
				possibleProblems = ex.getMessage();

			//System.err.println(request.getPathInfo() + "." + errorClass);

			int errorCode = 0;
			String des = null;

			try {
				errorCode = Integer.parseInt(code.getString(
						request.getPathInfo() + "." + errorClass).trim());
				des = description.getString(
						request.getPathInfo() + "." + errorClass).trim();
			} catch (MissingResourceException exp) {
				errorCode = 302;
				des = "Invalid query";
				String[] pP = {("Missing key :" + exp.getKey())};
			}
			
			error = new ErrorBean(errorCode, des, "Column : "
					 + columnNumber, lineNumber,
					possibleProblems, ex.getStackTrace(), request);
			reply = information.getString("Error.ResponseServlet");
			save = transfer.getString("ErrorBean");
			((Logger) ExtendedActionServlet.cxt.getAttribute("logger")).warning("Invalid query received: " + error.getProblem());
		}

		request.setAttribute(save, error);

		return mapping.findForward(reply);
	}
}

