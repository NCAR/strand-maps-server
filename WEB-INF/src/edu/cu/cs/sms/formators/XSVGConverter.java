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

package edu.cu.cs.sms.formators;


import edu.cu.cs.sms.Database.SMSResultSet;
import edu.cu.cs.sms.svg.SVGFormatter;
import org.dlese.dpc.xml.XSLTransformer;

import org.dlese.dpc.xml.XMLUtils;

import java.io.BufferedReader;
import java.io.StringReader;

/**
 * 
 * Outputs the SVG as plain XML wihtout namespaces.
 * 
 * @author jweather
 */
public class XSVGConverter extends SVGFormatter {

    String id = null;

    public byte[] populate(SMSResultSet info) throws Exception {
        // if(!info.isSuitableforSVG())
        // throw new UnsupportedFormatException();

    	byte[] bytes = super.populate(info);
    	
		if(bytes ==  null || bytes.length == 0)
			return bytes;
		
    	String svg = new String(bytes);
		
		String xsvg = null;
		try {
			// First remove DTD declaration, which was causing intermittent errors in the localization method:
			svg = svg.replaceFirst("\\<!DOCTYPE.*\\s*.*\\>","");
			xsvg = XSLTransformer.localizeXmlThrowsExceptions(svg);
		} catch (Exception t) {
			System.out.println("XSVGConverter: Error localizing svg. String was: '" +svg+ "'");
			throw t;
		}
    	
    	return xsvg.getBytes("UTF-8");
    }

    public XSVGConverter() {
        super();
    }

    public String getFormat() {
        return "XSVG";
    }

    public void setId(String id) {
        this.id = id;
    }

    public boolean isBinary() {
        return false;
    }

    public String mimeType() {
        return "application/xml";
    }
}
