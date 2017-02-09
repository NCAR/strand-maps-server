<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="../../TagLibIncludes.jsp" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%-- Grab the required service URLs (defined in web.xml or server.xml): --%>
<c:set var="smsCsipBaseUrl" value="${initParam.smsCsipBaseUrl}" />
<c:set var="nsdlSearchBaseUrl" value="${initParam.nsdlSearchBaseUrl}" />
<c:set var="httpUserAgentJavaScriptAPI" value="${initParam.httpUserAgentJavaScriptAPI}" />
		
<%
String startingOffset = request.getParameter("startingOffset");
String pagerPage = request.getParameter("page");
String maxTotalResults = request.getParameter("maxTotalResults");
String maxPerPage = request.getParameter("maxPerPage");

String bmId = request.getParameter("bmId");
String map = request.getParameter("mapId");
String AAASCode = request.getParameter("AAASCode");
String displaytype = request.getParameter("displaytype");
String collections = request.getParameter("collections");
String callback = request.getParameter("callback");
String callingFunction = request.getParameter("callingFunction");
%>

<c:set var="displaytype" value="<%=displaytype%>"/>

<c:set var="callback" value="<%=callback%>"/>
<c:set var="callingFunction" value="<%=callingFunction%>"/>
<c:set var="startingOffset" value="<%=startingOffset%>"/>
<c:set var="pagerPage" value="<%=pagerPage%>"/>
<c:set var="maxPerPage" value="<%=maxPerPage%>"/>

<c:if test="${empty startingOffset}">
	<c:set var="startingOffset" value="0"/>
</c:if>

<c:if test="${empty pagerPage}">
	<c:set var="pagerPage" value="1"/>
</c:if>

<c:if test="${empty maxPerPage}">
	<c:set var="maxPerPage" value="5"/>
</c:if>

<c:set var="maxTotalResults" value="<%=maxTotalResults%>"/>

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


<c:set var="query" value='(xmlFormat:nsdl_dc AND (${standards_list}) AND ((${text_list}) )) ${includeCollections} NOT ${excludeCollections}'/>


<c:set var="nsdlRelatedResults">
<%-- The maximum character length of the description that gets displayed in the initial search results. 
		A smaller value here will make the search results page more compact. Leave blank to 
		display the full description text regardles off its length --%>
<c:set var="maxDescriptionLength" value="400" />
<c:set var="maxTitleLength" value="90" />
<%-- The maximum character length of the URL that gets displayed in the UI. A smaller
		value here will prevent problems with HTML wrapping --%>
<c:set var="maxUrlLength" value="85" />
<%-- Set up the variables used for paging through results--%>

<c:set var="offset" value="${startingOffset +(pagerPage * maxPerPage) - maxPerPage}"/>

<%-- Issue the request to the web service. If a connection error occurs, store it in variable 'serviceError' --%>
<c:catch var="serviceError"> 
	<%-- Construct the http request to send to the web service and store it in variable 'webServiceRequest' --%>
	<c:url value="${nsdlSearchBaseUrl}" var="webServiceRequest"> 
		<%-- Define each of the http parameters used in the request --%>
		<c:param name="verb" value="Search"/> 
		<%-- Begin the result at the current offset --%>
		<c:param name="s" value="${offset}"/> 
		<%-- Return ${maxPerPage} results --%>
		<c:param name="n" value="${maxPerPage}"/> 
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

	<%-- Display the record metadata to the user (if no connection error occured) --%>
	<c:if test="${empty serviceError}"> 
			<%-- If the total number of results is greater than five, display them --%>
			<%-- ------ Begin paging logic ------ --%>
			<%-- Save the number of results in variable 'numResults' --%>
			<c:set var="numResults"> 
				<x:out select="$xmlDom/DDSWebService/Search/resultInfo/totalNumResults"/> 
			</c:set> 
			
			<!--  make altercations do to the fact of offset -->
			<c:set var="numResults" value="${numResults-startingOffset}"/> 
			<c:if test="${not empty maxTotalResults and numResults>maxTotalResults}">
				<c:set var="numResults" value="${maxTotalResults}"/>
			</c:if>
			<c:set var="offset" value="${offset-startingOffset}"/> 

			
			<c:if test="${numResults>0 and offset<numResults}">
				<c:set var="offsetDiff" value="${numResults-offset }"/>
				<c:choose>
					<c:when test="${not empty maxTotalResults and offsetDiff<maxPerPage}">
						<c:set var="numRecordsToShow" value="${offsetDiff}"/>
					</c:when>
					<c:otherwise>
						<c:set var="numRecordsToShow" value="${maxPerPage}"/>
					</c:otherwise>
				</c:choose>
				
				<span style="display:none;">
					<c:out value="${query}"/></span>
					
					
					<c:set var="pageIndex"> 
					<%-- Create and store the HTML for the pager in variable 'pager' --%>
					
						<p><nobr> ${numResults > 1 ? 'Results':'Result'} 
						<c:out value="${offset + 1}"/> - 
						<c:choose>
							<c:when test="${offset + maxPerPage<=numResults}">
								<c:out value="${offset + maxPerPage}"/> 
							</c:when>
							<c:otherwise>
								<c:out value="${numResults}"/> 
							</c:otherwise>
						</c:choose>
						
						

						</nobr> 
						<nobr>out of <span id="numResults${callback}">
						
						<c:out value="${numResults}"/>
	
						</span></nobr> </p>
						
						<c:set var="page_prev"> 
							${pagerPage - 1}
						</c:set>
						<c:set var="page_next"> 
							${pagerPage + 1}
						</c:set>
						
						<c:if test="${pagerPage > 1 && param.view != 'print'}"> 
							<a href="javascript:StrandMap.${callingFunction}(${page_prev},'${displaytype}')"  onclick="sendToGoogleTracker('resPagerTrack', '/content_click/tab/related_resources/${map}/${bmId}/page_${page_prev}_${startingOffset-1}/','page_${page_prev}_${startingOffset-1}','','','');">&lt;&lt; Prev</a> &nbsp;
						</c:if> 
						<!--//The total number of pages we can display based on the number of search results//-->
						<c:set var="total_pages_full">${(numResults) div maxPerPage}</c:set>
						<c:set value="${fn:substringBefore(total_pages_full,'.')}" var="total_pages" />
						<c:set var="total_pages_fraction">${fn:substringAfter(total_pages_full,'.')}</c:set>
						<c:set var="total_pages_integer">${fn:substringBefore(total_pages_full,'.')}</c:set>
						<c:if test="${(total_pages_fraction > 0) && (total_pages_integer > 0)}">
							<c:set var="total_pages">${total_pages + 1}</c:set>
						</c:if>
						<!--//The result page we are currently on (add 1 to it)//-->
						<c:set var="current_page">${pagerPage}</c:set>
						<!--// The number of page links we want to display in the pagination nav //-->
						<c:set var="set_page_display">11</c:set>
						<!--// Skip to this page number based on the page we're on //-->
						<c:set var="start_page">${current_page - (fn:substringBefore((set_page_display div 2), '.') + 1)}</c:set>
						<c:choose>
							<c:when test="${(total_pages > (set_page_display - 1)) && (current_page > (set_page_display/2))}">
								<c:set var="end_page">${current_page + fn:substringBefore(((set_page_display/2) - 1), '.')}</c:set>
							</c:when>
							<c:when test="${total_pages < (set_page_display - 1)}">
								<c:set var="end_page">${total_pages}</c:set>
							</c:when>
							<c:otherwise>
								<c:set var="end_page">${set_page_display - 1}</c:set>
							</c:otherwise>
						</c:choose>
					
						<c:choose>
							<c:when test="${start_page < 1}">
								<c:set var="start_page">1</c:set>
							</c:when>
							<c:when test="${end_page ge set_page_display}">
								<c:set var="start_page">${start_page + 1}</c:set>
							</c:when>
							<c:otherwise>
								<c:set var="start_page">${start_page}</c:set>
							</c:otherwise>
						</c:choose>
						<c:if test="${end_page ge total_pages}">
							<c:set var="end_page">${total_pages}</c:set>
						</c:if>
						<c:if test="${current_page >= 6}">
							<c:choose>
								<c:when test="${current_page >= 7}">
									<a href="javascript:StrandMap.${callingFunction}(1,'${displaytype}')" onclick="sendToGoogleTracker('resPagerTrack', '/content_click/tab/related_resources/${map}/${bmId}/page_0_4/','page_0_4','','','');">1</a>...
								</c:when>
							</c:choose>
						</c:if>
						<c:if test="${total_pages > 1}">
							<c:forEach var="i" begin="${start_page}" end="${end_page}" varStatus="status">
								<c:choose>
									<c:when test="${i == current_page}">
										<strong>${i}</strong>&nbsp;
									</c:when>
									<c:otherwise>
										<c:set var="next_skip">${i}</c:set>
										<a href="javascript:StrandMap.${callingFunction}(${next_skip},'${displaytype}')" onclick="sendToGoogleTracker('resPagerTrack', '/content_click/tab/related_resources/${map}/${bmId}/page_${next_skip}_${next_skip+4}/','page_${next_skip}_${next_skip+4}', '', '', '');">${i}</a>&nbsp;
									</c:otherwise>
								</c:choose>
							</c:forEach>
						</c:if>
						<c:if test="${(current_page < (total_pages - maxPerPage)) && (total_pages > (set_page_display - 1))}">
							...<a href="javascript:StrandMap.${callingFunction}(${total_pages},'${displaytype}')" onclick="sendToGoogleTracker('resPagerTrack', '/content_click/tab/related_resources/${map}/${bmId}/page_${next_skip}_${next_skip+4}/','page_${next_skip}_${next_skip+4}','','','');">${total_pages}</a>&nbsp;
						</c:if>
						<c:if test="${(offset + maxPerPage) < numResults && param.view != 'print'}"> 
							<a href="javascript:StrandMap.${callingFunction}(${page_next},'${displaytype}')" onclick="sendToGoogleTracker('resPagerTrack', '/content_click/tab/related_resources/${map}/${bmId}/page_${page_next}_${page_next+4}/','page_${page_next}_${page_next+4}','','','');">Next &gt;&gt;</a> &nbsp;
						</c:if>
					</c:set>
					${pageIndex}
					<%-- ------ end paging logic ------ --%>
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
						
						<c:if test="${resourcePosition<numRecordsToShow}">
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
								/open_resource/tab/related_resources/${map}/${bmId}/
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
							</c:if>
						</x:forEach> 
						<span id="${mySectionIndex}" class="navIndex">${pager}</span>
					</div>
					
			</c:if>

		</c:if> 
	</c:catch> 
	<c:if test="${not empty serviceError}"> Sorry, our system has encountered a problem and we were unable to perform your search at this time. Please try again later. </c:if> 


	</c:set>
	<% pageContext.setAttribute("newLineChar", "\n"); %>
	<% pageContext.setAttribute("tabChar", "\t"); %>
	<c:set var="nsdlRelatedResults" value="${fn:replace(nsdlRelatedResults, tabChar, '')}"/>
	<c:set var="nsdlRelatedResults" value="${fn:replace(nsdlRelatedResults, newLineChar, '')}"/>

	${callback}(
	<json:object prettyPrint="true" escapeXml="false">
	 	<json:property name="nsdlRes" value="${nsdlRelatedResults}"/>
		<json:property name="displaytype" value="${displaytype}"/>
	</json:object>
)