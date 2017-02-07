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

//import java.io.*;
import java.util.*;
//import java.net.*;

public class benchmark implements Cloneable {
  private String ID;
  private String name;
  private String grade;
  private String full_text;
  private String code;
  private int v_level=0;
  private ArrayList<benchmark> toBenchmark = new ArrayList<benchmark>();
  private ArrayList<benchmark> fromBenchmark = new ArrayList<benchmark>();
  private ArrayList<benchmark> belongtoStrand = new ArrayList<benchmark>();
  private double h_level=0.0;
  private double h2_level=0;
  
  private String GradeDes;
  private String GradeID;
  
  private List<HashMap<String, String>> strands = new ArrayList<HashMap<String, String>>();
  private ArrayList<benchmark> conflictList = new ArrayList<benchmark>();
  private boolean addedToStrand = false;
  private boolean setForStrandSpan = false;
  
  public boolean isSetForStrandSpan() {
	return setForStrandSpan;
}

public void setSetForStrandSpan(boolean setForStrandSpan) {
	this.setForStrandSpan = setForStrandSpan;
}

public boolean isAddedToStrand() {
	return addedToStrand;
}

public void setAddedToStrand(boolean addedToStrand) {
	this.addedToStrand = addedToStrand;
}


private ArrayList<String> toBenchmarkType = new ArrayList<String>();
  private ArrayList<String> fromBenchmarkType = new ArrayList<String>();

  private String relationToSource = null;

    

	//Faisal: added these fields to be used in DLESE query construction
    private String keywords;
    private String subjects;

   public benchmark(String my_ID, String my_name, String my_grade, String my_full_text, String my_code, String my_keywords, String my_subjects)throws Exception
      {

          ID=my_ID;
        name=my_name;
        grade=my_grade;
        full_text=my_full_text;
        code=my_code;

          //Faisal: Initialization of keywords and subjects
          keywords = my_keywords;
          subjects = my_subjects;


      }// for constructor
      
   public boolean conflict (benchmark bb)
   {
     boolean result = false;
     if (conflictList.contains(bb)) {result = true; } 
     
     return result;
   }
 
   /** This conflict list is used to disable the rendring of lines drawn between
        the given Benchmarks. Not sure if this is needed - should probably be controlled
        instead by editing the DB.
   */   
   public void addConflict (benchmark bb)
   {
      conflictList.add(bb);
   }
   
   public void setGradeDes(String inS)
   {
      GradeDes=inS;
    
   }
   
   public String getGradeDes()
   {
       return GradeDes;
        
    
   }
   
   public void setGradeID(String inS)
   {
      GradeID=inS;
    
   }
   
   public String getGradeID()
   {
       return GradeID;
        
    
   }
   
   public void addStrand(String strandId, String strandName, String strandPos )
   {
	   HashMap<String, String> strand = new HashMap<String, String>();
	   strand.put("id", strandId);
	   strand.put("name", strandName);
	   strand.put("pos", strandPos);
	   this.strands.add(strand);
   }

   public int getLowestStrandPos()
   {
	   int minPos = 100;
	   for(HashMap<String, String> strand:this.strands)
	   {
		   if(strand.get("pos")!="No Pos")
		   {
			   int position = Integer.parseInt(strand.get("pos"));
			   if(position<minPos)
				   minPos = position;
		   }
	   }
	   return minPos;
   }
   
   public int getHighestStrandPos()
   {
	   int maxPos = 0;
	   for(HashMap<String, String> strand:this.strands)
	   {
		   if(strand.get("pos")!="No Pos")
		   {
			   int position = Integer.parseInt(strand.get("pos"));
			   if(position>maxPos)
				   maxPos = position;
		   }
	   }
	   return maxPos;
   }
   
   
   
   public String getID()
   {
       return ID;

   }
   public String getName()
   {
       return name;

   }
   public String getGrade()
   {
       return grade;

   }

   public String getText()
   {
       return full_text;

   }

   public String getCode()
   {
       return code;

   }

   public ArrayList<benchmark> getFromBenchmark()
   {
       return fromBenchmark;

   }
   
   public ArrayList<String> getFromBenchmarkType()
   {
       return fromBenchmarkType;

   }
   
   public ArrayList<String> getToBenchmarkType()
   {
       return toBenchmarkType;

   }

   public ArrayList<benchmark> getToBenchmark()
   {
       return toBenchmark;

   }

   public void addToBenchmark(benchmark bm)
   {
       toBenchmark.add(bm);
   }

   public void addFromBenchmark(benchmark bm)
   {
       fromBenchmark.add(bm);
   }
   
   public void addFromBenchmarkType(String  s)
   {
       fromBenchmarkType.add(s);
   }
   
   public void addToBenchmarkType(String s)
   {
       toBenchmarkType.add(s);
   }

   public void belongtoStrand(benchmark bm)
   {
       belongtoStrand.add(bm);
   }

   public void setVValue(int v){
       v_level=v;
   }

   public int getVValue(){
       return v_level;
   }

    public void setHValue(double h){
        h_level=h;
    }

    public double getHValue(){
        return h_level;
    }

    public void setH2Value(double h){
        h2_level=h;
    }

    public double getH2Value(){
        return h2_level;
    }
    public String getRelationToSource() {
    	return relationToSource;
    }

    public void setRelationToSource(String relationToSource) {
    	this.relationToSource = relationToSource;
    }





    /**
     * @return
     */
    public String getKeywords()
    {
        return keywords;
    }

    /**
     * @return
     */
    public String getSubjects()
    {
        return subjects;
    }
    
    public List<HashMap<String, String>> getDisplayableStrands()
    {
    	Collections.sort(this.strands, new Comparator<HashMap<String, String>>() {

	        public int compare(HashMap<String, String> strand1, HashMap<String, String> strand2) {
	            Integer pos1 = Integer.parseInt(strand1.get("pos"));
	            Integer pos2 = Integer.parseInt(strand2.get("pos"));
	            return pos1.compareTo(pos2);
	        }
	    });
    	
    	if(this.strands.size()==1)
    		return this.strands;
    	
    	if(this.strands.size()==2)
    	{
    		Integer pos1 = Integer.parseInt(this.strands.get(0).get("pos"));
            Integer pos2 = Integer.parseInt(this.strands.get(1).get("pos"));
            if(pos2.intValue()-pos1.intValue()==1)
            	return this.strands;
    	}
    	
    	// else add them and divide by two
    	int positionCount = 0;
    	for(HashMap<String, String> strand:this.strands)
    	{
    		Integer pos = Integer.parseInt(strand.get("pos"));
    		positionCount+=pos.intValue();
    	}
    	int average = (int)(positionCount/this.strands.size());
    	
    	ArrayList<HashMap<String, String>> newList = new ArrayList<HashMap<String, String>>();
    	
    	for(HashMap<String, String> strand:this.strands)
    	{
    		if(Integer.parseInt(strand.get("pos"))==average)
    			newList.add(strand); 
    	}
		
		if(newList.size()==0)
			newList.add(this.strands.get(0));
		return newList;
		
			


    }
    public benchmark clone() {
    	 try {
			return (benchmark)super.clone();
		} catch (CloneNotSupportedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
    	 }

}  // end for class
