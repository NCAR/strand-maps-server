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
 * Author: Qianyi Gu
 * Date  : Sept 14, 2005
 * email : Qianyi.Gu@colorado.edu
 */

package edu.cu.cs.sms.svg;

import org.xml.sax.SAXParseException;

import edu.cu.cs.sms.Database.SMSResultSet;
import edu.cu.cs.sms.Exceptions.InvalidIDException;
import edu.cu.cs.sms.util.Links;
import edu.cu.cs.sms.xml.GenerateXML;
import java.util.Date;
import java.util.concurrent.ConcurrentHashMap;

public class SVGFormatter implements GenerateXML {

    String id = null;
    private static ConcurrentHashMap<String, String> svgCache = new ConcurrentHashMap<String, String>();
    
    public byte[] populate(SMSResultSet info) throws Exception {
        // if(!info.isSuitableforSVG())
        // throw new UnsupportedFormatException();
    	String svgString = null;
    	String objectId = info.getObjectID();
    	if(svgCache.containsKey(objectId))
    	{
    		svgString = svgCache.get(objectId);
    		while(svgString==null)
    		{
    			svgCache.wait();
    			svgString = svgCache.get(objectId);
    		}
    		
    	}
    	else
    	{
    		svgString = Visualization.createSVG(info.getObjectID(), "$colorArgument$", info.getConceptSize());
    		svgCache.putIfAbsent(objectId, svgString);
    	}
    	
    	svgString = svgString.replace("$colorArgument$", info.getColor());
    	
        try {
            return new Links().LinkMaker(svgString, info);
            

        } catch (SAXParseException exp) {
            exp.printStackTrace();
            throw new InvalidIDException();
        }
        
    }

    public SVGFormatter() {
        super();
    }

    public String getFormat() {
        return "SVG";
    }

    /**
     * @param id
     *            The id to set.
     */
    public void setId(String id) {
        this.id = id;
    }

    public boolean isBinary() {
        return false;
    }

    public String mimeType() {
        return "image/svg+xml";
    }
	
	public Date getLastModifiedDate() {
		return new Date(); 
	}	
}
