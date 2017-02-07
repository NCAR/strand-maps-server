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

import java.util.Date;
import java.io.Serializable;


public class ConCache implements Serializable {
	private byte[] response;
	private boolean binary = false;
	private String mimeType = null;
	private Date lastModified = null;


	public ConCache(byte[] response,boolean bin,String mimeType,Date lastModified)
	{
		super();
		this.response 		= response;
		this.binary			= bin;
		this.mimeType = mimeType;
		this.lastModified = lastModified;
	}

	public byte[] getResponse() 
	{
		return response;
	}

	public boolean isBinary() {
		return binary;
	}
	
	public String getMimeType() {
		return mimeType;
	}

	public Date getLastModifiedDate() {
		return lastModified;
	}	
}
