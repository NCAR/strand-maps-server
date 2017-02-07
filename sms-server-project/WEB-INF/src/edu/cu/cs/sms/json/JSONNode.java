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
package edu.cu.cs.sms.json;

import org.json.JSONObject;
import org.json.JSONArray;
import org.json.JSONException;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.StringReader;
import java.io.StringWriter;
import java.sql.SQLException;
import java.util.List;
import java.util.ArrayList;

/**
 *  A wrapper for JSONObject and JSONArray that provides static methods to get json sub-elements as Strings or
 *  Lists of Strings using jPath notation.
 *
 * @author     John Weatherley
 */
public class JSONNode {
	private JSONObject json_object = null;
	private JSONArray json_array = null;
	private String end_node_string = null;


	/**
	 *  Gets the sub-string of json from the given json at the specified jPath location.
	 *
	 * @param  json   A json String, for example '{"book": {"title": "My Book", "author": "John Doe"} }'
	 * @param  jPath  A jPath expression, for example book.title, for example "My Book"
	 * @return        A json String or regular String value
	 */
	public static String getJsonStringAt(String json, String jPath) {
		JSONNode node = new JSONNode(json);
		return node.getJsonAtJpath(jPath);
	}


	/**
	 *  Gets a List of json Strings from the given json at the specified jPath location.
	 *
	 * @param  json   A json String, for example '{"book": {"title": "My Book", "author": "John Doe"} }'
	 * @param  jPath  A jPath expression, for example book.title
	 * @return        A List of json Strings
	 */
	public static List getJsonListAt(String json, String jPath) {
		JSONNode node = new JSONNode(getJsonStringAt(json, jPath));
		return node.toList();
	}


	/**
	 *  Constructor for the JSONNode object
	 *
	 * @param  json  NOT YET DOCUMENTED
	 */
	public JSONNode(String json) {
		try {
			json_object = new JSONObject(json);
		} catch (JSONException obj_exception) {
			try {
				json_array = new JSONArray(json);
			} catch (JSONException array_exception) {
				end_node_string = json;
				//System.out.println("Does not appear to be valid JSON: " + obj_exception + " " + array_exception);
			}
		}
	}


	/**
	 *  Constructor for the JSONNode object
	 *
	 * @param  json_obj  NOT YET DOCUMENTED
	 */
	public JSONNode(Object json_obj) {
		if (json_obj instanceof JSONArray)
			this.json_array = (JSONArray) json_obj;
		else if (json_obj instanceof JSONObject)
			this.json_object = (JSONObject) json_obj;
		else if (json_obj instanceof String)
			end_node_string = (String) json_obj;
	}


	/**
	 *  NOT YET DOCUMENTED
	 *
	 * @return    NOT YET DOCUMENTED
	 */
	public String toString() {
		if (json_object != null)
			return json_object.toString();
		else if (json_array != null)
			return json_array.toString();
		else if (end_node_string != null)
			return end_node_string;
		else
			return "";
	}


	/**
	 *  NOT YET DOCUMENTED
	 *
	 * @return    NOT YET DOCUMENTED
	 */
	public List toList() {
		ArrayList list = new ArrayList();
		if (json_object != null) {
			list.add(json_object.toString());
		}
		else if (json_array != null) {
			try {
				for (int i = 0; i < json_array.length(); i++)
					list.add(json_array.getString(i));
			} catch (JSONException je) {}
		}
		else if (end_node_string != null) {
			list.add(end_node_string);
		}
		return list;
	}


	/**
	 *  Gets the jSONNode attribute of the JSONNode object
	 *
	 * @param  key  A String without periods or a bracketed integer [2].
	 * @return      The jSONNode value
	 */
	public JSONNode getJSONNode(String key) {
		if (key == null || key.length() == 0)
			return null;
		int blockIndex = key.indexOf('[');
		if (blockIndex == -1 && json_object != null) {
			try {
				return new JSONNode(json_object.get(key));
			} catch (JSONException je) {
				System.out.println("Error getJSONNode() 1: " + je);
			}
		}
		else if (json_array != null) {
			if (blockIndex == -1)
				return null;
			int blockEndIndex = key.indexOf(']');
			if (blockEndIndex == -1)
				return null;
			key = key.substring(blockIndex + 1, blockEndIndex);
			int i = Integer.parseInt(key);
			try {
				return new JSONNode(json_array.get(i));
			} catch (JSONException je) {
				System.out.println("Error getJSONNode() 2: " + je);
			}
		}
		return null;
	}


	/**
	 *  Gets the baseObject attribute of the JSONNode object
	 *
	 * @return    The baseObject value
	 */
	public Object getBaseObject() {
		if (json_object != null)
			return json_object;
		else
			return json_array;
	}


	/**
	 *  Gets the jsonAtJpath attribute of the JSONNode object
	 *
	 * @param  jPath  NOT YET DOCUMENTED
	 * @return        The jsonAtJpath value
	 */
	public String getJsonAtJpath(String jPath) {
		if (jPath == null)
			return "";
		if (jPath.length() == 0)
			return this.toString();

		int dotIndex = jPath.indexOf('.');
		int blockIndex = jPath.indexOf('[');

		if (dotIndex == -1 && blockIndex == -1) {
			JSONNode n = getJSONNode(jPath);
			if (n == null)
				return "";
			return n.toString();
		}

		// Handle path elements of the form my.path.here or my.path[0]
		if (dotIndex > 0 && (blockIndex == -1 || dotIndex < blockIndex)) {
			JSONNode n = getJSONNode(jPath.substring(0, dotIndex));
			if (n == null)
				return "";
			return n.getJsonAtJpath(jPath.substring(dotIndex + 1, jPath.length()));
		}

		else {
			// Handle path elements of the form [0] or [1].more.stuff
			if (blockIndex == 0) {
				int endBlockIndex = jPath.indexOf(']');
				JSONNode n = getJSONNode(jPath.substring(0, endBlockIndex + 1));
				if (n == null)
					return "";
				int start = (endBlockIndex + 2 > jPath.length() ? endBlockIndex + 1 : endBlockIndex + 2);
				return n.getJsonAtJpath(jPath.substring(start, jPath.length()));
			}
			// Handle path elements of the form myObj[0]
			else {
				JSONNode n = getJSONNode(jPath.substring(0, blockIndex));
				if (n == null)
					return "";
				return n.getJsonAtJpath(jPath.substring(blockIndex, jPath.length()));
			}
		}
	}
}

