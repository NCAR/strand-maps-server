<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="../../TagLibIncludes.jsp" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%-- Grab the required service URLs (defined in web.xml or server.xml): --%>	
<%
String bmId = request.getParameter("bmId");
String AAASCode = request.getParameter("AAASCode");
String displaytype = request.getParameter("displaytype");
%>
<c:set var="bmId" value="<%=bmId%>"/>
<c:set var="AAASCode" value="<%=AAASCode%>"/>
<c:set var="displaytype" value="<%=displaytype%>"/>
<%-- Issue the request to the web service. If a connection error occurs, store it in variable 'serviceError' --%>

<c:set var="url">${initParam.aaasAssessmentsBaseURL}/svc/sms/items/${bmId}</c:set>
<%-- Construct the http request to send to the web service and store it in variable 'webServiceRequest' --%>
	<c:set var="aaasAssessmentResults" value="${f:timedImport(url,10000)}"></c:set>
	displayAaasAssessment(
	<json:object prettyPrint="true" escapeXml="false">
	 	<json:property name="aaasAssessment" value="${aaasAssessmentResults}"/>
		<json:property name="displaytype" value="${displaytype}"/>
	</json:object>
)