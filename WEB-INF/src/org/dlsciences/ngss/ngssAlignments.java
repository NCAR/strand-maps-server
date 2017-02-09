package org.dlsciences.ngss;

import java.util.HashMap;
import org.dom4j.Document;
import org.dom4j.Node;
import org.dom4j.Element;
import org.dom4j.DocumentException;
import org.dom4j.io.SAXReader;
import java.util.ArrayList;
import java.util.List;

import java.util.Set;
import java.util.Arrays;
import java.util.Collections;


public class ngssAlignments {
	
	private String BASE_URL = "http://nsdl.org/asn/service.do?verb=GetStandard&id=";
    
	public List<String> ngssIds = new ArrayList<String>();
	public HashMap<String,HashMap<String,List<ngssAlignmentItem>>> ngssAlignmentHash = new HashMap<String,HashMap<String,List<ngssAlignmentItem>>>();
	
	public ngssAlignments(){};
	
	public ngssAlignments(List<String> ngssIds){
		setNgssIds(ngssIds);
		
		for(int i = 0; i<ngssIds.size();i++){
			
			String pathName = new String();
        	String nodeValue = new String();
        	
			String ngssID = ngssIds.get(i);
			try {
		        Document document = retrieveRecord(ngssID);
		        List<Node> nodes = new ArrayList<Node>();
		        // process and store
		        List<Element> records = new ArrayList<Element>();
		        records = document.selectNodes("ASNWebService/GetStandard/result/Standard");
		        for (int j = 0; j < records.size(); j++) {
                    Element record = records.get(j);
                    // text of the aligned standard
                    pathName = "Text";
                    nodeValue = getNodeValue(record, pathName);
                    String ngssText = nodeValue;
                    
                    // get grade levels
                    pathName = "StartGradeLevel";
                    nodeValue = getNodeValue(record, pathName);
                    String StartGradeLevel = nodeValue;
                    if(StartGradeLevel.equals("0")){
	                 	StartGradeLevel = "K";  
                    }
                    
                    pathName = "EndGradeLevel";
                    nodeValue = getNodeValue(record, pathName);
                    String EndGradeLevel = nodeValue;
                    if(EndGradeLevel.equals("0")){
	                 	EndGradeLevel = "K";  
                    }
                    if(StartGradeLevel.equals(EndGradeLevel)){
	                 	ngssText += " (Grade "+StartGradeLevel+")";
                    } else {
	                    ngssText += " (Grades "+StartGradeLevel+"-"+EndGradeLevel+")";
                    }
                    
                    
                    // now get all of the parent text levels
                    pathName = "Parent//Standard";
                    List<Element> subrecords = new ArrayList<Element>();
                    subrecords = record.selectNodes(pathName);
                   
                    List<String> standardText = new ArrayList<String>();
                    for (int k = 0; k < subrecords.size(); k++) {
	                    Element subrecord = subrecords.get(k);
	                    pathName = "Text";
                    	nodeValue = getNodeValue(subrecord, pathName);
                    	standardText.add(nodeValue);   
                    }
                    
                    // reverse order
                    List<String> temp = new ArrayList<String>();
	                for(int l = 1; l<=standardText.size();l++){
		               	temp.add(standardText.get(standardText.size()-l));
	                }
	                standardText = temp;
	                
	                // remove ngss
	                standardText.remove(0);
	                // place next item into a key for master array and then remove
	                String sectionTitle = new String();
	                String parentText = new String();
	                sectionTitle = standardText.get(0);
	                standardText.remove(0);
	                // add ngsstext to bottom of this list
	                parentText = standardText.get(0);
	                
	                
                    
                    //now get the corresponding performance expectations
                    pathName = "OtherReferencesToThis/ComprisedOf/Standard";
                    nodes = record.selectNodes(pathName);
                    
	                HashMap<String, String> peItemHash = new HashMap<String, String>();
                    for (int k = 0; k < nodes.size(); k++) {
	                    Node node = nodes.get(k);
	                    
	                  	pathName = "StatementNotation";
	                  	nodeValue = getNodeValue(node, pathName);
	                  	String peNotation = nodeValue;
	                  	
	                  	pathName = "Text";
	                  	nodeValue = getNodeValue(node, pathName);
	                  	String peText = nodeValue;
	                  	// create new hash of pe notation to text
	                  	peItemHash.put(peNotation,peText);
	                  	
	                  	// add to hash of pes for this standard alignment
                  	}
                  	
                  	HashMap<String, String> peItemHashSorted = new HashMap<String, String>();
                  	Set set=peItemHash.keySet();
					String[] keys = new String[set.size()];
					set.toArray(keys);
					List tmpkeyList=Arrays.asList(keys);
					
					Collections.sort(tmpkeyList);
					for(Object key:tmpkeyList){
						peItemHashSorted.put(key.toString(),peItemHash.get(key).toString());
					}
					peItemHash = peItemHashSorted;
                  	
                  	//now add the standard text and pelist to an ngssAlignmentItem
                  	ngssAlignmentItem nai = new ngssAlignmentItem(ngssText, peItemHash);
                  	
                  	// based on the sectiontype of this standard add that to the corresponding sectiontype list
                  	HashMap<String,List<ngssAlignmentItem>> sectionHashTemp = new HashMap<String,List<ngssAlignmentItem>>();
                  	List<ngssAlignmentItem> parentListTemp = new ArrayList<ngssAlignmentItem>();
                  	if(ngssAlignmentHash.containsKey(sectionTitle) == true){
	                 	// retrieve existing sectionTitle
	                 	sectionHashTemp = ngssAlignmentHash.get(sectionTitle);
	                 	
	                 	if(sectionHashTemp.containsKey(parentText) == true){
		                 	// retrieve existing parentText
		                 	parentListTemp = sectionHashTemp.get(parentText);	
	                 	}

                  	}
                  	// add nai to end of list
	                 parentListTemp.add(nai);
	                 // update parentText entry
	                 sectionHashTemp.put(parentText,parentListTemp);
	                 // update sectiontitle entry
	                 ngssAlignmentHash.put(sectionTitle,sectionHashTemp);
                }
               setNgssAlignmentsHash(ngssAlignmentHash);
                
			} catch (DocumentException de) {
		    	
			}
		 }
	}
	
    /**
     *  Getter for peList var	
     *	@return peList var
    **/
    public List<String> getNgssIds() {
        return this.ngssIds;
    }
    /**
     *  Setter for peList var	
    **/
    private final void setNgssIds(List<String> ngssIds) {
        this.ngssIds = ngssIds;
    }
    
    /**
     *  Getter for peList var	
     *	@return peList var
    **/
    public HashMap<String,HashMap<String,List<ngssAlignmentItem>>> getNgssAlignmentsHash() {
        return this.ngssAlignmentHash;
    }
    /**
     *  Setter for peList var	
    **/
    private final void setNgssAlignmentsHash(HashMap<String,HashMap<String,List<ngssAlignmentItem>>> ngssAlignmentHash) {
        this.ngssAlignmentHash = ngssAlignmentHash;
    }
    /**
     *	Reads in the XML record from the DDS and stores in a document
     *
     *	@return	Document represents the XML item record
    **/
    public Document retrieveRecord(String ngssID) throws DocumentException {
        
        String s_url = BASE_URL + ngssID;
	    SAXReader reader = new SAXReader();
       
		Document document = reader.read(s_url);
        
		return document;
    }
    
    /** 
     * Retrieve the value of a node from a parent record object
     * @param record	The parent record
     * @param pathName	The xpath to extract the value from
     * @return String the value of the node
    **/
    protected String getNodeValue(Element record, String pathName){
        String nodeValue = "";
        
        try{
            Node node = record.selectSingleNode(pathName);
            nodeValue = node.getText().toString().trim();
        } catch(NullPointerException npe){
        }
        return nodeValue;
    }
    
    /** 
     * Retrieve the value of a node from a parentnode object
     * @param node	The parent node
     * @param pathName	The xpath to extract the value from
     * @return String the value of the node
    **/ 
    protected String getNodeValue(Node node, String pathName){
        String nodeValue = "";
        
        try{
            Node childNode = node.selectSingleNode(pathName);
            nodeValue = childNode.getText().toString().trim();
        } catch(NullPointerException npe){
        }
        return nodeValue;
    }
       
    
}