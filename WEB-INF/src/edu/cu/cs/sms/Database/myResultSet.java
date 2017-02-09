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

import java.io.InputStream;
import java.io.Reader;
import java.math.BigDecimal;
import java.net.URL;
import java.sql.Array;
import java.sql.Blob;
import java.sql.Clob;
import java.sql.Date;
import java.sql.NClob;
import java.sql.RowId;
import java.sql.SQLXML;
//import java.sql.NClob;
import java.sql.Ref;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
//import java.sql.RowId;
import java.sql.SQLException;
import java.sql.SQLWarning;
//import java.sql.SQLXML;
import java.sql.Statement;
import java.sql.Time;
import java.sql.Timestamp;
import java.util.Calendar;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;



public class myResultSet implements ResultSet 
{
	int pointer = -1;
	int maxSize = -1;
	Map byNameLookup = new HashMap();
	List byLocationLookup = new LinkedList();
	ResultSetMetaData metadata = null;
	
	public myResultSet(ResultSet rs) throws SQLException
	{
		ResultSetMetaData meta 	= 	rs.getMetaData();
		int numCols 			=   meta.getColumnCount();
		String colNames[] 		= 	new String[numCols];
		
		for(int x = 0; x < numCols; x++)
		{
			List temp = new LinkedList();
			byNameLookup.put(meta.getColumnName(x+1),temp);
			byLocationLookup.add(temp);
		}

		while(rs.next())
		  for(int x = 1; x <= numCols; x++)
		  {
		  	String  temp;
			temp = rs.getString(x) ;
			temp = (temp == null) ? "":temp;			
		  	((List)byLocationLookup.get(x-1)).add(temp);
		  }

		if(((List)byLocationLookup.get(0)).size() > 0)
			maxSize = ((List)byLocationLookup.get(0)).size();
		
		metadata = meta;
	}
	
	public String[] getItemid2()
	{
		List ll = (List) byNameLookup.get("ItemID2");

		if(ll != null)
		{
			String[] pl = new String[ll.size()];
			
			for(int index=0;index<ll.size();index++)
				pl[index] = (String) ll.get(index);
			
			return pl;
		}
		return new String[0];
	}	
	
	public String[] getrelations()
	{
		List ll = (List) byNameLookup.get("RelationType");
		
		if(ll != null)
		{
			String[] pl = new String[ll.size()];
			
			for(int index=0;index<ll.size();index++)
				pl[index] = (String) ll.get(index);
			return pl;
		}
		return new String[0];
	}
	
	
	public int getConcurrency() throws SQLException 
	{

		return 0;
	}

	public int getFetchDirection() throws SQLException {
		return 0;
	}

	public int getFetchSize() throws SQLException {
		return 0;
	}

	public int getRow() throws SQLException {
		return 0;
	}

	public int getType() throws SQLException {
		return 0;
	}

	public void afterLast() throws SQLException {
	}

	public void beforeFirst() throws SQLException {
	}

	public void cancelRowUpdates() throws SQLException {
	}

	public void clearWarnings() throws SQLException {
	}

	public void close() throws SQLException {
	}

	public void deleteRow() throws SQLException {
	}

	public void insertRow() throws SQLException {
	}

	public void moveToCurrentRow() throws SQLException {
	}

	public void moveToInsertRow() throws SQLException {
	}

	public void refreshRow() throws SQLException {
	}

	public void updateRow() throws SQLException {
	}
	public boolean first() throws SQLException {

		return false;
	}

	public boolean isAfterLast() throws SQLException {
		return false;
	}

	public boolean isBeforeFirst() throws SQLException {
		return false;
	}
	public boolean isFirst() throws SQLException {
		return false;
	}
	public boolean isLast() throws SQLException {
		return false;
	}
	public boolean last() throws SQLException {
		return false;
	}
	public boolean next() throws SQLException 
	{
		if(pointer < maxSize-1)
		{
			pointer++;
			return true;
		}
		return false;
	}
	public boolean previous() throws SQLException {
		return false;
	}
	public boolean rowDeleted() throws SQLException {
		return false;
	}
	public boolean rowInserted() throws SQLException {
		return false;
	}
	public boolean rowUpdated() throws SQLException {
		return false;
	}
	public boolean wasNull() throws SQLException {
		return false;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getByte(int)
	 */
	public byte getByte(int arg0) throws SQLException {
		// TODO Auto-generated method stub
		return 0;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getDouble(int)
	 */
	public double getDouble(int arg0) throws SQLException {
		// TODO Auto-generated method stub
		return 0;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getFloat(int)
	 */
	public float getFloat(int arg0) throws SQLException {
		// TODO Auto-generated method stub
		return 0;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getInt(int)
	 */
	public int getInt(int arg0) throws SQLException {
		// TODO Auto-generated method stub
		return 0;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getLong(int)
	 */
	public long getLong(int arg0) throws SQLException {
		// TODO Auto-generated method stub
		return 0;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getShort(int)
	 */
	public short getShort(int arg0) throws SQLException {
		// TODO Auto-generated method stub
		return 0;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#setFetchDirection(int)
	 */
	public void setFetchDirection(int arg0) throws SQLException {
		// TODO Auto-generated method stub
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#setFetchSize(int)
	 */
	public void setFetchSize(int arg0) throws SQLException {
		// TODO Auto-generated method stub
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateNull(int)
	 */
	public void updateNull(int arg0) throws SQLException {
		// TODO Auto-generated method stub
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#absolute(int)
	 */
	public boolean absolute(int arg0) throws SQLException {
		// TODO Auto-generated method stub
		return false;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getBoolean(int)
	 */
	public boolean getBoolean(int arg0) throws SQLException {
		// TODO Auto-generated method stub
		return false;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#relative(int)
	 */
	public boolean relative(int arg0) throws SQLException {
		// TODO Auto-generated method stub
		return false;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getBytes(int)
	 */
	public byte[] getBytes(int arg0) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateByte(int, byte)
	 */
	public void updateByte(int arg0, byte arg1) throws SQLException {
		// TODO Auto-generated method stub
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateDouble(int, double)
	 */
	public void updateDouble(int arg0, double arg1) throws SQLException {
		// TODO Auto-generated method stub
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateFloat(int, float)
	 */
	public void updateFloat(int arg0, float arg1) throws SQLException {
		// TODO Auto-generated method stub
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateInt(int, int)
	 */
	public void updateInt(int arg0, int arg1) throws SQLException {
		// TODO Auto-generated method stub
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateLong(int, long)
	 */
	public void updateLong(int arg0, long arg1) throws SQLException {
		// TODO Auto-generated method stub
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateShort(int, short)
	 */
	public void updateShort(int arg0, short arg1) throws SQLException {
		// TODO Auto-generated method stub
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateBoolean(int, boolean)
	 */
	public void updateBoolean(int arg0, boolean arg1) throws SQLException {
		// TODO Auto-generated method stub
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateBytes(int, byte[])
	 */
	public void updateBytes(int arg0, byte[] arg1) throws SQLException {
		// TODO Auto-generated method stub
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getAsciiStream(int)
	 */
	public InputStream getAsciiStream(int arg0) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getBinaryStream(int)
	 */
	public InputStream getBinaryStream(int arg0) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getUnicodeStream(int)
	 */
	@Deprecated
	public InputStream getUnicodeStream(int arg0) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateAsciiStream(int, java.io.InputStream, int)
	 */
	public void updateAsciiStream(int arg0, InputStream arg1, int arg2)
			throws SQLException {
		// TODO Auto-generated method stub
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateBinaryStream(int, java.io.InputStream, int)
	 */
	public void updateBinaryStream(int arg0, InputStream arg1, int arg2)
			throws SQLException {
		// TODO Auto-generated method stub
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getCharacterStream(int)
	 */
	public Reader getCharacterStream(int arg0) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateCharacterStream(int, java.io.Reader, int)
	 */
	public void updateCharacterStream(int arg0, Reader arg1, int arg2)
			throws SQLException {
		// TODO Auto-generated method stub
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getObject(int)
	 */
	public Object getObject(int arg0) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateObject(int, java.lang.Object)
	 */
	public void updateObject(int arg0, Object arg1) throws SQLException {
		// TODO Auto-generated method stub
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateObject(int, java.lang.Object, int)
	 */
	public void updateObject(int arg0, Object arg1, int arg2)
			throws SQLException {
		// TODO Auto-generated method stub
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getCursorName()
	 */
	public String getCursorName() throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getString(int)
	 */
	public String getString(int arg0) throws SQLException 
	{
		List tt = (List)byLocationLookup.get(arg0-1);
		String pp =  (String)tt.get(pointer);
		
		return (String) ((List)byLocationLookup.get(arg0-1)).get(pointer);
		
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateString(int, java.lang.String)
	 */
	public void updateString(int arg0, String arg1) throws SQLException {
		// TODO Auto-generated method stub
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getByte(java.lang.String)
	 */
	public byte getByte(String arg0) throws SQLException {
		// TODO Auto-generated method stub
		return 0;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getDouble(java.lang.String)
	 */
	public double getDouble(String arg0) throws SQLException {
		// TODO Auto-generated method stub
		return 0;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getFloat(java.lang.String)
	 */
	public float getFloat(String arg0) throws SQLException {
		// TODO Auto-generated method stub
		return 0;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#findColumn(java.lang.String)
	 */
	public int findColumn(String arg0) throws SQLException {
		// TODO Auto-generated method stub
		return 0;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getInt(java.lang.String)
	 */
	public int getInt(String arg0) throws SQLException {
		// TODO Auto-generated method stub
		return 0;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getLong(java.lang.String)
	 */
	public long getLong(String arg0) throws SQLException {
		// TODO Auto-generated method stub
		return 0;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getShort(java.lang.String)
	 */
	public short getShort(String arg0) throws SQLException {
		// TODO Auto-generated method stub
		return 0;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateNull(java.lang.String)
	 */
	public void updateNull(String arg0) throws SQLException {
		// TODO Auto-generated method stub
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getBoolean(java.lang.String)
	 */
	public boolean getBoolean(String arg0) throws SQLException {
		// TODO Auto-generated method stub
		return false;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getBytes(java.lang.String)
	 */
	public byte[] getBytes(String arg0) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateByte(java.lang.String, byte)
	 */
	public void updateByte(String arg0, byte arg1) throws SQLException {
		// TODO Auto-generated method stub
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateDouble(java.lang.String, double)
	 */
	public void updateDouble(String arg0, double arg1) throws SQLException {
		// TODO Auto-generated method stub
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateFloat(java.lang.String, float)
	 */
	public void updateFloat(String arg0, float arg1) throws SQLException {
		// TODO Auto-generated method stub
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateInt(java.lang.String, int)
	 */
	public void updateInt(String arg0, int arg1) throws SQLException {
		// TODO Auto-generated method stub
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateLong(java.lang.String, long)
	 */
	public void updateLong(String arg0, long arg1) throws SQLException {
		// TODO Auto-generated method stub
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateShort(java.lang.String, short)
	 */
	public void updateShort(String arg0, short arg1) throws SQLException {
		// TODO Auto-generated method stub
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateBoolean(java.lang.String, boolean)
	 */
	public void updateBoolean(String arg0, boolean arg1) throws SQLException {
		// TODO Auto-generated method stub
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateBytes(java.lang.String, byte[])
	 */
	public void updateBytes(String arg0, byte[] arg1) throws SQLException {
		// TODO Auto-generated method stub
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getBigDecimal(int)
	 */
	@Deprecated
	public BigDecimal getBigDecimal(int arg0) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getBigDecimal(int, int)
	 */
	@Deprecated
	public BigDecimal getBigDecimal(int arg0, int arg1) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateBigDecimal(int, java.math.BigDecimal)
	 */
	public void updateBigDecimal(int arg0, BigDecimal arg1) throws SQLException {
		// TODO Auto-generated method stub
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getURL(int)
	 */
	public URL getURL(int arg0) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getArray(int)
	 */
	public Array getArray(int arg0) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateArray(int, java.sql.Array)
	 */
	public void updateArray(int arg0, Array arg1) throws SQLException {
		// TODO Auto-generated method stub
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getBlob(int)
	 */
	public Blob getBlob(int arg0) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateBlob(int, java.sql.Blob)
	 */
	public void updateBlob(int arg0, Blob arg1) throws SQLException {
		// TODO Auto-generated method stub
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getClob(int)
	 */
	public Clob getClob(int arg0) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateClob(int, java.sql.Clob)
	 */
	public void updateClob(int arg0, Clob arg1) throws SQLException {
		// TODO Auto-generated method stub
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getDate(int)
	 */
	public Date getDate(int arg0) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateDate(int, java.sql.Date)
	 */
	public void updateDate(int arg0, Date arg1) throws SQLException {
		// TODO Auto-generated method stub
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getRef(int)
	 */
	public Ref getRef(int arg0) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateRef(int, java.sql.Ref)
	 */
	public void updateRef(int arg0, Ref arg1) throws SQLException {
		// TODO Auto-generated method stub
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getMetaData()
	 */
	public ResultSetMetaData getMetaData() throws SQLException 
	{
		return metadata;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getWarnings()
	 */
	public SQLWarning getWarnings() throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getStatement()
	 */
	public Statement getStatement() throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getTime(int)
	 */
	public Time getTime(int arg0) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateTime(int, java.sql.Time)
	 */
	public void updateTime(int arg0, Time arg1) throws SQLException {
		// TODO Auto-generated method stub
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getTimestamp(int)
	 */
	public Timestamp getTimestamp(int arg0) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateTimestamp(int, java.sql.Timestamp)
	 */
	public void updateTimestamp(int arg0, Timestamp arg1) throws SQLException {
		// TODO Auto-generated method stub
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getAsciiStream(java.lang.String)
	 */
	public InputStream getAsciiStream(String arg0) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getBinaryStream(java.lang.String)
	 */
	public InputStream getBinaryStream(String arg0) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getUnicodeStream(java.lang.String)
	 */
	@Deprecated
	public InputStream getUnicodeStream(String arg0) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateAsciiStream(java.lang.String, java.io.InputStream, int)
	 */
	public void updateAsciiStream(String arg0, InputStream arg1, int arg2)
			throws SQLException {
		// TODO Auto-generated method stub
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateBinaryStream(java.lang.String, java.io.InputStream, int)
	 */
	public void updateBinaryStream(String arg0, InputStream arg1, int arg2)
			throws SQLException {
		// TODO Auto-generated method stub
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getCharacterStream(java.lang.String)
	 */
	public Reader getCharacterStream(String arg0) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateCharacterStream(java.lang.String, java.io.Reader, int)
	 */
	public void updateCharacterStream(String arg0, Reader arg1, int arg2)
			throws SQLException {
		// TODO Auto-generated method stub
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getObject(java.lang.String)
	 */
	public Object getObject(String arg0) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateObject(java.lang.String, java.lang.Object)
	 */
	public void updateObject(String arg0, Object arg1) throws SQLException {
		// TODO Auto-generated method stub
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateObject(java.lang.String, java.lang.Object, int)
	 */
	public void updateObject(String arg0, Object arg1, int arg2)
			throws SQLException {
		// TODO Auto-generated method stub
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getString(java.lang.String)
	 */
	public String getString(String arg0) throws SQLException 
	{	
		String s = null;
		try {
			s = (String) ((List)byNameLookup.get(arg0)).get(pointer);
		} catch (Throwable t) {
			// Ensure no null pointer exception, return empty string...	
		}
		if(s == null)
			s = "";
		return s;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateString(java.lang.String, java.lang.String)
	 */
	public void updateString(String arg0, String arg1) throws SQLException {
		// TODO Auto-generated method stub
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getBigDecimal(java.lang.String)
	 */
	@Deprecated
	public BigDecimal getBigDecimal(String arg0) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getBigDecimal(java.lang.String, int)
	 */
	@Deprecated
	public BigDecimal getBigDecimal(String arg0, int arg1) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateBigDecimal(java.lang.String, java.math.BigDecimal)
	 */
	public void updateBigDecimal(String arg0, BigDecimal arg1)
			throws SQLException {
		// TODO Auto-generated method stub
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getURL(java.lang.String)
	 */
	public URL getURL(String arg0) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getArray(java.lang.String)
	 */
	public Array getArray(String arg0) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateArray(java.lang.String, java.sql.Array)
	 */
	public void updateArray(String arg0, Array arg1) throws SQLException {
		// TODO Auto-generated method stub
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getBlob(java.lang.String)
	 */
	public Blob getBlob(String arg0) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateBlob(java.lang.String, java.sql.Blob)
	 */
	public void updateBlob(String arg0, Blob arg1) throws SQLException {
		// TODO Auto-generated method stub
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getClob(java.lang.String)
	 */
	public Clob getClob(String arg0) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateClob(java.lang.String, java.sql.Clob)
	 */
	public void updateClob(String arg0, Clob arg1) throws SQLException {
		// TODO Auto-generated method stub
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getDate(java.lang.String)
	 */
	public Date getDate(String arg0) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateDate(java.lang.String, java.sql.Date)
	 */
	public void updateDate(String arg0, Date arg1) throws SQLException {
		// TODO Auto-generated method stub
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getDate(int, java.util.Calendar)
	 */
	public Date getDate(int arg0, Calendar arg1) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getRef(java.lang.String)
	 */
	public Ref getRef(String arg0) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateRef(java.lang.String, java.sql.Ref)
	 */
	public void updateRef(String arg0, Ref arg1) throws SQLException {
		// TODO Auto-generated method stub
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getTime(java.lang.String)
	 */
	public Time getTime(String arg0) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateTime(java.lang.String, java.sql.Time)
	 */
	public void updateTime(String arg0, Time arg1) throws SQLException {
		// TODO Auto-generated method stub
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getTime(int, java.util.Calendar)
	 */
	public Time getTime(int arg0, Calendar arg1) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getTimestamp(java.lang.String)
	 */
	public Timestamp getTimestamp(String arg0) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateTimestamp(java.lang.String, java.sql.Timestamp)
	 */
	public void updateTimestamp(String arg0, Timestamp arg1)
			throws SQLException {
		// TODO Auto-generated method stub
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getTimestamp(int, java.util.Calendar)
	 */
	public Timestamp getTimestamp(int arg0, Calendar arg1) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getDate(java.lang.String, java.util.Calendar)
	 */
	public Date getDate(String arg0, Calendar arg1) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getTime(java.lang.String, java.util.Calendar)
	 */
	public Time getTime(String arg0, Calendar arg1) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getTimestamp(java.lang.String, java.util.Calendar)
	 */
	public Timestamp getTimestamp(String arg0, Calendar arg1)
			throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
    public int getMaxSize() {
        return maxSize;
    }

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getHoldability()
	 */
	public int getHoldability() throws SQLException
	{
		// TODO Auto-generated method stub
		return 0;
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getNCharacterStream(int)
	 */
	public Reader getNCharacterStream(int arg0) throws SQLException
	{
		// TODO Auto-generated method stub
		return null;
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getNCharacterStream(java.lang.String)
	 */
	public Reader getNCharacterStream(String arg0) throws SQLException
	{
		// TODO Auto-generated method stub
		return null;
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getNClob(int)
	 */
	public NClob getNClob(int arg0) throws SQLException
	{
		// TODO Auto-generated method stub
		return null;
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getNClob(java.lang.String)
	 */
	public NClob getNClob(String arg0) throws SQLException
	{
		return null;
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getNString(int)
	 */
	public String getNString(int arg0) throws SQLException
	{
		// TODO Auto-generated method stub
		return null;
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getNString(java.lang.String)
	 */
	public String getNString(String arg0) throws SQLException
	{
		// TODO Auto-generated method stub
		return null;
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getObject(int, java.util.Map)
	 */
	public Object getObject(int arg0, Map<String, Class<?>> arg1) throws SQLException
	{
		// TODO Auto-generated method stub
		return null;
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getObject(java.lang.String, java.util.Map)
	 */
	public Object getObject(String arg0, Map<String, Class<?>> arg1) throws SQLException
	{
		// TODO Auto-generated method stub
		return null;
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getRowId(int)
	 */
	public RowId getRowId(int arg0) throws SQLException
	{
		return null;
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getRowId(java.lang.String)
	 */
	public RowId getRowId(String arg0) throws SQLException
	{
		return null;
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getSQLXML(int)
	 */
	public SQLXML getSQLXML(int arg0) throws SQLException
	{
		// TODO Auto-generated method stub
		return null;
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#getSQLXML(java.lang.String)
	 */
	public SQLXML getSQLXML(String arg0) throws SQLException
	{
		// TODO Auto-generated method stub
		return null;
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#isClosed()
	 */
	public boolean isClosed() throws SQLException
	{
		// TODO Auto-generated method stub
		return false;
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateAsciiStream(int, java.io.InputStream)
	 */
	public void updateAsciiStream(int arg0, InputStream arg1) throws SQLException
	{
		// TODO Auto-generated method stub
		
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateAsciiStream(java.lang.String, java.io.InputStream)
	 */
	public void updateAsciiStream(String arg0, InputStream arg1) throws SQLException
	{
		// TODO Auto-generated method stub
		
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateAsciiStream(int, java.io.InputStream, long)
	 */
	public void updateAsciiStream(int arg0, InputStream arg1, long arg2) throws SQLException
	{
		// TODO Auto-generated method stub
		
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateAsciiStream(java.lang.String, java.io.InputStream, long)
	 */
	public void updateAsciiStream(String arg0, InputStream arg1, long arg2) throws SQLException
	{
		// TODO Auto-generated method stub
		
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateBinaryStream(int, java.io.InputStream)
	 */
	public void updateBinaryStream(int arg0, InputStream arg1) throws SQLException
	{
		// TODO Auto-generated method stub
		
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateBinaryStream(java.lang.String, java.io.InputStream)
	 */
	public void updateBinaryStream(String arg0, InputStream arg1) throws SQLException
	{
		// TODO Auto-generated method stub
		
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateBinaryStream(int, java.io.InputStream, long)
	 */
	public void updateBinaryStream(int arg0, InputStream arg1, long arg2) throws SQLException
	{
		// TODO Auto-generated method stub
		
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateBinaryStream(java.lang.String, java.io.InputStream, long)
	 */
	public void updateBinaryStream(String arg0, InputStream arg1, long arg2) throws SQLException
	{
		// TODO Auto-generated method stub
		
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateBlob(int, java.io.InputStream)
	 */
	public void updateBlob(int arg0, InputStream arg1) throws SQLException
	{
		// TODO Auto-generated method stub
		
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateBlob(java.lang.String, java.io.InputStream)
	 */
	public void updateBlob(String arg0, InputStream arg1) throws SQLException
	{
		// TODO Auto-generated method stub
		
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateBlob(int, java.io.InputStream, long)
	 */
	public void updateBlob(int arg0, InputStream arg1, long arg2) throws SQLException
	{
		// TODO Auto-generated method stub
		
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateBlob(java.lang.String, java.io.InputStream, long)
	 */
	public void updateBlob(String arg0, InputStream arg1, long arg2) throws SQLException
	{
		// TODO Auto-generated method stub
		
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateCharacterStream(int, java.io.Reader)
	 */
	public void updateCharacterStream(int arg0, Reader arg1) throws SQLException
	{
		// TODO Auto-generated method stub
		
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateCharacterStream(java.lang.String, java.io.Reader)
	 */
	public void updateCharacterStream(String arg0, Reader arg1) throws SQLException
	{
		// TODO Auto-generated method stub
		
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateCharacterStream(int, java.io.Reader, long)
	 */
	public void updateCharacterStream(int arg0, Reader arg1, long arg2) throws SQLException
	{
		// TODO Auto-generated method stub
		
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateCharacterStream(java.lang.String, java.io.Reader, long)
	 */
	public void updateCharacterStream(String arg0, Reader arg1, long arg2) throws SQLException
	{
		// TODO Auto-generated method stub
		
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateClob(int, java.io.Reader)
	 */
	public void updateClob(int arg0, Reader arg1) throws SQLException
	{
		// TODO Auto-generated method stub
		
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateClob(java.lang.String, java.io.Reader)
	 */
	public void updateClob(String arg0, Reader arg1) throws SQLException
	{
		// TODO Auto-generated method stub
		
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateClob(int, java.io.Reader, long)
	 */
	public void updateClob(int arg0, Reader arg1, long arg2) throws SQLException
	{
		// TODO Auto-generated method stub
		
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateClob(java.lang.String, java.io.Reader, long)
	 */
	public void updateClob(String arg0, Reader arg1, long arg2) throws SQLException
	{
		// TODO Auto-generated method stub
		
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateNCharacterStream(int, java.io.Reader)
	 */
	public void updateNCharacterStream(int arg0, Reader arg1) throws SQLException
	{
		// TODO Auto-generated method stub
		
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateNCharacterStream(java.lang.String, java.io.Reader)
	 */
	public void updateNCharacterStream(String arg0, Reader arg1) throws SQLException
	{
		// TODO Auto-generated method stub
		
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateNCharacterStream(int, java.io.Reader, long)
	 */
	public void updateNCharacterStream(int arg0, Reader arg1, long arg2) throws SQLException
	{
		// TODO Auto-generated method stub
		
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateNCharacterStream(java.lang.String, java.io.Reader, long)
	 */
	public void updateNCharacterStream(String arg0, Reader arg1, long arg2) throws SQLException
	{
		// TODO Auto-generated method stub
		
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateNClob(int, java.sql.NClob)
	 */
	public void updateNClob(int arg0, NClob arg1) throws SQLException
	{
		
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateNClob(java.lang.String, java.sql.NClob)
	 */
	public void updateNClob(String arg0, NClob arg1) throws SQLException
	{
		
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateNClob(int, java.io.Reader)
	 */
	public void updateNClob(int arg0, Reader arg1) throws SQLException
	{
		
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateNClob(java.lang.String, java.io.Reader)
	 */
	public void updateNClob(String arg0, Reader arg1) throws SQLException
	{
		
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateNClob(int, java.io.Reader, long)
	 */
	public void updateNClob(int arg0, Reader arg1, long arg2) throws SQLException
	{
		
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateNClob(java.lang.String, java.io.Reader, long)
	 */
	public void updateNClob(String arg0, Reader arg1, long arg2) throws SQLException
	{
		
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateNString(int, java.lang.String)
	 */
	public void updateNString(int arg0, String arg1) throws SQLException
	{
		
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateNString(java.lang.String, java.lang.String)
	 */
	public void updateNString(String arg0, String arg1) throws SQLException
	{
		
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateRowId(int, java.sql.RowId)
	 */
	public void updateRowId(int arg0, RowId arg1) throws SQLException
	{
		// TODO Auto-generated method stub
		
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateRowId(java.lang.String, java.sql.RowId)
	 */
	public void updateRowId(String arg0, RowId arg1) throws SQLException
	{
		// TODO Auto-generated method stub
		
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateSQLXML(int, java.sql.SQLXML)
	 */
	public void updateSQLXML(int arg0, SQLXML arg1) throws SQLException
	{
		// TODO Auto-generated method stub
		
	}

	/* (non-Javadoc)
	 * @see java.sql.ResultSet#updateSQLXML(java.lang.String, java.sql.SQLXML)
	 */
	public void updateSQLXML(String arg0, SQLXML arg1) throws SQLException
	{
		
	}

	/* (non-Javadoc)
	 * @see java.sql.Wrapper#isWrapperFor(java.lang.Class)
	 */
	public boolean isWrapperFor(Class<?> arg0) throws SQLException
	{
		// TODO Auto-generated method stub
		return false;
	}

	/* (non-Javadoc)
	 * @see java.sql.Wrapper#unwrap(java.lang.Class)
	 */
	public <T> T unwrap(Class<T> arg0) throws SQLException
	{
		// TODO Auto-generated method stub
		return null;
	}
}
