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



package edu.cu.cs.sms.DTO;

import java.util.Arrays;
import java.lang.StackTraceElement;
import javax.servlet.http.HttpServletRequest;

public class ErrorBean extends DTO
{
	int 		code;
	String 		description;
	String 		location;
	String errorMsg = "";
	int 		lineNo;
	String stackTrace = "n/a";
	String urlRequested = "n/a";
	
	public ErrorBean(int initCode,String initDescription,String initLocation,int initLineNo,String errorMsg,StackTraceElement[] stackTraceElements,HttpServletRequest httpServletRequest)
	{
		super();
		
		if(initDescription == null) initDescription = "";
		if(initLocation == null) initLocation = "";
		
		code 		= initCode;
		description = initDescription;
		location 	= initLocation;
		lineNo 		= initLineNo;
		
		if(stackTraceElements != null && stackTraceElements.length > 0){
			stackTrace = "";
			for(int i = 0; i < stackTraceElements.length; i++)
				stackTrace += stackTraceElements[i]+"\n";
		}
		
		if(httpServletRequest != null && httpServletRequest.getRequestURL() != null)
			urlRequested = httpServletRequest.getRequestURL().toString();
		if(errorMsg != null)
			this.errorMsg = errorMsg;
	}
	
	public int 		getCode(){return code;}
	public String 	getDescription(){return description;}
	public String 	getLocation(){return location;}
	public int 		getLineNo(){return lineNo;}
	public String	getProblem(){return errorMsg;}
	public String toString(){return "Error Code:"+code+" Description: '"+description+"' Problem: "+errorMsg+" Location: '"+location+"' Line No:"+lineNo+" Request made: "+urlRequested+" Stack Trace: " + stackTrace;}
}
