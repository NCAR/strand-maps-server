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

import java.util.ArrayList;
import java.util.HashMap;
import edu.cu.cs.sms.Exceptions.CorruptDataException;


public class SMSData
{
	/*
		ItemID2	RelationType	object_type		object_ID	Name	description		aaas_code

		RelationCategory	source	primary_grade	record_status	full_text	
		subjects	keywords	metadata_code	metadata_lan	date_created	O	P	Q	R	S	
	*/		
	private String aaas_code;
	private String description;
	private String Name;
	private String object_id;
	private String object_type;

	private ArrayList ItemID2;
	private ArrayList RelationType;
	private ArrayList RelationCategory;
	
	private ArrayList asn_ID;
	private ArrayList asn_MatchType;
	private ArrayList asn_MatchPercent;
	
	
	private ArrayList NGSS_ID;
	private ArrayList NGSS_Type;
	
	

	private String lang;
	private String source;
	private String primary_grade;
	private String record_status;
	private String full_text;
	private String subjects;
	private String keywords;
	private String metadata_lan;
	private String date_created;
	private String student_conceptions;
	private String examples;
	private String assessments;
	private String instructional_information;
	private String clarification;
	private String Standards;
	private String Resources;
	

	public SMSData(HashMap in) throws CorruptDataException
	{
		
		if(in.size() < 20)
			throw new CorruptDataException("Invlaid data for bean initialization");

		ItemID2 		 = new ArrayList();
		RelationType 	 = new ArrayList();
		RelationCategory = new ArrayList();
		
		asn_ID           = new ArrayList();
		asn_MatchType    = new ArrayList();
		asn_MatchPercent = new ArrayList();
		
		
		NGSS_ID           = new ArrayList();
		NGSS_Type    = new ArrayList();
		
		
		aaas_code 			= (String)in.get("aaas_code");
		description 		= (String)in.get("description");
		Name 				= (String)in.get("Name");
		object_id 			= (String)in.get("object_ID");
		object_type 		= (String)in.get("object_type");
		
		ItemID2.add((String)in.get("ItemID2"));
		RelationType.add((String)in.get("RelationType"));
		RelationCategory.add((String)in.get("RelationCategory"));
		
		asn_ID.add((String)in.get("asn_ID"));
		asn_MatchType.add((String)in.get("MatchType"));
		asn_MatchPercent.add((String)in.get("MatchPercent"));
		
		NGSS_ID.add((String)in.get("NGSS_ID"));
		NGSS_Type.add((String)in.get("NGSS_Type"));
		
		
		
		source 						= (String)in.get("source");
		primary_grade 				= (String)in.get("primary_grade");
		record_status 				= (String)in.get("record_status");
		full_text 					= (String)in.get("full_text");
		subjects 					= (String)in.get("subjects");
		keywords 					= (String)in.get("keywords");
		metadata_lan 				= (String)in.get("metadata_lan");
		date_created 				= (String)in.get("date_created");
		student_conceptions			= (String)in.get("student_conceptions");
		examples					= (String)in.get("examples");
		assessments					= (String)in.get("assessments");
		instructional_information	= (String)in.get("instructional_information");
		clarification				= (String)in.get("clarification");
		lang 						= (String)in.get("metadata_lan");
		Standards					= (String)in.get("Standards");
		Resources					= (String)in.get("ExternalResources");
	}

	
	/*
	// is this even ever called?

	public SMSData(String aaas_code,String description,String ItemID2,String Name,String object_id,String object_type,String RelationType,String RelationCategory,String source,String primary_grade,String record_status,String full_text,String subjects,String keywords,String metadata_lan,String date_created,String O,String P,String Q,String R,String S)
	{
		this.ItemID2 		 = new ArrayList();
		this.RelationType 	 = new ArrayList();
		this.RelationCategory = new ArrayList();

		this.aaas_code    		= aaas_code;
		this.description 		= description;
		this.ItemID2.add(ItemID2);
		this.Name		  		= Name;
		this.object_id	  		= object_id;
		this.object_type  		= object_type;
		this.RelationType.add(RelationType);
		this.RelationCategory.add(RelationCategory);
		this.source 					= source;
		this.primary_grade 				= primary_grade;
		this.record_status 				= record_status;
		this.full_text 					= full_text;
		this.subjects 					= subjects;
		this.keywords 					= keywords; 
		this.metadata_lan 				= metadata_lan;
		this.date_created 				= date_created;
		this.student_conceptions		= O;
		this.examples					= P;
		this.assessments				= Q;
		this.instructional_information	= R;
		this.clarification				= S;
	}
	
	*/

	public String getDate_created()
	{
		return date_created;
	}

	public String getFull_text()
	{
		return full_text;
	}

	public String getKeywords()
	{
		return keywords;
	}

	public String getMetadata_lan()
	{
		return metadata_lan;
	}


	
	/**
	 * @return the examples
	 */
	public String getExamples()
	{
		return this.examples;
	}


	public String getPrimary_grade()
	{
		return primary_grade;
	}

	public String getRecord_status()
	{
		return record_status;
	}

	public ArrayList getRelationCategory()
	{
		return RelationCategory;
	}

	public ArrayList getAsn_ID()
	{
		return asn_ID;
	}
	public ArrayList getAsn_MatchType()
	{
		return asn_MatchType;
	}
	public ArrayList getAsn_MatchPercent()
	{
		return asn_MatchPercent;
	}
	public ArrayList getNGSS_ID()
	{
		return NGSS_ID;
	}
	public ArrayList getNGSS_Type()
	{
		return NGSS_Type;
	}
	public String getSource()
	{
		return source;
	}

	public String getSubjects()
	{
		return subjects;
	}

	public ArrayList getItemID2()
	{
		return ItemID2;
	}

	public String getName()
	{
		return Name;
	}

	public String getObject_id()
	{
		return object_id;
	}

	public String getObject_type()
	{
		return object_type;
	}

	public ArrayList getRelationType()
	{
		return RelationType;
	}

	public void setIR(HashMap in)
	{
		if(!ItemID2.contains((String)in.get("ItemID2"))){
			ItemID2.add((String)in.get("ItemID2"));
			RelationType.add((String)in.get("RelationType"));
			RelationCategory.add((String)in.get("RelationCategory"));
		}
	}

	public void setAC(HashMap in)
	{
		if(!asn_ID.contains((String)in.get("asn_ID"))){
			asn_ID.add((String)in.get("asn_ID"));
			asn_MatchType.add((String)in.get("MatchType"));
			asn_MatchPercent.add((String)in.get("MatchPercent"));
		}
	}
	
	public void setEXTR(HashMap in)
	{
		if(!NGSS_ID.contains((String)in.get("NGSS_ID"))){
			NGSS_ID.add((String)in.get("NGSS_ID"));
			NGSS_Type.add((String)in.get("NGSS_Type"));
		}
	}
	
	public String getAaas_code()
	{
		return aaas_code;
	}


	public String getDescription()
	{
		return description;
	}

	public String getLang()
	{
		return lang;
	}

	public String getResources() {
		return Resources;
	}

	public String getStandards() {
		return Standards;
	}


	
	/**
	 * @return the student_conceptions
	 */
	public String getStudent_conceptions()
	{
		return this.student_conceptions;
	}


	
	/**
	 * @return the assessments
	 */
	public String getAssessments()
	{
		return this.assessments;
	}


	
	/**
	 * @return the instructional_information
	 */
	public String getInstructional_information()
	{
		return this.instructional_information;
	}


	
	/**
	 * @return the clarification
	 */
	public String getClarification()
	{
		return this.clarification;
	}
}
