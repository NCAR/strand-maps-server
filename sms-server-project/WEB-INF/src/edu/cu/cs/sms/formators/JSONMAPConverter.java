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
import org.json.XML;

/**
 *  Outputs the SVG map data in JSON form, for use in the JS API and other JavaScript
 *  applications.
 *
 * @author     John Weatherley
 */
public class JSONMAPConverter extends XSVGConverter {

	String id = null;


	/**
	 *  Returns JSON as bytes
	 *
	 * @param  info           The SMSResultSet
	 * @return                Returns JSON as bytes
	 * @exception  Exception  If error
	 */
	public byte[] populate(SMSResultSet info) throws Exception {
		
		// Grab localized XML from super and create	JSON
		String svg = new String(super.populate(info));
		return XML.toJSONObject(svg).toString(3).getBytes("UTF-8");
	}


	/**  Constructor for the JSONMAPConverter object */
	public JSONMAPConverter() {
		super();
	}


	/**
	 *  Gets the format attribute of the JSONMAPConverter object
	 *
	 * @return    The format value
	 */
	public String getFormat() {
		return "SVG-JSON";
	}


	/**
	 *  Sets the id attribute of the JSONMAPConverter object
	 *
	 * @param  id  The new id value
	 */
	public void setId(String id) {
		this.id = id;
	}


	/**
	 *  Gets the binary attribute of the JSONMAPConverter object
	 *
	 * @return    The binary value
	 */
	public boolean isBinary() {
		return false;
	}


	/**
	 *  Gets the mime type as a string
	 *
	 * @return    mime type as a string
	 */
	public String mimeType() {
		return "text/javascript";
	}
}

