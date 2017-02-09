<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="../../TagLibIncludes.jsp" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%-- Grab the required service URLs (defined in web.xml or server.xml): --%>
<c:set var="smsCsipBaseUrl" value="${initParam.smsCsipBaseUrl}" />
		
<%
String mapid = request.getParameter("mapid");
String bmid = request.getParameter("bmid");
%>
<c:set var="mapid" value="<%=mapid%>"/>
<c:set var="bmid" value="<%=bmid%>"/>

<c:choose>
	<c:when test="${fn:contains(mapid, 'MAP')}">
		<c:set var="sms_map_id" value="<%=mapid%>"/>
	</c:when>
	<c:when test="${fn:contains(mapid, 'GRD')||fn:contains(mapid, 'STD')}">
		<c:set var="queryforstdgrade">
	      <SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			<Query Color="skyblue" DetailLevel="Detailed" Format="SMS" Scope="ALL" ThirdPartyQuery="">
				<Content-Query>
					<ObjectID><c:out value="${mapid}" /></ObjectID>
				</Content-Query>
			</Query>
		 </SMS-CSIP>
	     </c:set>
	     <c:url value="${initParam.smsCsipBaseUrl}/Query" var="stdgradeReq">
			<c:param name="Query" value="${queryforstdgrade}"/>
		 </c:url>	
	
		 <c:import url="${stdgradeReq}" var="xmlResponse" charEncoding="UTF-8" />
		 <c:set var="stdgraderesponse" value="${fn:replace( xmlResponse, '&' , '&amp;')}"/>
		 <x:transform xslt="${f:removeNamespacesXsl()}" xml="${stdgraderesponse}" var="stdgradedoc"/>
		 <c:set var="sms_map_id">
				<x:out select="$stdgradedoc//SMS/Record/itemRecord/Data/InternalRelationship/CatalogID[contains(@CatalogNumber,'MAP')][1]/@CatalogNumber" />
		 </c:set>
	</c:when>
	<c:otherwise>
		<c:set var="sms_map_id" value=""/>
	</c:otherwise>
</c:choose>



<c:set var="relmapcontent">

	<c:set var="queryforbm">
      <SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
		<Query Color="skyblue" DetailLevel="Detailed" Format="SMS" Scope="ALL" ThirdPartyQuery="">
			<Content-Query>
				<ObjectID><c:out value="${bmid}" /></ObjectID>
			</Content-Query>
		</Query>
	 </SMS-CSIP>
     </c:set>

	<c:url value="${initParam.smsCsipBaseUrl}/Query" var="req">
		<c:param name="Query" value="${queryforbm}"/>
	</c:url>	

	<c:import url="${req}" var="xmlResponse" charEncoding="UTF-8" />
	<c:set var="newresponse" value="${fn:replace( xmlResponse, '&' , '&amp;')}"/>
	<x:transform xslt="${f:removeNamespacesXsl()}" xml="${newresponse}" var="testdoc"/>
	
	<c:set var="looked_up_sms_map_id" value=""/>
	<c:set var="looked_up_sms_map_name" value=""/>
	<c:set var="mutliple_maps" value="false"/>
	
	<x:forEach select="$testdoc//SMS/Record/itemRecord/Data/InternalRelationship/CatalogID[contains(@CatalogNumber,'SMS-STD')]" varStatus="loop">
		<c:set var="relationId"><x:out select="@CatalogNumber" /></c:set>
		<c:set var="queryforstd">
			 <SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
				<Query Color="skyblue" DetailLevel="Detailed" Format="SMS" Scope="ALL" ThirdPartyQuery="">
					<Content-Query>
						<ObjectID><c:out value="${relationId}" /></ObjectID>
					</Content-Query>
				</Query>
			</SMS-CSIP>
		</c:set>
		
		<c:url value="${initParam.smsCsipBaseUrl}/Query" var="req2">
			<c:param name="Query" value="${queryforstd}"/>
		</c:url>	
		
		<c:import url="${req2}" var="xmlResponse2" charEncoding="UTF-8" />
		<c:set var="newresponse2" value="${fn:replace( xmlResponse2, '&' , '&amp;')}"/>
		<x:transform xslt="${f:removeNamespacesXsl()}" xml="${newresponse2}" var="testdoc2"/>
		
		<c:set var="strandname">
			<x:out select="$testdoc2//SMS/Record/itemRecord/Data/Name"/>
		</c:set>
		<c:set var="inmap">
			<x:out select="$testdoc2//SMS/Record/itemRecord/Data/InternalRelationship/CatalogID[contains(@CatalogNumber,'MAP')][1]/@CatalogNumber" />
		</c:set>
	
		<c:choose>
			<c:when test="${relationId eq mapid}">
				${strandname}, 
			</c:when>
			<c:when test="${empty sms_map_id}">
				<c:if test="${inmap!=looked_up_sms_map_id}">
					
					<c:set var="queryformap">
				      <SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
							<Query Color="skyblue" DetailLevel="Detailed" Format="SMS" Scope="ALL" ThirdPartyQuery="">
								<Content-Query>
									<ObjectID><c:out value="${inmap}" /></ObjectID>
								</Content-Query>
							</Query>
						</SMS-CSIP>
					</c:set>
					<c:url value="${initParam.smsCsipBaseUrl}/Query" var="mapreq">
						<c:param name="Query" value="${queryformap}"/>
					</c:url>	
						
					<c:import url="${mapreq}" var="xmlMapResponse" charEncoding="UTF-8" />
					<!-- change the & to &amp; -->
					<c:set var="xmlMapResponse" value="${fn:replace( xmlMapResponse, '&' , '&amp;')}"/>
					<x:transform xslt="${f:removeNamespacesXsl()}" xml="${xmlMapResponse}" var="testdocmap"/>
				
					<c:set var="looked_up_sms_map_name"><x:out select="$testdocmap//SMS/Record/itemRecord/Data/FullText" /></c:set>
					<c:set var="looked_up_sms_map_id">${inmap}</c:set>
				</c:if>
				<a href='?id=${relationId}&bm=${bmid}'>${strandname} (in ${looked_up_sms_map_name})</a>, 
			</c:when>
			<c:when test="${inmap eq sms_map_id}">
				<a href='?id=${relationId}&bm=${bmid}'>${strandname}</a>, 
			</c:when>
		</c:choose>
	</x:forEach>
</c:set>
<% pageContext.setAttribute("newLineChar", "\n"); %>
<% pageContext.setAttribute("tabChar", "\t"); %>
<c:set var="relmapcontent" value="${fn:replace(relmapcontent, tabChar, '')}"/>
<c:set var="relmapcontent" value="${fn:replace(relmapcontent, newLineChar, '')}"/>

<c:set var="stringLength" value='${fn:length(relmapcontent)}'/>
<c:set var="relmapcontent" value="${fn:substring(relmapcontent, 0,stringLength-1)}"/>

saveBenchmarkStrands(
	<json:object prettyPrint="true" escapeXml="false">
	 	<json:property name="content" value="${relmapcontent}"/>
	</json:object>
)