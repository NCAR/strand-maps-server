<%@page import="java.lang.*,java.sql.*,java.io.*,java.net.*,java.util.*,
java.util.regex.*,java.text.*,javax.xml.parsers.*,javax.xml.transform.Transformer,
javax.xml.transform.TransformerFactory,javax.xml.transform.TransformerException,
javax.xml.transform.TransformerConfigurationException,javax.xml.transform.dom.*,
javax.xml.transform.stream.*,edu.cu.cs.sms.Database.*,org.xml.sax.*,org.w3c.dom.*"%>

<%!
//  University of Illinois/NCSA Open Source License
//
// Copyright &#xa9; 2002,2003 The Board of Trustees of the University of Illinois
// All rights reserved.
//
// Developed by:  Open Archives Initiative Metadata Harvesting Project
//                University of Illinois at Urbana-Champaign
//                http://oai.grainger.uiuc.edu/
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal with the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
//
//     &#xb7; Redistributions of source code must retain the above copyright
//            notice, this list of conditions and the following disclaimers.
//     &#xb7; Redistributions in binary form must reproduce the above copyright
//            notice, this list of conditions and the following disclaimers in the
//            documentation and/or other materials provided with the distribution.
//     &#xb7; Neither the names of Open Archives Initiative Metadata Harvesting
//            Project, University of Illinois at Urbana-Champaign, nor the names of
//            its contributors may be used to endorse or promote products derived
//            from this Software without specific prior written permission.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
// THE CONTRIBUTORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
// OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
// ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS WITH THE SOFTWARE.
//

/* N.B.: DELETIONS AND RECORD-SPECIFIC FORMATS ARE NOT SUPPORTED IN THIS
   IMPLEMENTATION.

   To change the database, change all routines with names beginning with
   "db".  Some of these assume a primary key for the master table, ids,
   stored in global g_currentRecID.  Others assume a metadata record
   identifier stored in g_currentOAI_ID.  If you change either the database
   format or input data format (from MARC21) you must change the code in
   OAI_DC_Handler().

   To add an output format in addition to oai_dc, replace the word OTHER with
   the new name, and write OAI_OTHER_Handler().
*/

// INITIALIZE GLOBAL VARIABLES
// Change the variables having names ending in "Param" as needed in the oai.ini file

	public String g_ThisArchiveParam;
	public String g_ThisSchemeParam;
	public int g_MaxIdentifiersParam;
	public int g_MaxRecordsParam;
	public int g_MaxSetsParam;
	public boolean OAI_LOG;
	public String requestURL;
	public String g_verb;
	public String g_identifier;             // xxx:xxx:g_currentOAI_ID
	public String g_metadataPrefix;
	public String g_untilDateStr;
	public String g_fromDateStr;
	public String g_set_;
	public String g_currentOAI_ID;
	public long g_currentRecID;            // primary key in table ids
	public String g_resumptionToken;
	public java.util.Date fromDate;			// can be local
	public java.util.Date untilDate;		// can be local
	public java.util.Date g_lastUpdate;
	public java.util.Date g_whenRsmtnTokenCreatedUTC;
	public Connection g_conn;
	public Statement g_stmtSets;  	// for all sets for an OAI_Identifier
	public Statement g_fieldStmt;  	// for all fields of item that map to the same DC field
	public Statement g_stmt;  		// general purpose, generally all OAI_Identifiers
	public ResultSet g_rsSets;
	public ResultSet g_rs;
	public String    g_BaseURL;
	public boolean typeCreatedInUseFormats = false;  // used only for OTHER
	public long g_completeListSize=0;
	public Properties prop = new Properties();
	public String tID;
//    public PropertyResourceBundle conf = new PropertyResourceBundle(new BufferedInputStream(this.getClass().getClassLoader().getResourceAsStream("edu/cu/cs/sms/Database/database.properties")));
    public Properties conf = new Properties(); 

%><%

// GET CONFIG FILE VALUES AND OPEN DATABASE

	String propPath;
	propPath=pageContext.getServletContext().getRealPath("/") + "OAI.ini";
	getConfigVariables(propPath);
	if(! dbOpen( out)){
		return;
	}

// CHECK FOR VERB, must be exactly one, not empty string,
// and legal OAI verb

	if(! checkVerbArguments(request, out)){
		return;
	}

// IMPLEMENT PSEUDO-VERB "Document", USEFUL FOR DEBUG AND DEMOS (but assumes
// there's a record id=1477521)

	if (g_verb.equals("Document")) {
      	Document(request,response,out);
		return;
	}

// WRITE OAI HEADER

	Write_OAIPMH_Header(request, response, out);

// DISPATCH TO VERB-SPECIFIC ROUTINE TO VALIDATE AND IMPLEMENT VERB

	if (g_verb.equals("Identify")) {
		Identify(request,response,out);}

	else if (g_verb.equals("GetRecord")) {
		GetRecord(request,response,out);}

	else if (g_verb.equals("ListSets")) {
		ListSets(request,response,out);}

	else if (g_verb.equals("ListMetadataFormats")) {
		ListMetadataFormats(request,response,out);}

	else if (g_verb.equals("ListIdentifiers")) {
		ListIdentifiers(request,response,out);}

	else if (g_verb.equals("ListRecords")) {
		ListRecords(request,response,out);}

// WRITE OAI-PMH TRAILER and end

	Write_OAIPMH_Trailer(out);


%>
<%!
// ***************************************************
// ***************  BEGIN SUBPROCEDURES **************
// ***************************************************


private boolean checkGetRecordsArguments (JspWriter out, HttpServletRequest request){

	String pname;
	String[] tmpstr;
	String requestString;
	Enumeration enu = request.getParameterNames();

	String err="";
	fromDate = null;
	g_fromDateStr = "";
	g_metadataPrefix = "";
	g_resumptionToken = "";
	g_set_ = "";
	g_untilDateStr = "";
	untilDate = null;
	g_identifier = "";
	requestString = "<request";

	// GetRecord MUST have identifier AND metadataPrefix
	while (enu.hasMoreElements()) {
		pname = enu.nextElement().toString();
		if (pname.equals("verb")) {
			}
		else if (pname.equals("identifier")) {
			tmpstr = request.getParameterValues("identifier");
			if (tmpstr.length > 1) {
				err += "\t<error code=\"badArgument\">Multiple 'identifier' is "
					+ "not allowed.</error>\n";
			} else {
				try {
		    		g_identifier = tmpstr[0].trim();
					URI uri = new URI(g_identifier);
				}
				catch(URISyntaxException ue) {
					err += "\t<error code=\"badArgument\">Identifier '"
						+ htmlEncode(g_identifier) + "' is not valid.</error>\n";
				}
			}}
		else if (pname.equals("metadataPrefix")) {
			tmpstr = request.getParameterValues("metadataPrefix");
			if (tmpstr.length > 1) {
				err += "\t<error code=\"badArgument\">Multiple 'metadataPrefix' "
					+ "is not allowed.</error>\n";}
			else if (!tmpstr[0].equals("oai_dc") && !tmpstr[0].equals("nsdl_dc")){
				err += "\t<error code=\"cannotDisseminateFormat\">The value "
					+ "of the metadataPrefix argument '" +	tmpstr[0]
					+ "' is not supported by the repository</error>\n";
		   		g_metadataPrefix = tmpstr[0].trim();} //to avoid "missing" error
			else {
		   		g_metadataPrefix = tmpstr[0].trim();
			}
		} else {
			err += "\t<error code=\"badArgument\">Illegal argument '" + pname
				+ "'</error>\n";
		}
	}

	if (g_identifier.length() == 0) {
		err += "\t<error code=\"badArgument\">Required argument 'identifier' "
			+ "is missing.</error>\n";
	}

	if (g_metadataPrefix.length() == 0) {
		err += "\t<error code=\"badArgument\">Required argument 'metadataPrefix' "
			+ "is missing.</error>\n";
	}

	if (err.length() != 0) {
		requestString += ">" + request.getRequestURL() + "</request>";
		try{
			out.println( requestString);
			out.println(err);
		} catch(Exception x){return false;}
		return false;
	}

	try{
			requestString +=
			" verb=\"GetRecord\" identifier=\""
				+ htmlEncode(g_identifier)
				+ "\" metadataPrefix=\"" + htmlEncode(g_metadataPrefix) + "\">"
				+ request.getRequestURL() + "</request>";
			out.println( requestString);}
	catch(Exception ex){}
	return true;
}


private boolean checkIdentifyArguments(JspWriter out,
	HttpServletRequest request){

	String[] tmpstr;
	String pname;
	String requestString;
	String err="";

	Enumeration enu = request.getParameterNames();

	requestString = "<request verb=\"Identify\"";

	while (enu.hasMoreElements()) {
		pname = enu.nextElement().toString();
		if (!pname.equals("verb")) {
			err += "\t<error code=\"badArgument\">Illegal argument '"
				+ htmlEncode(pname) + "'</error>\n";
		}
	}

	requestString += ">" + request.getRequestURL() + "</request>";
	try{out.println( requestString);}catch(Exception ex){}

	if (err.length()==0) {
		return true;}
	else {
		try{out.println( err);} catch(Exception ex){}
		return false;
	}
}


private boolean checkListIdentifiersArguments (JspWriter out,
	HttpServletRequest request){

	String pname;
	String[] tmpstr;
	String requestString;
	Enumeration enu = request.getParameterNames();

	String err = "";
	fromDate = null;
	g_fromDateStr = "";
	g_identifier = "";
	g_metadataPrefix = "";
	g_resumptionToken = "";
	g_set_ = "";
	g_untilDateStr = "";
	untilDate = null;

	requestString = "<request";

	// until, from, and set are optional parameters, metadataPrefix is
	// required, but resumptionToken is an exclusive parameter
	while (enu.hasMoreElements()) {
		pname = enu.nextElement().toString();
		if (pname.equals("verb")) {
			}
		else if (pname.equals("identifier")){
			tmpstr = request.getParameterValues("identifier");
			if (tmpstr.length > 1) {
				err += "\t<error code=\"badArgument\">Multiple 'identifier' "
					+ "is not allowed.</error>\n";}
			else {
		    	g_identifier = tmpstr[0].trim();
				try {
					URI uri = new URI(g_identifier);
				}
				catch(URISyntaxException ue) {
					err += "\t<error code=\"badArgument\">Identifier '"
						+ htmlEncode(g_identifier) + "' is not valid.</error>\n";
				}
			}}
		else if (pname.equals("metadataPrefix")) {
			tmpstr = request.getParameterValues("metadataPrefix");
			if (tmpstr.length > 1) {
				err += "\t<error code=\"badArgument\">Multiple 'metadataPrefix' "
					+ "is not allowed.</error>\n";}
			else if (!tmpstr[0].equals("oai_dc") && !tmpstr[0].equals("nsdl_dc")){
				err += "\t<error code=\"cannotDisseminateFormat\">The value "
					+ "of the metadataPrefix argument '" +	tmpstr[0]
					+ "' is not supported by the repository</error>\n";
		    	g_metadataPrefix = tmpstr[0].trim();}//to avoid "missing" error
			else {
		    	g_metadataPrefix = tmpstr[0].trim();
			}}
		else if (pname.equals("until")) {
			tmpstr = request.getParameterValues("until");
			if (tmpstr.length > 1) {
				err += "\t<error code=\"badArgument\">Multiple 'until' "
					+ "is not allowed.</error>\n";}
		 	else {
	    		g_untilDateStr = tmpstr[0].trim();
	    		untilDate = completeDate(g_untilDateStr);
				if (untilDate == null) {
					err += "\t<error code=\"badArgument\">'"
						+ htmlEncode(g_untilDateStr)
						+ "' is illegal or not supported by the respository</error>\n";
				}
			}
		} else if (pname.equals("from")) {
			tmpstr = request.getParameterValues("from");
			if (tmpstr.length > 1) {
				err += "\t<error code=\"badArgument\">Multiple 'from' "
					+"is not allowed.</error>\n";}
			else {
	    		g_fromDateStr = tmpstr[0].trim();
				fromDate = completeDate(g_fromDateStr);
				if (fromDate == null) {
					err += "\t<error code=\"badArgument\">'"
						+ htmlEncode(g_fromDateStr)
						+ "' is illegal or not supported by the respository</error>\n";
				}
			}}
		else if (pname.equals("set")) {
			tmpstr = request.getParameterValues("set");
			if (tmpstr.length > 1) {
				err += "\t<error code=\"badArgument\">Multiple 'set' "
					+ "is not allowed.</error>\n";
			} else {
	    		g_set_ = tmpstr[0].trim();
			}
		} else if (pname.equals("resumptionToken")) {
			tmpstr = request.getParameterValues("resumptionToken");
			if (tmpstr.length > 1) {
				err += "\t<error code=\"badArgument\">Multiple 'resumpti"
				+ "onToken' is not allowed.</error>\n"; }
		 	else {
	    		g_resumptionToken = tmpstr[0].trim();
			}
		} else {
			err += "\t<error code=\"badArgument\">Illegal argument '"
				+ pname + "'</error>\n";
		}
	}

	// validate the from and until fields

	if (g_resumptionToken.length() > 0 &&
		(g_fromDateStr.length() + g_untilDateStr.length()
			+ g_metadataPrefix.length() + g_set_.length()) > 0) {
			err += "\t<error code=\"badArgument\">'resumptionToken' must be "
				+"the only parameter</error>\n";}
	else if (g_resumptionToken.length()== 0 && g_metadataPrefix.length() == 0) {
			err += "\t<error code=\"badArgument\">either 'metadataPrefix' "
				+ "or 'resumptionToken' is required</error>\n";
	}
	if (untilDate != null && fromDate != null) {
		if (g_untilDateStr.length() != g_fromDateStr.length()) {
			err +="\t<error code=\"badArgument\">The values of 'from' and"
			+ "'until' specify different granularity.</error>\n";
		}
	}
  	if( g_fromDateStr != null && g_fromDateStr.length() > 10 ) {
			err +="\t<error code=\"badArgument\">The value of 'from'"
			+ " requests a granularity finer than that available "
			+ " from this provider.</error>\n";
	}
  	if( g_untilDateStr != null && g_untilDateStr.length() > 10 ) {
			err +="\t<error code=\"badArgument\">The value of"
			+ " 'until' requests a granularity finer than that available "
			+ " from this provider.</error>\n";
	}
	if (err.length()!=0) {
		requestString += ">" + request.getRequestURL() + "</request>";
		try{
			out.println( requestString);
			out.println(err);
		} catch(Exception x){return false;}
		return false;}
	else {
		requestString +=" verb=\"ListIdentifiers\"";
		if (g_metadataPrefix.length() > 0) {
			requestString += " metadataPrefix=\"" + htmlEncode(g_metadataPrefix) + "\"";
		}
		if (g_fromDateStr.length() > 0) {
			requestString += " from=\"" + htmlEncode(g_fromDateStr) + "\"";
		}
		if (g_untilDateStr.length() > 0) {
			requestString += " until=\"" + htmlEncode(g_untilDateStr) + "\"";
		}
		if (g_set_.length() > 0) {
			requestString += " set=\"" + htmlEncode(g_set_) + "\"";
		}
		if (g_resumptionToken.length() > 0) {
			requestString += " resumptionToken=\"" +
				htmlEncode(g_resumptionToken) + "\"";
		}
		requestString += ">" + request.getRequestURL() + "</request>";
		try{out.println( requestString);}catch(Exception ex){return false;}
		return true;
	}
}


private boolean checkListMetadataFormatsArguments (JspWriter out,
	HttpServletRequest request){

	String[] tmpstr;
	String pname;
	String requestString;
	String err="";

	Enumeration enu = request.getParameterNames();

	requestString = "<request" ;

	// No required parameters, identifier parameter may be supplied
	g_identifier="";
	while (enu.hasMoreElements()) {
		pname = enu.nextElement().toString();
		if (pname.equals("verb")) {
			}
		else if (pname.equals("identifier")) {
			tmpstr = request.getParameterValues("identifier");
			if (tmpstr.length > 1) {
				err += "\t<error code=\"badArgument\">Multiple 'identifier' "
					+ "is not allowed.</error>\n";}
			else {
	    		g_identifier = tmpstr[0].trim();
				try {
					URI uri = new URI(g_identifier);
				}
				catch(URISyntaxException ue) {
					err += "\t<error code=\"badArgument\">Identifier '"
					+ htmlEncode(g_identifier) + "' is not valid.</error>\n";
				}
				// CHECK THAT THIS IDENTIFIER IS ACTUALLY IN THE
				// DATABASE AND IS HARVESTABLE

			  	String[] results = parseIdentifier();
				g_currentOAI_ID = results[3];
				if( ! dbPosition_IDRec( out)) {
					err += "\t<error code=\"idDoesNotExist\">The value of "
					+ "identifier '"  + htmlEncode(g_identifier) + "' is "
					+ "unknown or illegal in this repository.</error>\n";
				}
			}}
		else {
			err += "\t<error code=\"badArgument\">Illegal argument '"
				+ htmlEncode(pname) + "'</error>\n";
		}
	}
	if (err.length()!=0) {
		requestString += ">" + request.getRequestURL() + "</request>";
		try{out.println(requestString);} catch(Exception x){}
		try{out.println(err);} catch(Exception x){}
		return false;}
	else {
		requestString += " verb=\"ListMetadataFormats\"";
		if (g_identifier.length() > 0) {
			requestString += " identifier=\"" + htmlEncode(g_identifier) + "\"";
		}
		requestString += ">" + request.getRequestURL() + "</request>";
		try{out.println( requestString);}catch(Exception ex){}
		return true;
	}
}


private boolean checkListRecordsArguments (JspWriter out,
	HttpServletRequest request){

	String pname;
	String[] tmpstr;
	String requestString;
	Enumeration enu = request.getParameterNames();

	String err = "";
	fromDate = null;
	g_fromDateStr = "";
	g_identifier = "";
	g_metadataPrefix = "";
	g_resumptionToken = "";
	g_set_ = "";
	g_untilDateStr = "";
	untilDate = null;

	requestString = "<request";

	// until, from, and set are optional parameters, metadataPrefix is
	// required, but resumptionToken is an exclusive parameter
	while (enu.hasMoreElements()) {
		pname = enu.nextElement().toString();
		if (pname.equals("verb")) {
			g_verb = request.getParameter("verb");}
		else if (pname.equals("identifier")) {
			tmpstr = request.getParameterValues("identifier");
			if (tmpstr.length > 1) {
				err += "\t<error code=\"badArgument\">Multiple 'identifier' "
					+ "is not allowed.</error>\n";}
			else {
		    	g_identifier = tmpstr[0].trim();
				try {
					URI uri = new URI(g_identifier);
				}
				catch(URISyntaxException ue) {
					err += "\t<error code=\"badArgument\">Identifier '"
						+ htmlEncode(g_identifier) + "' is not valid.</error>\n";
				}
			}
		} else if (pname.equals("metadataPrefix")) {
			tmpstr = request.getParameterValues("metadataPrefix");
			if (tmpstr.length > 1) {
				err += "\t<error code=\"badArgument\">Multiple 'metadataPrefix' "
					+ "is not allowed.</error>\n";}
			else if (!tmpstr[0].equals("oai_dc") && !tmpstr[0].equals("nsdl_dc")){
				err += "\t<error code=\"cannotDisseminateFormat\">The value "
					+ "of the metadataPrefix argument '" +	tmpstr[0]
					+ "' is not supported by the repository</error>\n";
		    	g_metadataPrefix = tmpstr[0].trim();}//to avoid "missing" error
			else {
		    		g_metadataPrefix = tmpstr[0].trim();
			}}
			else if (pname.equals("until")) {
				tmpstr = request.getParameterValues("until");
				if (tmpstr.length > 1) {
					err += "\t<error code=\"badArgument\">Multiple 'until' "
						+ "is not allowed.</error>\n";}
			 	else {
		    		g_untilDateStr = tmpstr[0].trim();
		    		untilDate = completeDate(g_untilDateStr);
					if (untilDate == null) {
						err += "\t<error code=\"badArgument\">'"
							+ htmlEncode(g_untilDateStr)
							+ "' is illegal or not supported by the respository</error>\n";
					}
				}
			} else if (pname.equals("from")) {
				tmpstr = request.getParameterValues("from");
				if (tmpstr.length > 1) {
					err += "\t<error code=\"badArgument\">Multiple 'from' "
						+"is not allowed.</error>\n";}
				else {
		    		g_fromDateStr = tmpstr[0].trim();
					fromDate = completeDate(g_fromDateStr);
					if (fromDate == null) {
						err += "\t<error code=\"badArgument\">'"
							+ htmlEncode(g_fromDateStr)
							+ "' is illegal or not supported by the respository</error>\n";
					}
				}}
			else if (pname.equals("set")) {
			tmpstr = request.getParameterValues("set");
			if (tmpstr.length > 1) {
				err += "\t<error code=\"badArgument\">Multiple 'set' "
					+ "is not allowed.</error>\n";
			} else {
		    		g_set_ = tmpstr[0].trim();
			}
		} else if (pname.equals("resumptionToken")) {
			tmpstr = request.getParameterValues("resumptionToken");
			if (tmpstr.length > 1) {
				err += "\t<error code=\"badArgument\">Multiple 'resumptionToken' "
					+ "is not allowed.</error>\n";
			} else {
		    		g_resumptionToken = tmpstr[0].trim();
			}
		} else {
			err += "\t<error code=\"badArgument\">Illegal argument '"
				+ pname + "'</error>\n";
		}
	}

	// validate the from and until fields

	if (g_resumptionToken.length() > 0 &&
		(g_fromDateStr.length() + g_untilDateStr.length()
			+ g_metadataPrefix.length() + g_set_.length()) > 0) {
			err += "\t<error code=\"badArgument\">'resumptionToken' must be "
				+"the only parameter</error>\n";
	} else if (g_resumptionToken.length() == 0 && g_metadataPrefix.length() == 0) {
			err += "\t<error code=\"badArgument\">either 'metadataPrefix' "
				+ "or 'resumptionToken' is required</error>\n";
	}
	if (untilDate != null && fromDate != null) {
		if (g_untilDateStr.length() != g_fromDateStr.length()) {
			err +="\t<error code=\"badArgument\">The values of 'from' and"
			+ "'until' specify different granularity.</error>\n";
		}
	}
  	if( g_fromDateStr != null && g_fromDateStr.length() > 10 ) {
			err +="\t<error code=\"badArgument\">The value of 'from'"
			+ " requests a granularity finer than that available "
			+ " from this provider.</error>\n";
	}
  	if( g_untilDateStr != null && g_untilDateStr.length() > 10 ) {
			err +="\t<error code=\"badArgument\">The value of"
			+ " 'until' requests a granularity finer than that available "
			+ " from this provider.</error>\n";
	}

	if( db_CountMatchingIDs(out).equals(new Integer(0)) ) {
		err += "<error code=\"noRecordsMatch\">The combination of "
		+ "the values of the from, until, set and metadataPrefix"
		+ "arguments or the resumptionToken results in an empty list.</error>";
	}

	if (err.length() != 0) {
		requestString += ">" + request.getRequestURL() + "</request>";
		try{out.println( requestString);
			out.println( err);}
		catch(Exception ex){return false;}
		return false;}
	else {
		if (g_metadataPrefix.length() > 0) {
			requestString += " metadataPrefix=\""
			+ htmlEncode(g_metadataPrefix) + "\"";
		}
		if (g_fromDateStr.length() > 0) {
			requestString += " from=\"" + htmlEncode(g_fromDateStr) + "\"";
		}
		if (g_untilDateStr.length() > 0) {
			requestString += " until=\"" + htmlEncode(g_untilDateStr) + "\"";
		}
		if (g_set_.length() > 0) {
			requestString += " set=\"" + htmlEncode(g_set_) + "\"";
		}
		if (g_resumptionToken.length() > 0) {
			requestString += " resumptionToken=\""
			+ htmlEncode(g_resumptionToken) + "\"";
		}
		requestString += ">" + request.getRequestURL() + "</request>";
		try{out.println( requestString);}catch(Exception ex){return false;}
	}
	return true;
}


private boolean checkListSetsArguments (JspWriter out,
	HttpServletRequest request){

	String pname;
	String err = "";
	String[] tmpstr;
	String requestString;
	Enumeration enu = request.getParameterNames();

	fromDate = null;
	g_fromDateStr = "";
	g_identifier = "";
	g_metadataPrefix = "";
	g_resumptionToken = "";
	g_set_ = "";
	g_untilDateStr = "";
	untilDate = null;

	requestString = "<request verb=\"ListSets\"";

	// resumptionToken is the only option parameter
	while (enu.hasMoreElements()) {
		pname = enu.nextElement().toString();
		if (pname.equals("verb")) {
		} else if (pname.equals("resumptionToken")) {
			tmpstr = request.getParameterValues("resumptionToken");
			if (tmpstr.length > 1) {
				err += "\t<error code=\"badArgument\">Multiple 'resumptionToken' "
				+ "is not allowed.</error>\n";
			} else {
		    		g_resumptionToken = tmpstr[0].trim();
			}
		} else {
			err += "\t<error code=\"badArgument\">Illegal argument '"
				+ pname + "'</error>\n";
		}
	}

	if (err.length() != 0) {
		try{ out.println(err);} catch(Exception x){}
		return false;}
	else {
		if (g_resumptionToken.length() > 0) {
			requestString += " resumptionToken=\""
				+ htmlEncode(g_resumptionToken) + "\"";
		}
		requestString += ">" + request.getRequestURL() + "</request>";
		try{out.println( requestString);}catch(Exception ex){}
		return true;
	}
}


private boolean checkVerbArguments(HttpServletRequest request, JspWriter out){

	String err = "";

	String s[]= request.getParameterValues("verb");
	if(s==null){
		err = "\t<error code=\"badVerb\">Missing OAI verb</error>\n";
		try{
		out.println(err);} catch(Exception ex){}
		return false;
	}

	if(s.length>1) {
 		err = "\t<error code=\"badVerb\"" +
			">Duplicate OAI verbs not allowed</error>\n";
	}

	if(s.length==1) {
		g_verb=s[0];
		if (! (
			g_verb.equals("Document") ||
			g_verb.equals("Identify") ||
			g_verb.equals("GetRecord") ||
			g_verb.equals("ListIdentifiers") ||
			g_verb.equals("ListMetadataFormats") ||
			g_verb.equals("ListRecords") ||
			g_verb.equals("ListSets")
			)){
			err = "\t<error code=\"badVerb\">Illegal OAI verb: "
				+ g_verb + "</error>\n";
		}
	}

	if(s.length==0 || (s.length==1 && g_verb.equals(""))) {
		err = "\t<error code=\"badVerb\">Missing OAI verb</error>\n";
	}

	if(err.length()!=0){
		try{
		out.println(err);} catch(Exception ex){}
		return false;
	}

	return true;
}



private String cnvtToYYYYMMDD(String DateStr){

	// cnvt YYYY-MM-DD to YYYYMMDD

	if(DateStr.equals("null")) {
		return "NULLDATE";
	}
	else {
		return DateStr.substring(0,4) + DateStr.substring(5,7)+
			DateStr.substring(8,10);
	}
}


private Integer db_CountMatchingIDs(JspWriter out) {

	// returns a count of the number of records in the database matching
	// the criteria for ListRecords and ListIdentifiers

	String sql = "SELECT count(*) FROM objects;";

	ResultSet rs;
	rs = db_execSQL(out,g_stmtSets,sql);
	try{rs.first();} catch(Exception xxx){}
	Integer i=new Integer(0);
	try{ i = new Integer(rs.getInt(1));} catch(Exception xx){};

	return i;
}


private ResultSet db_execSQL(JspWriter out, Statement st, String sql) {

	ResultSet result = null;

	try {
		result = st.executeQuery(sql);
	}
	catch (SQLException ex) {
		while (ex != null){
			try{out.println("<SQLERR>SQLState: " +
				ex.getSQLState() + "</SQLERR>");} catch (Exception x) {}
			try{out.println("<SQLERR>Message:  " +
				ex.getMessage() + "</SQLERR>");} catch (Exception x) {}
			try{out.println("<SQLERR>Ventor Code:" + ex.getErrorCode() +
				 "</SQLERR>"); } catch (Exception x){}
			ex.printStackTrace(System.out);
			ex = ex.getNextException();
		}
	}

	return result;
}


private String dbget_EarliestDateTimeModified(HttpServletRequest request,
        HttpServletResponse response, JspWriter out){

	String r="";
	String err="";
	try{
	    g_rs = db_execSQL(out, g_stmt,"SELECT MIN(date_created) AS MinMDate from objects;");
		if( g_rs == null) {
			err="<error>No last-modified date found in table ids</error>";
			g_stmt.close();
			g_conn.close();
			g_rs.close();
		} else {
			g_rs.next();
			r =  g_rs.getString("MinMDate");
			g_rs.close();
		}
	} catch (Exception ex) {err="<error>Unable to retrieve lastModDate field from " +
		"cursor in dbget_EarliestDateTimeModified</error>";}
	if( err.length()==0) {
		return r;}
	else {
		try{out.println(err);} catch(Exception x){}
		return "";
	}
}


private boolean dbget_NumberOfEligibleIDs(HttpServletRequest request,
	HttpServletResponse response, JspWriter out) {

	//The spec says both from and until must be in UTC!!!
	//This code assumes lastModDate column in database table ids is in UTC.

	/* Discover how many records, perhaps in a set, are eligible
	for harvest.  This count is used in the resumption token.  Note:
	the following dates are in local time of the sql server but
	should be in GMT.  They can't be converted because there is now
	HH:MM:SS on which a conversion to GMT would be based. */

	// Set Defaults if date parameters not set

	if(untilDate==null) {
		g_untilDateStr = "9999-12-31";		// max date supported by Access
		untilDate = completeDate(g_untilDateStr);
	}
	if(fromDate==null) {
		g_fromDateStr = "1753-01-01";	// min date supported by Access/SQL server
		fromDate = completeDate(g_fromDateStr);
	}

	g_rs = db_execSQL(out,g_stmt,	"SELECT COUNT(*) FROM objects WHERE date_created >= '" + g_fromDateStr + " '  AND  date_created <= '" + g_untilDateStr + "'");

	if (g_rs == null)  
	{
	try
		{
			out.println("<error>No record found in table ids checking for date range!</error>");
 			g_stmt.close();
			g_conn.close();
			return false;}
		catch(Exception x)
		{return false;}
	}
	try{
		g_rs.first();
		g_completeListSize=g_rs.getInt(1);   // used in resumption tokens
	} catch (Exception x) {return false;}
	return true;
}


private boolean  dbget_NumberOfSets(JspWriter out){

	g_rsSets = db_execSQL(out, g_stmtSets, "SELECT count(*) FROM sets");
	try{
		g_rsSets.first();
		g_completeListSize= g_rsSets.getInt(1);}
	catch(Exception ex){
		String err="Unable to count records in Sets table";
		try{ out.println( err);} catch(Exception x){}
		return false;
	}
	return true;
}


private boolean dbget_RemainingIDs(HttpServletRequest request,
	HttpServletResponse response, JspWriter out) {

	// parse the Resumpiton Token, if any, to get the g_currentOAI_ID,
	// from and until dates, and setSpec

	String err= parseResumptionToken( request, response, out);
	if (err.length()!=0) return false;

	// load record set g_rs with data needed to list identifiers

	g_rs = db_execSQL(out,g_stmt,	"SELECT object_ID,date_created FROM objects WHERE date_created >= '" + g_fromDateStr + " '  AND  date_created <= '" + g_untilDateStr + "'");

	try{
		if (g_rs == null)  {
			out.println("<error code=\"noRecordsMatch\">The combination " +
			"of the values of the from, until, set and metadataPrefix " +
			"arguments or the resumptionToken results in an empty list." +
			" </error>");
			return false;}
		else {
//			g_rs.first();
		}}
	catch(Exception x){return false;}
	return true;
}


private boolean dbget_RemainingSets(HttpServletRequest request,
		HttpServletResponse response, JspWriter out){

	String err= parseResumptionToken ( request, response, out);
	if( err.length()!=0) return false;

	/*  N.B.  The reference to g_currentOAI_ID in the following stmt
	is misleading.  It is actually the set ID parsed out of the
	resumption token in the call to parseResumptionToken above.  */

	g_rsSets = db_execSQL(out,g_stmtSets,
		"SELECT setID, setName, setSpec " +
		"FROM sets " +
		"WHERE setID> '" + g_currentOAI_ID  + "'" +
		" ORDER BY setID;");
	try{
		if (g_rsSets == null ) {
			err="No sets found! (No record found in Sets table)";
			try{ out.println( err);} catch(Exception x){return false;}
			return false;
		}}
	catch(Exception x){return false;}
	return true;
}

private void dbget_SetSpecs( JspWriter out){

	long id;
	try{
		id=g_rs.getLong("recID");
		g_rsSets = db_execSQL(out, g_stmtSets,
			"SELECT setmap.recID, setmap.setID, " +
			 " sets.setID, setName, setSpec " +
			"FROM setmap, sets " +
			"WHERE  setmap.recID = '" + id + "' AND " +
				" setmap.setID = sets.setID;");
	} catch(Exception x){
	}
}


private boolean dbOpen(JspWriter out){

	// GET DATABASE SPECIFICATION for this DB
	try{
		g_conn = DriverManager.getConnection(conf.getProperty("Driver.URL").trim()+conf.getProperty("Driver.database").trim(),
				conf.getProperty("Driver.User").trim(), conf.getProperty("Driver.Password").trim());
		g_stmt = g_conn.createStatement(ResultSet.TYPE_FORWARD_ONLY,
			ResultSet.CONCUR_READ_ONLY);
		g_stmtSets = g_conn.createStatement(ResultSet.TYPE_FORWARD_ONLY,
			ResultSet.CONCUR_READ_ONLY);
		g_fieldStmt = g_conn.createStatement(ResultSet.TYPE_FORWARD_ONLY,
			ResultSet.CONCUR_READ_ONLY);}
	catch (Exception ex){
		try{
		out.println("<error>Unable to open database</error>");}
			catch (Exception x){}
		return false;
	}
	return true;
}


private boolean dbPosition_IDRec( JspWriter out){

	// Retrieve's a record based on it's OAI_Identifier, not it's
	// recID.   After retrieval, it loads the recID into the global
	// g_currentRecID
	
	String sql =
		"SELECT object_ID, date_created FROM objects "
		+ "WHERE object_ID = '" + g_currentOAI_ID
		+ "'";

	g_rs = db_execSQL( out, g_stmt, sql);
	try{
		if( g_rs.first()){
//			g_currentRecID = g_rs.getString("object_ID");
			tID = g_rs.getString("object_ID");
			return true;
		}}
	catch(Exception ex){ return false;}

	return false;

}


private void Document(HttpServletRequest request,
        HttpServletResponse response, JspWriter out){

// Prints out a choice list with the pseudo-verb "Document"

	try{
		out.println("<html>");
		out.println("<head>");
		out.println("	<title>Sample OAI 2.0 Compliant Provider - </title>");
		out.println("  <body bgcolor=#FFFFFF>");

		out.println("  	<h3>OAI 2.0 Compliant Server - Provided for Illustration Only</h3>");

		out.println(" 	The " + g_ThisArchiveParam + " OAi server is available at " + request.getRequestURL());
		out.println(" 	<p>");
		out.println(" 	<h4>Example commands</h4>");
		out.println(" 	<ul>");
		out.println(" 	<li> <a href=" + request.getRequestURL() + "?verb=Identify>?verb=Identify</a> </li>");
		out.println("   <li> <a href=" + request.getRequestURL() + "?verb=ListSets>?verb=ListSets</a></li>");
		out.println("     <li> <a href=" + request.getRequestURL()
			+ "?verb=ListMetadataFormats>?verb=ListMetadataFormats</a></li>");
		out.println("     <li> <a href=" + request.getRequestURL()
			+ "?verb=ListMetadataFormats&amp;identifier=" + g_ThisSchemeParam + ":" + g_ThisArchiveParam
			+ ":1477521>?verb=ListMetadataFormats&amp;identifier=" + g_ThisSchemeParam + ":"
			+ g_ThisArchiveParam + ":1477521</a></li>");
		out.println("     <li> <a href=" + request.getRequestURL() + "?verb=GetRecord&amp;identifier="
			+ g_ThisSchemeParam + ":" + g_ThisArchiveParam
			+ ":1477521&amp;metadataPrefix=oai_dc>?verb=GetRecord&amp;identifier=" + g_ThisSchemeParam
			+ ":" + g_ThisArchiveParam + ":1477521&amp;metadataPrefix=oai_dc</a></li>");
		out.println(" 	</ul>");
		out.println(" 	<h4>Sample records</h4>");
		out.println("   <li> <a href=" + request.getRequestURL()
			+ "?verb=ListRecords&amp;metadataPrefix=oai_dc>?verb=ListRecords&amp;"
			+ "metadataPrefix=oai_dc</a></li>");
		//out.println(" 	<h5>Example Name Of Project</h5>");
		out.println("	<ul>");
		out.println(" 	</ul>");
		out.println(" 	Code version: 2.4, Created by<br>Tom Habing (thabing@uiuc.edu),<br>");
		out.println("		Tim Cole (t-cole3@uiuc.edu),<br> Yuping Tseng (ytseng1@uiuc.edu),<br>");
		out.println("		and John Lewis (jslewis@uiuc.edu)");
		out.println("  </body>");
		out.println("</html>");
		g_conn.close();
	}catch(Exception e){}
	return;
}


private void errorHTML(HttpServletResponse response, String e,
	JspWriter out) throws Exception {

	// Set the HTTP status and return an XHTML error response

	try {
		response.sendError(Integer.parseInt(e.substring(0, 3)), e);
		if(e.indexOf("503") >= 0){
			response.addIntHeader("Retry-After", 10800);
		}
		response.setContentType("text/xml");
		out.println("<html xmlns='http://www.w3.org/1999/xhtml'>");
		out.println("	<head><title>" + e + "</title></head>");
		out.println("	<body>");
		out.println("		<h4>" + e + "</h4>");
		out.println("		<p>" + requestURL + "</p>");
		out.println("	</body>");
		out.println("</html>");
	}
	catch(Exception ex) { throw(ex); }
}


private void getConfigVariables(String propPath) throws Exception {

	try {
		conf.load(new BufferedInputStream(this.getClass().getClassLoader().getResourceAsStream("edu/cu/cs/sms/Database/database.properties")));
		prop.load(new FileInputStream(propPath));
        Class.forName(conf.getProperty("Driver.Name").trim()).newInstance();
//		Class.forName(prop.getProperty("Driver")).newInstance();
		g_ThisArchiveParam = prop.getProperty("namespace-identifier");
//		g_ThisSchemeParam = prop.getProperty("Scheme");
		g_ThisSchemeParam = "oai";
		g_MaxIdentifiersParam = new Integer(prop.getProperty("MaxIdentifiers")).intValue();
		g_MaxRecordsParam = new Integer(prop.getProperty("MaxRecords")).intValue();
		g_MaxSetsParam = new Integer(prop.getProperty("MaxSets")).intValue();
		OAI_LOG = new Boolean(prop.getProperty("OAILog")).booleanValue();
		g_BaseURL = prop.getProperty("OAIBaseContext").trim();
		g_set_ = null;
		g_metadataPrefix=null;
	}
	catch (Exception ex) {
			FileOutputStream fo = new FileOutputStream("oaix.log", true);
			PrintWriter pw = new PrintWriter(fo);
			pw.print("exception thrown in getConfigVariables()");
			pw.close();
			fo.close();
			throw ex; }
}


private void getLastUpdateDate(HttpServletRequest request,
        HttpServletResponse response, JspWriter out){
	try{
		g_rs = db_execSQL(out, g_stmt,"SELECT MAX(lastModDate) AS MaxMDate from ids;");
		if (g_rs == null) {
			errorHTML(response,  "500 Database Error", out);
			logError(request,500, out);
 			g_stmt.close();
	 		g_conn.close();
			return;
		}

 		if(g_rs.next()) {

 			g_lastUpdate = g_rs.getDate("MaxMDate");

//                      UTC Manipulation is meaningless when only dates are used.

			//IF "LAST" UPDATE WAS "IN THE FUTURE" SOMETHING IS WRONG, POSSIBLY
			//THE DATABASE IS BEING UPDATED NOW.  ADVISE USER TO TRY AGAIN LATER
			java.util.Date today = new java.util.Date();
			 if(g_lastUpdate.after(today)) {
 				errorHTML(response, "503 Service Unavailable (Retry After "
				+ "10800 Seconds)" + g_lastUpdate.toString() + " "
				+ new java.util.Date().toString(), out);
 				logError(request, 503, out);
	 			g_rs.close();
 				g_stmt.close();
 				g_conn.close();
 				return;
			}	
		}

		else {
			errorHTML(response,  "500 No record found in table ids!", out);
 			g_rs.close();
 			g_stmt.close();
			g_conn.close();
			return;
		}

	} catch(Exception ex){}
}


private void GetRecord(HttpServletRequest request, HttpServletResponse response, JspWriter out)
{
	String err="";

	if(! checkGetRecordsArguments(out, request))
		return;

/*
  	String[] results = parseIdentifier(); 

  	if(!results[0].equals("true")
	 	|| !results[1].equals(g_ThisSchemeParam)
		|| !results[2].equals(g_ThisArchiveParam))  {
		err ="\t<error code=\"idDoesNotExist\">The value of "
			+ "the identifier argument '" + htmlEncode(g_identifier)
			+ "' is unknown or illegal in the repository</error>\n";
		try{ out.println( err); } catch(Exception ex){ }

		return;
	}
*/
	
	g_currentOAI_ID = g_identifier.trim();

	if( ! dbPosition_IDRec( out)) {
		try { out.println(
			"\t<error code=\"idDoesNotExist\">The value of "
			+ "identifier '"  + htmlEncode(g_identifier) + "' is "
			+ "unknown or illegal in this repository.</error>\n");}
		catch(Exception ex){ return;}
		return;
	}
	

	try{
		tID = g_rs.getString("object_ID");

		if(tID.indexOf("BMK") != -1 || tID.indexOf("bmk") != -1) 
		{
	
			out.println("\t<GetRecord>");
			out.println("\t\t<record>");
			out.println("\t\t\t<header>");
	
			if( ! dbPosition_IDRec( out)) return;  //loads g_currentRecID
			writeRecordHeader(out);
	
			out.println("\t\t\t</header>");
			out.println("\t\t\t<metadata>");
	
			writeRecord( out);  // writes the record now in g_rs
	
			out.println("\t\t\t</metadata>");
			out.println("\t\t</record>");
			out.println("\t</GetRecord>");
		}
		else
			out.println("\t<error code=\"idDoesNotExist\">The value of identifier '"  + htmlEncode(g_identifier) + "' is unknown or illegal in this repository.</error>\n");
	}
	catch(Exception x){return;}
}


private String htmlEncode(String s) {

	// replaces 4 characters with equivalent OAI
	// entities.  Also checks that no entities are
	// converted twice by removing any already in
	// the input string.

	String sClean = new String(s);
	sClean = sClean.replaceAll("&amp;", "&");
	sClean = sClean.replaceAll("&quot;", "\"");
	sClean = sClean.replaceAll("&lt;", "<");
	sClean = sClean.replaceAll("&gt;", ">");

	StringBuffer sb = new StringBuffer("");

	for (int i = 0; i < sClean.length(); i++) {
		char c = sClean.charAt(i);

		switch(c) {
			case '&':
				sb.append("&amp;");
				break;
			case '"':
				sb.append("&quot;");
				break;
			case '<':
				sb.append("&lt;");
				break;
			case '>':
				sb.append("&gt;");
				break;
			default:
				sb.append(c);
		}
	}

	return sb.toString();
}


private void Identify(HttpServletRequest request,
    HttpServletResponse response, JspWriter out){

	// All data, except earliest modified date in database, is from
	// config file.

	if (!checkIdentifyArguments(out, request)) {
		return;
	}

	String earliestDTM;
	earliestDTM=dbget_EarliestDateTimeModified(request, response, out);
	if (earliestDTM.length()==0) {
		return;
	}

	try{
 		out.println("\t<Identify>");
		out.println("\t\t<repositoryName>" +
			htmlEncode(prop.getProperty("repositoryName")) + "</repositoryName>");
 		out.println("\t\t<baseURL>" + request.getRequestURL() + "</baseURL>");
 		out.println("\t\t<protocolVersion>" +
			prop.getProperty("protocolVersion") + "</protocolVersion>");
		out.println("\t\t<adminEmail>" +
			htmlEncode(prop.getProperty("adminEmail")) + "</adminEmail>");
		out.println("\t\t<earliestDatestamp>" +
			prop.getProperty("earliestModifiedDate") + "</earliestDatestamp>");
 		out.println("\t\t<deletedRecord>" +
			prop.getProperty("deletedRecord") + "</deletedRecord>");
		out.println("\t\t<granularity>" +
			prop.getProperty("granularity") + "</granularity>");
		out.println("\t</Identify>");
	} catch(Exception ex) {}
}


private java.sql.Timestamp UTCStringToTimestamp( String s) {

	/* converts a string in the format returned by UTCEncode()
	and nowUTC(), YYYY-MM-DDTHH:MM:SSZ, into a timestamp */

	String t = s;
	t = s.substring(0,10) + " " + s.substring(11,19);
	return java.sql.Timestamp.valueOf(t);

}


private java.util.Date completeDate(String str) {

	// Returns input date in YYYY-MM-DD hh:mm:ss format.  Assumes input
	// string is either YYYY-MM-DD or YYYY-MM-DDThh:mm:ss+HH:HHZ format!

	SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
	java.util.Date retDate;

	try
   {
		if (str.indexOf("T") > 0 && str.endsWith("Z")) {
		// if date is in YYYY-MM-DDThh:mm:ss+00:00Z format...
			retDate = formatter.parse(str.replace('T', ' ').substring(0, str.length() - 1));}
		else {
			// otherwise assume it's in YYYY-MM-DD format and append zero time-of-day
			retDate = formatter.parse(str + " 00:00:00");
		}
	}
	catch (ParseException pe) {
		retDate = null;
	}

	return retDate;
}


private void ListIdentifiers(HttpServletRequest request, HttpServletResponse response, JspWriter out)
{

	int lastCdpidInBatch=0;
	String err="";
	if (! checkListIdentifiersArguments(out, request)) {
		return;
	}

	// load global variable g_completeListSize with number of records
	if(!dbget_NumberOfEligibleIDs(request, response, out)) return;

	// load RecordSet rs with data needed for ListIdentifiers
	if(! dbget_RemainingIDs( request, response, out)) return;
//	try{out.println("<debug>" + "in ListIdentifers "+ g_rs.getLong("recID")  + "</debug>");} catch(Exception ex){}

	if (g_completeListSize == 0) {
		try {
			out.println("<error code=\"noRecordsMatch\">The combination of from, until, "
				+ "and set (if present) result in an empty set</error>");
		} catch (Exception x) {}}
	else {
		try
		{
			out.println("\t<ListIdentifiers>");
			/* output the first MaxRecordsParam records -- these were
			selected as records set rs in dbget_RemainingIDs() */
			int recInBatch;
			while(g_rs.next())
			{
				g_currentOAI_ID  = g_rs.getString("object_ID");

				if(g_currentOAI_ID.indexOf("BMK") != -1 || g_currentOAI_ID.indexOf("bmk") != -1) 
				{
				
				// then write all elements available for this ID
				out.println("\t\t<header>");
				g_identifier =  g_ThisSchemeParam  + ":" + 
					g_ThisArchiveParam + ":" + g_currentOAI_ID;
				out.println("\t\t\t<identifier>" + htmlEncode(g_currentOAI_ID)
					+ "</identifier>");
				out.println("\t\t\t<datestamp>"
			 		+ g_rs.getString("date_created") + "</datestamp>");
				out.println("\t\t</header>");
				}
			}
					out.println("\t</ListIdentifiers>");
					g_stmt.close();
					g_conn.close();
		} catch (Exception ex){}
	}
}


private void ListMetadataFormats(HttpServletRequest request,
	HttpServletResponse response, JspWriter out){

	/* Ultimately, the metadata format info should be put in
	the config file, until then, this routine must be modified
	to add a new metadata format */

	if (! checkListMetadataFormatsArguments(out, request)){
		return;
	}

	try{
		out.println("\t<ListMetadataFormats>");

		/* Print both oai_dc and OTHER because they both apply to all
		records.  In other implementations, some records may support
		only one and not the other.  In that case the following logic
		must be modified when an indentifier is present in the request */

		out.println("\t\t<metadataFormat>");
		out.println("\t\t\t<metadataPrefix>oai_dc</metadataPrefix>");
		out.println("\t\t\t<schema>http://www.openarchives.org" +
			"/OAI/2.0/oai_dc.xsd</schema>");
		out.println("\t\t\t<metadataNamespace>http://" +
			"www.openarchives.org/OAI/2.0/oai_dc/</metadataNamespace>");
		out.println("\t\t</metadataFormat>");

		out.println("\t\t<metadataFormat>");
		out.println("\t\t\t<metadataPrefix>nsdl_dc</metadataPrefix>");
		out.println("\t\t\t<schema>http://ns.nsdl.org/schemas/nsdl_dc/nsdl_dc_v1.02.xsd</schema>");
		out.println("\t\t\t<metadataNamespace>http://ns.nsdl.org/nsdl_dc_v1.02/</metadataNamespace>");
		out.println("\t\t</metadataFormat>");
		
	/*  OTHER!!
		out.println("\t\t<metadataFormat>");
		out.println("\t\t\t<metadataPrefix>OTHER</metadataPrefix>");
		out.println("\t\t\t<schema>http://www.openarchives.org/OAI"+
			"/2.0/OTHER.xsd</schema>");
		out.println("\t\t\t<metadataNamespace>http://"+
			"www.cdpheritage.org/OTHER_v1.00/</metadataNamespace>");
		out.println("\t\t</metadataFormat>");
	*/
		out.println("\t</ListMetadataFormats>");
	} catch(Exception ex) {}
}


private void ListRecords(HttpServletRequest request, HttpServletResponse response, JspWriter out)
{

	int lastCdpidInBatch=0;
	String err="";
	if (! checkListRecordsArguments(out, request)) {
		return;
	}

	// load global variable g_completeListSize with number of records
	if(!dbget_NumberOfEligibleIDs(request, response, out)) return;

	// load RecordSet g_rs with all eligible OAI_Identifiers
	if(! dbget_RemainingIDs( request, response, out)) return;

	if (g_metadataPrefix.length() > 0) 
	{

		try {
			out.println("\t<ListRecords>");
			
			while(g_rs.next()) 
			{
				tID = g_rs.getString("object_ID");

				if(tID.indexOf("BMK") != -1 || tID.indexOf("bmk") != -1) 
				{
					// then write all elements available for this ID
					out.println("\t<record>");
					out.println("\t\t<header>");
					writeRecordHeader( out);
					out.println("\t\t</header>");
	
					out.println("\t\t\t<metadata>");
					tID = g_rs.getString("object_ID");
					writeRecord(  out);
					out.println("\t\t\t</metadata>");
					out.println("\t\t</record>");
				}
			}

			out.println("\t</ListRecords>");
		} catch (Exception ex){}
	}
}


private void ListSets(HttpServletRequest request, HttpServletResponse response, JspWriter out) throws IOException
{
	checkListSetsArguments(out,request);
	out.println("\t<error code=\"noSetHierarchy\">This repository does not support sets</error>");
}


private void logError(HttpServletRequest request, int num, JspWriter out) {

	// Set the HTTP status and return an XHTML error response

	if (!OAI_LOG){
		return;
	}
	try {
		FileOutputStream fo = new FileOutputStream("oaix.log", true);
		PrintWriter pw = new PrintWriter(fo);

		pw.print(request.getRemoteHost() + " ");
		if(request.getRemoteUser() != null){
			pw.print(request.getRemoteUser() + " ");}
		else {
			pw.print("- ");
		}

		pw.print("[" + nowUTC( out) + "]");
		pw.print("\"" + requestURL + "\" ");
		pw.println(num + " -");
		pw.close();
		fo.close();
	}
	catch(Exception e) {
		System.out.println(e);
	}
}


private void logRequest(HttpServletRequest request,
	JspWriter out) {

	// Add a line to the OAI_LOG file for the request

	if (!OAI_LOG){
		return;
	}

	try {
		FileOutputStream fo = new FileOutputStream("oaix.log", true);
		PrintWriter pw = new PrintWriter(fo);

		pw.print(request.getRemoteHost() + " ");
		if(request.getRemoteUser() != null) {
			pw.print(request.getRemoteUser() + " ");}
		else {
			pw.print("- ");
		}
		pw.print("[" + nowUTC(out) + "]");
		pw.print("\"" + requestURL + "\" ");
		pw.println("200 -");
		pw.close();
		fo.close();
	}
	catch(Exception e) { }
}


private String makeResumptionToken( String lastIDSent, JspWriter out) {

	String rt;
	if ( g_untilDateStr.length() == 0) {
		rt = "null|";
	} else {
		rt = g_untilDateStr + "|";
	}

	if (g_fromDateStr == null || g_fromDateStr.length() == 0) {
		rt += "null|";
	} else {
		rt += g_fromDateStr + "|";
	}

	if (g_set_ == null || g_set_.length() == 0) {
		rt += "null|";
	} else {
		rt += g_set_ + "|";
	}

	if (g_metadataPrefix==null || g_metadataPrefix.length() == 0) {
		rt += "null|";
	} else {
		rt += g_metadataPrefix + "|";
	}

	rt += lastIDSent + "|" + nowUTC( out);
	return rt;
}


private String makeResumptionToken(int lastIDSent, JspWriter out) {

	String rt;
	if ( g_untilDateStr.length() == 0) {
		rt = "null|";
	} else {
		rt = g_untilDateStr + "|";
	}

	if (g_fromDateStr == null || g_fromDateStr.length() == 0) {
		rt += "null|";
	} else {
		rt += g_fromDateStr + "|";
	}

	if (g_set_ == null || g_set_.length() == 0) {
		rt += "null|";
	} else {
		rt += g_set_ + "|";
	}

	if (g_metadataPrefix==null || g_metadataPrefix.length() == 0) {
		rt += "null|";
	} else {
		rt += g_metadataPrefix + "|";
	}

	rt += lastIDSent + "|" + nowUTC( out);
	return rt;
}


private String nowUTC( JspWriter out ) {

	/* returns current time Z based on the machine
	clock of the sql server.  The sql server's time
	zone is ASSUMED to be the same as that of the
	provider */

	return UTCEncode(out, null);
}




private void OAI_DC_Handler( JspWriter out)  
{
	//  '''''''''''''''''''''''''''''''''''''''''''
	//  Purpose:	Output the metadata in the required format
	//
	//  Input:	recID --- passed via the global variable g_currentOAI_ID
	//              RecordSet  --- passed via global g_rs
	//              out -- output to the client browser
	///  '''''''''''''''''''''''''''''''''''''''''''
	String sqlHead;
	String sql;
	String tagArray[];
	String tagItem;
	String strContent;
	String leader6;
	String leader7;
	String control008;
	ResultSet field_rs;
	ResultSet irs;
	boolean in;

	sqlHead = "SELECT * FROM objects O,relation R where object_id='"+tID+"' and O.object_ID = R.itemid1";
	
	try
	{
		irs = new myResultSet(db_execSQL(out,g_stmtSets,sqlHead));	

		in = irs.next();
		
		if(!in)
		{
			sqlHead = "SELECT * FROM objects O where object_id='"+tID+"'";
			irs     = new myResultSet(db_execSQL(out,g_stmtSets,sqlHead));	
			
			in = irs.next();
		}
		
		if(in)
		{

			out.println("<oai_dc:dc");
			out.println("xsi:schemaLocation=\"http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd\"");
			out.println("xmlns:oai_dc=\"http://www.openarchives.org/OAI/2.0/oai_dc/\"");
			out.println("xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"");
			out.println("xmlns:dc=\"http://purl.org/dc/elements/1.1/\">");
			
			//   ******** dc:title ********
			out.println("<dc:title>"+escapeXML(irs.getString("Name"))+"</dc:title>");
			//   ******** dc:creator ********
			out.println("<dc:creator>Stedman Willard</dc:creator>");
			//   ******** dc:type ********
			out.println("<dc:type>"+escapeXML(irs.getString("object_type"))+"</dc:type>");
			out.println("<dc:type>InteractiveResource</dc:type>");
			out.println("<dc:type>Text</dc:type>");
			//   ******** dc:publisher ********
			out.println("<dc:publisher> The American Association for the Advancement of Science</dc:publisher>");
			//   ******** dc:date ********
			out.println("<dc:date>"+escapeXML(irs.getString("date_created"))+"</dc:date>");
			//   ******** dc:language ********
			out.println("<dc:language>"+escapeXML(irs.getString("metadata_lan"))+"</dc:language>");
			//   ******** dc:format ********
			out.println("<dc:format>text/html</dc:format>");
			//   ******** dc:description ********
			out.println("<dc:description>"+escapeXML(irs.getString("description")+" This benchmark addresses following educational levels:"+irs.getString("primary_grade").replaceAll(",",", "))+"</dc:description>");
			//   ******** dc:coverage ********
//			out.println("<dc:coverage>Grades:"+escapeXML(irs.getString("primary_grade").replaceAll(",",", "))+"</dc:coverage>");
			//   ******** dc:relation ********
			String[] sub1 = ((myResultSet)irs).getItemid2();
			String[] sub  = ((myResultSet)irs).getrelations();
			for(int index=0;index<sub1.length;index++)
			{
				String bmID = escapeXML(sub1[index]);
				if(bmID.indexOf("STD") == -1 && bmID.indexOf("GRD") == -1 && bmID.indexOf("SEC") == -1 && bmID.indexOf("CHP") == -1 && bmID.indexOf("ATL") == -1)
					out.println("<dc:relation>("+escapeXML(sub[index])+")  "+g_BaseURL+"?bm="+bmID+"</dc:relation>");
				else
					out.println("<dc:relation>("+escapeXML(sub[index])+") "+bmID+"</dc:relation>");
			}
			
			String std = irs.getString("Standards");
			if(!std.equals(""))
			{
				String[] as = std.split("###end###");
				
				for(int index = 0;index < as.length; index++)
					out.println("<dc:conformsTo>"+escapeXML(as[index].replaceAll("###start###","Standard Name:").replaceFirst("\\?\\?\\?sep\\?\\?\\?",",Grade:").replaceFirst("\\?\\?\\?sep\\?\\?\\?",",Identifier:").replaceFirst("\\?\\?\\?sep\\?\\?\\?",",Content Standard Text Level 1:").replaceFirst("\\^\\^\\^l-next\\^\\^\\^",",Content Standard Text Level 2:").replaceFirst("\\^\\^\\^l-next\\^\\^\\^",",Content Standard Text Level 3:"))+"</dc:conformsTo>");
			}

			//   ******** dc:subject ********
			String[] sub2 = irs.getString("subjects").split(",");
			for(int index=0;index<sub2.length;index++)
				if(!sub2[index].equals(""))
					out.println("<dc:subject>"+escapeXML(sub2[index])+"</dc:subject>");
			
			Set<String> mapNameSet 	= new HashSet<String>();

			for(int index=0;index<sub1.length;index++)
				if(sub[index].equalsIgnoreCase("Is Part Of") && (sub1[index].indexOf("STD") != -1 || sub1[index].indexOf("std") != -1))
				{
					String strandNames 		= "SELECT O.name FROM objects O where object_id='"+sub1[index]+"'";
					String mapNames			= "SELECT O.name FROM objects O, relation R WHERE (R.ItemID1 = '"+sub1[index]+"' and R.ItemID2 = O.object_id)";
					ResultSet rSet1			= new myResultSet(db_execSQL(out,g_stmtSets,strandNames));	
					ResultSet rSet2			= new myResultSet(db_execSQL(out,g_stmtSets,mapNames));	
					
					if(rSet1.next())
					{
						String std1 = escapeXML(rSet1.getString("name"));
						mapNameSet.add(std1);
					}
					while(rSet2.next())
					{
						String std2 	= escapeXML(rSet2.getString("name"));
						mapNameSet.add(std2);
					}
					
				}

			for(String tSet: mapNameSet)
				out.println("<dc:subject>"+tSet+"</dc:subject>");

			//   ******** dc:identifier ********
			out.println("<dc:identifier>"+g_BaseURL+"?bm="+escapeXML(tID)+"</dc:identifier>");
			//   ******** dc:rights ********
			out.println("<dc:rights>Copyright 2004 by American Association for the Advancement of Science</dc:rights>");
			//   ******** dc:source ********
			out.println("<dc:source>"+escapeXML(irs.getString("source"))+"</dc:source>");
			//   ******** dc:contributor ********
			out.println("<dc:contributor>Stedman Willard</dc:contributor>");
			out.println("</oai_dc:dc>");
		}
	}
	catch(Exception exp){exp.printStackTrace();}

}


private void NSDL_DC_Handler( JspWriter out)  
{
	//  '''''''''''''''''''''''''''''''''''''''''''
	//  Purpose:	Output the metadata in the required format
	//
	//  Input:	recID --- passed via the global variable g_currentOAI_ID
	//              RecordSet  --- passed via global g_rs
	//              out -- output to the client browser
	///  '''''''''''''''''''''''''''''''''''''''''''
	String sqlHead;
	String sql;
	String tagArray[];
	String tagItem;
	String strContent;
	String leader6;
	String leader7;
	String control008;
	ResultSet field_rs;
	ResultSet irs;
	boolean in;

	sqlHead = "SELECT * FROM objects O,relation R where object_id='"+tID+"' and O.object_ID = R.itemid1";
	
	try
	{
		irs = new myResultSet(db_execSQL(out,g_stmtSets,sqlHead));	
			
		in = irs.next();
		
		if(!in)
		{
			sqlHead = "SELECT * FROM objects O where object_id='"+tID+"'";
			irs     = new myResultSet(db_execSQL(out,g_stmtSets,sqlHead));	
			
			in = irs.next();
		}
		
		if(in)
		{
			out.println("<nsdl_dc:nsdl_dc xmlns:nsdl_dc=\"http://ns.nsdl.org/nsdl_dc_v1.02/\" xmlns:dc=\"http://purl.org/dc/elements/1.1/\" xmlns:dct=\"http://purl.org/dc/terms/\" xmlns:ieee=\"http://www.ieee.org/xsd/LOMv1p0\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" schemaVersion=\"1.02.010\" xsi:schemaLocation=\"http://ns.nsdl.org/nsdl_dc_v1.02/ http://ns.nsdl.org/schemas/nsdl_dc/nsdl_dc_v1.02.xsd\">");

			//   ******** dc:title ********
			out.println("<dc:title>"+escapeXML(irs.getString("Name"))+"</dc:title>");
			//   ******** dc:creator ********
			out.println("<dc:creator>Stedman Willard</dc:creator>");
			//   ******** dc:type ********
			out.println("<dc:type>"+escapeXML(irs.getString("object_type"))+"</dc:type>");
			out.println("<dc:type>InteractiveResource</dc:type>");
			out.println("<dc:type>Text</dc:type>");
			
			out.println("<dc:type xsi:type=\"nsdl_dc:NSDLType\">Reference Material</dc:type>");
			out.println("<dc:type xsi:type=\"nsdl_dc:NSDLType\">Educational Standard</dc:type>");			
			
//			out.println("<dc:type>Instructor Guide</dc:type>");
			out.println("<dc:type>Standards or Frameworks</dc:type>");
			//   ******** dc:publisher ********
			out.println("<dc:publisher> The American Association for the Advancement of Science</dc:publisher>");
			//   ******** dct:created ********
			out.println("<dct:created>"+escapeXML(irs.getString("date_created"))+"</dct:created>");
			//   ******** dc:language ********
			out.println("<dc:language>"+escapeXML(irs.getString("metadata_lan"))+"</dc:language>");
			//   ******** dc:format ********
			out.println("<dc:format xsi:type=\"dct:IMT\">text/html</dc:format>");
			//   ******** dc:description ********
			out.println("<dc:description>"+escapeXML(irs.getString("description"))+"</dc:description>");

			//   ******** dct:educationLevel ********
			String grades 		= escapeXML(irs.getString("primary_grade"));
			
			if(grades.indexOf("K") != -1 || grades.indexOf("k") != -1 || grades.indexOf("5") != -1)	
			{
				out.println("<dct:educationLevel xsi:type=\"nsdl_dc:NSDLEdLevel\">Elementary School</dct:educationLevel>");
				out.println("<dct:educationLevel xsi:type=\"nsdl_dc:NSDLEdLevel\">Kindergarten</dct:educationLevel>");
				out.println("<dct:educationLevel xsi:type=\"nsdl_dc:NSDLEdLevel\">Grade 1</dct:educationLevel>");
				out.println("<dct:educationLevel xsi:type=\"nsdl_dc:NSDLEdLevel\">Grade 2</dct:educationLevel>");
				out.println("<dct:educationLevel xsi:type=\"nsdl_dc:NSDLEdLevel\">Grade 3</dct:educationLevel>");
				out.println("<dct:educationLevel xsi:type=\"nsdl_dc:NSDLEdLevel\">Grade 4</dct:educationLevel>");
				out.println("<dct:educationLevel xsi:type=\"nsdl_dc:NSDLEdLevel\">Grade 5</dct:educationLevel>");
			}
			if(grades.indexOf("8") != -1)													
			{
				out.println("<dct:educationLevel xsi:type=\"nsdl_dc:NSDLEdLevel\">Middle School</dct:educationLevel>");
				out.println("<dct:educationLevel xsi:type=\"nsdl_dc:NSDLEdLevel\">Grade 6</dct:educationLevel>");
				out.println("<dct:educationLevel xsi:type=\"nsdl_dc:NSDLEdLevel\">Grade 7</dct:educationLevel>");
				out.println("<dct:educationLevel xsi:type=\"nsdl_dc:NSDLEdLevel\">Grade 8</dct:educationLevel>");
			}
			if(grades.indexOf("12") != -1)													
			{
				out.println("<dct:educationLevel xsi:type=\"nsdl_dc:NSDLEdLevel\">High School</dct:educationLevel>");
				out.println("<dct:educationLevel xsi:type=\"nsdl_dc:NSDLEdLevel\">Grade 9</dct:educationLevel>");
				out.println("<dct:educationLevel xsi:type=\"nsdl_dc:NSDLEdLevel\">Grade 10</dct:educationLevel>");
				out.println("<dct:educationLevel xsi:type=\"nsdl_dc:NSDLEdLevel\">Grade 11</dct:educationLevel>");
				out.println("<dct:educationLevel xsi:type=\"nsdl_dc:NSDLEdLevel\">Grade 12</dct:educationLevel>");
			}
			
			//   ******** dc:coverage ********
//			out.println("<dc:coverage>Grades:"+escapeXML(irs.getString("primary_grade"))+"</dc:coverage>");

			//   ******** dct:relation ********
			String[] sub1 = ((myResultSet)irs).getItemid2();
			String[] sub  = ((myResultSet)irs).getrelations();
			for(int index=0;index<sub1.length;index++)
			{
				// **** 10/2007 jweather - removed isPartOf since there's no URL for it yet...

				/* if(sub[index].equalsIgnoreCase("Is Part Of"))
					out.println("<dct:isPartOf>"+escapeXML(sub1[index])+"</dct:isPartOf>");
				else */
				if(sub[index].equalsIgnoreCase("Contributes to achieving"))
					out.println("<dct:isRequiredBy>"+g_BaseURL+"?bm="+escapeXML(sub1[index])+"</dct:isRequiredBy>");
				else
					out.println("<dc:relation>"+g_BaseURL+"?bm="+escapeXML(sub1[index])+"</dc:relation>");
			}
			
			//   ******** dc:subject ********
			String[] sub2 = irs.getString("subjects").split(",");
			for(int index=0;index<sub2.length;index++)
				if(!sub2[index].equals(""))
					out.println("<dc:subject>"+escapeXML(sub2[index])+"</dc:subject>");
			
			Set<String> mapNameSet 	= new HashSet<String>();
			
			for(int index=0;index<sub1.length;index++)
				if(sub[index].equalsIgnoreCase("Is Part Of") && (sub1[index].indexOf("STD") != -1 || sub1[index].indexOf("std") != -1))
				{
					String strandNames 		= "SELECT O.name FROM objects O where object_id='"+sub1[index]+"'";
					String mapNames			= "SELECT O.name FROM objects O, relation R WHERE (R.ItemID1 = '"+sub1[index]+"' and R.ItemID2 = O.object_id)";
					ResultSet rSet1			= new myResultSet(db_execSQL(out,g_stmtSets,strandNames));	
					ResultSet rSet2			= new myResultSet(db_execSQL(out,g_stmtSets,mapNames));	
					
					if(rSet1.next())
					{
						String std = escapeXML(rSet1.getString("name"));
						mapNameSet.add(std);
					}
					while(rSet2.next())
					{
						String std 	= escapeXML(rSet2.getString("name"));
						mapNameSet.add(std);
					}
					
				}

			for(String tSet: mapNameSet)
				out.println("<dc:subject>"+tSet+"</dc:subject>");
			
			//   ******** dc:identifier ********
			out.println("<dc:identifier>"+g_BaseURL+"?bm="+escapeXML(tID)+"</dc:identifier>");
			//   ******** dc:rights ********
			out.println("<dc:rights>Copyright 2004 by American Association for the Advancement of Science</dc:rights>");
			//   ******** dc:source ********
			out.println("<dc:source>"+escapeXML(irs.getString("source"))+"</dc:source>");
			//   ******** dc:contributor ********
			out.println("<dc:contributor>Stedman Willard</dc:contributor>");
			//   ******** dc:conformsTo ********
			String std = irs.getString("Standards");
			if(!std.equals(""))
			{
				String[] as = std.split("###end###");
				
				for(int index = 0;index < as.length; index++)
					out.println("<dct:conformsTo>"+escapeXML(as[index].replaceAll("###start###","Standard Name:").replaceFirst("\\?\\?\\?sep\\?\\?\\?",",Grade:").replaceFirst("\\?\\?\\?sep\\?\\?\\?",",Identifier:").replaceFirst("\\?\\?\\?sep\\?\\?\\?",",Content Standard Text Level 1:").replaceFirst("\\^\\^\\^l-next\\^\\^\\^",",Content Standard Text Level 2:").replaceFirst("\\^\\^\\^l-next\\^\\^\\^",",Content Standard Text Level 3:"))+"</dct:conformsTo>");
			}
			out.println("</nsdl_dc:nsdl_dc>");
		}
	}
	catch(Exception exp){exp.printStackTrace();}

}

private String escapeXML(String in)
{
	return in.replaceAll("&","&amp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("'","&apos;").replaceAll("\"","&quot;");
}

private void OAI_OTHER_Handler( JspWriter out){

	/* to add another oai format, write this program
	using OAI_DC_Handler () as an example. */
		try {
			out.println("<metadata>");
			out.println("<OTHER:dc" +
				" xsi:schemaLocation='http://www.cdpheritage.org/OTHER_v1.00 http://IMLSDCC.grainger.uiuc.edu/schemas/OTHER_v1.00.xsd'" +
				" xmlns:dc='http://purl.org/dc/elements/1.1/'" +
				" xmlns:dct='http://purl.org/dc/terms/'" +
				" schemaVersion = '1.00'"  +
				" xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'" +
				" xmlns:OTHER='http://www.cdpheritage.org/OTHER_v1.00' >");
		}
		catch(IOException ie)
		{
			System.out.println(ie);
		}
		try
		{
			out.println("</OTHER:dc>");
			out.println("</metadata>");
		}
		catch(IOException ie)
		{
			System.out.println(ie);
	}
}


private String[] parseIdentifier() {

	// Parse an identifier into its scheme, archive, and id
	// Returns true if it is able to parse, else it returns false

	String[] results = {"false", "scheme", "archive", "id"};

	

	if(g_identifier == null){
		return results;
	}
	
	String colon= new String(":");
	StringTokenizer parts = new StringTokenizer(g_identifier, colon);
	int count;
	String delim = new String("");
	
	if((count = parts.countTokens()) >= 3) {
		results[0] = "true";
		results[1] = parts.nextToken();  // scheme
		results[2] = parts.nextToken();  // archive
		results[3]="";                   // build id here, even if it contains ":"
		
		do {
			results[3] = results[3] + delim +  parts.nextToken(); // record id
			delim = colon;
		} while (parts.hasMoreTokens());

		/* As a primitive security measure, no single quotes are allowed
		in the id, and it may not be longer than 255 characters */


		if (results[3].length() > 255 || results[3].indexOf("'")!=-1){
			results[0]="false";
		}
	}

	return results;
}
private String parseResumptionToken ( HttpServletRequest request,
	HttpServletResponse response, JspWriter out) {

	/*''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	' Parse a resumption token into its various parts
	' The resumptionToken syntax is
	'	 until|from|set|metadataPrefix|lastCDPIDsent|dateTimeStamp
	' If the resumptionToken cannot be parsed, set the 400 status code
	' and exit
	''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''*/

	String err = "";

	if(g_resumptionToken.length()==0) {
			g_currentOAI_ID = "0";}
	else {
		StringTokenizer parts = new StringTokenizer(g_resumptionToken, "|");
	if(parts.countTokens() != 6) {
		err = "\t<error code=\"badArgument\">'"
			+ URLEncoder.encode(g_resumptionToken)
			+ "' is not a valid resumptionToken</error>";
  		logError(request, 400, out);
		return err;
	}

		g_untilDateStr = parts.nextToken();
		untilDate = completeDate(g_untilDateStr);
		g_fromDateStr = parts.nextToken();
		fromDate = completeDate(g_fromDateStr);
		g_set_ = parts.nextToken();
		if(g_set_.equals("null")) {
			g_set_ = "";
		}
		g_metadataPrefix = parts.nextToken();
		if(g_metadataPrefix.equals("null")){
			 g_metadataPrefix = null;
		}
		g_currentOAI_ID = parts.nextToken();
		g_whenRsmtnTokenCreatedUTC = completeDate(parts.nextToken());

		// All ResumptionTokens issued prior to last Object
		// update/modify are expired!
		getLastUpdateDate(request, response, out);

		/* This test is no longer implemented to conform to the
			universal OAI software architecture at uiuc.

		if(g_lastUpdate.after(g_whenRsmtnTokenCreatedUTC)) {
			err = "\t<error code=\"badResumptionToken\">'"
				+ URLEncoder.encode(g_resumptionToken) + "' has expired</error>";
  			logError(request, 400, out);
			err=""; //this line added by TGH 2/24/2003
			return err;
		} */
	}

	// Set Defaults if date parameters not set

	if(untilDate==null) {
		g_untilDateStr = "9999-12-31";		// max date supported by Access
		untilDate = completeDate(g_untilDateStr);
	}
	if(untilDate==null) {
		g_fromDateStr = "1753-01-01";	// min date suppoered by Access/SQL server
		fromDate = completeDate(g_fromDateStr);
	}

	return err;
}


private String upcaseNoSpaces(String s){

	// converts the input string upper case
	// and removes ALL spaces, incl embedded
	// spaces.

	String trimmedString;
	trimmedString=s.trim();
	trimmedString= trimmedString.toUpperCase();
	int i;
	char c;
	StringBuffer sb = new StringBuffer("");
	for (i=0; i<trimmedString.length(); i++) {
		c=trimmedString.charAt(i);
		if( c!=' '){
			sb.append(c);
		}
	}
	return new String(sb);
}


private String UTCEncode( JspWriter out, Timestamp t) {

	/* Input is timestamp in local time zone or null. If
	null, timestamp is assigned local time at the SQL server.
	If not null, timestamp is assumed to be a time in
	the provider-local time zone.

	Output is a string representing the timestamp in UTC. */

	GregorianCalendar calAtSQLsrvr = new GregorianCalendar();

	Timestamp fileTimestamp;
	if (t == null){
		//timestamp is null, get SQLserver system time.
		try{
			ResultSet g_rs = g_stmt.executeQuery("SELECT now()");
			g_rs.next();
			fileTimestamp = g_rs.getTimestamp(1);
		} catch (Exception ex) {
			return "Failed to read DB Timestamp()" ;}
		}
	else {
		fileTimestamp = t;
	}

	// convert timestampe to milliseconds in unix epoch.
	long fileTimeMillis = fileTimestamp.getTime();

	// set calandar to that time, assume local Time Zone
	calAtSQLsrvr.setTimeInMillis( fileTimeMillis);

	// set calandar to convert to UTC when it reads its
	// internal time and date:
	calAtSQLsrvr.setTimeZone(TimeZone.getTimeZone("GMT"));

	// convert the time and date to a string and return
	StringBuffer dateStr = new StringBuffer();
	dateStr.append(calAtSQLsrvr.get(calAtSQLsrvr.YEAR)).append('-');
	dateStr.append(zPad(calAtSQLsrvr.get(calAtSQLsrvr.MONTH) + 1)).append('-');
	dateStr.append(zPad(calAtSQLsrvr.get(calAtSQLsrvr.DAY_OF_MONTH))).append('T');
	dateStr.append(zPad(calAtSQLsrvr.get(calAtSQLsrvr.HOUR_OF_DAY))).append(':');
	dateStr.append(zPad(calAtSQLsrvr.get(calAtSQLsrvr.MINUTE))).append(':');
	dateStr.append(zPad(calAtSQLsrvr.get(calAtSQLsrvr.SECOND)));
	dateStr.append('Z');

	return dateStr.toString();
}


private boolean validW3CdtfDate(String d) {

	// returns true if the input stream is a valid
	// w3cdtf date subset, with legal months and days,
	// else returns false

	// allows: yyyy, yyyy-mm, and yyyy-mm-dd

	// WARNING: be sure to trim the input string before
	// calling this routine!!!

	String fullPat = new String(
		"\\d\\d\\d\\d(-[0-1][0-9](-[0-3][0-9])??)??");
	System.out.println(d);
	boolean b = Pattern.matches(fullPat, d.trim());
	if (!b) {return false;}

	// any yyyy will do, mm must be 01-12 and dd must be 01-31
	String date = new String (d);
	String mon = new String ("");
	String day = new String ("");
	String legalMons =
		new String("01 02 03 04 05 06 07 08 09 10 11 12");
	String legalDays = new String(legalMons +
		" 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31");

	System.out.println(date.length());
	if (date.length()>=10) {
		day = date.substring(8,10);
		System.out.println("day=" + day);
		if(legalDays.indexOf(day)==-1) {return false;}
	}
	if (date.length()>=7) {
		mon = date.substring(5,7);
		System.out.println("mon=" + mon);
		if(legalMons.indexOf(mon)==-1) {return false;}
	}
	String shortMons = new String("02 04 06 09 11");
	if( shortMons.indexOf(mon) > -1 &&  day=="31") {return false;}

	// don't account for leap years: 02/29 is valid every year!

	if( mon.equals("02") &&
		(day.equals("30") || day.equals("31"))) {return false;}

	return true;
}


private void Write_OAIPMH_Header(HttpServletRequest request,
        HttpServletResponse response, JspWriter out){

	try{
		response.setContentType("text/xml");
		
		//out.println("test lines");
		//out.println("<?xml version='1.0' encoding='UTF-8'?>");
		out.print("<OAI-PMH xmlns='http://www.openarchives.org/OAI/2.0/' "
			+ "xmlns:xsi= 'http://www.w3.org/2001/XMLSchema-instance' ");
		out.println("xsi:schemaLocation='http://www.openarchives.org/OAI/2.0/ "
			+ "http://www.openarchives.org/OAI/2.0/OAI-PMH.xsd'>");
		out.println("<responseDate>" + nowUTC(out) + "</responseDate>");
	} catch(Exception ex){g_verb="err";};
}


private void Write_OAIPMH_Trailer(JspWriter out){
	try{
	out.println("</OAI-PMH>");
	g_stmt.close();
	g_conn.close();} catch (Exception ex) {}
}


private void writeRecord( JspWriter out) {

	// 	Write metadata record with OAI_Preifx stored in g_currentOAI_ID
   	if (g_metadataPrefix.equals("oai_dc")) 
		OAI_DC_Handler(out);

   	if (g_metadataPrefix.equals("nsdl_dc")) 
		NSDL_DC_Handler(out);
	

 	if (g_metadataPrefix.equals("OTHER")) {
		OAI_OTHER_Handler( out);
	}
}


private void writeRecordHeader( JspWriter out) {

	// synthesize and output identifier

	try {
		g_identifier = g_ThisSchemeParam + ":" +
			g_ThisArchiveParam + ":" + g_currentOAI_ID;
		out.println("\t\t<identifier>" + htmlEncode(tID)
			+ "</identifier>");
		out.println("\t\t<datestamp>" + g_rs.getString("date_created")
			+ "</datestamp>");

		// output a setSpec line for each set this record belongs to
		dbget_SetSpecs( out);
		while (g_rsSets.next()) {
			writeRecordHeaderSetSpec( out);
		}
	} catch(Exception xx) {}
}


private void writeRecordHeaderSetName( JspWriter out){

	try{
		out.println("\t\t<setName>" + htmlEncode(g_rsSets.getString("setName")) +
		"</setName>");
	} catch(Exception xx) {}
}


private void writeRecordHeaderSetSpec( JspWriter out){

	try{
		out.println("\t\t\t<setSpec>" + g_rsSets.getString("setSpec") +
		"</setSpec>");
	} catch(Exception xx) {}
}


private void WriteSimpleField( JspWriter out, String xmlTagName,
	String xmlTagAttr, String datafieldTag, String[] subfieldCodeArray,
	String sqlHead) {

	String sql;
	String strContent="";
	int iSubCodeItem;
	ResultSet field_rs;

	sql = sqlHead +
		" AND varName = '" + datafieldTag + "' ";

	if( subfieldCodeArray.length==0) {
	}
	else {
		sql = sql +
			" AND (" +
				"subfield= '" + subfieldCodeArray[0] + "' ";
		int L = subfieldCodeArray.length;
		for (iSubCodeItem=1; iSubCodeItem< L ; iSubCodeItem++) {
			sql=sql +
				" OR subfield = '" + subfieldCodeArray[iSubCodeItem] + "' ";
		}
		sql = sql + ")";
	}

	sql = sql + ";";

	field_rs = db_execSQL( out, g_fieldStmt, sql);

	try{
		while( field_rs.next()) {
			strContent = field_rs.getString("value");
			out.println("<" + xmlTagName + " " + xmlTagAttr + ">" + strContent +
			"</" + xmlTagName + ">");
		}	

	} catch (Exception xx){}

}

private String zPad(int val) {

	// left pads numbers under 10 with character 0

	if(val < 10) {
		return new String("0" + val);}
	else {
		return new String("" + val);
	}
}
/* Possible future enhancements:

1.  	Remove flow control form ListSets.  As with flow control 
	for ListMetadataFormats it is not needed.
2.	Add MARC output handler.  Currently the only avaliable output
	format is Simple DC
3.	Add metadata formats to OAI.ini, and remove from hard coding.
*/
%>

