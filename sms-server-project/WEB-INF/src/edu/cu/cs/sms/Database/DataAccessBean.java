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
 */
package edu.cu.cs.sms.Database;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import java.util.PropertyResourceBundle;
import java.io.BufferedInputStream;

import edu.cu.cs.sms.Exceptions.CorruptDataException;
import edu.cu.cs.sms.ExtendedActionServlet;

/**
 *  Accesses specific data from the SMS database needed in the JSP pages and elsewhere in the application.
 *  First set the oid in the bean, then call the getter for the necessary data.
 *
 * @author     John Weatherley
 */
public class DataAccessBean {

	private String dataObjectID = null;
	
	private static HashMap<String, Map<String, String>> parentMaps = new HashMap<String, Map<String, String>>();
	private static HashMap<String, Map<String, String>> grandParentMaps = new HashMap<String, Map<String, String>>();
	private static HashMap<String, Map<String, String>> greatGrandParentMaps = new HashMap<String, Map<String, String>>();
	
	/**  Constructor for the DataAccessBean object */
	public DataAccessBean() { }

	/**
	 *  Sets the oid attribute of the DataAccessBean object
	 *
	 * @param  id  The new oid value
	 */
	public void setOid(String id) {
		this.dataObjectID = id;
	}

	private Map<String, String> getParentMap(String objectID)
	{
		if (objectID == null)
			return null;
		if(!parentMaps.containsKey(objectID))
		{
			parentMaps.put(objectID, createParentMap(objectID));
		}
		return parentMaps.get(objectID);
	}
	
	private Map<String, String> getGrandParentMap(String objectID)
	{
		if (objectID == null)
			return null;
		if(!grandParentMaps.containsKey(objectID))
		{
			grandParentMaps.put(objectID, createParentMap(
					getParentMap(objectID).get("id")));
		}
		return grandParentMaps.get(objectID);
	}
	
	private Map<String, String> getGreatGrandParentMap(String objectID)
	{
		if (objectID == null)
			return null;
		if(!greatGrandParentMaps.containsKey(objectID))
		{
			greatGrandParentMaps.put(objectID, createParentMap(
					getGrandParentMap(objectID).get("id")));
		}
		return greatGrandParentMaps.get(objectID);
	}

	public String getParentJson()
	{
		return getMapJson(this.getParentMap(this.dataObjectID));
	}
	
	public String getGrandparentJson()
	{
		return getMapJson(this.getGrandParentMap(this.dataObjectID));
	}
	
	public String getGreatgrandparentJson()
	{
		return getMapJson(this.getGreatGrandParentMap(this.dataObjectID));
	}
	
	
	private String getMapJson(Map<String, String> parentMap)
	{
		return "{\"ObjectID\":\"" + parentMap.get("id") + "\",\"Name\":\"" + parentMap.get("name") + "\"}";

	}
	
	/**
	 *  Gets the parentChapterJson attribute of the DataAccessBean object
	 *
	 * @return    The parentChapterJson value
	 */
	public Map<String, String> createParentMap(String objectID) {
		if (objectID == null)
			return null;
		
		HashMap<String, String> parentMap = null;
		
		try {
			// Initialize the DB connection...
			PropertyResourceBundle conf = new PropertyResourceBundle(
				new BufferedInputStream(this.getClass().getClassLoader().getResourceAsStream("edu/cu/cs/sms/ApplicationResources.properties")));
			QueryExecutor queryExecutor = (QueryExecutor) ExtendedActionServlet.cxt.getAttribute(conf.getString("QueryEngine").trim());

			// Perform the DB query and extract the data...
			String SQLQuery = "select itemid2, name from relation, objects where itemid2=objects.object_ID and itemid1 = '"
				 + objectID + "' and relationtype = 'is part of'";

			ResultSet rs = queryExecutor.executeRawSearch(SQLQuery);
			String id = "";
			String name = "";
			while (rs.next())
			{
				id = rs.getString(1);
				name = rs.getString(2);
			}
			parentMap = new HashMap<String, String>();
			parentMap.put("id", id);
			parentMap.put("name", name);
		} catch (Throwable t) {
			System.out.println("Error DataAccessBean.createParentMap(): " + t);
			t.printStackTrace();
			return null;
		}
		
		return parentMap;
	}
}

