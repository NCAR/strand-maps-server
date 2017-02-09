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


package edu.cu.cs.sms.Database;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import edu.cu.cs.sms.DTO.DTO;
import edu.cu.cs.sms.DTO.SMSData;
import edu.cu.cs.sms.Exceptions.CorruptDataException;
import edu.cu.cs.sms.util.QueryExpander;

public class SMSResultSet extends DTO implements SMSResult
{
/*
	ItemID1	ItemID2	RelationType	RelationCategory	codename1	codename2	object_type	
	object_ID	Name	source	primary_grade	second_grade	record_status	full_text	
	description		subjects	keywords	metadata_code	metadata_lan	date_created	O	P	Q	R	S	
	serial	aaas_code	code_plus
*/		
	private ArrayList searchSet = new ArrayList();
	private int totalObjects						= 0;
	private String detail							= null;
	private String objectID							= null;
	private int graphType							= 0;
	private String color							= null;
	private float imageScale						= -1;
	private int conceptSize							= -1;
	private boolean suitableforSVG					= true;
	private QueryExpander defaultBMKQueryExpander 	= null;
	private QueryExpander defaultGRDQueryExpander 	= null;
	private QueryExpander defaultSTDQueryExpander 	= null;
	private QueryExpander defaultMAPQueryExpander 	= null;
	private QueryExpander defaultCLSQueryExpander 	= null;
	private QueryExpander defaultCHPQueryExpander 	= null;
	private QueryExpander defaultATLQueryExpander 	= null;
	private QueryExpander defaultSECQueryExpander 	= null;
	private QueryExpander defaultSFAAQueryExpander 	= null;
	private QueryExpander defaultALLQueryExpander 	= null;

	private ArrayList BMKDLQueries 					= new ArrayList();
	private ArrayList GRDDLQueries 					= new ArrayList();
	private ArrayList STDDLQueries 					= new ArrayList();
	private ArrayList MAPDLQueries 					= new ArrayList();
	private ArrayList CLSDLQueries 					= new ArrayList();
	private ArrayList CHPDLQueries 					= new ArrayList();
	private ArrayList ATLDLQueries 					= new ArrayList();
	private ArrayList SECDLQueries 					= new ArrayList();
	private ArrayList SFAADLQueries 				= new ArrayList();
	private ArrayList ALLDLQueries	 				= new ArrayList();
	
	public void addALLDLQuery(QueryExpander qe)
	{
		ALLDLQueries.add(qe);
		
		if(ALLDLQueries.size() == 1)
			defaultALLQueryExpander = qe;
	}

	public void addSFAADLQuery(QueryExpander qe)
	{
		SFAADLQueries.add(qe);
		
		if(SFAADLQueries.size() == 1)
			defaultSFAAQueryExpander = qe;
	}

	public void addSECDLQuery(QueryExpander qe)
	{
		SECDLQueries.add(qe);
		
		if(SECDLQueries.size() == 1)
			defaultSECQueryExpander = qe;
	}

	public void addATLDLQuery(QueryExpander qe)
	{
		ATLDLQueries.add(qe);
		
		if(ATLDLQueries.size() == 1)
			defaultATLQueryExpander = qe;
	}

	public void addCHPDLQuery(QueryExpander qe)
	{
		CHPDLQueries.add(qe);
		
		if(CHPDLQueries.size() == 1)
			defaultCHPQueryExpander = qe;
	}

	public void addCLSDLQuery(QueryExpander qe)
	{
		CLSDLQueries.add(qe);
		
		if(CLSDLQueries.size() == 1)
			defaultCLSQueryExpander = qe;
	}

	public void addMAPDLQuery(QueryExpander qe)
	{
		MAPDLQueries.add(qe);
		
		if(MAPDLQueries.size() == 1)
			defaultMAPQueryExpander = qe;
	}

	public void addSTDDLQuery(QueryExpander qe)
	{
		STDDLQueries.add(qe);
		
		if(STDDLQueries.size() == 1)
			defaultSTDQueryExpander = qe;
	}

	public void addGRDDLQuery(QueryExpander qe)
	{
		GRDDLQueries.add(qe);
		
		if(GRDDLQueries.size() == 1)
			defaultGRDQueryExpander = qe;
	}

	public void addBMKDLQuery(QueryExpander qe)
	{
		BMKDLQueries.add(qe);
		
		if(BMKDLQueries.size() == 1)
			defaultBMKQueryExpander = qe;
	}
	
	
	/**
	 * @param rs
	 */
	public SMSResultSet(ResultSet rs) throws SQLException, IOException, CorruptDataException
	{
		ResultSetMetaData meta 	= 	rs.getMetaData();
		int numCols 			=   meta.getColumnCount();
		String temp 			= 	null;
		String colNames[] 		= 	new String[numCols];
		HashMap init 			= 	new HashMap(20);

		suitableforSVG = true;
		
		totalObjects = 0;

		for(int x = 0; x < numCols; x++)
			colNames[x] = meta.getColumnName(x+1);
		
		while(rs.next())
		{
		  init.clear();
		  	
		  for(int x = 1; x <= numCols; x++)
		  {
			temp = rs.getString(x) ;
			temp = (temp == null) ? "":temp;			
			init.put(colNames[x-1], temp);
		  }

				  
		  if(mergeSkeletonInfo(init))
		  {		 
		  	searchSet.add(new SMSData(init));
			totalObjects = searchSet.size();
		  }
		}

	}
	
	public boolean mergeSkeletonInfo(HashMap in)
	{
		Iterator it = searchSet.iterator();
		
		while(it.hasNext())
		{
			SMSData test = (SMSData)it.next();

			if(((String)in.get("object_ID")).equalsIgnoreCase(test.getObject_id()))
			{
				test.setIR(in);
				test.setEXTR(in);
				test.setAC(in);
				return false;
			}
		}
		
		return true;
	}
	
	public void add(SMSResult rs) throws SQLException, CorruptDataException
	{
		for(int i=0;i<rs.getTotalObjects();i++)
			if(checkID(rs.getObject(i)))
			{
				searchSet.add(rs.getObject(i));
				totalObjects = searchSet.size();
			}
	}

	public boolean checkID(SMSData in)
	{
		for(int i=0;i<totalObjects;i++)
			if(in.getObject_id().equalsIgnoreCase(getObject(i).getObject_id()))
				return false;
	
		return true;
	}

	public SMSData getObject(int index)
	{
		return (SMSData)searchSet.get(index);
	}

	public int getTotalObjects()
	{
		return totalObjects;
	}

	public String getDetail()
	{
		return detail;
	}

	public String getObjectID() 
	{
		return objectID;
	}

    public int getGraphType() 
	{
		return graphType;
	}

	public void setGraphType(int graphType) 
	{
		this.graphType = graphType;
	}

	public void setDetail(String detail) 
	{
		this.detail = detail;
	}

	public void setObjectID(String objectID) 
	{
		this.objectID = objectID;

		if(this.objectID == null)
			this.suitableforSVG = false;
	}

	public String getColor() 
	{
		return color;
	}

	public void setColor(String color) 
	{
		this.color = color;
	}

	public ArrayList getALLDLQueries() {
		return ALLDLQueries;
	}

	public ArrayList getATLDLQueries() {
		return ATLDLQueries;
	}

	public ArrayList getBMKDLQueries() {
		return BMKDLQueries;
	}

	public ArrayList getCHPDLQueries() {
		return CHPDLQueries;
	}

	public ArrayList getCLSDLQueries() {
		return CLSDLQueries;
	}

	public QueryExpander getDefaultALLQueryExpander() {
		return defaultALLQueryExpander;
	}

	public QueryExpander getDefaultATLQueryExpander() {
		return defaultATLQueryExpander;
	}

	public QueryExpander getDefaultBMKQueryExpander() {
		return defaultBMKQueryExpander;
	}

	public QueryExpander getDefaultCHPQueryExpander() {
		return defaultCHPQueryExpander;
	}

	public QueryExpander getDefaultCLSQueryExpander() {
		return defaultCLSQueryExpander;
	}

	public QueryExpander getDefaultGRDQueryExpander() {
		return defaultGRDQueryExpander;
	}

	public QueryExpander getDefaultMAPQueryExpander() {
		return defaultMAPQueryExpander;
	}

	public QueryExpander getDefaultSECQueryExpander() {
		return defaultSECQueryExpander;
	}

	public QueryExpander getDefaultSFAAQueryExpander() {
		return defaultSFAAQueryExpander;
	}

	public QueryExpander getDefaultSTDQueryExpander() {
		return defaultSTDQueryExpander;
	}

	public ArrayList getGRDDLQueries() {
		return GRDDLQueries;
	}

	public ArrayList getMAPDLQueries() {
		return MAPDLQueries;
	}

public ArrayList getSearchSet() {
	return searchSet;
}

	public ArrayList getSECDLQueries() {
		return SECDLQueries;
	}

	public ArrayList getSFAADLQueries() {
		return SFAADLQueries;
	}

	public ArrayList getSTDDLQueries() {
		return STDDLQueries;
	}

	public boolean isSuitableforSVG() {
		return suitableforSVG;
	}

	public void setSuitableforSVG(boolean suitableforSVG) {
		this.suitableforSVG = suitableforSVG;
	}

	
	/**
	 * @return the imageScale
	 */
	public float getImageScale()
	{
		return this.imageScale;
	}

	
	/**
	 * @param imageScale the imageScale to set
	 */
	public void setImageScale(float imageScale)
	{
		this.imageScale = imageScale;
	}

	
	/**
	 * @return the conceptSize
	 */
	public int getConceptSize()
	{
		return this.conceptSize;
	}

	
	/**
	 * @param conceptSize the conceptSize to set
	 */
	public void setConceptSize(int conceptSize)
	{
		this.conceptSize = conceptSize;
	}
}