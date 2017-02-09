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
import java.awt.Font;
import java.awt.FontMetrics;
import java.awt.Graphics;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.StringTokenizer;

import org.apache.commons.lang.StringUtils;

import edu.cu.cs.sms.Database.QueryExecutor;
import edu.cu.cs.sms.Exceptions.InvalidIDException;
import edu.cu.cs.sms.util.Aggregate;

import org.apache.batik.ext.awt.g2d.DefaultGraphics2D;

//import java.lang.*;
// test


//package com.microsoft.*;

public class Visualization{
	public static String DEJAVU_SANS = "font-family:'DejaVu LGC Sans'";
	public static String GLOBAL_FONT = DEJAVU_SANS;
	
	public static String STRAND_FONT_STYLE = "font-size:14;"+GLOBAL_FONT;
	public static String GRADE_FONT_STYLE = "font-size:14;"+GLOBAL_FONT;
	
	public static Font  HEADER_FONT = new Font(GLOBAL_FONT, Font.PLAIN, 15);
	public static FontMetrics HEADER_FONT_METRICS = new DefaultGraphics2D(false).getFontMetrics(
			HEADER_FONT);

	public static int FONT_LINE_HEIGHT = HEADER_FONT_METRICS.getHeight();
	
	public static String BENCHMARK_FONT_STYLE = "font-size:11;"+GLOBAL_FONT;
	public static String HEADER_FONT_STYLE = "font-size:14;"+GLOBAL_FONT;
	public static int TEXT_PADDING_HORIZONTAL = 6;
	
	// This is the movement we make in the maps. If a benchmark spans more then one strand
	// or trying to fix lines crossing themselves. Should always be less then one
	public static double SMALL_H_MOVEMENT = .5;
	public static double Y_SHIFT_FOR_LONG_STRAND_NAMES = 14;
	public static double MAX_STRAND_NAME_PER_H = 25;
    public static String createSVG(String objectID ,String flag, int concept_size ) throws Exception
    {
    	String svgOutput = null;
    	QueryExecutor qe = new QueryExecutor();
		try
		{
		
		ArrayList<Strand> strandList = new ArrayList<Strand>();
		ArrayList<Grade> gradeList = new ArrayList<Grade>();
		
		int size_flag=1;
    	
		size_flag=concept_size;
		
		size_flag=4;
		
		
		//BMWidth=150.0;
    	//BMHeight=158.0;	

		double bmWidth = 0;
		double bmHeight = 0;
    	if (size_flag==1)
    	{
    		bmWidth=100.0;
    		bmHeight=100.0;	
    		
    	}
    	
    	if (size_flag==2)
    	{
    		bmWidth=100.0;
    		bmHeight=130.0;	
    		
    	}
    	
    	if (size_flag==3)
    	{
    		bmWidth=100.0;
    		bmHeight=158.0;	
    		
    	}
    	
    	if (size_flag==4)
    	{
    		bmWidth=150.0;
    		bmHeight=158.0;	
    		
    	}
    	
    	if (size_flag==5)
    	{
    		bmWidth=200.0;
    		bmHeight=158.0;	
    		
    	}
    	
    	if (size_flag==6)
    	{
    		bmWidth=250.0;
    		bmHeight=158.0;	
    		
    	}
    	
    	
    	//BMWidth=200.0;
    	//BMHeight=158.0;
    	
    	
    	//----------
    	
    	if(objectID == null)
            throw new InvalidIDException();

        Strand st1 = new Strand();
        Strand st2 = new Strand();
        Strand st3 = new Strand();
        Strand st4 = new Strand();
        Strand st5 = new Strand();
		Strand st6 = new Strand();
		Strand st7 = new Strand();
        
        
        strandList.add(0,st1);   
        strandList.add(1,st2);
        strandList.add(2,st3);
        strandList.add(3,st4);
        strandList.add(4,st5);
        strandList.add(5,st6);
        strandList.add(6,st7);
        
        Grade gd1 = new Grade();
        Grade gd2 = new Grade();
        Grade gd3 = new Grade();
        Grade gd4 = new Grade();
        
        gradeList.add(0,gd1);
        gradeList.add(1,gd2);
        gradeList.add(2,gd3);
        gradeList.add(3,gd4); 
  
        String col = flag;
        
        boolean intersection=false;

        

            String type="";
            if (objectID.indexOf(":")>0)
            {
                type="intersection";
                intersection=true;     
            }
            else
            { 
            	String SQLStatement="select object_type from objects where object_ID='"+objectID+"'";
            	ResultSet rs=qe.executeRawSearch(SQLStatement);
            	if (rs.next())
            		type=rs.getString(1);
                rs.close();
            }

            HashMap<String, benchmark> benchmarkMap = createBenchmarks(qe, type, objectID);
            ArrayList<benchmark> benchmarks = null;
            if(benchmarkMap!=null)
            {
            	benchmarks = new ArrayList(benchmarkMap.values());
            }	
            	
             if (type.equalsIgnoreCase("intersection"))
             {
                 process_grade(benchmarks, gradeList, strandList, false );
                 svgOutput =  createSVGMap(objectID, benchmarks, gradeList, strandList, bmWidth, bmHeight, col, true);
             }
             else if(type.equalsIgnoreCase("Benchmark"))
             {
                 int num_to=0, num_from=0;
                 benchmark sourceBm = null;
                 
                 ArrayList<benchmark> tos = new ArrayList<benchmark>();
                 ArrayList<benchmark> froms = new ArrayList<benchmark>();
                 
                 // From old code, for some reason level_from , must be set to to
                 // if there are any to benchmarks. Otherwise its one.
                 int level_from=1;
                 for(benchmark bm:benchmarkMap.values())
                 {
                	 if(bm.getRelationToSource().equals("to"))
                	 {
                		 level_from=2;
                		 break;
                	 }	 
                 }
                 for(benchmark bm:benchmarkMap.values())
                 {
                	 if(bm.getRelationToSource().equals("to"))
                	 {
                		 bm.setVValue(0);
                		 num_to++;
                		 bm.setH2Value(num_to);
                		 tos.add(bm);
                	 }
                	 else if(bm.getRelationToSource().equals("from"))
                	 {
                		 bm.setVValue(level_from);
                         num_from++;
                         bm.setH2Value(num_from);
                         froms.add(bm);
                	 }
                	 else if(bm.getRelationToSource().equals("self"))
                		 sourceBm = bm; 
                 }
                 benchmarks.addAll(tos);
                 benchmarks.addAll(froms);
                 benchmarks.add(sourceBm);
                 sourceBm.setVValue(level_from-1);
                 int this_num=1;
                 
                 if (num_from>=num_to){
                    this_num=num_from/2;
                    
                 }
                 else{
                    this_num=num_to/2;
                 }
                 if (this_num<1) {this_num=1;}

                sourceBm.setH2Value(this_num);
                int total_related = 0;
                total_related=num_to+num_from;
				
                svgOutput = createSVGMap2(objectID, benchmarks, gradeList, strandList, bmWidth, bmHeight, col, intersection, total_related);
              }
              else if ((type.equalsIgnoreCase("Grade Group"))){

            	process_grade(benchmarks, gradeList, strandList, true);
            	
            	svgOutput = createSVGMap(objectID, benchmarks, gradeList, strandList, bmWidth, bmHeight, col, false);
                        
              }  // end of if for a grade group
              else if ((type.equalsIgnoreCase("strand")))
              {
                process_strand(benchmarks, gradeList, strandList);
                svgOutput = createSVGMap(objectID, benchmarks, gradeList, strandList, bmWidth, bmHeight, col, false);
               }  // end of if for a strand
              else if (type.equalsIgnoreCase("Map"))
              {
            	  
            	  process_grade(benchmarks, gradeList, strandList, true);
            	  svgOutput = createSVGMap(objectID, benchmarks, gradeList, strandList, bmWidth, bmHeight, col, false);
                 }  // end of if: in this case, it draws a map  
                  else
                  {
                    throw new InvalidIDException();
                  }
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		return svgOutput;
                // end of else: in this case, not draw the related BMs
       

    }  // end of method
    
    private static HashMap<String, benchmark> createBenchmarks(QueryExecutor qe, String type, String baseId) throws Exception {
    	
    	HashMap<String, benchmark> benchmarkMap = new HashMap<String, benchmark>();
    	String containmentQuery = "select object_ID, Name, primary_grade, description, aaas_code, keywords, subjects, grade_description, grade_id, strand_id, strand_description, strand_pos, 'contained_in' as relationToSource "+
    				   "from objects o, relation strandrelation, relation graderelation,(%s) as strand, (%s) as grade "+
    				   "where o.object_type='benchmark' and strand.strand_id=strandrelation.ItemID2 and strandrelation.ItemID1=o.object_ID and "+
    						"grade.grade_id=graderelation.ItemID2 and graderelation.ItemID1=o.object_ID and "+
    						"strandrelation.ItemID1 = graderelation.ItemID1";
    	String query = null;
    	String strandQuery = null;
    	String gradeQuery = null;

    	
    	if(type.equalsIgnoreCase("map"))
    	{
    		strandQuery = "SELECT description as strand_description, o.object_ID as strand_id, pos as strand_pos " +
    					  "FROM objects o, relation r, strandpos s " +
    					  "where o.object_ID = r.ItemID1 and r.ItemID2='%s' and o.object_type = 'strand' and s.object_ID=o.object_ID";
    		gradeQuery = "SELECT description as grade_description, object_ID as grade_id "+
    					 "FROM objects o, relation r "+
    					 "where o.object_id = r.ItemID1 and r.ItemID2='%s' and o.object_type = 'grade group'";
    		gradeQuery = String.format(gradeQuery, baseId);
    		strandQuery = String.format(strandQuery, baseId);
    		
    		query = String.format(containmentQuery, strandQuery, gradeQuery);
    	}
    	else if(type.equalsIgnoreCase("strand"))
    	{
    		strandQuery = "SELECT description as strand_description, o.object_ID as strand_id, pos as strand_pos " +
			  "FROM objects o, strandpos s " +
			  "where o.object_ID = '%s' and o.object_type = 'strand' and s.object_ID=o.object_ID ";
    		gradeQuery = "SELECT description as grade_description, object_ID as grade_id "+
			 "FROM objects o "+
			 "where o.object_type = 'grade group'";
    		strandQuery = String.format(strandQuery, baseId);
    		
    		query = String.format(containmentQuery, strandQuery, gradeQuery);
    	}
    	else if(type.equalsIgnoreCase("grade group"))
    	{
    		strandQuery = "SELECT description as strand_description, o.object_ID as strand_id, pos as strand_pos " +
			  "FROM objects o, strandpos s, relation r " +
			  "where o.object_type = 'strand' and s.object_ID=o.object_ID and r.ItemID1=o.object_ID and r.ItemID2 = "+
			  		  "(select object_id " +
			  		   "from relation, objects "+
			  		   "where relation.ItemID1='%s' and relation.ItemID2=objects.object_ID)";
    		strandQuery = String.format(strandQuery, baseId);
    		
    		gradeQuery = "SELECT description as grade_description, object_ID as grade_id "+
			 "FROM objects o " +
			 "where o.object_id = '%s' and o.object_type = 'grade group'";
    		gradeQuery = String.format(gradeQuery, baseId);
    		
    		query = String.format(containmentQuery, strandQuery, gradeQuery);
    	}
    	else if(type.equalsIgnoreCase("benchmark"))
    	{
    		query = "select o.object_ID, Name, primary_grade, description, aaas_code, keywords, subjects, 'n/a' as grade_description, 'n/a' as grade_id, 'n/a' as strand_id, 'n/a' as strand_description, 'n/a' as strand_pos, relationToSource "+
    			    "from objects o, "+
						"("+
						"Select Distinct ItemID2 as object_ID, 'to' as relationToSource from relation where ItemID1='%s' and (RelationType='Contributes to achieving' or RelationType='Contributes to and relies upon') "+
						"union "+
						"Select Distinct ItemID1 as object_ID, 'from' as relationToSource from relation where ItemID2='%s' and (RelationType='Contributes to achieving' or RelationType='Contributes to and relies upon') "+
						"union " +
						"Select '%s' as object_ID, 'self' as relationToSource) as relations " +
						"where o.object_ID = relations.object_ID ";
    		query = String.format(query, baseId,baseId,baseId);
    	}
    	else if(type.equalsIgnoreCase("intersection"))
    	{
    		String[] ids = baseId.split(":");
    		String id1 = ids[0].trim();
    		String id2 = ids[1].trim();
            
            query = "select R.ItemID1 from relation R where R.ItemID1=O.object_ID and R.ItemID2='%s' and R.ItemID1='%s'";
            query = String.format(query, id1, id2); 

    	}
    	else
    	{
    		return null;
    	}
    	ResultSet rs=qe.executeRawSearch(query);
    	
    	ArrayList<String> idList = new ArrayList<String>();
        while(rs.next())
        {
       	 	String id=rs.getString(1);
       	 	String strandPosition = rs.getString(12);
       	 	String strandId = rs.getString(10);
       	 	String strandName = rs.getString(11);
       	 	if(benchmarkMap.containsKey(id))
       	 	{
       	 		benchmark aBenchmark = benchmarkMap.get(id);
       	 		aBenchmark.addStrand(strandId, strandName, strandPosition);
       	 		continue;
       	 	}
       	 	String name=rs.getString(2);
            String grade=rs.getString(3);
            String text=rs.getString(4);
            String code=rs.getString(5);
            String keywords=rs.getString(6);
            String subjects=rs.getString(7);
            benchmark aBenchmark = new benchmark(id,name,grade,text,code,keywords,subjects);

            String gradeDescription=rs.getString(8);
            String gradeId=rs.getString(9);
            
            aBenchmark.setGradeDes(gradeDescription);
            aBenchmark.setGradeID(gradeId);
            aBenchmark.addStrand(strandId, strandName, strandPosition);
            String relationToSource = rs.getString(13);
            aBenchmark.setRelationToSource(relationToSource);

        	benchmarkMap.put(id, aBenchmark);
        	idList.add(id);
        }
        
        String idsAsSqlString = StringUtils.join(idList.iterator(), "','");
        String SQLStatement =  " select distinct ItemID1, ItemID2,relationType from relation R where (R.mapExclusion NOT LIKE '%" + baseId + "%' OR R.mapExclusion IS NULL) AND (R.relationType='Contributes to achieving' or R.relationType='Contributes to and relies upon') and ItemID1 in ('"+idsAsSqlString+"') and ItemID2 in ('"+idsAsSqlString+"')";

         rs=qe.executeRawSearch(SQLStatement);
         while (rs.next())
         {
             String ID1=rs.getString(1);
             String ID2=rs.getString(2);
             String ID3=rs.getString(3);
            
             benchmark aBenchmark1 = benchmarkMap.get(ID1);
             benchmark aBenchmark2 = benchmarkMap.get(ID2);
        	 
             aBenchmark1.addToBenchmark(aBenchmark2);
             
             aBenchmark2.addFromBenchmark(aBenchmark1);

             aBenchmark1.addToBenchmarkType(ID3);
             aBenchmark1.addFromBenchmarkType(ID3);
         }
          rs.close();
		return benchmarkMap;
	}

    private  static boolean conflict(seat s1, seat s2){
       int x1, x2,y1,y2;
       x1=s1.getX();
       x2=s2.getX();
       y1=s1.getY();
       y2=s2.getY();

       return true;

   }  // end of method

  
   private static  ArrayList<benchmark> rootList(ArrayList<benchmark> currentPool){

       ArrayList<benchmark> my_list = new ArrayList<benchmark>();
       benchmark my_b, temp_b;
       boolean isroot;
       //System.out.println("currentPool size is: "+ currentPool.size());
       for (int i=0;i<currentPool.size();i++){
           my_b= currentPool.get(i);
           isroot=true;

           for (int j=0;j<my_b.getToBenchmark().size();j++){
               temp_b=my_b.getToBenchmark().get(j);
               if (currentPool.contains((Object)temp_b)){
                   isroot=false;
                   break;
               }

           }
           if (isroot){ my_list.add(my_b);}


       }
       return my_list;
   }  // end of rootList

   
   
   private static void setH(ArrayList<benchmark> org_process_list, 
		   HashMap<String, ArrayList<benchmark>> hCache,
		   int strandPosition)
   {
	   
      // Figure out the correct order, by making sure if a benchmark is split between to strands
      // its 
	  ArrayList<benchmark>  process_list = new ArrayList<benchmark>();
	   
      for(benchmark bm: org_process_list)
      {
    	  if(bm.getDisplayableStrands().size()>1)
    	  {
    		  if(strandPosition==bm.getHighestStrandPos())
    			  process_list.add(0, bm);
    		  else
    			  process_list.add(bm);
    	  }
    	  else
    	  {
    		  // We want to make sure the benchmarks that do span more then one
    		  // strand are at the beginning or the end of the list, respectively
    		  // to do that we force the other ones to be in the middle somewhere
    		  if(process_list.size()==0)
    			  process_list.add(0, bm);
    		  else
    			  process_list.add(1, bm);
    	  }
      }
      
      Collections.reverse(process_list);
      
      double possibleH = 5;

      for(benchmark bm: process_list)
      {
    	  possibleH--;
    	  possibleH = (int)possibleH;
    	  
    	  double multipleStrandDirection = 0;
    	  
    	  if(bm.getDisplayableStrands().size()>1)
    	  {
    		  if(strandPosition==bm.getHighestStrandPos())
    		  {
    			  multipleStrandDirection = -1;
    		  }
    		  else
    			  multipleStrandDirection = 1;
    		  bm.setSetForStrandSpan(true);
    		  
    		  possibleH+=(multipleStrandDirection*SMALL_H_MOVEMENT);
    	  }
    	  
           // Make sure that lines that are draw are not going to go through each other

        	  boolean foundSpot = false;
	          while(!foundSpot)
	           {
	            	
	            	foundSpot = true;
	            	
	            	
	            	if(!hCache.containsKey(String.valueOf(possibleH)))
	            		hCache.put(String.valueOf(possibleH), new ArrayList<benchmark>());
	            	
	            	
	            	ArrayList<benchmark> currentBenchmarksInH = hCache.get(String.valueOf(possibleH));
		            for(int cacheIndex=0; cacheIndex<currentBenchmarksInH.size(); cacheIndex++)
		            {
		            	benchmark aBenchmark = currentBenchmarksInH.get(cacheIndex);
		            	if(bm.getToBenchmark().contains(aBenchmark))
		            	{
		            		
		            		// If its not the last H benchmark this benchmark cannot go here
		            		if(cacheIndex!=currentBenchmarksInH.size()-1 && possibleH>=1)
		            		{

		            			possibleH-=1;
		            			bm.setSetForStrandSpan(false);
		            			foundSpot = false;
		            			break;
		            		}		
		            	}
		            }
	            }
	        hCache.get(String.valueOf(possibleH)).add(bm);
          	bm.setH2Value(possibleH);
            
      }  // end of if BM>1
       
      
   
   
   
}  // end of method setH

   
   
   private static void process_grade(ArrayList<benchmark> benchmarks, ArrayList<Grade> gradeList, 
		   ArrayList<Strand> strandList, boolean setGrades)
   {
	   int totalLevel = 0;
	   
	   ArrayList<HashMap<String, Object>>strands = new ArrayList<HashMap<String,Object>>();
	   for(int i=0;i<7;i++)
	   {
		   HashMap<String, Object> strand = new HashMap<String, Object>();
		   strand.put("benchmarks", new ArrayList<benchmark>());
		   strand.put("active", null);
		   strands.add(strand);
	   }
	   
	   
	   String[] gradeLevels = {"grades 9-12", "grades 6-8", "grades 3-5", "grades K-2"};
	   List<String>gradeLevelsList = Arrays.asList(gradeLevels);
	   
	   for(String gradeDescription: gradeLevelsList)
	   {
		  
		   ArrayList<benchmark> gradeBenchmarks = new ArrayList<benchmark>();
		   benchmark aBenchmark = null;
		   for(benchmark bm: benchmarks)
		   {
			   if(bm.getGradeDes().equals(gradeDescription))
			   {
				   gradeBenchmarks.add(bm);
				   aBenchmark = bm;
			   }
		   }
		   if(aBenchmark==null)
			   continue;
		   
		   if(setGrades)
		   {
			   Grade gt1 = gradeList.get(gradeLevelsList.indexOf(gradeDescription));
			   gt1.setID(aBenchmark.getGradeID());
	           gt1.setName(aBenchmark.getGradeDes().replace("grades ", ""));
	           gt1.setV(totalLevel+1);
		   }
		   
			   
		   ArrayList<benchmark> current_process= (ArrayList<benchmark>) gradeBenchmarks.clone();
		   
		   // This is how we set dependencies. If a benchmak depends on another one. We need to 
		   // make the sure tehe dependency is below it on the map. To do this we figure out
		   // which benchmarks do not contribute to any other benchmark. Make those the first level
		   // Remove them from the list. Then find the next ones
		   while (current_process.size()>0)
            {
			   ArrayList<benchmark> current_root = rootList(current_process);
			   totalLevel++;
                for(int j=0;j<current_root.size();j++)
                {
                    benchmark myBM = current_root.get(j);
                    myBM.setVValue(totalLevel);
                    current_process.remove(myBM);
                } 
            }  
		    
		// set strands 
		   for(benchmark bm:gradeBenchmarks)
		   {
			   for(HashMap<String,String> strand : bm.getDisplayableStrands())
			   {
				   if (!strand.get("pos").equals("No Pos"))
	           	   {
					    int strandPos = Integer.parseInt(strand.get("pos"));
	           			int index = strandPos-1;
	           			Strand st = strandList.get(index);
	           			
		                st.setName(strand.get("name"));
		                st.setID(strand.get("id"));
		                // add it to the correct strand, note we add a cloned benchmark to the other strand
		                // it belongs to if the benchmark spans. This way we save a space for it in the other strand
		                // so no other benchmark is put there
		                ArrayList<benchmark> strandBenchmarks = ((ArrayList<benchmark>)strands.get(index).get("benchmarks"));
		                if(bm.isAddedToStrand())
		                {
		                	benchmark clonedBm = bm.clone();
		                	strandBenchmarks.add(clonedBm);
		                }
		                else
		                {
		                	bm.setAddedToStrand(true);
		                	strandBenchmarks.add(bm);
		                }
		                strands.get(index).put("active", "true");
	           		}
	           }
		   }   
	   }

	   // Loop through all the strands, levels then benchmarks placing them best as we can with respect
	   // to the other benchmarks that are in the its strand and grade. We are not worrying about how they
	   // relate to each other yet
		for(HashMap<String, Object> strand: strands)
		{
			if(strand.get("active")==null)
				continue;
			HashMap<String, ArrayList<benchmark>> hCache = new HashMap<String, ArrayList<benchmark>>();
			
			for (int m=1;m<=totalLevel;m++)
			{ 
				
				ArrayList<benchmark> benchmarksToSet = new ArrayList<benchmark>();
				for (benchmark benchmark: (ArrayList<benchmark>)strand.get("benchmarks"))
				{
					if (benchmark.getVValue()==m  )
					{
						benchmarksToSet.add(benchmark);
					}
				}
				int strandPos = strands.indexOf(strand)+1;
				setH(benchmarksToSet, hCache, strandPos);
			}
			
		}
		
		// Now we align all the strands levels to each other by finding the minV. Making sure
		// that what ever shift is decided on that the minV will be 1 or the small H movement.
		// Then shift all benchmark levels according that shift
		for(HashMap<String, Object> strand: strands)
		{
			if(strand.get("active")==null)
				continue;
			double minV = 100;
			for (benchmark benchmark: (ArrayList<benchmark>)strand.get("benchmarks"))
			{
				if(benchmark.getH2Value()<minV)
					minV = benchmark.getH2Value();
			}
			
			
			if(minV!=1 && minV!=SMALL_H_MOVEMENT)
			{
				int shift = 1 - (int)minV;
				
				for (benchmark benchmark: (ArrayList<benchmark>)strand.get("benchmarks"))
				{
					benchmark.setH2Value(benchmark.getH2Value()+shift);
				}
			}
		}
		
		// align all the strands together by shifting each other over. By the max V for each corresponding
		// strand
		double currentShift = 0;
		for(HashMap<String, Object> strand: strands)
		{
			if(strand.get("active")==null)
				continue;
			int maxV = 0;
			for (benchmark benchmark: (ArrayList<benchmark>)strand.get("benchmarks"))
			{
				benchmark.setH2Value(benchmark.getH2Value()+currentShift);
				
				if((int)benchmark.getH2Value()>maxV)
					maxV = (int)benchmark.getH2Value();
			}
			int index = strands.indexOf(strand);
			int basePosition = (int)currentShift+1;
			strandList.get(index).setV(basePosition);

			strand.put("basePosition", Integer.valueOf(basePosition));
			strand.put("maxV", Integer.valueOf(maxV));
			currentShift = maxV;
		}
		
		// Finally shift all benchmarks that span more then one strand where they should be. Note
		// we only can at most do this for one direction per strand and level. Otherwise it will overlap
		// thats why we use caches to keep track of it.
		for(HashMap<String, Object> strand: strands)
		{
			if(strand.get("active")==null)
				continue;
			
			ArrayList<Integer> levelSpansForward = new ArrayList<Integer>();
			ArrayList<Integer> levelSpansBackwards = new ArrayList<Integer>();
			int currentStrandPos = strands.indexOf(strand)+1;
			int strandBaseH2Value = (Integer)strand.get("basePosition");
			int strandMaxH2Value = (Integer)strand.get("maxV");
			for (benchmark benchmark: (ArrayList<benchmark>)strand.get("benchmarks"))
			{
				Integer level = Integer.valueOf(benchmark.getVValue());
				if(benchmark.isSetForStrandSpan())
				{
					if(benchmark.getHighestStrandPos()==currentStrandPos && 
							levelSpansBackwards.contains(level))
					{
						levelSpansBackwards.add(level);
						benchmark.setH2Value(strandBaseH2Value-SMALL_H_MOVEMENT);
					}
					else
					{
						levelSpansForward.add(level);
						benchmark.setH2Value(strandMaxH2Value+SMALL_H_MOVEMENT);
					}	
				}
				
			}
		}
		
		// Now that the entire map is combined and something we can display, we try to do a 
		// little shifting around to fix any lines that flow through other lines
		// This is not fool proof, we only can do this if it won't ruin our arrows going up
		// and down
		fixDiagonalLines(benchmarks);
		
   }

   /*
    * Fix the diagnoal lines that overlap. If they overlap we bring the benchmark - minus SMALL_H_MOVEMENT
    * , if that doesn't work we add SMALL_H_MOVEMENT. If that is not possible we do nothing.
    */
   private static void fixDiagonalLines(ArrayList<benchmark> benchmarks)
   {
	   for (benchmark benchmark: benchmarks)
	   {
		   double originalH = benchmark.getH2Value();
		   double [] possibleHArray = {originalH, originalH-SMALL_H_MOVEMENT, 
				   originalH+SMALL_H_MOVEMENT};
		   
		   for(double possibleH: possibleHArray)
		   {
			   if(hValueOverlaps(benchmarks, benchmark, possibleH))
				   continue;
			   
			   if( !hasOverlapLinesConflict(benchmark, possibleH, 
					   benchmark.getVValue()))
					   {
				   			benchmark.setH2Value(possibleH);
				   			break;
					   }
		   }
	   }
   }
   
   /*
    * Find out if any diagnoal lines follow the same slope through benchmarks.
    * We can do this by just comparing the ratios between the h and v values comparing
    * all the toBenchmarks and from benchmarks
    * @param alignedBenchmark
    * @param possibleH
    * @param vValue
    * @return
    */
   private static boolean hasOverlapLinesConflict(
		benchmark alignedBenchmark, double possibleH, int vValue) {
	   List<List<benchmark>> benchmarkListsToCheck = new ArrayList<List<benchmark>>();
	   benchmarkListsToCheck.add(alignedBenchmark.getToBenchmark());
	   benchmarkListsToCheck.add(alignedBenchmark.getFromBenchmark());
	  
	   for(List<benchmark> benchmarkList:benchmarkListsToCheck)
	   {
		   List<Double> ratios = new ArrayList<Double>();
		   for(benchmark aBenchmark:benchmarkList)
		   {
			   double hDiff = possibleH-aBenchmark.getH2Value();
			   double vDiff = vValue - aBenchmark.getVValue();
			   
			   // V diff zero would mean its above. That was already taken care of
			   // lines that cross on the same level we really can't fix, possibly a
			   // new feature but its based on levels are defined as certain values
			   if(vDiff==0||hDiff==0)
				   continue;
				   
			   Double ratio = new Double(hDiff/vDiff);
			   if(ratios.contains(ratio))
			   {
				   return true;
			   }
				ratios.add(ratio);
		   }
	   }
	   return false;
	   
   }

   /**
    * figure out of the possible h for a benchmark conflicts with any other benchmarks
    * on that level
    * @param benchmarks
    * @param alignedBenchmark
    * @param possibleH
    * @return
    */
   private static boolean hValueOverlaps(ArrayList<benchmark> benchmarks,
		benchmark alignedBenchmark, double possibleH) {
	
	   for(benchmark aBenchmark: benchmarks)
       {
		   // If we are comparing the benchmark in question or if the benchmark is not in the same
		   // row no need to worry about it
		   if(aBenchmark==alignedBenchmark || 
				   aBenchmark.getVValue()!=alignedBenchmark.getVValue())
			   continue;
		   
           double h2Value = aBenchmark.getH2Value();
           double minLevel = h2Value-SMALL_H_MOVEMENT;
           double maxLevel = h2Value+SMALL_H_MOVEMENT;

           if(possibleH>=minLevel && possibleH<=maxLevel)
           {
        	   return true;
                   
           }
       }  
	return false;
   }

private static void process_strand(ArrayList<benchmark> benchmarks, ArrayList<Grade> gradeList, 
		ArrayList<Strand> strandList)
   {

        ArrayList<benchmark> processPool = new ArrayList<benchmark>();
        processPool = (ArrayList<benchmark>) benchmarks.clone();
        ArrayList<benchmark> myPool = new ArrayList<benchmark>();
            
            
        //---- The pool for each grade
        ArrayList<benchmark> first_list = new ArrayList<benchmark>();
        ArrayList<benchmark> second_list = new ArrayList<benchmark>();
        ArrayList<benchmark> third_list = new ArrayList<benchmark>();
        ArrayList<benchmark> fourth_list = new ArrayList<benchmark>();

        // assign benchmark to each list:
        benchmark localBM;
        
        // All benchmarks will belong to the same strand, Therefore we just want to set the first
        // strand to the name and id, so it will be displayed in the strand image
        if(benchmarks.size()>0)
        {
        	HashMap<String, String> bmStrand = benchmarks.get(0).getDisplayableStrands().get(0);
        	Strand strand = strandList.get(0);
        	strand.setName(bmStrand.get("name"));
        	strand.setID(bmStrand.get("id"));
        	strand.setV(1);
        }
        
        for (int i=0;i<processPool.size();i++)
        {
            localBM=processPool.get(i);
            if (localBM.getGradeDes().equals("grades 9-12"))
            {
                 first_list.add(localBM);
                 myPool.add(localBM);
                 
                 
                 
            }
            
            if (localBM.getGradeDes().equals("grades 6-8"))
            {
                 second_list.add(localBM);
                 myPool.add(localBM);
                
                 
            }
            
            if (localBM.getGradeDes().equals("grades 3-5"))
            {
                 third_list.add(localBM);
                 myPool.add(localBM);
                
                 
            }
            
            if (localBM.getGradeDes().equals("grades K-2"))
            {
                 fourth_list.add(localBM);
                 myPool.add(localBM);
                
                 
            }
            
            if (localBM.getGradeDes().equals("No Grade"))
            {
                 
                //System.out.println("fourthgrade:"+fourth_list.size());
            }
            
//          System.out.println("first Strands size"+first_list.size());
            
            
            
        }  // end of for loop
        
        
       
        ArrayList<benchmark> current_root = new ArrayList<benchmark>();
        ArrayList<benchmark> current_process = new ArrayList<benchmark>();
        
        
        int currentV=0;
        current_process = (ArrayList<benchmark>) first_list.clone();
            
        boolean firstSet=false,secondSet=false,thirdSet=false,fourthSet=false;
        
        while (current_process.size()>0)
        {
           current_root = rootList(current_process);
           if (firstSet==false)
           {  
            firstSet=true;
            Grade myGt = (Grade)gradeList.get(0);
//          System.out.println("Set grade lable at: "+currentV);
              
            myGt.setV(currentV+1);
            myGt.setID((current_root.get(0)).getGradeID());
            myGt.setName(( current_root.get(0)).getGradeDes());
           }  // end of if set
              
            
            
            currentV++;
            // assign vertical level to each BM:
            for(int j=0;j<current_root.size();j++)
            {
                benchmark myBM = current_root.get(j);
                myBM.setVValue(currentV);
                current_process.remove(myBM);
                
                
                
            }
        }
        
    
        
    current_process = (ArrayList<benchmark>) second_list.clone();
            
    while (current_process.size()>0)
    {
        current_root = rootList(current_process);
                
        if (secondSet==false)
        {  
         secondSet=true;
         Grade myGt = gradeList.get(1);
//       System.out.println("Set grade lable at: "+currentV);
              
         myGt.setV(currentV+1);
         myGt.setID((current_root.get(0)).getGradeID());
         myGt.setName((current_root.get(0)).getGradeDes());
        }  // end of if set
              
        
        
        currentV++;
        // assign vertical level to each BM:
        for(int j=0;j<current_root.size();j++)
        {
            benchmark myBM = current_root.get(j);
            myBM.setVValue(currentV);
            current_process.remove(myBM);
                
                
                
        }
    }
    
    current_process = (ArrayList<benchmark>) third_list.clone();
            
    while (current_process.size()>0)
    {
        current_root = rootList(current_process);
        if (thirdSet==false)
        {  
         thirdSet=true;
         Grade myGt = gradeList.get(2);
//       System.out.println("Set grade lable at: "+currentV);
              
         myGt.setV(currentV+1);
         myGt.setID(( current_root.get(0)).getGradeID());
         myGt.setName((current_root.get(0)).getGradeDes());
        }  // end of if set
              
        
        
        currentV++;
        // assign vertical level to each BM:
        for(int j=0;j<current_root.size();j++)
        {
            benchmark myBM = current_root.get(j);
            myBM.setVValue(currentV);
            current_process.remove(myBM);
                
                
                
        }
    }
    
    current_process = (ArrayList<benchmark>) fourth_list.clone();
            
    while (current_process.size()>0)
    {
        current_root = rootList(current_process);
        if (fourthSet==false)
        {  
            fourthSet=true;
            Grade myGt = gradeList.get(3);
//          System.out.println("Set grade lable at: "+currentV);
              
            myGt.setV(currentV+1);
            myGt.setID(( current_root.get(0)).getGradeID());
            myGt.setName((current_root.get(0)).getGradeDes());
        }  // end of if set
              
        currentV++;
        // assign vertical level to each BM:
        for(int j=0;j<current_root.size();j++)
        {
            benchmark myBM =  current_root.get(j);
            myBM.setVValue(currentV);
            current_process.remove(myBM);
                
                
                
        }
    }
	
	
    
    //  process h-level here:
    
    
    int total_level=currentV;
    int maxH=0,currentH=0;
    ArrayList<benchmark> cacheList = new ArrayList<benchmark>();
    for (int k=1;k<=total_level;k++)
        {
            currentH=0;
            
            // process kth vertical level:
            ArrayList<benchmark> h_process = new ArrayList<benchmark>();
            int hNum=0;  // number of benchmarks in this vertical level
            double H1=2.0;
            //System.out.println("size"+myPool.size());
            for (int j=0;j<myPool.size();j++)
                   {
                       benchmark BM =  myPool.get(j);
                       if (BM.getVValue()==k)  
                       { 
                            //cacheList.add(BM);
                            currentH++;
                            //System.out.println("process BM"+BM.getID()+"V value"+BM.getVValue());
                            
                            int totalNumH=0;
                            double totalH=0.0;
                            h_process.add(BM);
                            hNum++;
                            ArrayList<benchmark> toBM = new ArrayList<benchmark>();
                            toBM=BM.getToBenchmark();
                            for (int l=0;l<toBM.size();l++)
                            
                            {
                                benchmark cBM =toBM.get(l); 
                                if (myPool.contains(cBM))
                                {
                                    totalH=cBM.getH2Value()+totalH;
                                    totalNumH++; 
                                    //System.out.println(BM.getID()+ "toBM"+cBM.getID());
                                        
                                } // end of if
                                
                            }  // end of for loop l
                            double H2=0.0;
                            if (totalNumH>0)
                            {
                                H2=totalH/((double)totalNumH);
                                //System.out.println(totalH+"total num"+totalNumH);
                            }
                            else
                            { 
                                //System.out.println("wrong with root");
                                H2=H1;
                                H1=H1+2;
                                //System.out.println(H2);
                                
                            }
                            
                            BM.setHValue(H2);
                            
                            //int H=(int)(H2+0.5);
                            //BM.setH2Value(H);
                            
                            
                        }  //end of if
                       
                       
                   }  // end of for loop  j 
                   
                   if (currentH>maxH) {maxH=currentH;}
                    //System.out.println("v level:"+k+"num of BMs:"+currentH);
                   // calculate H for BMs in this v-level:
                   ArrayList<benchmark> sorted= sortByH(h_process);
                   
                   //for(int index=0;index < h_process.size();index++)
                    //System.out.println("sorted : "+sorted.get(index)+"\nh_process : "+h_process.get(index));
                   
                   ArrayList<benchmark> h2_process = new ArrayList<benchmark>();
                   //System.out.println("sorted list:"+(sorted.get(0)).getHValue());
                   double space=(((double)maxH)*2.0+1.0)/((double)sorted.size());
                   int initial=0,finalS=0;
                   //System.out.println("level:"+k+";previous list size:"+cacheList.size());
                   for (int i=0;i<sorted.size();i++)
                   {
                      benchmark hBM = sorted.get(i);
                      if (((int)((space+1.0)/2))>2)
                      {
                        initial=((int)((space+1.0)/2));
                      }
                      else
                      {
                        initial=2+i*(int)space;
                      }  
                      if (!checkAva(initial,cacheList))
                      {
                           initial--;
                           //System.out.println("conflict detect");
                           
                            
                      }
                      finalS=initial;
                      
                      hBM.setH2Value(finalS);
                     // System.out.println("do I get here?");
                     // System.out.println("benchmarkID: "+hBM.getName()+";v level"+hBM.getVValue()+";set h2 level:"+finalS);   
                      h2_process.add(hBM);
                      
                   }  // end of for loop i
                   
                   cacheList.clear();
                   cacheList= (ArrayList) h2_process.clone();
        
        }  //end of for loop k
    
    double minH = 100;
    for (int j=0;j<myPool.size();j++)
    {
        benchmark BM =  myPool.get(j);
        if(BM.getH2Value()<minH)
        	minH = BM.getH2Value();
    
    }
        	
    if(minH!=1)
	{
		int shift = 1 - (int)minH;
		
		for (int j=0;j<myPool.size();j++)
	    {
	        benchmark BM =  myPool.get(j);
	        BM.setH2Value(BM.getH2Value()+shift);
		}
	}
    
    
   }  // end of function
   
   private static boolean checkAva(double s, ArrayList<benchmark> cache)
   {
      boolean result=true;
      for (int i=0;i<cache.size();i++)
      {
            if (s==(cache.get(i)).getH2Value())  
            {
                result=false;
                //System.out.println("previous conflict BM:"+((cache.get(i)).getName())+";H value:"+((cache.get(i)).getH2Value())+";");
            }
      }
      //System.out.println(result);
      return result;
    
   }
   
   private static ArrayList<benchmark> sortByH(ArrayList<benchmark> my_process)
   {
	   //System.out.println("This method: sortByH is called");
	   ArrayList<benchmark> sorted = new ArrayList<benchmark>();
      while (my_process.size()>0)
      {
        benchmark BM= my_process.get(0);
        for (int j=1;j<my_process.size();j++)
        {
            if (BM.getHValue()>(my_process.get(j)).getHValue())
            {
                BM= my_process.get(j);
            }   
        }
        my_process.remove(BM);
        sorted.add(BM);
        
      }

      return sorted;
   }


   private static String createSVGMap(String objectID, ArrayList<benchmark> benchmarks,  ArrayList<Grade> gradeList, ArrayList<Strand> strandList, double bmWidth, double bmHeight, String col, boolean intersection) throws Exception{
        double width, height;
        double box_w=bmWidth, box_h=bmHeight;
        double white_ratio=1.1;

		//System.out.println("width is"+box_w);
		
        double v_scale=0.0, h_scale=0.0;
        int maxV=0;
        double minH=100.0, maxH=-2.0;
        
        Aggregate outs2 = new Aggregate();
        
        
        for (benchmark curr_b: benchmarks){

			if ((curr_b.getID().equals("SMS-BMK-0842"))&& (objectID.equals("SMS-MAP-2554")))
			{
				curr_b.setH2Value(13);
			}
			
			if ((curr_b.getID().equals("SMS-BMK-0845"))&& (objectID.equals("SMS-MAP-2554")))
			{
				curr_b.setH2Value(11);
			}
			
			if ((curr_b.getID().equals("SMS-BMK-0843"))&& (objectID.equals("SMS-MAP-2554")))
			{
				curr_b.setH2Value(13);
			}
			
			if ((curr_b.getID().equals("SMS-BMK-0844"))&& (objectID.equals("SMS-MAP-2554")))
			{
				curr_b.setH2Value(7);
			}
			
			if ((curr_b.getID().equals("SMS-BMK-0772"))&& (objectID.equals("SMS-MAP-2554")))
			{
				curr_b.setH2Value(9);
			}
					
						
			//System.out.println("Benchmark is:"+curr_b.getID());
			//System.out.println("H2 Value is: " +curr_b.getH2Value()+" AND in Strand: "+curr_b.getStrandName());

			
            if (maxV<curr_b.getVValue()){
                maxV=curr_b.getVValue();
            }
            if (minH>curr_b.getH2Value()){ minH=(double)curr_b.getH2Value(); }
            if (maxH<curr_b.getH2Value()){ maxH=(double)curr_b.getH2Value(); }

        }  // end of for
        
		
        maxV=maxV+2;
        maxH=maxH+2.0;
        height=((double)maxV)*white_ratio*box_h;
        width=((double)maxH)*white_ratio*box_w;
        
        //------------:)
        
        
        //------------:(
        
        //outs2 = new PrintWriter(new FileOutputStream("C:\\Program Files\\Apache Tomcat 4.0\\webapps\\examples\\MYJSP\\"+filename),true);
        
        
//        outs2.println("<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>"  + " <!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 1.0//EN\" \"http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd\">"+"<svg xmlns:cms=\"http://sms.dlese.org\" xmlns:xlink=\"http://www.w3.org/1999/xlink\"  xmlns=\"http://www.w3.org/2000/svg\" width=\""+width+"\" height=\""+height+"\" onload=\"\">");
        outs2.println("<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>"+"<svg xmlns:xlink=\"http://www.w3.org/1999/xlink\" xmlns=\"http://www.w3.org/2000/svg\" width=\""+width+"\" height=\""+height+"\" onload=\"\">");
        
    outs2.println("<script language=\"text/ecmascript\">");
    outs2.println("<![CDATA[");
    outs2.println("function mouseOverColor(evt)"); 
    outs2.println("{");
    outs2.println("evt.target.setAttribute(\"stroke\", \"black\");");
    outs2.println("evt.target.setAttribute(\"stroke-width\",1)");
    outs2.println("}");
    outs2.println("function mouseOutColor(evt)"); 
    outs2.println("{");
    outs2.println("evt.target.setAttribute(\"stroke\", \"none\");");
    outs2.println("evt.target.setAttribute(\"stroke-width\",0)");
    outs2.println("}");

    
    
    outs2.println("]]>");
    outs2.println("</script>");
    
        

        outs2.println("\n<g transform=\"translate(140,40)\">");
        
        //post_process();


        v_scale=height/(double)maxV;
        h_scale= width/(maxH-minH);
        //System.out.println("V: "+v_scale+ ",  H:  "+h_scale);
        
        
        //#########################################################
        // if we want to draw strand name, draw it here:

        
        
        double SX=0.0, BASE_SY=50.0;
        
        int stx=0,sty=0;
        //System.out.println("size of the strand list: "+StrandList.size());
        Strand st1 = (Strand)strandList.get(0);
        Strand st2 = (Strand)strandList.get(1);
        Strand st3 = (Strand)strandList.get(2);
        Strand st4 = (Strand)strandList.get(3);
        Strand st5 = (Strand)strandList.get(4);
		Strand st6 = (Strand)strandList.get(5);
		Strand st7 = (Strand)strandList.get(6);
        //System.out.println("st1 is: " +st1);
		
		// process the strand name positions:
		int strand1=0,strand2=0,strand3=0,strand4=0,strand5=0,strand6=0,strand7=0;
		int mypoint=0;
		boolean overlap=false;
		
		if (st1.getV()>0)
		{

			strand1=st1.getV();
		}
		
		// The rest we want to shift over the amount that we did for the benchmarks
		if (st2.getV()>0)
		{
			strand2=st2.getV();
		}
		
		if (st3.getV()>0)
		{
			strand3=st3.getV();
		}
		
		if (st4.getV()>0)
		{
			strand4=st4.getV();
		}
		
		if (st5.getV()>0)
		{
			strand5=st5.getV();
		}
		
		if (st6.getV()>0)
		{
			strand6=st6.getV();
		}
		
		if (st7.getV()>0)
		{
			strand7=st7.getV();
		}
		
		
		/*if ((strand1==strand2)||(strand1==strand3)||(strand1==strand4)||(strand1==strand5)||(strand2==strand3)||(strand2==strand4)||(strand2==strand5)||(strand3==strand4)||(strand3==strand5)||(strand4==strand5))
		{
			
			strand1=1;
			strand2=3;
			strand3=5;
			strand4=7;
			strand5=9;
			strand6=11;
			strand7=13;
			overlap=true;
			
			
		}
*/
	double SY = BASE_SY;
    if (intersection==false)
    {
        
        if (st1.getV()>0)
        {
            stx=strand1;
            SX=(double)(stx-minH)*h_scale;
            outs2.println("<a xlink:href=\""+st1.getID()+"\">");
            SY = displayStrandText(outs2, st1.getName(), st1.getID(), SX, BASE_SY, strand1, strand2);  
            outs2.println("</a>");  

            //System.out.println("Strand Name:"+st1.getName()+";   Strand Position"+stx);
			//System.out.println("Strand Name:"+st1.getName()+";   Strand Position"+SX);
        }
        
    if (st2.getV()>0)
    {
        stx=strand2;
        SX=(double)(stx-minH)*h_scale+5.0;
		if (st2.getName().equals("trade"))
		{
			SX=SX+200.0;
		}
		
		if (st2.getName().equals("nature of science"))
		{
			SX=SX+300.0;
		}
		
		
		
    //    System.out.println("draw second strand name here:"+SX);
        //System.out.println("draw strand name here:"+st1.getV()+"; "+st1.getName());
	
		
		if (st2.getName().equals("development and acceptance of scientific"))
		{
			
			st2.setName("development and acceptance of scientific ideas about evolution");
		}
        outs2.println("<a xlink:href=\""+st2.getID()+"\">");
        SY = displayStrandText(outs2, st2.getName(), st2.getID(), SX, BASE_SY, strand2, strand3);  
        outs2.println("</a>");  
        
        //System.out.println("Strand Name:"+st2.getName()+";   Strand Position"+stx);
        
    }
    
    if (st3.getV()>0)
    {
        stx=strand3;
        SX=(double)(stx-minH)*h_scale+25.0;
		if (st3.getName().equals("dependence of organisms on their environment"))
		{
			SX=SX-25.0;
		}
		
		

       // System.out.println("draw third strand name here:"+SX); 
        //System.out.println("draw strand name here:"+st1.getV()+"; "+st1.getName());
//      System.out.println("draw strand name here:"+st3.getV()+"; "+st3.getName()); 
        outs2.println("<a xlink:href=\""+st3.getID()+"\">");
        SY = displayStrandText(outs2, st3.getName(), st3.getID(), SX, BASE_SY, strand3, strand4);        
        outs2.println("</a>");  
        
        //System.out.println("Strand Name:"+st3.getName()+";   Strand Position"+stx);
            
            
    }
    
    if (st4.getV()>0)
    {
        stx=strand4;
        
        
        
        SX=(double)(stx-minH)*h_scale+40.0;
		
   //     System.out.println("draw fourth strand name here:"+st4.getV()); 
//      System.out.println("draw strand name here:"+st4.getV()+"; "+st4.getName());     
        outs2.println("<a xlink:href=\""+st4.getID()+"\">");
        SY = displayStrandText(outs2, st4.getName(), st4.getID(), SX, BASE_SY, strand4, strand5);  
        outs2.println("</a>");  
         
        //System.out.println("Strand Name:"+st4.getName()+";   Strand Position"+stx);
            
    }
    
    if (st5.getV()>0)
    {
        stx=strand5;
        SX=(double)(stx-minH)*h_scale-50.0;
        
       
        
     //   System.out.println("draw fifth strand name here:"+st5.getV()); 
        //System.out.println("draw strand name here:"+st1.getV()+"; "+st1.getName());
//      System.out.println("draw strand name here:"+st4.getV()+"; "+st4.getName());     
        outs2.println("<a xlink:href=\""+st5.getID()+"\">");
        SY = displayStrandText(outs2, st5.getName(), st5.getID(), SX, BASE_SY, strand5, strand6); 
        outs2.println("</a>");  
            
		//System.out.println("Strand Name:"+st5.getName()+";   Strand Position"+stx);    
    }
	
	 if (st6.getV()>0)
	    {
	        stx=strand6;
	        SX=(double)(stx-minH)*h_scale-50.0;
	        
	        	        
	     //   System.out.println("draw fifth strand name here:"+st5.getV()); 
	        //System.out.println("draw strand name here:"+st1.getV()+"; "+st1.getName());
//	      System.out.println("draw strand name here:"+st4.getV()+"; "+st4.getName());     
	        outs2.println("<a xlink:href=\""+st6.getID()+"\">");
	        SY = displayStrandText(outs2, st6.getName(), st6.getID(), SX, BASE_SY, strand6, strand7); 
	        outs2.println("</a>");  
	            
			//System.out.println("Strand Name:"+st6.getName()+";   Strand Position"+stx);    
	    }
		
	 
	 if (st7.getV()>0)
	    {
	        stx=strand7;
	        SX=(double)(stx-minH)*h_scale-50.0;
	        
	        SY=BASE_SY;
	        

	     //   System.out.println("draw fifth strand name here:"+st5.getV()); 
	        //System.out.println("draw strand name here:"+st1.getV()+"; "+st1.getName());
//	      System.out.println("draw strand name here:"+st4.getV()+"; "+st4.getName());     
	        outs2.println("<a xlink:href=\""+st7.getID()+"\">");
	        SY = displayStrandText(outs2, st7.getName(), st7.getID(), SX, BASE_SY, 1, 0); 

	        outs2.println("</a>");  
	            
			//System.out.println("Strand Name:"+st7.getName()+";   Strand Position"+stx);     
	    }
	
    
    //  draw the grade line here if we want:
    
    Grade gt1 = (Grade)gradeList.get(0);
    Grade gt2 = (Grade)gradeList.get(1);
    Grade gt3 = (Grade)gradeList.get(2);
    Grade gt4 = (Grade)gradeList.get(3);
    
    if (gt1.getV()>=0)
    {
        SX=((double)gt1.getV())*v_scale+10;
//      System.out.println("grade label at: "+ gt1.getV());
        

        outs2.println("<a xlink:href=\""+gt1.getID()+"\">");
        outs2.println("<text NS1:OID=\""+gt1.getID()+"\" NS1:gradeName=\""+gt1.getName()+"\" x=\"-100\" y=\""+SX+"\" NS1:width=\""+HEADER_FONT_METRICS.stringWidth(gt1.getName())+"\" NS1:height=\""+FONT_LINE_HEIGHT+"\" style=\""+GRADE_FONT_STYLE+"\" xmlns:NS1=\"http://sms.dlese.org\">"+gt1.getName()+"</text>");
        outs2.println("</a>");  
        //outs2.println("<line x1=\"0\" y1=\""+(SX-25)+"\" x2=\"150%\" y2=\""+(SX-25)+"\" style=\"stroke:gray;stroke-width:5;stroke-opacity:.6\"/>");
        
    }
    
    if (gt2.getV()>=0)
    {
        SX=((double)gt2.getV())*v_scale+15;

        outs2.println("<a xlink:href=\""+gt2.getID()+"\">");
        outs2.println("<text NS1:OID=\""+gt2.getID()+"\" NS1:gradeName=\""+gt2.getName()+"\" x=\"-100\" y=\""+SX+"\" NS1:width=\""+HEADER_FONT_METRICS.stringWidth(gt2.getName())+"\" NS1:height=\""+FONT_LINE_HEIGHT+"\" style=\""+GRADE_FONT_STYLE+"\" xmlns:NS1=\"http://sms.dlese.org\">"+gt2.getName()+"</text>");
        outs2.println("</a>");  

        outs2.println("<line x1=\"0\" y1=\""+(SX-25)+"\" x2=\"150%\" y2=\""+(SX-25)+"\" style=\"stroke:gray;stroke-width:5;stroke-opacity:.6\"/>");
        
    }
    
    if (gt3.getV()>=0)
    {
        SX=((double)gt3.getV())*v_scale+15;

        outs2.println("<a xlink:href=\""+gt3.getID()+"\">");
        outs2.println("<text NS1:OID=\""+gt3.getID()+"\" NS1:gradeName=\""+gt3.getName()+"\" x=\"-100\" y=\""+SX+"\" NS1:width=\""+HEADER_FONT_METRICS.stringWidth(gt3.getName())+"\" NS1:height=\""+FONT_LINE_HEIGHT+"\" style=\""+GRADE_FONT_STYLE+"\" xmlns:NS1=\"http://sms.dlese.org\">"+gt3.getName()+"</text>");
        outs2.println("</a>");  
        outs2.println("<line x1=\"0\" y1=\""+(SX-25)+"\" x2=\"150%\" y2=\""+(SX-25)+"\" style=\"stroke:gray;stroke-width:5;stroke-opacity:.6\"/>");
        
    }
    
    if (gt4.getV()>=0)
    {
        SX=((double)gt4.getV())*v_scale+15;
        outs2.println("<line x1=\"0\" y1=\""+(SX-25)+"\" x2=\"150%\" y2=\""+(SX-25)+"\" style=\"stroke:gray;stroke-width:5;stroke-opacity:.6\"/>");
    
        outs2.println("<a xlink:href=\""+gt4.getID()+"\">");
        outs2.println("<text NS1:OID=\""+gt4.getID()+"\" NS1:gradeName=\""+gt4.getName()+"\" x=\"-100\" y=\""+SX+"\" NS1:width=\""+HEADER_FONT_METRICS.stringWidth(gt4.getName())+"\" NS1:height=\""+FONT_LINE_HEIGHT+"\" style=\""+GRADE_FONT_STYLE+"\" xmlns:NS1=\"http://sms.dlese.org\">"+gt4.getName()+"</text>");
        outs2.println("</a>");  
            
    }
        
        
            
            
    }  // end of intersection if clause         
        
        
        //##########################################################
        
        
        
        for (benchmark curr_b: benchmarks){

            //System.out.println("BMID:"+curr_b.getID()+"  H2 position "+curr_b.getH2Value()+"  BM Strand Position: "+curr_b.getStrandPos());
            String text= curr_b.getText();
            double X=0.0,Y=0.0;
            X=((double)curr_b.getH2Value()-minH)*h_scale;
            X=X+(white_ratio-1.0)/2.0*box_w;

            Y=(double)curr_b.getVValue()*v_scale;
            // Y is center of block:
            Y=Y+white_ratio/2.0*box_h;

            //drawBox(X,Y,box_w,box_h,text,col,curr_b.getID(),curr_b.getKeywords(),curr_b.getSubjects());

            // draw the links from that box:
            for (int h=0;h<(curr_b.getToBenchmark()).size();h++){
                benchmark bb =  ((curr_b.getToBenchmark()).get(h));
                String linkType = (String) ((curr_b.getToBenchmarkType()).get(h));
                boolean doubleA = false;
                if (linkType.equalsIgnoreCase("Contributes to and relies upon"))
                {
                    doubleA=true;
                }
                
                if (!curr_b.conflict(bb))
                {
            
                if (benchmarks.contains((Object)bb)){

                    String text2 = bb.getText();
                    double X2=0.0,Y2=0.0;
                    X2=((double)bb.getH2Value()-minH)*h_scale;
                    X2=X2+(white_ratio-1.0)/2.0*box_w;

                    Y2=(double)bb.getVValue()*v_scale;
                    // Y is center of block:
                    Y2=Y2+white_ratio/2.0*box_h;
                    draw_link(outs2, bmWidth, bmHeight, doubleA,X,Y,X2,Y2,text,text2,(box_w+25),box_h,box_w);
                    
                    
                }
                
                }



            }

            
            
            
            
            
            

        }  // end of this for
        
//        System.out.println("draw map");
    for (benchmark curr_b: benchmarks){
                
                String text= curr_b.getText();
                double X=0.0,Y=0.0;
                X=((double)curr_b.getH2Value()-minH)*h_scale;
                X=X+(white_ratio-1.0)/2.0*box_w;

                Y=(double)curr_b.getVValue()*v_scale;
                // Y is center of block:
                Y=Y+white_ratio/2.0*box_h;

                drawBox(outs2, X,Y,box_w,box_h,text,col,curr_b.getID(),curr_b.getKeywords(),curr_b.getSubjects());
    }  // end of another for
        


        //---------------------------
        // end of file:
        outs2.println("</g>");
        
//      outs2.println("<use xlink:href=\"#map\" transform=\"translate(0,40)\"/>");
        


        
        outs2.println("</svg>");
//      outs2.close();

        return outs2.toString();


   }  // end of drawMap
   
   
   private static double displayStrandText(Aggregate outs, String strandText, String strandId, double startingX, 
		   double startingY, int startHOfStrand, int startHOfNextStrand)
   {
	   int columns = 0;
	   if(startHOfNextStrand==0)
		   columns = 3;
	   else
		   columns = startHOfNextStrand - startHOfStrand;

       ArrayList<String> lines = new ArrayList<String>();
       ArrayList<String> words = new ArrayList<String>();
      
       StringTokenizer tok = new StringTokenizer(strandText, " ");
       int lineLen = 0;
       while (tok.hasMoreTokens()) {
           String word = tok.nextToken();
           if (lineLen + word.length() > MAX_STRAND_NAME_PER_H*(columns)) {
        	   lines.add(StringUtils.join(words.iterator(), " "));
               lineLen = 0;
               words.clear();
           }
           lineLen += word.length()+1;
           words.add(word);
       }
       if(words.size()>0)
    	   lines.add(StringUtils.join(words.iterator(), " "));
       
       if(lines.size()==0)
    	   lines.add("");
       double SY = startingY;
       SY-=Y_SHIFT_FOR_LONG_STRAND_NAMES;
       
       for(String line:lines)
       {
    	   SY+=Y_SHIFT_FOR_LONG_STRAND_NAMES;
           outs.println("<text NS1:OID=\""+strandId+"\" NS1:strandName=\""+line+"\" NS1:width=\""+HEADER_FONT_METRICS.stringWidth(line)+"\" NS1:height=\""+HEADER_FONT_METRICS.getHeight()+"\" x=\""+startingX+"\" y=\""+SY+"\" style=\""+STRAND_FONT_STYLE+"\" xmlns:NS1=\"http://sms.dlese.org\">"+line+ "</text>");
       }
       return SY;
   }
   
   private static String createSVGMap2(String objectID, ArrayList<benchmark> benchmarks,  ArrayList<Grade> gradeList, ArrayList<Strand> strandList, double bmWidth, double bmHeight, String col, boolean intersection, int related) throws Exception{

	   //  drawMap2 function is called to generate the display of a benchmark and all benchmarks which are directly related to them.
	   
	   Aggregate outs2 = new Aggregate();
	    double width, height;
        double box_w=bmWidth, box_h=bmHeight;
        double white_ratio=1.15;


        double v_scale=0.0, h_scale=0.0;
        int maxV=0;
        double minH=2.0, maxH=-2.0;
        for (benchmark curr_b:benchmarks){

            if (maxV<curr_b.getVValue()){
                maxV=curr_b.getVValue();
            }
            if (minH>curr_b.getH2Value()){ minH=(double)curr_b.getH2Value(); }
            if (maxH<curr_b.getH2Value()){ maxH=(double)curr_b.getH2Value(); }

        }  // end of for
        maxV=maxV+2;
        maxH=maxH+1.0;
        height=((double)maxV)*white_ratio*box_h;
        width=((double)maxH)*white_ratio*box_w;
        //outs2 = new PrintWriter(new FileOutputStream("C:\\Program Files\\Apache Tomcat 4.0\\webapps\\examples\\MYJSP\\"+filename),true);
        outs2.println("<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>"  + " <!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 1.0//EN\" \"http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd\">"+"<svg xmlns:xlink=\"http://www.w3.org/1999/xlink\" xmlns=\"http://www.w3.org/2000/svg\" width=\""+width+"\" height=\""+height+"\">");
        
    outs2.println("<script language=\"text/ecmascript\">");
    outs2.println("<![CDATA[");
    outs2.println("function mouseOverColor(evt)"); 
    outs2.println("{");
    outs2.println("evt.target.setAttribute(\"stroke\", \"black\");");
    outs2.println("evt.target.setAttribute(\"stroke-width\",1)");
    outs2.println("}");
    outs2.println("function mouseOutColor(evt)"); 
    outs2.println("{");
    outs2.println("evt.target.setAttribute(\"stroke\", \"none\");");
    outs2.println("evt.target.setAttribute(\"stroke-width\",0)");
    outs2.println("}");
    outs2.println("]]>");
    outs2.println("</script>");
        

        outs2.println("\n<g transform=\"translate(0,30)\">");
        
        // write the number of related benchmarks:
        outs2.println("<text x=\"0\" y=\"-10\" style=\""+HEADER_FONT_STYLE+"\">Benchmarks shown below may be concepts that are part of another map.</text>");

        v_scale=height/(double)maxV;
        h_scale= width/(maxH-minH);
        //System.out.println("V: "+v_scale+ ",  H:  "+h_scale);
        for (benchmark curr_b: benchmarks){
            
            String text= curr_b.getText();
            double X=0.0,Y=0.0;
            X=((double)curr_b.getH2Value()-minH)*h_scale;
            X=X+(white_ratio-1.0)/2.0*box_w;

            Y=(double)curr_b.getVValue()*v_scale;
            // Y is center of block:
            Y=Y+white_ratio/2.0*box_h;

            if (curr_b.getID().equals(objectID)){
                drawBox(outs2, X,Y,box_w,box_h,text,col,curr_b.getID(),curr_b.getKeywords(),curr_b.getSubjects());
                
            }
            else
            {
            
                drawBox(outs2, X,Y,box_w,box_h,text,col,curr_b.getID(),curr_b.getKeywords(),curr_b.getSubjects());
            }

            // draw the links from that box:
            for (int h=0;h<(curr_b.getToBenchmark()).size();h++){
                benchmark bb =  ((curr_b.getToBenchmark()).get(h));
                if (curr_b.getID().equals(objectID)||bb.getID().equals(objectID))
                {


                if (benchmarks.contains((Object)bb)){

                    String tLinkType = (String) ((curr_b.getToBenchmarkType()).get(h));
                    boolean dArrow   = tLinkType.equalsIgnoreCase("Contributes to and relies upon") ? true:false;
                    String text2 = bb.getText();
                    double X2=0.0,Y2=0.0;
                    X2=((double)bb.getH2Value()-minH)*h_scale;
                    X2=X2+(white_ratio-1.0)/2.0*box_w;

                    Y2=(double)bb.getVValue()*v_scale;
                    // Y is center of block:
                    Y2=Y2+white_ratio/2.0*box_h;
                    draw_link(outs2, bmWidth, bmHeight, dArrow,X,Y,X2,Y2,text,text2,(box_w+25),box_h,box_w);
                    
                    //  try double arrow here:
                    
                    //draw_link(X2,Y2,X,Y,text,text2,(box_w+10),box_h);
                }  // end of second if
                
                }   // end of first if



            }  // end of for loop
            
            
        }
//        System.out.println("draw map 2");

        //---------------------------
        // end of file:
        outs2.println("</g>");
        
//      outs2.println("<use xlink:href=\"#map\" transform=\"translate(0,40)\"/>");
        


        
        outs2.println("</svg>");
//      outs2.close();


        return outs2.toString();


   }  // end of drawMap

   private static void drawBox(Aggregate outs2, double X, double Y, double box_w, double box_h,String brief_text,String color,String benchmark_ID, String keywords, String subjects){

        // Y is center of box;
        //String benchmark_ID="sms911";
        
        //brief_text=brief_text+" ...";
       int MaxLines=11; 
       int MaxChars=28;
       
	   MaxChars = (int) (box_w/6.2);
	   MaxLines= (int) (box_h/14.3);
        ArrayList texts;
        double current_x,current_y;
        int Toverflow=0;
        int maxLength=0;
        
        texts=breakLine(brief_text,MaxChars);
        int point_tracker=0;
        String qq = null;
        int my_size=texts.size();
        if (my_size>MaxLines){
            my_size=MaxLines;
            Toverflow=1;
        }
        point_tracker=12*(my_size+1)-6;
        current_x=X;
        current_y=Y-point_tracker/2;
        box_w=box_w+20.0;

        //current_y=(row-1)*sbh+0.5*(sbh-sh)+0.5*(sh-point_tracker);




        // new code added to add xlink to the box: 
            outs2.println("<a xlink:href=\""+benchmark_ID+"\">");
                
        //outs2.println("<a xlink:href=\"http://hsdvl.sciencematerialscenter.org/results.php?smsid="+benchmark_ID+"\">");

        //outs2.println("<a xlink:href=\"start?conceptMaps=null&amp;strands=SMS-STD-9002&amp;gradeRange=null&amp;browseQuery=GO\">");
        outs2.println("<g onmouseover=\"mouseOverColor(evt);\" onmouseout=\"mouseOutColor(evt)\">");
        for (int k1=0;k1<my_size;k1++)
        {
                 String tls=(String)texts.get(k1);
                 int currentL=0;
                 
                 if ((k1==(my_size-1))&&(Toverflow==1)) {tls=tls+"...";}
                 
                 currentL=tls.length();
                 
                 if (currentL>maxLength) maxLength=currentL;
                 
                 
        }     
        
        // calculate the actural box size by max number of characters in a line
        
        //box_w=maxLength*7.0;
        

        outs2.println("<rect width=\""+box_w+"\" height=\""+ point_tracker+"\" x=\""+current_x+"\" y=\""+current_y+"\" ry=\"10\" rx=\"10\" fill=\""+color+"\" stroke=\"none\" opacity=\"1.0\"/>");
        
        for (int k1=0;k1<my_size;k1++)
        {
                 String tls=(String)texts.get(k1);
                 
                 
                 //System.out.println(texts.size());
                 outs2.println("<text x=\""+(current_x+TEXT_PADDING_HORIZONTAL)+"\" y=\""+((current_y+12)+(k1*12))+"\" style=\""+BENCHMARK_FONT_STYLE+"\">"+tls+"</text>");

        }

        //outs2.println("<rect width=\""+box_w+"\" height=\""+ point_tracker+"\" x=\""+current_x+"\" y=\""+current_y+"\" ry=\"10\" rx=\"10\" fill=\""+color+"\" stroke=\"none\" opacity=\"0.3\"/>");
        
        outs2.println("</g>");
        
        outs2.println("</a>");
        


   }  // end of drawBox
   
   private  static ArrayList breakLine(String in,int width)
   {

        int dlen=0;
        String[] words;

        ArrayList lines = new ArrayList();
        String tl="";
        dlen=in.length();
        words=in.split(" ");
        for (int i=0;i<java.lang.reflect.Array.getLength(words);i++)
        {
            tl=tl+" "+words[i];

            if (tl.length()+((i==java.lang.reflect.Array.getLength(words)-1) ? 0:words[i+1].length())>width)
            {

                //System.out.println(tl);

                lines.add(tl);

                tl = "";
            }
        }

        lines.add(tl);
        tl="";
        return lines;
   }  // end of breakLine

   private static void draw_link(Aggregate outs2, double bmWidth, double bmHeight, boolean doublearrow,double in_x1, double in_y1, double in_x2, double in_y2,String brief_text1, String brief_text2, double sw, double sh, double Box_Width)
   {

	 int MaxLines=11;  
	 
	 int MaxChars=28;
	 
	 MaxChars=(int) (bmWidth/6.2);
	 
	   
	   MaxLines= (int) (bmHeight/14.3);
	 
	   
     ArrayList texts;
     texts=breakLine(brief_text1,MaxChars);
     int my_size=texts.size();
     if (my_size>MaxLines){ my_size=MaxLines;}

     int  point_tracker1=12*(my_size+1);
     texts=breakLine(brief_text2,MaxChars);
     my_size=texts.size();
     if (my_size>MaxLines){ my_size=MaxLines;}
     int point_tracker2=12*(my_size+1);


     double x1,y1,x2,y2,kl,tx,ty,xs,ys,xe,ye;
     double X1,X2,X3,X4,X5,Y1,Y2,Y3,Y4,Y5;
     double sh1=point_tracker1,sw1=sw,sh2=point_tracker2,sw2=sw;


     //row=row1;
     //column=column1;
     //current_x=(column-1)*sbw+0.5*sbw;
     double current_x= in_x1+0.5*sw;
     double current_y= in_y1;

     //current_y=(row-1)*sbh+0.5*sbh;
     x1=current_x;
     y1=current_y;

     //row=row2;
     //column=column2;
     //current_x=(column-1)*sbw+0.5*sbw;
     //current_y=(row-1)*sbh+0.5*sbh;
     current_x= in_x2+0.5*sw;
     current_y= in_y2;

     x2=current_x;
     y2=current_y;



       // calculate the line equation:

       if ((x2-x1)==0) x2++;
       //if ((y2-y1)==0) y2++;
       kl=(y2-y1)/(x2-x1);
       if (kl==0.0)  kl=0.01;

    // calculate the starting point:
     if (y1==y2)
     {
         if (x1>x2) { x1=x1-sw1/2;x2=x2+sw2/2;}
         else {  x1=x1+sw1/2;x2=x2-sw2/2;}

     }
     else
     {
     // calculate the starting point:
       tx=((y1-sh1/2)-y1+kl*x1)/kl;
       if ((tx>(x1-sw1/2))&&(tx<(x1+sw1/2)))
       {
          xs=tx;
          ys=y1-sh1/2;
       }
       else
       {

       if (tx<=(x1-sw1/2))
       {
         xs=x1-sw1/2;
         ys=kl*xs+(y1-kl*x1);
       }
       else
       {
         xs=x1+sw1/2;
         ys=kl*xs+(y1-kl*x1);
       }

       }

       x1=xs;
       y1=ys;



       // calculate the end point:
       tx=((y2+sh2/2)-y1+kl*x1)/kl;
               if ((tx>=(x2-sw2/2))&&(tx<=x2+sw2/2))
               {
                  xe=tx;
                  ye=y2+sh2/2;
               }
               else if (tx<(x2-sw2/2))
               {
                 xe=x2-sw2/2;
                 ye=kl*xe+(y1-kl*x1);
               }
               else
               {
                 xe=x2+sw2/2;
                 ye=kl*xe+(y1-kl*x1);
               }

       x2=xe;
       y2=ye;

       }  // end of else







               outs2.println("<line x1=\""+x1+"\" y1=\""+y1+"\" x2=\""+x2+"\" y2=\""+y2+"\" style=\"stroke:black;stroke-width:1;\"/>");

                    // calculate and draw the triangle:



                    X1=(double)x2;
                    X3=(double)x1;
                    Y1=(double)y2;
                    Y3=(double)y1;
                    double k2=0.0,k=0.0,l=0.0,r=0.0,a=5.0;
                    k2=(Y3-Y1)/(X3-X1);
                    if (k2==0) k2=0.1;
                    k=(-1.0)/k2;
                    l=java.lang.Math.sqrt(((X3-X1)*(X3-X1)+(Y3-Y1)*(Y3-Y1)));
                    r=a/l;
                    X2=X1+(X3-X1)*r;
                    Y2=Y1+(Y3-Y1)*r;

                    X4=java.lang.Math.sqrt(((a*a)/(k*k+1)))+X2;
                    X5=(-1.0)*java.lang.Math.sqrt(((a*a)/(k*k+1)))+X2;
                    Y4=k*(X4-X2)+Y2;
                    Y5=k*(X5-X2)+Y2;
                    //X5=X3;
                    //Y5=Y3;
              outs2.println("<polygon points=\""+X1+","+Y1+" "+X4+","+Y4+" "+X5+","+Y5+" "+X1+","+Y1+"\"/>");
              
              //  try to draw another triangle:
              if (doublearrow){
                X1=(double)x1;
                X3=(double)x2;
                Y1=(double)y1;
                Y3=(double)y2;
                k2=0.0;
                k=0.0;
                l=0.0;
                r=0.0;
                a=5.0;
                k2=(Y3-Y1)/(X3-X1);
                if (k2==0) k2=0.1;
                k=(-1.0)/k2;
                l=java.lang.Math.sqrt(((X3-X1)*(X3-X1)+(Y3-Y1)*(Y3-Y1)));
                r=a/l;
                X2=X1+(X3-X1)*r;
                Y2=Y1+(Y3-Y1)*r;

                X4=java.lang.Math.sqrt(((a*a)/(k*k+1)))+X2;
                X5=(-1.0)*java.lang.Math.sqrt(((a*a)/(k*k+1)))+X2;
                Y4=k*(X4-X2)+Y2;
                Y5=k*(X5-X2)+Y2;
                //X5=X3;
                //Y5=Y3;
          outs2.println("<polygon points=\""+X1+","+Y1+" "+X4+","+Y4+" "+X5+","+Y5+" "+X1+","+Y1+"\"/>");
              }  // end of doublearrow if
     }
}
