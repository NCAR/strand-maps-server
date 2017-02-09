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
 */

package edu.cu.cs.sms.jsapi;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;


import edu.cu.cs.sms.QueryAction;

// this servlet recives all queries
public class JavascriptAction extends QueryAction {
	

    // --------------------------------------------------------- Instance
    // Variables

    // --------------------------------------------------------- Static
    // Variables


    // --------------------------------------------------------- Methods

    public ActionForward execute(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
			
    		String realPath = request.getRequestURI();
			
    		//System.out.println("realPath: " + realPath);
    		
    		// Return the map service JavaScript...
			if(realPath.endsWith("/maps") || realPath.endsWith("/maps-impl")){
				String api = request.getParameter( "api" );
				
				if(api == null)
					return mapping.findForward("js-api-not-supported");
				
				if(api.equals("v1")){
					// Handle /maps
					if(realPath.endsWith("/maps"))
						return mapping.findForward("map-js-v1");
					// Handle /maps-impl
					else
						return mapping.findForward("map-js-impl-v1");
				}
				else
					return mapping.findForward("js-api-not-supported");
			}
			
			// Handle other jsapi output:
			
    		// Params sent to service:
			String format = null;
    		String color = null;
			String objectId = null;
			String asnId = null;
			String scale = null;
			String size = null;
			String detailLevel = null;
			String thirdPartyQuery = null;
			String scope = null;
			
			String queryElem = null;
			
			Pattern p = null;
			Matcher m = null;
			
    		// Map images (JPG, PNG, PDF, SVG):
    		if(realPath.contains("/map_images/")){
    			
    			// Default images:
    			if(realPath.contains("/default/")){
    				// No color, size, scale indicated: /map_images/default/{map-id}.{ext}
					// Example: /map_images/default/SMS-MAP-0048.PNG
    				
        			p = Pattern.compile( "\\A.*/map_images/default/(.+)\\.(.+)" );
            		m = p.matcher( realPath );
            		while(m.find()){
	            		objectId = m.group( 1 );
						format = m.group( 2 );							
            		}
    			}
				// Custom images:
    			else {  				
    				// Color, concept size, and scale indicated: /map_images/{color}/{concept-size}/{scale}/{map-id}.{ext}
					// Example: /map_images/blue/6/100/SMS-MAP-0048.JPG
        			p = Pattern.compile( "\\A.*/map_images/(.+)/(.+)/(.+)/(.+)\\.(.+)" );
            		m = p.matcher( realPath );
            		while(m.find()){
						color = m.group( 1 );
						if(isHex(color))
							color = "#" + color;
						size =  m.group( 2 );
	            		scale = m.group( 3 );
	            		objectId = m.group( 4 );
						format = m.group( 5 );	
            		}   				
    			}	
    		}
    		// SVG as XML:
    		else if(realPath.contains("/xsvg/")){
    			format = "XSVG";
    			// Pattern /xsvg/color-%23aaaaaa/SMS-MAP-0048.XML
    			if(realPath.contains("/color-")){
        			p = Pattern.compile( "\\A.*/xsvg/color-(.+)/(.+).XML" );
            		m = p.matcher( realPath );
            		while(m.find()){
	            		color = m.group( 1 );
	            		objectId = m.group( 2 );
            		}   					
    			}
    			else {
	    			// Pattern /xsvg/SMS-MAP-0048.XML
	    			p = Pattern.compile( "\\A.*/xsvg/(.+).XML" );
	        		m = p.matcher( realPath );
	        		while(m.find()){
	            		objectId = m.group( 1 );
	        		}  
    			}	
    		}
    		// SMS or SVG as JSON:
    		else if(realPath.contains("/json")){
				
    			format = request.getParameter("Format").toUpperCase();
				objectId = request.getParameter("ObjectID");
				size = request.getParameter("ConceptSize");
				scale = request.getParameter("ImageScale");
				asnId = request.getParameter("ASNID");
				
				String callBack = request.getParameter("callBack");

				if(callBack != null && callBack.trim().length() > 0)
					request.setAttribute("callBackFunction", callBack);
				
				// Format may be SMS-JSON or SVG-JSON
				if(format.equals("SMS-JSON")){
					detailLevel = request.getParameter("DetailLevel");
					thirdPartyQuery = request.getParameter("ThirdPartyQuery");
					scope = request.getParameter("Scope");
					if(detailLevel == null || detailLevel.trim().length() == 0)
						detailLevel = "Detailed";
					if(scope == null || scope.trim().length() == 0)
						scope = "ALL";
					if(thirdPartyQuery == null || thirdPartyQuery.trim().length() == 0)
						thirdPartyQuery = "";
					else
						thirdPartyQuery = " ThirdPartyQuery=\"" + thirdPartyQuery + "\"";
					queryElem = "<Query Format=\"SMS-JSON\" DetailLevel=\"" + detailLevel + "\" Scope=\"" + scope + "\"" + thirdPartyQuery + ">";
				}
    		}			
    		    		
			// Create the query element for an SVG-based response:
			if(queryElem == null) {
				// Set default color, size, scale if none indicated
				if(color == null)
					color = "#E2E8F6";
				if(size == null)
					size = "4";
				if(scale == null)
					scale = "100";					
				if(format.equals("JPG"))
					format = "JPEG";
				queryElem = "<Query Color=\"" + color + "\" ImageScale=\"" + scale + "\" ConceptSize=\"" + size + "\" Format=\"" + format + "\">";
			}
			
			//System.out.println("jsapi request for: " + queryElem);

			String query = null;
			if(asnId != null){
				query = 
    			"<SMS-CSIP xmlns=\"http://sms.dlese.org\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">" +
    			queryElem +
    			"<ASNLookup-Query>" +
    			"<ASNID>" + asnId + "</ASNID>" +
    			"</ASNLookup-Query>" +
    			"</Query>" +
    			"</SMS-CSIP>";
			} else {
    			query = 
    			"<SMS-CSIP xmlns=\"http://sms.dlese.org\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">" +
    			queryElem +
    			"<Content-Query>" +
    			"<ObjectID>" + objectId + "</ObjectID>" +
    			"</Content-Query>" +
    			"</Query>" +
    			"</SMS-CSIP>";
			}
    		//System.out.println("jsapi query sent: " + query);
			
    		request.setAttribute("js-query", query);
			return super.execute( mapping,  form,
		             request,  response);
    }
	
	private boolean isHex(String color){
		try {
			Integer.parseInt(color, 16);
			return true;
		} catch (NumberFormatException nfe) {
			return false;
		}
	}
}