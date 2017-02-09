<%@ page language="java" contentType="application/json; charset=UTF-8" %>
<%@ include file="../../TagLibIncludes.jsp" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%-- Grab the required service URLs (defined in web.xml or server.xml): --%>
<c:set var="nsdlSearchBaseUrl" value="${initParam.nsdlSearchBaseUrl}" />
<c:set var="httpUserAgentJavaScriptAPI" value="${initParam.httpUserAgentJavaScriptAPI}" />
		
<%
String bmIds = request.getParameter("bmIds");
String AAASCode = request.getParameter("AAASCode");
String displaytype = request.getParameter("displaytype");
String collections = request.getParameter("collections");
%>
<c:set var="bmIds" value="<%=bmIds%>"/>
<c:set var="collections" value="<%=collections%>"/>
<c:set var="AAASCode" value="<%=AAASCode%>"/>

<c:set var="excludeCollections" value='ky:("2063768")' />
<c:set var="includeCollections" value='' />

<c:set var="bmFull" value=""/>
<c:set var="asns" value=""/>
<c:set var="keywords" value=""/>

<c:set var="smsCollections" value=""/>
<c:forTokens var="coll" items="${collections}" delims="|">
<c:choose>
	<c:when test="${empty smsCollections}">
		<c:set var="smsCollections">"${coll}"</c:set>
	</c:when>
	<c:otherwise>
		<c:set var="smsCollections">${smsCollections} OR "${coll}"</c:set>
	</c:otherwise>
</c:choose>	
</c:forTokens>
<c:if test="${not empty smsCollections}">
	<c:set var="includeCollections" value=' AND ky:(${smsCollections})' />
</c:if>

<c:set var="resultJSON">
{
<c:forTokens var="bmId" items="${bmIds}" delims="|" varStatus="loop">
	<c:set var="queryforbm">
	      <SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
		<Query Color="skyblue" DetailLevel="Detailed" Format="SMS" Scope="ALL" ThirdPartyQuery="">
			<Content-Query>
				<ObjectID><c:out value="${bmId}" /></ObjectID>
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
	<c:set var="isPartOf" value=""/>
	<x:forEach select="$testdoc//SMS/Record/itemRecord/Data/InternalRelationship/CatalogID[contains(@RelationType,'is part of')]/@CatalogNumber">
		<c:if test="${not empty isPartOf}">
			<c:set var="isPartOf" value="${isPartOf},"/>
		</c:if>

		<c:set var="isPartOf">${isPartOf}"<x:out select="." />"</c:set>
		
	</x:forEach>

	<x:forEach select="$testdoc//SMS/Record/itemRecord/Data/FullText">
		<c:set var="bmFullText"><x:out select="." /></c:set>
	</x:forEach>
	<c:set var="bmFullText" value="${bmFullText}"/>
	
	<c:set var='bmFull' value=''/>
	<c:forTokens var="bmParts" items="${bmFullText}" delims=".">
		<c:choose>
		<c:when test="${empty bmFull}">
			<c:set var='bmFull' value='"${bmParts}"'/>
		</c:when>
		<c:otherwise>
			<c:set var="bmFull">
				${bmFull} OR "${bmParts}"
			</c:set>
		</c:otherwise>
		</c:choose>
	</c:forTokens>

	<c:set var="asns" value=""/>
	<%-- get the asn ids --%>
	<x:if select="$testdoc//SMS/Record/itemRecord/Data/ASNIDs/ASNID">
		<x:forEach select="$testdoc//SMS/Record/itemRecord/Data/ASNIDs/ASNID">
			<c:set var="testasn"><x:out select="@ASNNumber" /></c:set>
			<c:choose>
				<c:when test="${not empty testasn}">
					<c:choose>
						<c:when test="${empty ASNID}">
							<c:set var="asns">
								"http://purl.org/ASN/resources/${testasn}" OR "http://asn.jesandco.org/resources/${testasn}"
							</c:set>
						</c:when>
						<c:otherwise>
							<c:set var="asns">
								${asns} OR "http://purl.org/ASN/resources/${testasn}" OR "http://asn.jesandco.org/resources/${testasn}"
							</c:set>
						</c:otherwise>
					</c:choose>	
				</c:when>
			</c:choose>
		</x:forEach>
	</x:if>
	<%-- END get the asn ids --%>
	
	<c:set var="keywords" value=""/>
	
	<%-- get the benchmark keywords --%>
	<x:forEach select="$testdoc//SMS/Record/itemRecord/Data/Keywords/keyword">
		<c:choose>
			<c:when test="${empty keywords}">
				<c:set var="keywords">
					"<x:out select="." />"
				</c:set>
			</c:when>
			<c:otherwise>
				<c:set var="keywords">
					${keywords} OR "<x:out select="." />"
				</c:set>
			</c:otherwise>
		</c:choose>	
	</x:forEach>
	<%-- END get the benchmark keywords --%>


	<c:set var="AAASCode"> 
		<x:out select="$testdoc//SMS/Record/itemRecord/Data/AAASCode"/> 
	</c:set> 

	<c:choose>
		<c:when test="${not empty asns}">
			<c:set var="standards_list">${bmFull} OR "${bmId}" OR ${asns} OR ("AAAS" AND ("${AAASCode}"))</c:set>
		</c:when>
		<c:otherwise>
			<c:set var="standards_list">${bmFull} OR "${bmId}" OR ("AAAS" AND ("${AAASCode}"))</c:set>
		</c:otherwise>
	</c:choose>
	
	
	<c:set var="text_list">(${keywords}) OR stems:(${keywords}) OR title:(${keywords})^15 OR titlestems:(${keywords}) OR description:(${keywords})^5 OR descriptionstems:(${keywords})</c:set>
	
	
	<%--c:set var="query" value='(xmlFormat:nsdl_dc AND (/relation.isAnnotatedBy//key//comm_anno/ASNstandard:(${standards_list}) OR /key//nsdl_dc/conformsTo:(${standards_list})) AND ((${text_list}) )) ${includeCollections} NOT ${excludeCollections}'/ --%>
	<c:set var="query" value='(xmlFormat:nsdl_dc AND (${standards_list}) AND ((${text_list}) )) ${includeCollections} NOT ${excludeCollections}'/>
	
	<c:set var="numResults" value="?"/> 
		
			
	<%-- Issue the request to the web service. If a connection error occurs, store it in variable 'serviceError' --%>
	<c:catch var="serviceError"> 
		<%-- Construct the http request to send to the web service and store it in variable 'webServiceRequest' --%>
		<c:url value="${nsdlSearchBaseUrl}" var="webServiceRequest"> 
			<%-- Define each of the http parameters used in the request --%>
			<c:param name="verb" value="Search"/> 
			<%-- Begin the result at the current offset --%>
			<c:param name="s" value="0"/> 
			<c:param name="n" value="0"/> 
			<%-- Perform a textual search using the user's input --%>
			<c:param name="q" value="${query}"/> 
			<%-- remove namespaces --%>
			<c:param name="transform" value="localize"/> 
			<%-- include collection info --%>
			<c:param name="response" value="allCollectionsMetadata"/> 
			<%-- retrieve only nsdl_dc records --%>
			<c:param name="xmlFormat" value="nsdl_dc"/> 
		</c:url> 
		<x:parse var="xmlDom">${f:timedImportUsingEncodingAgent(webServiceRequest, "UTF-8", 6000, httpUserAgentJavaScriptAPI)}</x:parse>
		<c:set var="numResults"> 
			<x:out select="$xmlDom/DDSWebService/Search/resultInfo/totalNumResults"/> 
		</c:set> 
	</c:catch> 
	<c:if test="${empty numResults}">
		<c:set var="numResults" value="0"/> 
	</c:if>
"${bmId}":{"nsdlResourcesAligned":${numResults},"isPartOf":[${isPartOf}]}<c:if test='${!loop.last}'>,</c:if>

</c:forTokens>
}
</c:set>
<% pageContext.setAttribute("newLineChar", "\n"); %>
<% pageContext.setAttribute("tabChar", "\t"); %>
<c:set var="resultJSON" value="${fn:replace(resultJSON, tabChar, '')}"/>
<c:set var="resultJSON" value="${fn:replace(resultJSON, newLineChar, '')}"/>
${resultJSON}