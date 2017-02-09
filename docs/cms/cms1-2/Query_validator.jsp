<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ include file="../../TagLibIncludes.jsp" %>
<c:set var="contextUrl" value="${f:contextUrl(pageContext.request)}"/>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">


<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	
		<title>Concept Map Service - Query Validator</title>
		
		<script type="text/javascript" src="scripts/validateQuery.js"></script>

	</head>
	<body>

	<%-- Insert the menus top: --%>
	<%@ include file="/docs/menus_insertion_top.jsp" %>


		<h1>CSIP Query Validator</h1>
		<p>This interface allows for manual validation of CSIP queries.</p>	
		<ul>
			<li>
				<b>Please enter the query:<br/><br/></b>
				<table width="100%">
					<tr>
						<td align="center">
							<form action="${contextUrl}/ValidateQuery" method="post" name="testQuery">
								<textarea name="query" rows="12" cols="80"></textarea>
								<br/><br/>
								<input type="button" value="               Submit Query               "  onclick="submitQuery('${contextUrl}/ValidateQuery',document.forms.testQuery.query,document.results.queryResult);"/>
								<%-- The localhost:8080 in the line above should be replaced with ${contextUrl} --%>
							</form>
						</td>
					</tr>
				</table>
			</li>
		</ul>
		<br/>
		<ul>
			<li>
				<b>Result:<br/><br/></b>
				<table width="100%">
					<tr>
						<td align="center">
							<form name="results">
								<textarea name="queryResult" rows="5" cols="80"></textarea>
							</form>
						</td>
					</tr>
				</table>
			</li>
		</ul>
		
	<%-- Insert the menus bottom: --%>
	<%@ include file="/docs/menus_insertion_bottom.jsp" %>
		
	</body>
</html>		