<%@ include file="/jsapi/TagLibIncludes.jsp" %>
<%-- The maximum character length of the description that gets displayed in the initial search results. 
		A smaller value here will make the search results page more compact. Leave blank to 
		display the full description text regardles off its length --%>
<c:set var="maxDescriptionLength" value="150" />
<%-- The maximum character length of the URL that gets displayed in the UI. A smaller
		value here will prevent problems with HTML wrapping --%>
<c:set var="maxUrlLength" value="85" />
<%-- Store the base URL to the service to use in the request below --%>
<c:set var="baseUrl" value="@LOCAL_CONTEXT_URL@/Query" />
<c:set var="queryformaps">
<SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<Query Color="skyblue" DetailLevel="Skeleton" Format="SMS" Scope="Map" ThirdPartyQuery="DLESE XML">
		<Content-Query>
		</Content-Query>
	</Query>
</SMS-CSIP>
</c:set>


<c:url value="${baseUrl}" var="req">
         <c:param name="Query" value="${queryformaps}"/>
</c:url>

<c:import url="${req}" var="xmlResponse" charEncoding="UTF-8" />

<!-- change the & to &amp; -->
<c:set var="newresponse" value="${fn:replace( xmlResponse, '&' ,'&amp;')}"/>


<x:transform xslt="${f:removeNamespacesXsl()}" xml="${newresponse}" var="testdoc"/>


<x:forEach select="$testdoc//itemRecord">
	<c:set var="bmName">
		<x:out select="Data/Name"/>
	</c:set>
	<c:set var="bmId">
		<x:out select="Admin/IDNumber"/>
	</c:set>
	<a href="@GLOBAL_CONTEXT_URL@/jsapi_client/?id=${bmId}">${bmName}</a><br/>
</x:forEach>








