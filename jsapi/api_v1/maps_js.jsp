<%@ page contentType="text/javascript" %><%@ include file="/jsapi/TagLibIncludes.jsp" %>
<jsp:useBean id="dataAccessBean" class="edu.cu.cs.sms.Database.DataAccessBean" scope="session" />
<%-- Create a HashMap to cache the responses once they have been generated, keyed by page params --%>
<%@ page import="java.util.*, java.lang.*" %>
<%
	if(getServletContext().getAttribute("jsServiceCache") == null ) 
		getServletContext().setAttribute("jsServiceCache",new java.util.HashMap());
%>
<c:set var="cacheKey" value="${pageContext.request.queryString}"/>

<c:if test="${param.keyword != null || empty applicationScope.jsServiceCache[cacheKey] || param.reload == 'true'}">
	<c:set var="fullContent">
		<c:choose>
			<%-- If id is present, display the map --%>
			<c:when test="${not empty param.id}">
				<c:set property="oid" target="${dataAccessBean}" value="${param.id}"/>
				var parentJson = ${dataAccessBean.parentJson};
				var grandparentJson = ${dataAccessBean.grandparentJson};
				var greatgrandparentJson = ${dataAccessBean.greatgrandparentJson};
				<c:choose>
					<c:when test="${param.view == 'print'}">
						<c:set var="mapHtml"><%@ include file="interactive_map/interactive_map_print.jsp" %></c:set>
						<c:if test="${not empty param.bm}">
							<c:url value="@LOCAL_CONTEXT_URL@/jsapi/json" var="jsonUrl">
								<c:param name="Format" value="SVG-JSON"/>
								<c:param name="ObjectID" value="${param.bm}"/>
							</c:url>
							<c:import url="${jsonUrl}" var="bmSvgJson" />		
							var bmSvgJson = ${bmSvgJson};
						</c:if>				
					</c:when>
					<c:otherwise>
						<c:set var="mapHtml"><%@ include file="interactive_map/interactive_map.jsp" %></c:set>
					</c:otherwise>
				</c:choose>
			</c:when>
			<c:when test="${param.keyword != null || ((param.chapter != null && param.chapter != '' ) && param.id == null)}">
				<c:set var="mapHtml"><%@ include file="map_list/index.jsp" %></c:set>
			</c:when>	
			<c:otherwise>
				<c:set var="mapHtml" value=""/>
			</c:otherwise>
		</c:choose>
		<c:set var="strandSelectorHtml"><%@ include file="strand_selector/index.jsp" %></c:set>
		<c:set var="strandSelectorHtmlMulti"><%@ include file="strand_selector/index_multiselect.jsp" %></c:set>
		<c:set var="mapSvgJson"><%@ include file="strand_selector/index.jsp" %></c:set>
		<c:if test="${not empty param.id}">
			
			<%-- Store the CSIP SMS itemRecord JSON for this map of form {"itemRecord":{"Data": ... }} --%>
			<c:url value="@LOCAL_CONTEXT_URL@/jsapi/json" var="jsonUrl">
				<c:param name="Format" value="SMS-JSON"/>
				<c:param name="ObjectID" value="${param.id}"/>
				<c:param name="DetailLevel" value="Detailed"/>
			</c:url>
			<c:import url="${jsonUrl}" var="_mapSmsJson" />
			var _mapSmsJson = ${sf:jsonStringAt(_mapSmsJson,'SMS-CSIP.QueryResponse.SMS.Record')};
			
			<%--
			// The following is an example of using the json JSTL EL tags:
			var myTest = ${sf:jsonStringAt(_mapSmsJson,"SMS-CSIP.QueryResponse.SMS")};
			var pIds = '';
			<c:forEach var="myJson" varStatus="i" items='${sf:jsonListAt(_mapSmsJson,"SMS-CSIP.QueryResponse.SMS.Record.itemRecord.Data.InternalRelationship.CatalogID")}'>
				var catId = ${myJson};
				pIds = pIds + ' ' + catId.CatalogNumber;
			</c:forEach>
			alert("My parent IDs are: " + pIds); 
			--%>
			
			<c:set var="conceptSize" value="4"/>
			<%-- Store the svg JSON for this map of form {"svg":{ ... }} --%>
			<c:url value="@LOCAL_CONTEXT_URL@/jsapi/json" var="jsonUrl">
				<c:param name="Format" value="SVG-JSON"/>
				<c:param name="ConceptSize" value="${conceptSize}"/>
				<c:param name="ObjectID" value="${param.id}"/>
			</c:url>
			<c:import url="${jsonUrl}" var="mapSvgJson" />
			var conceptSize = ${conceptSize};	
			var mapSvgJson = ${mapSvgJson};
		
			<%-- Store a JSON object that holds the CSIP SMS itemRecords for each benchmark in this map of form {"SMS-BMK-1702":{"itemRecord": ... }} --%>
			<c:set var="bmJson" value="{"/>
			<c:forEach var="myJson" varStatus="i" items='${sf:jsonListAt(mapSvgJson,"svg.g.g")}'>
				<c:set var="bmId" value="${sf:jsonStringAt(myJson,'OID')}"/>
		
				<c:url value="@LOCAL_CONTEXT_URL@/jsapi/json" var="jsonUrl">
					<c:param name="Format" value="SMS-JSON"/>
					<c:param name="ObjectID" value="${bmId}"/>
					<c:param name="DetailLevel" value="Detailed"/>
				</c:url>
				<c:import url="${jsonUrl}" var="bmSmsJson" />
				
				<c:set var="bmJson">${bmJson}"${bmId}":${sf:jsonStringAt(bmSmsJson,'SMS-CSIP.QueryResponse.SMS.Record')}${i.last?'}':','}</c:set>
			</c:forEach>
			var mapBenchmarksJson = ${bmJson};
			
		</c:if>
		<c:if test="${not empty param.algo}">
			<c:set var="searchAlgo" scope="session" value="${param.algo}"/>
		</c:if>
		
		var mapHtml = '${f:jsEncode(mapHtml)}';
		var strandSelectorHtml = '${f:jsEncode(strandSelectorHtml)}';
		var strandSelectorHtmlMulti = '${f:jsEncode(strandSelectorHtmlMulti)}';
		<%-- <%@ include file="/jsapi/lib/zxml.js" %>
		<%@ include file="/jsapi/lib/browser.js" %>
		<%@ include file="/jsapi/lib/prototype_1.5.1.1.js" %>
		<%@ include file="/jsapi/lib/scriptaculous_1.7.1_b3/effects.js" %> 
		<%@ include file="interactive_map/strand_map_implementation.js" %>
		<%@ include file="interactive_map/strand_map_public_js_api.js" %>
		<%@ include file="interactive_map/call_out_widget.js" %>
		<%@ include file="strand_selector/strand_selector.js" %>--%>
	</c:set>
	<c:choose>
		<c:when test="${param.keyword != null}">
			<%-- Output the page if keyword search --%>
			${fullContent}
		</c:when>
		<c:otherwise>
			<%-- Save the content in the cache --%>
			<c:set var="cacheKey" value="${fn:replace(cacheKey,'&reload=true','')}"/>
			<c:set var="cacheKey" value="${fn:replace(cacheKey,'reload=true&','')}"/>
			<c:set var="cacheKey" value="${fn:replace(cacheKey,'reload=true','')}"/>
			<c:set target="${applicationScope.jsServiceCache}" property="${cacheKey}" value="${fullContent}"/>
		</c:otherwise>
	</c:choose>
</c:if>
<c:if test="${param.keyword == null}">
	<%-- Output the page content --%>
	${applicationScope.jsServiceCache[cacheKey]}
</c:if>
