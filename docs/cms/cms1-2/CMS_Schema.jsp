<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ include file="../../TagLibIncludes.jsp" %>
<c:set var="domain" value="${f:serverUrl(pageContext.request)}"/>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">


<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

	<title>CSIP Schema</title>
		
</head>
	<body>

	<%-- Insert the menus top: --%>
	<%@ include file="/docs/menus_insertion_top.jsp" %>		   

		<a name="CMSSchema"></a>
		<h1>CSIP Schema</h1>
		<p>The CSIP schema defines the grammer for constructing valid queries for the service. The CSIP schema is a an XML-schema and conforms to W3C XML schema standard. Reading and generating valid request from schema can become a daunting task without any tool support. Two tools <a href="http://www.altova.com/products_ide.html">XMLSpy</a> and <a href="http://www.tibco.com/software/business_integration/turboxml.jsp">TurboXML</a> can be used to easily generate valid CSIP queries.</p>
		
		<p>
			<ul>
				<li>
						<a href="CSIPSchema/csip_doc.jsp">CSIP Schema Documentation</a> gives detials of the XML schema that provides grammer for query validation.
				</li>
			</ul>
			<ul>
				<li>
						<a href="CSIPSchema/CMSSchema.zip">Download the CSIP Schema</a>			
				</li>
			</ul>
		</p>
		<h2>XMLSpy</h2>
		<p>
			To generate queries using XMLSpy please follow these steps:
			<ol>
				<li>Open the CSIP schema i.e. CSIP.xsd</li>
				<li>Select <em>DTD/Schema</em> from the top menu</li>
				<li>Click on <em>Generate Sample <u>X</u>ML File...</em></li>
			</ol>
		</p>
		<p>
			In the end edit the sample file to get the desired query.
		</p>
		
	<%-- Insert the menus bottom: --%>
	<%@ include file="/docs/menus_insertion_bottom.jsp" %>
   
	</body>
</html>