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

package edu.cu.cs.sms.util;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.PropertyResourceBundle;

public class DumpDatabase {
    private static ArrayList<String> tableList = new ArrayList<String>();

    private static Connection getDatabaseConnection(PropertyResourceBundle props)
            throws ClassNotFoundException, SQLException {
        String driverClassName = props.getString("Driver.Name");
        String driverURL = props.getString("Driver.URL")
                + props.getString("Driver.database");
        // Default to not having a quote character
        Class.forName(driverClassName);
        return DriverManager.getConnection(driverURL, props
                .getString("Driver.User"), props.getString("Driver.Password"));
    }

    public static String dumpTableSchema(PropertyResourceBundle props)
            throws SQLException {
        String columnNameQuote = "`";

        tableList.clear();

        DatabaseMetaData dbMetaData = null;
        Connection dbConn = null;
        try {
            dbConn = getDatabaseConnection(props);
            dbMetaData = dbConn.getMetaData();
        } catch (Exception e) {
            throw new SQLException();
        }

        try {
            StringBuffer result = new StringBuffer();
            ResultSet rs = dbMetaData.getTables(null, null, null, null);
            if (!rs.next()) {
                // System.err.println("Unable to find any tables matching:
                // catalog="+catalog+" schema="+schema+" tables="+tables);
                rs.close();
            } else {
                // Right, we have some tables, so we can go to work.
                // the details we have are
                // TABLE_CAT String => table catalog (may be null)
                // TABLE_SCHEM String => table schema (may be null)
                // TABLE_NAME String => table name
                // TABLE_TYPE String => table type. Typical types are "TABLE",
                // "VIEW", "SYSTEM TABLE", "GLOBAL TEMPORARY", "LOCAL
                // TEMPORARY", "ALIAS", "SYNONYM".
                // REMARKS String => explanatory comment on the table
                // TYPE_CAT String => the types catalog (may be null)
                // TYPE_SCHEM String => the types schema (may be null)
                // TYPE_NAME String => type name (may be null)
                // SELF_REFERENCING_COL_NAME String => name of the designated
                // "identifier" column of a typed table (may be null)
                // REF_GENERATION String => specifies how values in
                // SELF_REFERENCING_COL_NAME are created. Values are "SYSTEM",
                // "USER", "DERIVED". (may be null)
                // We will ignore the schema and stuff, because people might
                // want to import it somewhere else
                // We will also ignore any tables that aren't of type TABLE for
                // now.
                // We use a do-while because we've already caled rs.next to see
                // if there are any rows
                do {
                    String tableName = rs.getString("TABLE_NAME");
                    String tableType = rs.getString("TABLE_TYPE");

                    if ("TABLE".equalsIgnoreCase(tableType)) {
                        ResultSet tableMetaData = dbMetaData.getColumns(null,
                                null, tableName, null);
                        boolean firstLine = true;

                        result.append("DROP TABLE IF EXISTS `" + tableName
                                + "`;\n");
                        result.append("CREATE TABLE " + tableName + " (");

                        while (tableMetaData.next()) {
                            if (firstLine)
                                firstLine = false;
                            else
                                result.append(",");

                            String columnName = tableMetaData
                                    .getString("COLUMN_NAME");
                            String columnType = tableMetaData
                                    .getString("TYPE_NAME");
                            int columnSize = tableMetaData
                                    .getInt("COLUMN_SIZE");
                            String nullable = tableMetaData
                                    .getString("IS_NULLABLE");
                            String nullString = "NULL";
                            String defaultValue = tableMetaData
                                    .getString("COLUMN_DEF");
                            String defString = "";
                            String enumValue = String.valueOf(columnSize);

                            if (defaultValue != null)
                                defString = "";
                            	//defString = "default '" + defaultValue + "'";	

                            if ("NO".equalsIgnoreCase(nullable))
                                nullString = "NOT NULL " + defString;

                            if (columnType.trim().equalsIgnoreCase("enum"))
                                enumValue = props.getString("Driver."
                                        + columnName);

                            result
                                    .append(columnNameQuote
                                            + columnName
                                            + columnNameQuote
                                            + " "
                                            + columnType
                                            + ((columnType.equals("varchar") || columnType
                                                    .equals("enum")) ? " ("
                                                    + enumValue + ")" : "")
                                            + " " + nullString);
                        }

                        tableMetaData.close();

                        // Now we need to put the primary key constraint
                        try {
                            ResultSet primaryKeys = dbMetaData.getPrimaryKeys(
                                    null, null, tableName);
                            // What we might get:
                            // TABLE_CAT String => table catalog (may be null)
                            // TABLE_SCHEM String => table schema (may be null)
                            // TABLE_NAME String => table name
                            // COLUMN_NAME String => column name
                            // KEY_SEQ short => sequence number within primary
                            // key
                            // PK_NAME String => primary key name (may be null)
                            String primaryKeyName = null;
                            StringBuffer primaryKeyColumns = new StringBuffer();

                            while (primaryKeys.next()) {
                                String thisKeyName = primaryKeys
                                        .getString("PK_NAME");

                                if ((thisKeyName != null && primaryKeyName == null)
                                        || (thisKeyName == null && primaryKeyName != null)
                                        || (thisKeyName != null && !thisKeyName
                                                .equals(primaryKeyName))
                                        || (primaryKeyName != null && !primaryKeyName
                                                .equals(thisKeyName))) {
                                    // the keynames aren't the same, so output
                                    // all that we have so far (if anything)
                                    // and start a new primary key entry
                                    if (primaryKeyColumns.length() > 0) {
                                        // There's something to output
                                        result.append(", PRIMARY KEY ");
                                        // if (primaryKeyName != null) {
                                        // result.append(primaryKeyName); }
                                        result.append("("
                                                + primaryKeyColumns.toString()
                                                + ")");
                                    }
                                    // Start again with the new name
                                    primaryKeyColumns = new StringBuffer();
                                    primaryKeyName = thisKeyName;
                                }
                                // Now append the column
                                if (primaryKeyColumns.length() > 0)
                                    primaryKeyColumns.append(", ");

                                primaryKeyColumns.append(primaryKeys
                                        .getString("COLUMN_NAME"));
                            }

                            if (primaryKeyColumns.length() > 0) {
                                // There's something to output
                                result.append(", PRIMARY KEY ");
                                // if (primaryKeyName != null) {
                                // result.append(primaryKeyName); }
                                result.append(" ("
                                        + primaryKeyColumns.toString() + ")");
                            }

                        } catch (SQLException e) {
                            throw new SQLException();
                        }

                        result.append(");\n");

                        // Right, we have a table, so we can go and dump it
                        // dumpTable(dbConn, result, tableName);

                        tableList.add(tableName);

                    }
                } while (rs.next());

                rs.close();
            }

            dbConn.close();

            return result.toString();
        } catch (SQLException e) {
            throw new SQLException();
        }
    }

    private static void dumpTable(Connection dbConn, StringBuffer result,
            String tableName) throws SQLException {
        try {
            // First we output the create table stuff
            PreparedStatement stmt = dbConn.prepareStatement("SELECT * FROM "
                    + tableName);
            ResultSet rs = stmt.executeQuery();
            ResultSetMetaData metaData = rs.getMetaData();
            int columnCount = metaData.getColumnCount();
            boolean firstSet = true;


            // Now we can output the actual data
            while (rs.next()) {
//                if (!firstSet)
//                    result.append(",");

                firstSet = false;

                result.append("INSERT INTO " + tableName + " VALUES ");
                result.append("(");

                for (int i = 0; i < columnCount; i++) {
                    if (i > 0)
                        result.append(", ");

                    Object value = rs.getObject(i + 1);

                    if (value == null)
                        result.append("NULL");
                    else {
                        String outputValue = value.toString();
                        
                        outputValue = outputValue.replaceAll("\'", "\\\\'");
                        result.append("'" + outputValue + "'");
                    }
                }
                result.append(");\n");
            }

            if (firstSet)
                result.append("()");

//            result.append(";\n");

            rs.close();
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new SQLException();
        }
    }

    public static String dumpTableContent(PropertyResourceBundle conf)
            throws ClassNotFoundException, SQLException {
        Connection con = getDatabaseConnection(conf);
        StringBuffer sb = new StringBuffer();

        for (int counter = 0; counter < tableList.size(); counter++) {
            String tableName = tableList.get(counter);

            sb.append("LOCK TABLES `" + tableName + "` WRITE;\n");
            dumpTable(con, sb, tableName);
            sb.append("UNLOCK TABLES;\n");
        }
        return sb.toString();
    }

}
