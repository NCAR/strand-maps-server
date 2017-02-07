<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="../../TagLibIncludes.jsp" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%-- Grab the required service URLs (defined in web.xml or server.xml): --%>
<c:set var="smsCsipBaseUrl" value="${initParam.smsCsipBaseUrl}" />
		
<%
String id = request.getParameter("id");
String mapid = request.getParameter("mapid");
String bmid = request.getParameter("bmid");
%>
<c:set var="id" value="<%=id%>"/>
<c:set var="mapid" value="<%=mapid%>"/>
<c:set var="bmid" value="<%=bmid%>"/>

<c:set var="relmapcontent">
<c:forTokens var="grdid" items="${id}" delims="|">
<c:set var="queryforgrd">
      <SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<Query Color="skyblue" DetailLevel="Detailed" Format="SMS" Scope="ALL" ThirdPartyQuery="">
		<Content-Query>
			<ObjectID><c:out value="${grdid}" /></ObjectID>
		</Content-Query>
	</Query>
</SMS-CSIP>
</c:set>
<c:url value="${initParam.smsCsipBaseUrl}/Query" var="req">
	<c:param name="Query" value="${queryforgrd}"/>
</c:url>	

<c:import url="${req}" var="xmlResponse" charEncoding="UTF-8" />
<!-- change the & to &amp; -->
<c:set var="newresponse" value="${fn:replace( xmlResponse, '&' , '&amp;')}"/>
<x:transform xslt="${f:removeNamespacesXsl()}" xml="${newresponse}" var="testdoc"/>

<x:forEach select="$testdoc//SMS/Record/itemRecord/Data/InternalRelationship/CatalogID">
	<c:set var="testMap"><x:out select="@CatalogNumber" /></c:set>	

	
		<c:set var="queryforgrd2">
	      <SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
				<Query Color="skyblue" DetailLevel="Detailed" Format="SMS" Scope="ALL" ThirdPartyQuery="">
					<Content-Query>
						<ObjectID><c:out value="${testMap}" /></ObjectID>
					</Content-Query>
				</Query>
			</SMS-CSIP>
		</c:set>
		<c:url value="${initParam.smsCsipBaseUrl}/Query" var="req2">
			<c:param name="Query" value="${queryforgrd2}"/>
		</c:url>	
			
		<c:import url="${req2}" var="xmlResponse2" charEncoding="UTF-8" />
		<!-- change the & to &amp; -->
		<c:set var="newresponse2" value="${fn:replace( xmlResponse2, '&' , '&amp;')}"/>
		<x:transform xslt="${f:removeNamespacesXsl()}" xml="${newresponse2}" var="testdoc2"/>
	
		<c:set var="mapname">
			<x:out select="$testdoc2//SMS/Record/itemRecord/Data/FullText" />
		</c:set>
		<c:set var="newmapid">
			<x:out select="$testdoc2//SMS/Record/itemRecord/Admin/IDNumber" />
		</c:set>

		<c:choose>
		
		<c:when test="${newmapid ne mapid}">
		<a href='?id=${newmapid}&bm=${bmid}'>${mapname}</a>, 
		</c:when>
		<c:otherwise>
		${mapname}</a>, 
		</c:otherwise>
		</c:choose>
				
</x:forEach>
</c:forTokens>
</c:set>
<c:set var="relmapcontent" value="${fn:substring(relmapcontent,0,fn:length(relmapcontent)-1)}" />

saveRelatedMaps(
	<json:object prettyPrint="true" escapeXml="false">
	 	<json:property name="content" value="${relmapcontent}"/>
	</json:object>
)