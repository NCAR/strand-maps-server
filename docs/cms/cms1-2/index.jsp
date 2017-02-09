<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ include file="../../TagLibIncludes.jsp" %>
<c:set var="domain" value="${f:serverUrl(pageContext.request)}"/>
<c:set var="baseCMSURL" value='${f:contextUrl(pageContext.request)}' />


<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

	<title>Concept Space Interchange Protocol</title>

</head>
	<body>

	<%-- Insert the menus top: --%>
	<%@ include file="/docs/menus_insertion_top.jsp" %>
	
	
		<h1>Concept Space Interchange Protocol</h1>
	
		<p>The Concept Space Interchange Protocol (CSIP) is a REpresentational State Transfer (REST) service API that lets developers search through concept maps and find digital library resource supporting concept maps. Developers can access concept maps in number of formats e.g. XML, OWLLite, SVG, PDF, PNG, TIFF, and JPEG.</p>
		
		<p>
		Currently, the service contains concept maps from the <em>Atlas of Science Literacy</em>  published by the American Association for the Advencement of Science (AAAS), <a href="http://www.project2061.org/" target="_blank">Project 2061</a>. 
		You can <a href="http://www.project2061.org/publications/bsl/online/bolintro.htm" target="_blank">browse these concept maps, or <em>benchmarks</em>, here</a>.
		Additional concept maps will be added to the service in the future.
		</p>
		
		<p>The service provides a rich search API and gives full access to the concept maps metadata. Developers can use the CSIP to dynamically generate concept maps, fragment of concept maps and locate digital library resources supporting concept maps. The service supports textual as well as navigational searching over the concept maps. Developers can use textual search feature to locate appropriate concepts, list of concepts, concept maps and concept maps fragments. The navigational search allows for searching using relationships between concepts e.g. what is the pre-requisite to a given concept.</p>
	
		<p>The service is illustrated and described formally here:</p>
		
		<ul>
	    	<li>
	    		<a href="CMS_specification.jsp">Documentation</a> - The documentation describes the service in detail, with service examples and information about each of the requests and search APIs.
	    	</li>
		</ul>  
		<ul>
		    <li>
		    	<a href="CMS_explorer.jsp">Explorer</a>- The CSIP explorer allows you to issue each of the available requests to the service and view the response using your web browser.
		    </li>
		</ul>
		<%-- <ul>
		    <li>
		    	<a href="Query_validator.jsp">Query Validator</a>- The CSIP query validator allows you to check if a query conforms to CSIP schema.
		    </li>
		</ul> --%>
		<ul>
		    <li>
		    	<a href="CMS_Schema.jsp">CSIP Schema</a>- The schema defines the grammer for constructing the XML component of the request.
		    </li>
		</ul>
		<ul>
		    <li>
		    	<a href="http://www.dlese.org/Metadata/strandmaps/index.htm">Concept Space Metadata Format </a>- The Concept Space metadata format provides details of the elements and structure of CSIP records.
		    </li>
		</ul>
		
		<br/>
		<p>To access the primary Concept Space service (CSIP v1.2), use the following <em>Base URL</em>:</p>
		<ul>
			<li><em>Base URL</em> = ${baseCMSURL}</li>
		</ul>
	
		<p>In order to make use of all available features of this service Adobe SVG plugin version 3.x should be present on the target browser.The Adobe plugin can be downloaded from <a href="http://www.adobe.com/svg/viewer/install/main.html">Adobe SVG Zone</a>.</p>

		<br/>
		<h3>SMS Version</h3>
		<p>
			This is version @VERSION@.  
			See <a href="<c:url value='/docs/CHANGES.txt'/>">list of changes in the software and APIs</a>.
			API changes are generally backward-compatible with previous versions.
		</p>		

	<%-- Insert the menus bottom: --%>
	<%@ include file="/docs/menus_insertion_bottom.jsp" %>
		
	</body>
</html>