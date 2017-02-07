<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="../../TagLibIncludes.jsp" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%-- Grab the required service URLs (defined in web.xml or server.xml): --%>
<c:set var="smsCsipBaseUrl" value="${initParam.smsCsipBaseUrl}" />
<c:set var="nsdlSearchBaseUrl" value="${initParam.nsdlSearchBaseUrl}" />
<c:set var="httpUserAgentJavaScriptAPI" value="${initParam.httpUserAgentJavaScriptAPI}" />
		
<%
String startingOffset = request.getParameter("offset");

String bmId = request.getParameter("bmId");
String map = request.getParameter("mapId");
String AAASCode = request.getParameter("AAASCode");
String displaytype = request.getParameter("displaytype");
String collections = request.getParameter("collections");
%>

<c:set var="displaytype" value="<%=displaytype%>"/>


<c:set var="startingOffset" value="<%=startingOffset%>"/>

<c:set var="bmId" value="<%=bmId%>"/>
<c:set var="map" value="<%=map%>"/>
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
<!-- change the & to &amp; -->
<c:set var="newresponse" value="${fn:replace( xmlResponse, '&' , '&amp;')}"/>
<x:transform xslt="${f:removeNamespacesXsl()}" xml="${newresponse}" var="testdoc"/>

<x:forEach select="$testdoc//SMS/Record/itemRecord/Data/FullText">
	<c:set var="bmFullText"><x:out select="." /></c:set>
</x:forEach>
<c:set var="bmFullText" value="${bmFullText}"/>
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

<c:set var="nsdlAlignedResults">

<%-- The maximum character length of the description that gets displayed in the initial search results. 
		A smaller value here will make the search results page more compact. Leave blank to 
		display the full description text regardles off its length --%>
<c:set var="maxDescriptionLength" value="400" />
<c:set var="maxTitleLength" value="80" />
<%-- The maximum character length of the URL that gets displayed in the UI. A smaller
		value here will prevent problems with HTML wrapping --%>
<c:set var="maxUrlLength" value="85" />
<%-- Set up the variables used for paging through results--%>
<c:set var="startingOffset"> 
	<c:if test="${empty startingOffset}">0</c:if> 
	<c:if test="${!empty startingOffset}"><c:out value="${startingOffset}"/></c:if> 
</c:set>
<%-- Issue the request to the web service. If a connection error occurs, store it in variable 'serviceError' --%>
<c:catch var="serviceError"> 
	<%-- Construct the http request to send to the web service and store it in variable 'webServiceRequest' --%>
	<c:url value="${nsdlSearchBaseUrl}" var="webServiceRequest"> 
		<%-- Define each of the http parameters used in the request --%>
		<c:param name="verb" value="Search"/> 
		<%-- Begin the result at the current offset --%>
		<c:param name="s" value="${startingOffset}"/> 
		<c:param name="n" value="5"/>
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

	<c:if test="${not empty serviceError}"> Sorry, our system has encountered a problem and we were unable to perform your search at this time. Please try again later. </c:if> 
	<%-- Display the record metadata to the user (if no connection error occured) --%>
	<c:if test="${empty serviceError}"> 
		<x:choose> 

				<%-- If the total number of results is greater than zero, display them --%>
				<x:when select="$xmlDom/DDSWebService/Search/resultInfo/totalNumResults > 0"> 
				<span style="display:none;">
<c:out value="${query}"/></span>
					<%-- ------ Begin paging logic ------ --%>
					<%-- Save the number of results in variable 'numResults' --%>
					<c:set var="numResults"> 
						<x:out select="$xmlDom/DDSWebService/Search/resultInfo/totalNumResults"/> 
					</c:set> 
					<c:choose>
						<c:when test="${numResults > 5}">
							<p>Results 1 - 5 out of 5</p>
						</c:when>
						<c:otherwise>
							<p>Results 1 - <c:out value="${numResults}"/> out of <c:out value="${numResults}"/></p>
						</c:otherwise>
					</c:choose>
					<div id="resourceList">		
						<c:set var="mySectionIndex">
							itemIndex<c:out value="${section}"/>
						</c:set>
						<span id="${mySectionIndex}" class="navIndex">${pager}</span>
						<%-- Render a gray line --%>
						<hr/>
						<%-- Loop through each of the record nodes --%>
						<c:set var="resourcePosition">0</c:set>
						<x:forEach select="$xmlDom/DDSWebService/Search/results/record"> 
						<%-- We are already at XPath $xmlDom/DDSWebService/Search/results/record
						so we can continue our path from there --%>
						<c:set var="resourceURL">
							<x:out select="metadata/nsdl_dc//identifier[@type='dct:URI']"/>
						</c:set>
						<c:set var="resourceTitle">
							<x:out select="metadata/nsdl_dc/title"/>
						</c:set>
						
						<c:set var="description">
							<x:out select="metadata/nsdl_dc/description"/> 
						</c:set>
						
						<c:set var="audience">
							<x:out select="metadata/nsdl_dc/educationLevel"/>
						</c:set>
						
						<c:set var="collectionId" value="" />
						<x:forEach select="allCollectionsMetadata/collectionMetadata/collectionRecord/additionalMetadata/ncsCollectionRecord/head/additionalMetadata/collection_info">
							<c:choose>
								<c:when test="${empty collectionId}">
									<c:set var="collectionId"><x:out select="setSpec"/></c:set>
								</c:when>
								<c:otherwise>
									<c:set var="nsdlId"><x:out select="setSpec"/></c:set>
									<c:if test="${fn:contains(collectionId,nsdlId) eq false}">
										<c:set var="collectionId">${collectionId}|${nsdlId}</c:set>
									</c:if>
								</c:otherwise>
							</c:choose>		
							
						</x:forEach>
						<c:set var="gaTrackURL">
							/open_resource/tab/top_picks/${map}/${bmId}/
						</c:set>
						<c:set var="shortResURL">
							${fn:replace(resourceURL,'http://','')}
						</c:set>
						
						<p class="resource, stdlink" id="resourceItem">
							<div class="resourceTitle">
								<c:if test="${not empty maxTitleLength && fn:length(resourceTitle) > maxTitleLength}">	
									<%-- Make sure the truncation occurs on white space and not in the middle of a word --%>
										<c:set var="numChars" value="0"/>
										<c:set var="resourceTitle">	
											<c:set var="words" value="${fn:split( resourceTitle, ' ')}"/>
												<c:forEach items="${words}" var="word">
													<c:if test="${numChars < maxTitleLength}">
														${word} 
														<c:set var="numChars" value="${numChars + fn:length( word ) + 1}"/>
													</c:if>
												</c:forEach> 
												...
											</c:set>
										</c:if>	
									<a href='${resourceURL}' target="_blank" class="boldlink" onclick="sendToGoogleTracker('gaTrackResource', '${gaTrackURL}', '','${collectionId}','${shortResURL}','${resourcePosition}');">${resourceTitle}</a>
								</div>
								
								<div class="resourceUrl">
									<c:choose>
										<c:when test="${ fn:length(resourceURL) > maxUrlLength }">
											<a href="${resourceURL}" target="_blank" onclick="sendToGoogleTracker('gaTrackResource', '${gaTrackURL}', '','${collectionId}','${shortResURL}','${resourcePosition}');">${fn:substring(resourceURL,0,maxUrlLength)} ...</a>	
										</c:when>
										<c:otherwise>
											<a href="${resourceURL}" target="_blank" onclick="sendToGoogleTracker('gaTrackResource', '${gaTrackURL}', '','${collectionId}','${shortResURL}','${resourcePosition}');">${resourceURL}</a>
										</c:otherwise>
									</c:choose>
								</div>
								<div class="resourceDescription"> 
									<%-- Truncate the description text if necessary --%>
									<c:if test="${not empty maxDescriptionLength && fn:length(description) > maxDescriptionLength}">	
										<%-- Make sure the truncation occurs on white space and not in the middle of a word --%>
										<c:set var="numChars" value="0"/>
										<c:set var="description">	
											<c:set var="words" value="${fn:split( description, ' ')}"/>
											<c:forEach items="${words}" var="word">
												<c:if test="${numChars < maxDescriptionLength}">
													${word} 
													<c:set var="numChars" value="${numChars + fn:length( word ) + 1}"/>
												</c:if>
											</c:forEach> 
											...
										</c:set>
									</c:if>	
									${description}
								</div>
							</p>
							<hr />
							<c:set var="resourcePosition" value="${resourcePosition + 1}"></c:set>
						</x:forEach> 
						<span id="${mySectionIndex}" class="navIndex">${pager}</span>
					</div>
				</x:when> 
				<%-- If there were no matches, report to user --%>
				<x:otherwise> 
				</x:otherwise>	
			</x:choose> 

		</c:if> 
	</c:catch> 

	</c:set>

	displayAlignedRes(
	<json:object prettyPrint="true" escapeXml="false">
	 	<json:property name="nsdlRes" value="${nsdlAlignedResults}"/>
		<json:property name="displaytype" value="${displaytype}"/>
	</json:object>
)