<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ include file="../../TagLibIncludes.jsp" %>
<c:set var="domain" value="${f:serverUrl(pageContext.request)}"/>
<c:set var="baseCMSURL" value='${f:contextUrl(pageContext.request)}' />

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">


<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	
		<title>Concept Space Interchange Protocol: Documentation</title>
		 						
	</head>
	<body>

	<%-- Insert the menus top: --%>
	<%@ include file="/docs/menus_insertion_top.jsp" %>
	
		<h1>Concept Space Interchange Protocol Documentation</h1>

		<p>
		Faisal Ahmad - <a href="http://grackle.colorado.edu/bolt.html" target="_blank">Boulder Learning Technologies Lab</a> (BoLT), University of Colorado at Boulder.<br/>
		
		<br/>
		The Concept Space Interchange Protocol (CSIP) provides programmatic access to the concept map repository. The service provides a rich search API and gives full access to the concept map metadata. Developers can use the CSIP to dynamically generate concept maps, fragment of concept maps and search digital library resources supporting concept maps. The service supports textual as well as navigational searching over the concept maps. Developers can use features of textual search to search appropriate concepts, list of concepts, concept maps and concept maps fragments. The navigational search allows for searching using relationships between concepts e.g. what is the pre-requisite to a given concept. The concept maps can be access in a number of formats e.g. XML, OWLLite, SVG, PDF, PNG, TIFF, and JPEG.
		
		<br/>
		<br/>
		Currently, the service contains maps from the <em>Atlas of Science Literacy</em>  published by the American Association for the Advencement of Science (AAAS), <a href="http://www.project2061.org/" target="_blank">Project 2061</a>. 
		You can <a href="http://www.project2061.org/publications/bsl/online/bolintro.htm" target="_blank">browse these concept maps, or <em>benchmarks</em>, here</a>.
		Additional concept maps will be added to the service in the future.
				
		<br/>
		<br/>
		The Web service requests and responses are described in detail below and examples are provided for reference by developers.<br/>
		<br/>
		Thanks to Tammy Sumner, Greg Janee, Mike Wright, John Weatherley, Sonal Bhushan, Sebastian de la Chica, Qianyi Gu and other <a href="http://grackle.colorado.edu/bolt.html" target="_blank">BoLT</a>, <a href="http://www.dlese.org">DLESE</a>, <a href="http://www.project2061.org/" target="_blank">AAAS Project 2061</a> and <a href="http://www.alexandria.ucsb.edu/" target="_blank">ADEPT</a> collaborators who contributed directly or indirectly to the design and testing of this service. The design of this service was greatly informed by the work of the <a href="http://www.alexandria.ucsb.edu/gazetteer/protocol/" target="_blank">Alexandria Digital Library Gazetteet Protocol</a> and <a href="http://www.dlese.org/dds/services/">DLESE Search Web Service</a>.<br/>
		</p><br/>			

		<h2>Definitions and concepts</h2>
		<p>CSIP is a REpresentational State Transfer (REST) style Web service. In REST style Web service architectures, requests are typically encoded as a URL and responses are returned as XML. This is the case with CSIP.<br><br>
		More formally: CSIP requests are expressed as HTTP argument/value pairs. These requests must be in either GET or POST format. Responses are returned in XML format, which varies in structure and content depending on the request.<br><br></p>
		<ul>
		<li><i>Base URL</i> - the base URL used to access the Web service. This is the portion of the request that precedes the request arguments. For example ${baseCMSURL}.
		<li><i>Request arguments</i> - the argument=value pairs that make up the request and follow the base URL. 
		<li><i>CSIP response envelope</i> - the XML container used to return data. This container returns different types of data depending on the request made.
		</ul>

		<h3>HTTP request formats</h3>		
		<br/>
		<p>CSIP request can be made by using three different HTTP formats:</p>
		<ul>
			<li>
				<em>HTTP GET  Method</em> - This request format consists of the base URL followed by the one of the service requests literal. Some of the service request literals are followed by <em>?</em> character which is appended with <em>key=value</em> pairs. If more than one key value pairs are required by the service request then the <em>key=value</em> pairs are concatenated by an <em>&</em> symbol.
			</li>
			<li>
				<em>HTTP POST Method 1</em> - This request format consists of the base URL followed by the one of the service requests literal. The <em>key=value</em> pairs are embedded in the body of the request
			</li>
			<li>
				<em>HTTP POST Method 2</em> - This request format consists of the base URL followed by the one of the service requests literal. No <em>key=value</em> pair is used in this kind of request but the value is directly embedded in the request.
			</li>
		</ul>		
	
		<h2>CSIP requests and responses</h2>	
		<p>This section defines the available requests.</p>
		<br/>
		<p>The HTTP request format has the following canonical structure: <b>[base URL]/<i>request</i></b>.<br></p>
		
		<br>
		<p>For example:<br>
		<pre>    ${baseCMSURL}/ServiceDescription</pre></p>
		<p>
			<b>Summary of available requests:</b><br>
			<br>
			<a href="#ServiceDescription">ServiceDescription</a> - Retrieves the capabilities of CSIP server and along with the version number.<br>
			<br>
			<a href="#SubmitResource">SubmitResource</a> - Allow clients to submit a examplary resources useful for teaching and learning a concept in the concept map repository.<br>
			<br>
			<a href="#RegisterQuery">RegisterQuery</a> - Enable clients to associate search query strings with concepts.<br>
			<br>
			<a href="#Query">Query</a> - Allows a client to search through concept maps and reterieve the matching concept maps in a number of formats.<br>
		</p>
		<br>
		<br>
		
		<a name="ServiceDescription"></a>
		<h3>ServiceDescription</h3>
		<p>
			<b>Sample request</b><br>
	
		    <br>
			    The following request get the CSIP server capabalities and version information:<br>
		    <br>
		    <a href="${baseCMSURL}/ServiceDescription" target="_blank">${baseCMSURL}/ServiceDescription</a><br>
		    <br>
		    	<b>Summary and usage</b><br>
		    <br>
		    	This request allows a clinet to determine the capabilities of the CSIP server. Clients can dynamic discovery available features of a CSIP server and tailor their behavior accordingly. This service request is also useful in a client is dealing with multiple CSIP servers which have varying capabilities.<br/>
		    <br>
			    <b>Arguments</b><br>
		    <br>
		    This service request does not take any arguments.<br/><br/>
			<b>Errors and exceptions</b><br/><br/>
			Error will only be reported if the literal is not spelled correctly.
			<br/><br/>
			<b>Examples</b><br>
			<br>
			<i><b>Request</b></i><br>
			<br>	
			Get the CSIP server capabilities<br/><br/>
			<pre>    ${baseCMSURL}/ServiceDescription</pre></p>
			<p><i><b>Response</b></i><br>
			
			<br>
			<table border="1" cellspacing="0" cellpadding="5">
			<tr><td><pre>			
&lt;SMS-CSIP&gt;
 &lt;ServiceDescriptionResponse&gt;

  &lt;Version majorNo="1" minorNo="0"&gt;Concept Map Service Server&lt;/Version&gt;
		
  &lt;SupportedConfigurations&gt;
   &lt;Configuration&gt;Skeleton&lt;/Configuration&gt;
   &lt;Configuration&gt;Detailed&lt;/Configuration&gt;
  &lt;/SupportedConfigurations&gt;
	
  &lt;SupportedQueryTypes&gt;
   &lt;Query&gt;Content-Query&lt;/Query&gt;
   &lt;Query&gt;Navigational-Query&lt;/Query&gt;
   &lt;Query&gt;ASNLookup-Query&lt;/Query&gt;
  &lt;/SupportedQueryTypes&gt;

  &lt;SupportedOperators&gt;
   &lt;Operator&gt;Logical&lt;/Operator&gt;
   &lt;Operator&gt;Relational&lt;/Operator&gt;
  &lt;/SupportedOperators&gt;
	
  &lt;SupportedReplyFormats&gt;
   &lt;Format&gt;SMS&lt;/Format&gt;
   &lt;Format&gt;SMS-JSON&lt;/Format&gt;
   &lt;Format&gt;SVG&lt;/Format&gt;
   &lt;Format&gt;SVG-JSON&lt;/Format&gt;   
   &lt;Format&gt;JPEG&lt;/Format&gt;
   &lt;Format&gt;PNG&lt;/Format&gt;
   &lt;Format&gt;TIFF&lt;/Format&gt;
   &lt;Format&gt;PDF&lt;/Format&gt;
   &lt;Format&gt;OWLLite&lt;/Format&gt;
  &lt;/SupportedReplyFormats&gt;
	
  &lt;SupportedLibrarySearch&gt;
   &lt;Library&gt;Google XML&lt;/Library&gt;
   &lt;Library&gt;DLESE&lt;/Library&gt;
   &lt;Library&gt;NSDL XML&lt;/Library&gt;
   &lt;Library&gt;Harvard Smithsonian&lt;/Library&gt;
   &lt;Library&gt;DLESE XML&lt;/Library&gt;
  &lt;/SupportedLibrarySearch&gt;
		
  &lt;SupportedExtensions/&gt;
		
 &lt;/ServiceDescriptionResponse&gt;
	
&lt;/SMS-CSIP&gt;</pre></td></tr>
			</table></p>
			<br>			
		
		<a name="SubmitResource"></a>
		<h3>SubmitResource</h3>
		<p><b>Sample request</b><br>
		    <br>
		    The following request sends an email to the AAAS personnel suggesting an examplary resource for teaching a concept:<br>
		    <br>
		    <a href="${baseCMSURL}/SubmitResource?ObjectID=SMS-BMK-1201&Resource=http://www.usd.edu/esci/exams/earthquakes.html&email=fahmad@colorado.edu" target="_blank">${baseCMSURL}/SubmitResource?ObjectID=SMS-BMK-1201&Resource=http://www.usd.edu/esci/exams/earthquakes.html&email=fahmad@colorado.edu</a><br>
		
		    <br>
		    <b>Summary and usage</b><br>
		    <br>
			<p>The SubmitResource request can be used by clients to contribute examplary resources. These examplary resources will become available to a wide range of digital libraries using the CSIP web-service.<br>
		
		    <br>
		    <b>Arguments</b><br>
		    <br>
			<ul>
				<li>
					ObjectID - A mandatory argument that should contain the value of CSIP identifier in appropriate <a href="#format">format</a>.
				</li> 
			</ul>
			<ul>
				<li>
					Resource - A mandatory argument that should contain the URL of the web-resource. 
				</li>
			</ul>
			<ul>
				<li>
					email 	 - A mandatory argument that specifies clients email address. 
				</li>
			</ul>
			<br>
					
			    <p><b>Errors and exceptions</b><br>
		    <br>
				Error is indicted if the request does not have the mandatory arguments or ObjectID does not follow the CSIP format.
		    <br></p>
		</p>
		
		<p>
		<b>Examples</b><br>
		<br>
		<i><b>Request</b></i><br>
		<br>
		Submit an examplary resource for ingestion into CSIP<br>
		<br>
		<pre>    ${baseCMSURL}/SubmitResource?ObjectID=SMS-MAP-1200&Resource=http://soils.ag.uidaho.edu/soilorders/index.htm&email=fahmad@colorado.edu</pre>
		</p>
		<p>
		<i><b>Response</b></i><br/><br/>
		A confirmation email is sent to the client.
		</p>
		<br>
		
		<a name="RegisterQuery"></a>
		<h3>RegisterQuery</h3>
		<p><b>Sample request</b><br>
		    <br>
		    The following request registers a digital library query with CSIP using HTTP GET method:<br>
		    <br>

					${baseCMSURL}/RegisterQuery?RegisterQuery=<em>&lt;SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"&gt;
	&lt;RegisterQuery CharacterEncoding="UTF-8"&gt;
		&lt;Functional&gt;
			&lt;Operation&gt;Add Query String&lt;/Operation&gt;
			&lt;PublishName&gt;SAMPLE-TEST&lt;/PublishName&gt;
			&lt;AuthenticationCode&gt;Hello World&lt;/AuthenticationCode&gt;
			&lt;QueryString&gt;s&lt;Group Repeat=" OR "&gt;\"&lt;Subjects Delimiter=" "  Paran="false"&gt;&lt;/Subjects&gt;\"&lt;/Group&gt; &lt;Group Repeat=" "&gt;\"&lt;Keywords Delimiter=" " Paran="false"&gt;&lt;/Keywords&gt;\"&lt;/Group&gt;&lt;/QueryString&gt;
			&lt;ObjectType&gt;Benchmark&lt;/ObjectType&gt;
		&lt;/Functional&gt;
	&lt;/RegisterQuery&gt;
&lt;/SMS-CSIP></em>

		    <br/><br/>
			    <p>The above mentioned request can also be made using HTTP POST method in two ways:</p><br/>
			    <ul>
			    	<li>Using a key=value pair 			- The key should be <em>RegisterQuery</em> and value will be the above mentioned XML fragment.</li>
			    	<li>Without using a key=value pair 	- In this senario the above mentioned XML fragment can be directly included in the body of post method request.</li>
			    </ul>

		    <br/>
		    <p><b>Summary and usage</b></p>
		    
			<p>The RegisterQuery request can be used by clients to register custom queries to a concept, lookup already registered queries, update an already registered query, and search for registered queries. When registering a query the client specifies a meta-query which get expanded when the concept map is returned to the client. The meta-query specifies query expansion rules using data from the concept map metadata.<br>

			<a name="schema"></a>
			<br/><b>Schema</b><br/>
			<p>The schema gives the rules for constructing the RegisterQuery request. Click <a href="RegisterQuerySchema.jsp">here</a> to see RegisterQuery schema type</p>
			
		    <p><b>Arguments</b></p>
			<ul>
				<li>
					RegisterQuery - If using HTTP GET this key  is mandatory. For HTTP POST method this key is optional.
				</li> 
			</ul>
			<br>

			<p><b>Register Query Options</b><br/></p>
			
			<ul>
				<li>
					 SeeAllQueries - A client can get the list of registered queries using this option
				</li>
				<li>
					  Lookup - A clinet can search for a query already registered
				</li>
				<li>
					  Functional - This operation can be used by a client to add a new query string or update a previsouly added query string.
				</li>
				<li>
					  Authentication - This operation is used to change password of a registered query.
				</li>
				<li>
					  Admin - A client can use this option to delete, enable and disable a registered query
				</li>
			</ul>
			
			<br/>
			<p><b>Examples</b></p>
			
			
			<p>
			<table border="0">
			
			<tr>
			<td width="2%" valign="top"><b>1.</b></td>
			<td valign="middle">
					<table border="1" cellpadding="10">
						<tr>
							<td align="left" colspan="2">
								SeeAllQueries - Gets the list of registered queries
							</td>
						</tr>
						<tr>
							<td align="center" width="2%">Request</td>
							<td><pre>
&lt;SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi=<br/>"http://www.w3.org/2001/XMLSchema-instance"&gt;
 &lt;RegisterQuery CharacterEncoding="UTF-8"&gt;
  &lt;SeeAllQueries&gt;
   &lt;Operation&gt;List&lt;/Operation&gt;
  &lt;/SeeAllQueries&gt;
 &lt;/RegisterQuery&gt;
&lt;/SMS-CSIP&gt;</pre></td>
						</tr>
						<tr>
							<td>Response</td>
							<td>
							<pre>
&lt;?xml version="1.0"?&gt;
&lt;SMS-CSIP xmlns="http://sms.dlese.org"&gt;
 &lt;QueryRegistrationResponse&gt;
  &lt;Result&gt;Success&lt;/Result&gt;
  &lt;Messege&gt;Found DL queries&lt;/Messege&gt;
  &lt;DLQuery&gt;
   &lt;PublishedName&gt;DLESE&lt;/PublishedName&gt;
   &lt;QueryHost/&gt;
   &lt;QueryString&gt;start?query=(&lt;Group Repeat="+OR+"<br/>&gt;contentStandard:"&lt;StandardName&gt;&lt;/StandardName&gt; ...
   &lt;Status&gt;Enable&lt;/Status&gt;
   &lt;ObjectType&gt;Benchmark&lt;/ObjectType&gt;
  &lt;/DLQuery&gt;
  &lt;DLQuery&gt;
   &lt;PublishedName&gt;DLESE XML&lt;/PublishedName&gt;
   &lt;QueryHost&gt;http://www.dlese.org<br/>&lt;/QueryHost&gt;
   &lt;QueryString&gt;/dds/services/ddsws1-0?verb=Search<br/>&amp;q=(&lt;Group Repeat="+OR+"&gt;contentStandard:"&lt;StandardName&gt; ...
   &lt;Status&gt;Enable&lt;/Status&gt;
   &lt;ObjectType&gt;Benchmark&lt;/ObjectType&gt;
   &lt;/DLQuery&gt;
  &lt;DLQuery&gt;
   &lt;PublishedName&gt;Google XML&lt;/PublishedName&gt;
   &lt;QueryHost/&gt;
   &lt;QueryString&gt;&lt;Group Repeat<br/>=" OR "&gt;"&lt;<br/>Subjects Delimiter=" "  Paran="false"&gt;&lt;/Subjects&gt;"&lt;/Group&gt; ...
   &lt;Status&gt;Enable&lt;/Status&gt;
   &lt;ObjectType&gt;Benchmark&lt;/ObjectType&gt;
   &lt;/DLQuery&gt;
  ...
&lt;/SMS-CSIP&gt;</pre>
							</td>
						</tr>
					</table>
			</td>
			</tr>
			
			<tr><td><br/></td></tr>
			
			<td valign="top"><b>2.</b></td>
			<td valign="middle">
					<table border="1" cellpadding="10">
						<tr>
							<td align="left" colspan="2">
								Lookup - Search for a registered Query
							</td>
						</tr>
						<tr>
							<td align="center" width="2%">Request</td>
							<td><pre>
&lt;SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi=<br/>"http://www.w3.org/2001/XMLSchema-instance"&gt;
 &lt;RegisterQuery CharacterEncoding="UTF-8"&gt;
  &lt;Lookup&gt;
   &lt;Operation&gt;Find&lt;/Operation&gt;
   &lt;Term&gt;NSDL&lt;/Term&gt;
  &lt;/Lookup&gt;
 &lt;/RegisterQuery&gt;
&lt;/SMS-CSIP></pre></td>
						</tr>
						<tr>
							<td>Response</td>
							<td>
							<pre>
&lt;?xml version="1.0"?&gt;
&lt;SMS-CSIP xmlns="http://sms.dlese.org"&gt;
 &lt;QueryRegistrationResponse&gt;
  &lt;Result&gt;Success&lt;/Result&gt;
  &lt;Messege&gt;Found DL queries&lt;/Messege&gt; 
  &lt;DLQuery&gt;
   &lt;PublishedName&gt;NSDL XML&lt;/PublishedName&gt;
   &lt;QueryHost/&gt;
   &lt;QueryString&gt;require(and(and(&lt;GradeRanges <br/>Delimiter=" " <br/>Paran="false"&gt;&lt;/GradeRanges&gt;<br/> " " " ") and ...
   &lt;Status&gt;Enable&lt;/Status&gt;
   &lt;ObjectType&gt;Benchmark&lt;/ObjectType&gt;
  &lt;/DLQuery&gt;
 &lt;/QueryRegistrationResponse&gt;
&lt;/SMS-CSIP></pre>
							</td>
						</tr>
						<tr>
							<td colspan="2" >
								<ul>
									<li>
										Term - The content of the this element can be changed for searching registered queries.
									</li>
								</ul>
							</td>
						</tr>
					</table>
			</td>
			</tr>
			<tr>
			<tr><td><br/></td><tr>

			<td valign="top"><b>3.</b></td>
			<td valign="middle">
					<table border="1" cellpadding="10">
						<tr>
							<td align="left" colspan="2">
								Functional - This operation can be used to add a new query string or update a previsouly added query string.
							</td>
						</tr>
						<tr>
							<td align="center" width="2%">Request</td>
							<td><pre>
&lt;SMS-CSIP xmlns="http://sms.dlese.org" <br/>xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"&gt;
 &lt;RegisterQuery CharacterEncoding="UTF-8"&gt;
  &lt;Functional&gt;
   &lt;Operation&gt;Add Query String&lt;/Operation&gt;
   &lt;PublishName&gt;HS&lt;/PublishName&gt;
   &lt;AuthenticationCode&gt;HSDVL<br/>&lt;/AuthenticationCode&gt;
   &lt;QueryString&gt;/results.php?smsid=&lt;IDNumber&gt;<br/>&lt;/IDNumber&gt;&lt;/QueryString&gt;
   &lt;ObjectType&gt;ALL&lt;/ObjectType&gt;
   &lt;QueryHost&gt;www.hsdvl.org&lt;/QueryHost&gt;
  &lt;/Functional&gt;
 &lt;/RegisterQuery&gt;
&lt;/SMS-CSIP&gt;</pre></td>
						</tr>
						<tr>
							<td>Response</td>
							<td>
							<pre>
&lt;?xml version="1.0"?&gt;
&lt;SMS-CSIP xmlns="http://sms.dlese.org"&gt;
 &lt;QueryRegistrationResponse&gt;
  &lt;Result&gt;Success&lt;/Result&gt;
  &lt;Messege&gt;Query Registered successfully<br/>&lt;/Messege&gt;
 &lt;/QueryRegistrationResponse&gt;
&lt;/SMS-CSIP&gt;</pre>
							</td>
						</tr>
						<tr>
							<td colspan="2" >
								<ul>
									<li>
										Operation - Defines what this request is going to achieve. I can take two values:
										<ul>
											<li>
												Add Query String - this option addes a new query string to CSIP registered query database.
											</li>
											<li>
												Update Query String - this options is used to modify an already registered query string.
											</li>
										</ul>
									</li>
									<li>
										PublishName - This is the name through which a registered query can be accessed.
									</li>
									<li>
										AuthenticationCode - The password that can be used later on to update or remove a registered query.
									</li>
									<li>
										QueryString - The meta-query string that defines template for instentiating an actual query string. <br/>The syntax of the query string is given in the <a href="#schema">schema</a> section.
									</li>
									<li>
										ObjectType - The object type to which the query string is bound. Following object types are possible:
										<ul>
											<li>
												ALL
											</li>
											<li>
												Atlas
											</li>
											<li>
												Benchmark
											</li>
											<li>
												Chapter
											</li>
											<li>
												Cluster
											</li>
											<li>
												Grade group
											</li>
											<li>
												Map
											</li>
											<li>
												Science for all americans paragraph
											</li>
											<li>
												Section
											</li>
											<li>
												Strand
											</li>
										</ul>
									</li>
									<li>
										QueryHost - An optional element used to define the query host
									</li>
								</ul>
							</td>
						</tr>
						</table>

			<tr>
			<tr><td><br/></td><tr>

			<td valign="top"><b>4.</b></td>
			<td valign="middle">
					<table border="1" cellpadding="10">
						<tr>
							<td align="left" colspan="2">
								Authentication - This operation is used to change password of a registered query.
							</td>
						</tr>
						<tr>
							<td align="center" width="2%">Request</td>
							<td><pre>
&lt;?xml version="1.0"?&gt;
&lt;SMS-CSIP xmlns="http://sms.dlese.org"&gt;							
 &lt;RegisterQuery CharacterEncoding="UTF-8"&gt;
  &lt;Authentication&gt;
  &lt;Operation&gt;Change Authentication Code<br/>&lt;/Operation&gt;
  &lt;PublishName&gt;HS&lt;/PublishName&gt;
  &lt;AuthenticationCode&gt;HSDVL<br/>&lt;/AuthenticationCode&gt;
  &lt;NewAuthenticationCode&gt;DLB<br/>&lt;/NewAuthenticationCode&gt;
  &lt;/Authentication&gt;
 &lt;/RegisterQuery&gt;
&lt;/SMS-CSIP></pre></td>
						</tr>
						<tr>
							<td>Response</td>
							<td>
							<pre>
&lt;?xml version="1.0"?&gt;
&lt;SMS-CSIP xmlns="http://sms.dlese.org"&gt;
 &lt;QueryRegistrationResponse&gt;
  &lt;Result&gt;Success&lt;/Result&gt;
  &lt;Messege&gt;Authentication code changed successfully<br/>&lt;/Messege&gt;
 &lt;/QueryRegistrationResponse&gt;
&lt;/SMS-CSIP></pre>
							</td>
						</tr>
						
						<tr>
							<td colspan="2" >
								<ul>
									<li>
										Operation - Defines what this request is going to achieve. 
									</li>
									<li>
										PublishName - Name of the registered query.
									</li>
									<li>
										AuthenticationCode - Old password for the registered query.
									</li>
									<li>
										NewAuthenticationCode - New password for the registered query.
									</li>
								</ul>
							</td>
						</tr>
						</table>
			<tr><td><br/></td><tr>

			<td valign="top"><b>5.</b></td>
			<td valign="middle">
					<table border="1" cellpadding="10">
						<tr>
							<td align="left" colspan="2">
								Admin - This operation is used to remove or change status of a registered query.
							</td>
						</tr>
						<tr>
							<td align="center" width="2%">Request</td>
							<td><pre>
&lt;SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi=<br/>"http://www.w3.org/2001/XMLSchema-instance"&gt;
 &lt;RegisterQuery CharacterEncoding="UTF-8"&gt;
  &lt;Admin&gt;
  &lt;Operation&gt;Disable&lt;/Operation&gt;
  &lt;PublishName&gt;HS&lt;/PublishName&gt;
  &lt;AuthenticationCode&gt;HSDVL<br/>&lt;/AuthenticationCode&gt;
  &lt;/Admin&gt;
 &lt;/RegisterQuery&gt;
&lt;/SMS-CSIP&gt;</pre></td>
						</tr>
						<tr>
							<td>Response</td>
							<td>
							<pre>
&lt;?xml version="1.0"?&gt;
&lt;SMS-CSIP xmlns="http://sms.dlese.org"&gt;
 &lt;QueryRegistrationResponse&gt;
  &lt;Result&gt;Success&lt;/Result&gt;
  &lt;Messege&gt;HS Query Disabled&lt;/Messege&gt;
 &lt;/QueryRegistrationResponse&gt;
&lt;/SMS-CSIP></pre>
							</td>
						</tr>
						
						<tr>
							<td colspan="2" >
								<ul>
									<li>
										Operation - Defines what this request is going to achieve. Possible operations are:
										<ul>
											<li>Enable</li>
											<li>Disable</li>
											<li>Remove</li>
										</ul>
									</li>
								</ul>
							</td>
						</tr>
			
			</table>
			</td>
			</tr>
			</table>
			</p>
			<br>
			<p>					
			    <b>Errors and exceptions</b><br>
		    <br>
				Error is indicted if the request does not conform to RegisterQuery <a href="#schema">schema</a>.
		    </p>
	
		<a name="Query"></a>
		<h3>Query</h3>
		<p><b>Sample request</b><br>
		    <br>
		    The following request send a query to searh for concept maps in the repository:<br>
		    <br>
			
					<p>${baseCMSURL}/Query?Query=<em>&lt;SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"&gt;&lt;Query&gt;&lt;Content-Query&gt;&lt;Term&gt;Ocean floor&lt;/Term&gt;&lt;/Content-Query&gt;&lt;/Query&gt;&lt;/SMS-CSIP&gt;</em></p>

		    <br/>
			    <p>The above mentioned request can also be made using HTTP POST method in two ways:</p>
			    <ul>
			    	<li>Using a key=value pair 			- The key should be <em>Query</em> and value will be the above mentioned XML fragment.</li>
			    	<li>Without using a key=value pair 	- In this senario the above mentioned XML fragment can be directly included in the body of post method request.</li>
			    </ul>
			</p>
			
		    <p><b>Summary and usage</b></p>
		    
			<p>The Query request can be used by clients to search through concept maps and retrieve concept maps in different formats.<br>

			<a name="Qschema"></a>
			<br/><b>Schema</b><br/>
			<p>The schema gives the rules for constructing the Query request. Click <a href="QuerySchema.jsp">here</a> to see Query schema type</p>
			
			
		    <p><b>Arguments</b></p>
			<ul>
				<li>
					Query - If using HTTP GET this key is mandatory. For HTTP POST method this key is optional.
				</li> 
			</ul>
			<br>
			<p><b>Query Options</b><br/></p>
			
			<ul>
				<li>
					 Content-Query - A client can use this query type to search through the concept map metadata.
				</li>
				<li>
					  Navigational-Query - A client can use this query type to look for concepts that are related to other concepts.
				</li>
				<li>
					  ASNLookup-Query - A client can use this query type to look for the SMS Benchmark ID that corresponds to a provided ASN ID, if available.
				</li>
			</ul>
			
			<br/>

			<p><b>Query Element Attributes</b><br/></p>
			
			
			<ul>
				<li>
					 Color - Color of the concept nodes in graphical representation of concept map. The default value is skyblue. This attribute is only useful when the response format request is SVG, PNG, TIFF, or JPEG.
				</li>
				<li>
					  DetailLevel - Using this attribute a client can decide on amount of metadata retrieved for a concept. This attribute is only useful if the response type is either SMS or OWLLite. This attribute can take two values:
					  <ul>
					  	<li>Skeleton <em>(default)</em> </li>
					  	<li>Detailed</li>
					  </ul>
				</li>
				<li>
					Format - The response format for concept maps. It can take following values:
					<ul>
						<li>SMS <em>(Default)</em> </li>
						<li>SMS-JSON</li>
						<li>SVG</li>
						<li>SVG-JSON</li>
						<li>PDF</li>
						<li>JPEG</li>
						<li>TIFF</li>
						<li>PNG</li>
						<li>OWLLite</li>
					</ul>
					The response format values can also be combined to set a preference order. For example, the response format might look like: PDF+SMS. In this case the server will attempt to return a PDF representation of the concept map, but if it fails to do so it will return the concept map data in SMS format. 
				</li>
				<li>
					Scope - It can be used to optimize the query search performance. Given an object type in scope, the search will restrict itself to just that object type and will not look into other object types. Following scope values are possible:
					<ul>
						<li>
							ALL <em>(Default)</em>
						</li>
						<li>
							Atlas
						</li>
						<li>
							Benchmark
						</li>
						<li>
							Chapter
						</li>
						<li>
							Cluster
						</li>
						<li>
							Grade group
						</li>
						<li>
							Map
						</li>
						<li>
							Science for all americans paragraph
						</li>
						<li>
							Section
						</li>
						<li>
							Strand
						</li>
					</ul>
					A combination of these values are possible e.g, Chapter+Map
				</li>
				<li>
					ThirdPartyQuery - Using this attribute a client can get a query string for some digital library for a concept. To get a query string the value must match some registered query published name.
				</li>
				<li>
					ImageScale - Scale of the returned map image if graphical format other than SVG is used. Its value can range between 1-200 (1 percent to 200 percent)
				</li>
				<li>
					ConceptSize - Size of the concept boxes. Its value can range between 1-6, i being the smallest and 6 being the largest.
				</li>
			</ul>
			
			<br/>

			<p><b>Examples</b></p>
		
			<p>
			<table border="0">
			
			<tr>
			<td width="2%" valign="top"><b>1.</b></td>
			<td valign="middle">
					<table border="1" cellpadding="10">
						<tr>
							<td align="left" colspan="2">
								This query looks for all the concepts that have <em>Ocean floor</em> in their full text component of the metadate record.
							</td>
						</tr>
						<tr>
							<td align="center" width="2%">Request</td>
							<td><pre>
&lt;SMS-CSIP xmlns="http://sms.dlese.org"&gt;
 &lt;Query Color="skyblue" DetailLevel="Skeleton" <br/>Format="SMS" Scope="ALL" ThirdPartyQuery="DLESE"&gt;
  &lt;Content-Query&gt;
   &lt;FullText MatchType="Contains-all-words"&gt;<br/>Ocean floor&lt;/FullText&gt;
  &lt;/Content-Query&gt;
 &lt;/Query&gt;
&lt;/SMS-CSIP>
</pre></td>
						</tr>
						<tr>
							<td>Response</td>
							<td>
							<pre>
&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;SMS-CSIP xmlns="http://sms.dlese.org"&gt;
 &lt;QueryResponse&gt;
  &lt;SMS Number="4"&gt;
   &lt;Record&gt;
    &lt;itemRecord xmlns="http://sms.dlese.org" xmlns:xsi=<br/>"http://www.w3.org/2001/XMLSchema-instance" <br/>xsi:schemaLocation="http://sms.dlese.org <br/>http://www.dlese.org/Metadata/strandmaps/0.1.01/<br/>Record.xsd"&gt;
     &lt;Data&gt;
      &lt;Name&gt;Earthquakes <br/>often occur along the <br/>boundaries&lt;/Name&gt;
      &lt;ObjectType&gt;benchmark&lt;/ObjectType&gt;
      &lt;AAASCode&gt;4C/H5&lt;/AAASCode&gt;
      &lt;InternalRelationship&gt;
       &lt;CatalogID CatalogNumber=<br/>"SMS-BMK-0027" <br/>RelationType="Contributes to achieving"/&gt;
       &lt;CatalogID CatalogNumber=<br/>"SMS-BMK-0034" <br/>RelationType="Contributes to achieving"/&gt;
       &lt;CatalogID CatalogNumber=<br/>"SMS-GRD-0045" <br/>RelationType="Is Part Of"/&gt;
       &lt;CatalogID CatalogNumber=<br/>"SMS-GRD-0047" <br/>RelationType="Is Part Of"/&gt;
       &lt;CatalogID CatalogNumber=<br/>"SMS-STD-0036" <br/>RelationType="Is Part Of"/&gt;
       &lt;CatalogID CatalogNumber=<br/>"SMS-STD-0041" <br/>RelationType="Is Part Of"/&gt;
       &lt;CatalogID CatalogNumber=<br/>"SMS-STD-0055" <br/>RelationType="Is Part Of"/&gt;
      &lt;/InternalRelationship&gt;
     &lt;/Data&gt;
     &lt;Admin&gt;
      &lt;IDNumber&gt;SMS-BMK-0025&lt;/IDNumber&gt;
     &lt;/Admin&gt;
     &lt;DLQueries&gt;
      &lt;Query DLName="DLESE"&gt;start?query=(<br/>contentStandard:%22nses:5-8:Content%20Standard%20D%20Earth%20and%20...
     &lt;/DLQueries&gt;
    &lt;/itemRecord&gt;
   &lt;/Record&gt;
  &lt;Record&gt;
  ...
</pre>
							</td>
						</tr>
						<tr>
							<td colspan="2">
								<ul>
									<li>
										The <em>MatchType</em> attribute can have four values:
										<ul>
											<li>Contains-all-words</li>
											<li>Contains-any-word</li>
											<li>Contains-phrase</li>
											<li>Equals</li>
										</ul>
									</li>
									<li>
										Elements other than <em>FullText</em> can also be used to searching. For other possible elements please see the query <a href="#Qschema">schema</a>. 
									</li>
								</ul>
								
							</td>
						</tr>
					</table>
			</td>
			</tr>
			
			<tr><td><br/></td></tr>
			
			<tr>
			<td width="2%" valign="top"><b>2.</b></td>
			<td valign="middle">
					<table border="1" cellpadding="10">
						<tr>
							<td align="left" colspan="2">
								This query looks for all the concepts that have any of the following words <em>wind, energy or waves</em>. This <br/><em>Term</em> elements searches for the text in every element of the metadata record.
							</td>
						</tr>
						<tr>
							<td align="center" width="2%">Request</td>
							<td><pre>
&lt;SMS-CSIP xmlns="http://sms.dlese.org"&gt;
 &lt;Query Color="skyblue" DetailLevel="Skeleton" <br/>Format="SMS" Scope="ALL"&gt;
  &lt;Content-Query>
   &lt;Term MatchType="Contains-any-word">Wind energy waves<br/>&lt;/Term&gt;
  &lt;/Content-Query>
 &lt;/Query>
&lt;/SMS-CSIP&gt;
</pre></td>
						</tr>
						<tr>
							<td>Response</td>
							<td>
							<pre>
&lt;SMS-CSIP xmlns="http://sms.dlese.org"&gt;
 &lt;QueryResponse&gt;
  &lt;SMS Number="4"&gt;
   &lt;Record&gt;
    &lt;itemRecord xmlns="http://sms.dlese.org" xmlns:xsi=<br/>"http://www.w3.org/2001/XMLSchema-instance" <br/>xsi:schemaLocation="http://sms.dlese.org http:<br/>//www.dlese.org/Metadata/strandmaps/0.1.01/<br/>Record.xsd"&gt;
     &lt;Data&gt;
      &lt;Name&gt;Earthquakes often occur along the <br/>boundaries&lt;/Name&gt;
      &lt;ObjectType&gt;benchmark&lt;/ObjectType&gt;
      &lt;AAASCode&gt;4C/H5&lt;/AAASCode&gt;
      &lt;InternalRelationship&gt;
       &lt;CatalogID CatalogNumber="SMS-BMK-0027" <br/>RelationType="Contributes to achieving"/&gt;
       &lt;CatalogID CatalogNumber="SMS-BMK-0034" <br/>RelationType="Contributes to achieving"/&gt;
       &lt;CatalogID CatalogNumber="SMS-GRD-0045" <br/>RelationType="Is Part Of"/&gt;
       &lt;CatalogID CatalogNumber="SMS-GRD-0047" <br/>RelationType="Is Part Of"/&gt;
       &lt;CatalogID CatalogNumber="SMS-STD-0036" <br/>RelationType="Is Part Of"/&gt;
       &lt;CatalogID CatalogNumber="SMS-STD-0041" <br/>RelationType="Is Part Of"/&gt;
       &lt;CatalogID CatalogNumber="SMS-STD-0055" <br/>RelationType="Is Part Of"/&gt;
      &lt;/InternalRelationship&gt;
     &lt;/Data&gt;
     &lt;Admin&gt;
      &lt;IDNumber&gt;SMS-BMK-0025&lt;/IDNumber&gt;
     &lt;/Admin&gt;
    &lt;/itemRecord&gt;
   &lt;/Record&gt;
   &lt;Record&gt;
	&lt;itemRecord xmlns="http://sms.dlese.org" <br/>xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"  
	...
</pre>
							</td>
						</tr>
					</table>
			</td>
			</tr>

			<tr><td><br/></td></tr>

			<tr>
			<td width="2%" valign="top"><b>3.</b></td>
			<td valign="middle">
					<table border="1" cellpadding="10">
						<tr>
							<td align="left" colspan="2">
								This query looks for all the concepts that has the word <em>earthquakes</em> in its name and has <em>Contributes to <br/>achieving</em> a relationship to another concept i.e. SMS-BMK-0009.
							</td>
						</tr>
						<tr>
							<td align="center" width="2%">Request</td>
							<td><pre>
&lt;SMS-CSIP xmlns="http://sms.dlese.org" <br/>xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" &gt;
 &lt;Query&gt;
  &lt;Content-Query&gt;
   &lt;AND&gt;
    &lt;Name MatchType="Contains-phrase"&gt;Earthquakes<br/>&lt;/Name&gt;
    &lt;InternalRelationships&gt;
     &lt;InternalRelationship Relation="Contributes to <br/>achieving" Object="SMS-BMK-0009"/&gt;
    &lt;/InternalRelationships&gt;
   &lt;/AND&gt;
  &lt;/Content-Query&gt;
 &lt;/Query&gt;
&lt;/SMS-CSIP&gt;
</pre></td>
						</tr>
						<tr>
							<td>Response</td>
							<td>
							<pre>
&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;SMS-CSIP xmlns="http://sms.dlese.org"&gt;
 &lt;QueryResponse&gt;
  &lt;SMS Number="1"&gt;
   &lt;Record&gt;
    &lt;itemRecord xmlns="http://sms.dlese.org" xmlns:xsi=<br/>"http://www.w3.org/2001/XMLSchema-instance" <br/>xsi:schemaLocation="http://sms.dlese.org http:<br/>//www.dlese.org/Metadata/strandmaps/0.1.01/<br/>Record.xsd"&gt;
     &lt;Data&gt;
      &lt;Name&gt;Earthquakes often occur along the <br/>boundaries&lt;/Name&gt;
      &lt;ObjectType&gt;benchmark&lt;/ObjectType&gt;
      &lt;AAASCode&gt;4C/H5&lt;/AAASCode&gt;
      &lt;InternalRelationship&gt;
       &lt;CatalogID CatalogNumber="SMS-BMK-0027" <br/>RelationType="Contributes to achieving"/&gt;
       &lt;CatalogID CatalogNumber="SMS-BMK-0034" <br/>RelationType="Contributes to achieving"/&gt;
       &lt;CatalogID CatalogNumber="SMS-GRD-0045" <br/>RelationType="Is Part Of"/&gt;
       &lt;CatalogID CatalogNumber="SMS-GRD-0047" <br/>RelationType="Is Part Of"/&gt;
       &lt;CatalogID CatalogNumber="SMS-STD-0036" <br/>RelationType="Is Part Of"/&gt;
       &lt;CatalogID CatalogNumber="SMS-STD-0041" <br/>RelationType="Is Part Of"/&gt;
       &lt;CatalogID CatalogNumber="SMS-STD-0055" <br/>RelationType="Is Part Of"/&gt;
      &lt;/InternalRelationship&gt;
     &lt;/Data&gt;
     &lt;Admin&gt;
      &lt;IDNumber&gt;SMS-BMK-0025&lt;/IDNumber&gt;
     &lt;/Admin&gt;
    &lt;/itemRecord&gt;
   &lt;/Record&gt;
  &lt;/SMS&gt;
 &lt;/QueryResponse&gt;
&lt;/SMS-CSIP&gt;
</pre>
							</td>
						</tr>
					</table>
			</td>
			</tr>
			<tr><td><br/></td></tr>

			<tr>
			<td width="2%" valign="top"><b>4.</b></td>
			<td valign="middle">
					<table border="1" cellpadding="10" >
						<tr>
							<td align="left" colspan="2">
								This query looks for all the concepts that has any relationship to another concept identified by SMS-BMK-0027 <br/>and any relationship to strand identfied by SMS-STD-0109.
							</td>
						</tr>
						<tr>
							<td align="center" width="2%">Request</td>
							<td><pre>
&lt;SMS-CSIP xmlns="http://sms.dlese.org"&gt;
 &lt;Query DetailLevel="Skeleton" Color="skyblue" <br/>Format="SMS" Scope="ALL" ThirdPartyQuery=""&gt;
  &lt;Content-Query&gt;
   &lt;InternalRelationships&gt;
    &lt;InternalRelationship Relation="Any" Object=<br/>"SMS-BMK-0027"&gt;&lt;/InternalRelationship&gt;
    &lt;InternalRelationship Relation="Any" Object=<br/>"SMS-STD-0109"&gt;&lt;/InternalRelationship&gt;
   &lt;/InternalRelationships&gt;
  &lt;/Content-Query&gt;
 &lt;/Query&gt;
&lt;/SMS-CSIP&gt;
</pre></td>
						</tr>
						<tr>
							<td>Response</td>
							<td>
							<pre>
&lt;SMS-CSIP xmlns="http://sms.dlese.org"&gt;
 &lt;QueryResponse&gt;
  &lt;SMS Number="0"/&gt;
 &lt;/QueryResponse&gt;
&lt;/SMS-CSIP&gt;
</pre>
							</td>
						</tr>
						<tr>
							<td colspan="2">
								In this case it shows a not match => empty response
							</td>
						</tr>
					</table>
			</td>
			</tr>
			<tr><td><br/></td></tr>

			<tr>
			<td width="2%" valign="top"><b>5.</b></td>
			<td valign="middle">
					<table border="1" cellpadding="10">
						<tr>
							<td align="left" colspan="2">
								This query retrieves a map and identified by SMS-MAP-1200, along with strands , grade groups and concepts that are part of the map.
							</td>
						</tr>
						<tr>
							<td align="center" width="2%">Request</td>
							<td><pre>
&lt;SMS-CSIP xmlns="http://sms.dlese.org"&gt;
 &lt;Query DetailLevel="Skeleton" Color="skyblue" <br/>Format="SMS" Scope="ALL" ThirdPartyQuery=""&gt;
  &lt;Content-Query&gt;
   &lt;ObjectID Depth="2"&gt;SMS-MAP-1200&lt;/ObjectID&gt;
  &lt;/Content-Query&gt;
 &lt;/Query&gt;
&lt;/SMS-CSIP&gt;
</pre></td>
						</tr>
						<tr>
							<td>Response</td>
							<td>
							<pre>
&lt;SMS-CSIP xmlns="http://sms.dlese.org"&gt;
 &lt;QueryResponse&gt;
  &lt;SMS Number="30"&gt;
   &lt;Record&gt;
    &lt;itemRecord xmlns="http://sms.dlese.org" xmlns:xsi=<br/>"http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http:<br/>//sms.dlese.org http://www.dlese.org/Metadata/strandmaps/0.1.01/<br/>Record.xsd"&gt;
     &lt;Data&gt;
      &lt;Name&gt;People are more likely to believe your ideas&lt;/Name&gt;
      &lt;ObjectType&gt;Benchmark&lt;/ObjectType&gt;
      &lt;AAASCode&gt;9E/P1&lt;/AAASCode&gt;
      &lt;InternalRelationship&gt;
       &lt;CatalogID CatalogNumber="SMS-BMK-0652" <br/>RelationType="Contributes to achieving"/&gt;
       &lt;CatalogID CatalogNumber="SMS-BMK-0772" <br/>RelationType="Contributes to achieving"/&gt;
       &lt;CatalogID CatalogNumber="SMS-BMK-0845" <br/>RelationType="Contributes to achieving"/&gt;
       &lt;CatalogID CatalogNumber="SMS-GRD-1203" <br/>RelationType="is part of"/&gt;
       ...
</pre>
							</td>
						</tr>
					</table>
			</td>
			</tr>
			<tr><td><br/></td></tr>

			<tr>
			<td width="2%" valign="top"><b>6.</b></td>
			<td valign="middle">
					<table border="1" cellpadding="10" width="100%">
						<tr>
							<td align="left" colspan="2">
								This query finds all the concepts that are prerequisite for the concept identified by SMS-BMK-1235.
							</td>
						</tr>
						<tr>
							<td align="center" width="2%">Request</td>
							<td><pre>
&lt;SMS-CSIP xmlns="http://sms.dlese.org"&gt;
 &lt;Query DetailLevel="Skeleton" Color="skyblue" <br/>Format="SMS" Scope="ALL" ThirdPartyQuery=""&gt;
  &lt;Navigational-Query&gt;
   &lt;ObjectID&gt;SMS-BMK-1235&lt;/ObjectID&gt;
   &lt;Relation&gt;
    &lt;Prerequisite/&gt;
   &lt;/Relation&gt;
  &lt;/Navigational-Query&gt;
 &lt;/Query&gt;
&lt;/SMS-CSIP&gt;
</pre></td>
						</tr>
						<tr>
							<td>Response</td>
							<td>
							<pre>
&lt;SMS-CSIP xmlns="http://sms.dlese.org"&gt;
 &lt;QueryResponse&gt;
  &lt;SMS Number="4"&gt;
   &lt;Record&gt;
    &lt;itemRecord xmlns="http://sms.dlese.org" xmlns:xsi=<br/>"http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http:<br/>//sms.dlese.org http://www.dlese.org/Metadata/strandmaps<br/>/0.1.01/Record.xsd"&gt;
     &lt;Data&gt;
      &lt;Name&gt;People are more likely to believe your ideas&lt;/Name&gt;
      &lt;ObjectType&gt;Benchmark&lt;/ObjectType&gt;
      &lt;AAASCode&gt;9E/P1&lt;/AAASCode&gt;
      &lt;InternalRelationship&gt;
       &lt;CatalogID CatalogNumber="SMS-BMK-0652" <br/>RelationType="Contributes to achieving"/&gt;
       &lt;CatalogID CatalogNumber="SMS-BMK-0772" <br/>RelationType="Contributes to achieving"/&gt;
       &lt;CatalogID CatalogNumber="SMS-BMK-0845" <br/>RelationType="Contributes to achieving"/&gt;
       &lt;CatalogID CatalogNumber="SMS-GRD-1203" <br/>RelationType="is part of"/&gt;
       ...
</pre>
							</td>
						</tr>
						<tr>
							<td colspan="2">
								Depth - This attribute is optional and default value is 0. The value of this attribute determines the deep of the <br/>retrieval operation. The depth can be positive as well as negative. Please refer to <a href="#Hierarchy"> CSIP object hierarchy</a> for depth details.
							</td>
						</tr>
					</table>
			</td>
			</tr>
			<tr><td><br/></td></tr>

			<tr>
			<td width="2%" valign="top"><b>7.</b></td>
			<td valign="middle">
					<table border="1" cellpadding="10" width="100%">
						<tr>
							<td align="left" colspan="2">
								This query finds all the concepts that are post-requisite, contributes to achieving or contains the the concept <br/>identified by SMS-BMK-1235.
							</td>
						</tr>
						<tr>
							<td align="center" width="2%">Request</td>
							<td><pre>
&lt;SMS-CSIP xmlns="http://sms.dlese.org"&gt;
 &lt;Query DetailLevel="Skeleton" Color="skyblue" <br/>Format="SMS" Scope="ALL" ThirdPartyQuery=""&gt;
  &lt;Navigational-Query&gt;
   &lt;ObjectID&gt;SMS-BMK-1235&lt;/ObjectID&gt;
   &lt;Relation&gt;
    &lt;OR&gt;
     &lt;Contains/&gt;
     &lt;Post-Requisite/&gt;
     &lt;Contributes-to-achieving/&gt;
    &lt;/OR&gt;
   &lt;/Relation&gt;
  &lt;/Navigational-Query&gt;
 &lt;/Query&gt;
&lt;/SMS-CSIP&gt;
</pre></td>
						</tr>
						<tr>
							<td>Response</td>
							<td>
							<pre>
&lt;SMS-CSIP xmlns="http://sms.dlese.org"&gt;
 &lt;QueryResponse&gt;
  &lt;SMS Number="2"&gt;
   &lt;Record&gt;
    &lt;itemRecord xmlns="http://sms.dlese.org" xmlns:xsi=<br/>"http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http:<br/>//sms.dlese.org http://www.dlese.org/Metadata/strandmaps/0.1.01/<br/>Record.xsd"&gt;
     &lt;Data&gt;
      &lt;Name&gt;Some changes are very slow&lt;/Name&gt;
      &lt;ObjectType&gt;Benchmark&lt;/ObjectType&gt;
      &lt;AAASCode&gt;9E/P1&lt;/AAASCode&gt;
      &lt;InternalRelationship&gt;
       &lt;CatalogID CatalogNumber="SMS-BMK-1235" RelationType="Contributes to achieving"/&gt;
       &lt;CatalogID CatalogNumber="SMS-GRD-1203" RelationType="is part of"/&gt;
       ...
</pre>
							</td>
						</tr>
					</table>
			</td>
			</tr>

			<tr>
				<td colspan="3">	
					<br/>
					<b>For detials about how to formulate queries please refer to <a href="CMS_Schema.jsp">Concept Space Interchange Protocol schema</a>.</b>
				</td>
			</tr>

			</table>		
		</p>
				
		<a name="format"></a>
		<h3>CSIP identifier format</h3>
		<p>According to Concept Space Interchange Protocol the CSIP identifier should followinw the following pattern:
		<em>[Three letters]-[three letters]-[4 digits]</em> e.g. SMS-CHP-1526</p>

		
		<a name="Hierarchy"></a>
		<h3>CSIP Object Hierarchy</h3>
		<table width="100%"><tr><td align="center"><img src="images/AAASObjectHierarchy.PNG"/></td></tr></table> 
		
	
	<%-- Insert the menus bottom: --%>
	<%@ include file="/docs/menus_insertion_bottom.jsp" %>
	</body>
</html>