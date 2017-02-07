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
 * Author: Faisal Ahmad
 * Date  : Sept 14, 2005
 * email : fahmad@colorado.edu
*/



package edu.cu.cs.sms.Database;

import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.PropertyResourceBundle;

import javax.sql.DataSource;

import org.apache.commons.dbcp.BasicDataSource;

import edu.cu.cs.sms.ExtendedActionServlet;
import edu.cu.cs.sms.Exceptions.CorruptDataException;
import edu.cu.cs.sms.Exceptions.DuplicateQueryRegisterationException;

//One instance of this class is created when the application startsup and executes 
//all queries for different clients
public final class QueryExecutor implements QueryEngine 
{
	private static String stylesheetLocation 	= null;
	private static final String key 			= "SQL";
	private DataSource ds 						= null;
	
	//Initlaizes the connection pool + driver
	public QueryExecutor() throws SQLException, InstantiationException, IllegalAccessException, ClassNotFoundException, FileNotFoundException, IOException
	{
		PropertyResourceBundle conf = new PropertyResourceBundle(new BufferedInputStream(this.getClass().getClassLoader().getResourceAsStream("edu/cu/cs/sms/Database/database.properties")));
		
		String driverName 		=	conf.getString("Driver.Name").trim();
		String url 		  		= 	conf.getString("Driver.URL")+conf.getString("Driver.database").trim();
		String user 			= 	conf.getString("Driver.User").trim();
		String pass 			= 	conf.getString("Driver.Password").trim();
		String autoComit		=	conf.getString("Driver.AutoComit").trim();
		int initPoolSize		=	Integer.parseInt(conf.getString("Driver.InitPoolSize").trim());
		int maxActiveCon		=	Integer.parseInt(conf.getString("Driver.MaxActive").trim());
		int maxIdleCon			=	Integer.parseInt(conf.getString("Driver.MaxIdle").trim());
		int maxOpenPrepStmts	=	Integer.parseInt(conf.getString("Driver.MaxOpenPreparedStatements").trim());
		int minIdleCon			=	Integer.parseInt(conf.getString("Driver.MinIdle").trim());
		boolean cacheStatement  =	Boolean.getBoolean(conf.getString("Driver.CacheStatement").trim());
		boolean validationTest  =	Boolean.getBoolean(conf.getString("Driver.validationTest").trim());
		long minIdleTimeout		=	Long.parseLong(conf.getString("Driver.IdleTimeOut").trim());
		long maxCheckoutTime	=	Long.parseLong(conf.getString("Driver.CheckOutTime").trim());
		Boolean autoCommit		= 	true;
		stylesheetLocation		=	conf.getString("Driver.Stylesheet").trim();

		if(autoComit.equalsIgnoreCase("false"))
			autoCommit = false;
		
		BasicDataSource ds = new BasicDataSource();
		


		ds.setDriverClassName(driverName);
        ds.setUsername(user);
        ds.setPassword(pass);
        ds.setUrl(url);
        ds.setDefaultAutoCommit(autoCommit);
        ds.setInitialSize(initPoolSize);
        ds.setMaxActive(maxActiveCon);
        ds.setMaxOpenPreparedStatements(maxOpenPrepStmts);
        ds.setMaxIdle(minIdleCon);
        ds.setPoolPreparedStatements(cacheStatement);
        ds.setTestWhileIdle(validationTest);
        ds.setMinEvictableIdleTimeMillis(minIdleTimeout);
        ds.setMaxWait(maxCheckoutTime);

        this.ds = ds;
	}
	
	//Exectues a query and converts the result set into SMSResultSet which is a wrapper
	//around SQL result set
	public SMSResultSet executeSearch(String inQuery) throws SQLException, IOException, CorruptDataException
	{
		Connection con = ds.getConnection();
		Statement stmt = con.createStatement();
		ResultSet rs = stmt.executeQuery(inQuery);   
		ResultSetMetaData meta = rs.getMetaData();
		int numCols = meta.getColumnCount();
		SMSResultSet searchResults = new SMSResultSet(rs);

		stmt.close();
		rs.close();
		con.close();

		return searchResults;
	}
	
	public String getKey()
	{
		return key;
	}
	
	public String getStylesheetLocation()
	{
		return stylesheetLocation;
	}

	public int executeUpdate(String inQuery) throws SQLException, IOException, CorruptDataException 
	{
			int result = 0;
			
			try {
				Connection con 		= 	ds.getConnection();
				Statement stmt 		= 	con.createStatement();
				result 				= 	stmt.executeUpdate(inQuery);
				
				stmt.close();
				con.close();
			} 
			catch (SQLException e) 
			{
				if(e.getMessage().indexOf("Duplicate entry") != -1)
					throw new DuplicateQueryRegisterationException();
			}
		
		return result;
	}

	

	public ResultSet executeRawSearch(String inQuery) throws SQLException, IOException, CorruptDataException 
	{
		Connection con = null;
		ResultSet myrs = null;
		ResultSet rs = null;
		Statement stmt = null;
		try
		{
			con = ds.getConnection();
			stmt = con.createStatement();
			rs = stmt.executeQuery(inQuery);
			myrs = new myResultSet(rs);

		}
		finally
		{
			if(rs!=null)
				try{rs.close();}catch(Exception e){};
			if(stmt!=null)
				try{stmt.close();}catch(Exception e){};
			if(con!=null)
				try{con.close();}catch(Exception e){};
		}
		return myrs;
	}

	protected void finalize() throws Throwable
	{
		super.finalize();
		
		((BasicDataSource)ds).close();
	}
	
}
