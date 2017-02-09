package org.dlsciences.ngss;

import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;


public class ngssAlignmentItem {
	public String ngssText;
	public HashMap<String, String> peHash = new HashMap<String, String>();

	public ngssAlignmentItem(String ngssText, HashMap<String, String> peHash){
		setNgssText(ngssText);
		setPeHash(peHash);
	
	
	}
	
	/**
     *  Getter for ngssText var	
     *	@return ngssText var
    **/
    public String getNgssText() {
        return this.ngssText;
    }
    /**
     *  Setter for ngssText var	
    **/
    private final void setNgssText(String ngssText) {
        this.ngssText = ngssText;
    }
	
    /**
     *  Getter for peHash var	
     *	@return peHash var
    **/
    public HashMap<String, String> getPeHash() {
        return this.peHash;
    }
    /**
     *  Setter for peHash var	
    **/
    private final void setPeHash(HashMap<String, String> peHash) {
        this.peHash = peHash;
    }
    
    
}