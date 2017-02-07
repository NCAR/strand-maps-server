<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ include file="../../TagLibIncludes.jsp" %>
<c:set var="domain" value="${f:serverUrl(pageContext.request)}"/>
<c:set var="baseCMSURL" value='${f:contextUrl(pageContext.request)}' />


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
   
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	
		<title>Concept Map Service Documentation v1.0</title>
	 		
	</head>
	<body>

	<%-- Insert the menus top: --%>
	<%@ include file="/docs/menus_insertion_top.jsp" %>

		<p>To <a href="index.jsp">Concept Map Service Service home</a> <br/>
		<p>Back to <a href="CMS_specification.jsp#Query">Query documentation</a> <br/><br/>

		<h1>Query schema type</h1>

		<img src="images/QuerySchema.png" alt="Query Request Schema"/>
		
	<%-- Insert the menus bottom: --%>
	<%@ include file="/docs/menus_insertion_bottom.jsp" %>
		
	</body>
</html>