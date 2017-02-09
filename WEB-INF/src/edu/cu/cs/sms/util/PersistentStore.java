/*
 *  License and Copyright:
 *
 *  The contents of this file are subject to the Educational Community License v1.0 (the "License"); you may
 *  not use this file except in compliance with the License. You should have received a copy of the License
 *  along with this software; if not, you may obtain a copy of the License at
 *  http://www.opensource.org/licenses/ecl1.php.
 *
 *  Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY KIND,
 *  either express or implied. See the License for the specific language governing rights and limitations
 *  under the License.
 *
 *  Copyright 2002-2011 by Digital Learning Sciences, University Corporation for Atmospheric Research (UCAR).
 *  All rights reserved.
 */

package edu.cu.cs.sms.util;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Date;
import java.text.SimpleDateFormat;
import java.io.File;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

import edu.cu.cs.sms.ExtendedActionServlet;
import edu.cu.cs.sms.DTO.ConCache;
import org.dlese.dpc.datamgr.SimpleDataStore;

public class PersistentStore implements DatabaseNotifier {
	private static boolean debug = true;
	
    private int maxSize = 0;
	
	// DB objects:
	private String driverURL = null;
	private String driverUser = null;
	private String driverPassword = null;
	private String driverName = null;
	
    public PersistentStore(String driverURL, String driverUser, String driverPassword, String driverName, Date databaseLastModified, int maxSize) throws Exception {
		this.maxSize = maxSize;
		this.driverURL = driverURL;
		this.driverUser = driverUser;
		this.driverPassword = driverPassword;
		this.driverName = driverName;
		
		executeDbStatement("CREATE DATABASE smsContentCache IF NOT EXISTS;");
		String dbStatement =	"CREATE TABLE IF NOT EXISTS `cachedObjects` (" +
								"`content` blob," +
								"`objectId` varchar(2000) not NULL," +
								"`updateDate` TIMESTAMP ON UPDATE CURRENT_TIMESTAMP," +
								"PRIMARY KEY  (`objectId`)" +
								") ENGINE=InnoDB DEFAULT CHARSET=latin1;";
		executeDbStatement(dbStatement);
		
		/* String databaseLastModifiedKey = "databaseLastModifiedDate";
		if( prevDatabaseLastModifiedDate == null || !prevDatabaseLastModifiedDate.equals(databaseLastModified) ) {
			if(prevDatabaseLastModifiedDate != null) {
				System.out.println("Database has changed. Deleting content cache (" + simpleDataStore.size() + " objects total)");	
			}
			simpleDataStore.clear();
			simpleDataStore.put(databaseLastModifiedKey,databaseLastModified);
		}
		System.out.println("Initializing content cache at " + cacheDirectory.getAbsolutePath());
		System.out.println("Content cache initialized with " + simpleDataStore.size() + " objects total"); */
    }
	
	private void executeDbStatement(String statement) throws Exception {
		Class.forName(driverName);
		Connection con = DriverManager.getConnection(driverURL,driverUser,driverUser);
		Statement stmt = con.createStatement();

		stmt.executeUpdate(statement);

		stmt.close();
		con.close();
	}
	
    public synchronized ConCache lookup(String id) {
        return null;
		//return (ConCache) simpleDataStore.get(id);
    }

    private synchronized void cleanPersistentStore() {
		/* prtln("cleanPersistentStore() start size: " + simpleDataStore.size());
				
		prtln("cleanPersistentStore() end size: " + simpleDataStore.size()); */
    }

    public synchronized void save(String code, byte[] response, boolean bin, String mimeType, Date lastModified) {
		/* if (!simpleDataStore.oidExists(code) && simpleDataStore.size() < maxSize) {
			prtln("Saving content to cache. Code: " + code);
			simpleDataStore.put(code, new ConCache(response, bin, mimeType, lastModified));
		}
		prtln("Content cache size " + simpleDataStore.size()); */
    }

    public synchronized void changeDatabase() {
        cleanPersistentStore();
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
		System.err.println(getDateStamp() + " PersistentStore ERROR: " + s);
	}



	/**
	 *  Output a line of text to standard out, with datestamp, if debug is set to true.
	 *
	 * @param  s  The String that will be output.
	 */
	protected final void prtln(String s) {
		if (debug) {
			System.out.println(getDateStamp() + " PersistentStore: " + s);
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