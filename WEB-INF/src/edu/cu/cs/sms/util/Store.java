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
 * Author: Faisal Ahmad, John Weatherley
 */

package edu.cu.cs.sms.util;

import java.util.Date;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.text.SimpleDateFormat;

import org.apache.commons.io.FileUtils;
import edu.cu.cs.sms.DTO.ConCache;

public class Store implements DatabaseNotifier {
	private static boolean debug = false;

    private String cacheDirectoryPath = null;
    
    public Store(String cacheDirectoryPath, boolean cachePersisent) throws IOException
    {
    	this.cacheDirectoryPath = cacheDirectoryPath;
    	
    	// If we do not want a persistent store remove the cache
    	if(!cachePersisent)
    		this.clearStore();
    	this.setupCacheDirectory();
    }
    
    /**
     * Setup the cache directory by making sure it exists and it can be read and written toos
     * @throws IOException
     */
    private void setupCacheDirectory() throws IOException
    {
    	File cacheDirectory = new File(this.cacheDirectoryPath);
    	cacheDirectory.mkdirs();
		if(!cacheDirectory.canWrite())
			throw new IOException("Can not write to cache directory '" + cacheDirectory.getAbsolutePath() + "'");
		if(!cacheDirectory.canRead())
			throw new IOException("Can not read from cache directory '" + cacheDirectory.getAbsolutePath() + "'");

    }
    
    /**
     * Attempt to lookup cache on the file system
     * @param id
     * @return
     */
    public ConCache lookup(String id) {
    	FileInputStream fin = null;
    	ObjectInputStream ois = null;
    	try
    	{
    		String fileKey = createFileKey(id);
    		File cacheFile = new File(this.cacheDirectoryPath, fileKey);
		    
    		if(cacheFile.exists())
    		{
	    		fin = new FileInputStream(cacheFile);
	    		ois = new ObjectInputStream(fin);
	    		return (ConCache) ois.readObject();
    		}
    	}
    	catch(Exception e)
    	{
    		e.printStackTrace();
    	}
    	finally
    	{
    		try {
    			if (ois!=null)
					ois.close();
    			if(fin!=null)
    				fin.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
    	}
    	return null;
    }

    /**
     * Purge the store of all cache
     * @throws IOException
     */
    public synchronized void clearStore() throws IOException {
    	prtln("Clearing the datastore by deleting the cache directory");
		FileUtils.deleteDirectory(new File(this.cacheDirectoryPath));
		this.setupCacheDirectory();
		prtln("Finished deleting cache directory.");
    }

    /**
     * Save a response to the cache to the given key
     * @param code
     * @param response
     * @param bin
     * @param mimeType
     * @param lastModified
     */
    public synchronized void save(String code, byte[] response, boolean bin, String mimeType, Date lastModified) {
    	FileOutputStream fout = null;
    	ObjectOutputStream oos = null;
    	try
    	{
	    	String fileKey = createFileKey(code);
	    	
	    	File cacheFile = new File(this.cacheDirectoryPath, fileKey);
	    	
			if (!cacheFile.exists())
			{
				fout = new FileOutputStream(cacheFile);
				oos = new ObjectOutputStream(fout);
				oos.writeObject(new ConCache(response, bin, mimeType, lastModified));
				
			}
    	}
    	catch(Exception e)
    	{
    		e.printStackTrace();
    	}
    	finally
    	{
    		try {
	    		if(oos!=null)
	    			oos.close();
	    		if(fout!=null)
	    			fout.close();
    		}
    		catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
    		}
    	}
    }
    
    /**
     * Create a unique file key for a given code. This file key must be a useable file name
     * @param code
     * @return
     * @throws Exception
     */
    private String createFileKey(String code) throws Exception
    {
    	MessageDigest m = MessageDigest.getInstance("MD5");
    	m.reset();
    	m.update(code.getBytes());
    	byte[] digest = m.digest();
    	BigInteger bigInt = new BigInteger(1,digest);
    	String hashtext = bigInt.toString(16);
    	return hashtext;
    }
   
    public synchronized void changeDatabase() {
    	try {
			clearStore();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }
	
	
	//================================================================

	/**
	 *  Return a string for the current time and date, sutiable for display in log files and output to standout:
	 *
	 * @return    The dateStamp value
	 */
	protected final static String getDateStamp() {
		return
			new SimpleDateFormat("MMM d, yyyy h:mm:ss a zzz").format(new Date());
	}


	/**
	 *  Output a line of text to error out, with datestamp.
	 *
	 * @param  s  The text that will be output to error out.
	 */
	protected final void prtlnErr(String s) {
		System.err.println(getDateStamp() + " Store ERROR: " + s);
	}



	/**
	 *  Output a line of text to standard out, with datestamp, if debug is set to true.
	 *
	 * @param  s  The String that will be output.
	 */
	protected final void prtln(String s) {
		if (debug) {
			System.out.println(getDateStamp() + " Store: " + s);
		}
	}


	/**
	 *  Sets the debug attribute of the object
	 *
	 * @param  db  The new debug value
	 */
	public static void setDebug(boolean db) {
		debug = db;
	}	
	
}