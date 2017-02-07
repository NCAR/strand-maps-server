<%@ include file="/jsapi/TagLibIncludes.jsp" %>
<%
String startingOffset = request.getParameter("startingOffset");
String bm = request.getParameter("bmId");
String map = request.getParameter("mapId");
String mapName = request.getParameter("mapName");
%>

<c:set var="bm" value="<%=bm%>"/>
<c:set var="map" value="<%=map%>"/>
<c:set var="mapName" value="<%=mapName%>"/>
<c:set var="s" value="<%=startingOffset%>"/>
		

<%-- get search terms --%>
<c:set var="baseUrl" value="@LOCAL_CONTEXT_URL@/Query" /> 

<c:set var="queryforbm">
	<SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
		<Query Color="skyblue" Format="SMS" Scope="ALL" DetailLevel="Detailed" ThirdPartyQuery="DLESE XML">
			<Content-Query>
				<ObjectID><c:out value="${bm}" /></ObjectID>
			</Content-Query>
		</Query>
	</SMS-CSIP>
</c:set>
<c:url value="${baseUrl}" var="req">
	<c:param name="Query" value="${queryforbm}"/>
</c:url>
<c:import url="${req}" var="xmlResponse" charEncoding="UTF-8" />
<!-- change the & to &amp; -->
<c:set var="newresponse" value="${fn:replace( xmlResponse, '&' ,'&amp;')}"/>
<x:transform xslt="${f:removeNamespacesXsl()}" xml="${newresponse}" var="testdoc"/>

<%--single keywords--%>

<c:set var="number" value="0" />
<x:forEach select="$testdoc//keyword">
	<c:set var="number" value="${number + 1}" />
	<c:choose>
		<c:when test="${number == 1}">
			<c:set var="keywords">"<x:out select="." />"</c:set>
		</c:when>
		<c:when test="${number != 1}" >
			<c:set var="keywords">${keywords} OR "<x:out select="." />"</c:set>
		</c:when>
	</c:choose>
</x:forEach>
<%--single subjects--%>

<c:set var="number" value="1" />
<x:forEach select="$testdoc//Subject">
<%--
	<c:set var="number" value="${number + 1}" />
	--%>
	<c:set var="temp"><x:out select="." /></c:set>
	
	<c:if test="${fn:contains(temp,':')}">
		<c:set var="temp">${fn:substringAfter(temp,':')}</c:set>
	</c:if>
	
<c:choose>
		<c:when test="${fn:contains(subjects,temp)}">
		
		</c:when>
		<c:otherwise>
	<c:choose>
		<c:when test="${number == 1}">
			<c:set var="subjects">"${temp}"</c:set>
			<c:set var="number" value="${number + 1}" />
		</c:when>
		<c:when test="${number != 1}" >
			<c:set var="subjects">${subjects} OR "${temp}"</c:set>
			<c:set var="number" value="${number + 1}" />
		</c:when>
	</c:choose>
</c:otherwise>
</c:choose>
</x:forEach>
<!-- strand name and map name-->
<!-- get official map name //-->

<c:set var="queryformap">
<SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<Query Color="skyblue" DetailLevel="Detailed" Format="SMS" Scope="ALL" ThirdPartyQuery="">
		<Content-Query>
			<ObjectID><c:out value="${map}" /></ObjectID>
		</Content-Query>
	</Query>
</SMS-CSIP>
</c:set>
<c:url value="${baseUrl}" var="req">
	<c:param name="Query" value="${queryformap}"/>
</c:url>
<c:import url="${req}" var="xmlResponse" charEncoding="UTF-8" />
<!-- change the & to &amp; -->
<c:set var="newresponse" value="${fn:replace( xmlResponse, '&' ,'&amp;')}"/>
<x:transform xslt="${f:removeNamespacesXsl()}" xml="${newresponse}" var="mapdoc"/>
<c:set var="number" value="0" />
<x:forEach select="$mapdoc//keyword">
	<c:set var="number" value="${number + 1}" />
	<c:choose>
		<c:when test="${number == 1}">
			<c:set var="mapkeywords">"<x:out select="." />"</c:set>
		</c:when>
		<c:when test="${number != 1}" >
			<c:set var="mapkeywords">${mapkeywords} OR "<x:out select="." />"</c:set>
		</c:when>
	</c:choose>
</x:forEach>


<!-- strand id //-->
<c:set var="count" value="0" />
<x:choose>
	<x:when select="$testdoc//InternalRelationship">
		<x:forEach select="$testdoc//CatalogID">
			<c:set var="someid">
				<x:out select="@CatalogNumber" />
			</c:set>
			<c:choose>
				<c:when test="${fn:containsIgnoreCase(someid, 'STD')}">
					<c:set var="count" value="${count + 1}" />
				</c:when>
			</c:choose>
		</x:forEach>
	</x:when>
</x:choose>	

<c:set var="num" value="0" />
<x:choose>
	<x:when select="$testdoc//InternalRelationship">
		<x:forEach select="$testdoc//CatalogID">
			<c:set var="someid">
				<x:out select="@CatalogNumber" />
			</c:set>

			<c:choose>
				<c:when test="${fn:containsIgnoreCase(someid, 'STD')}">
					<c:set var="num" value="${num + 1}" />
					<c:set var="queryforstrand">
						<SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
							<Query Color="skyblue" Format="SMS" Scope="ALL" DetailLevel="Detailed" ThirdPartyQuery="DLESE XML">
								<Content-Query>
									<ObjectID>
										<c:out value="${someid}" />
									</ObjectID>
								</Content-Query>
							</Query>
						</SMS-CSIP>
					</c:set>
					<c:url value="${baseUrl}" var="reqstrand">
						<c:param name="Query" value="${queryforstrand}"/>
					</c:url>
					<c:import url="${reqstrand}" var="xmlResponseStrand" charEncoding="UTF-8" />
					<!-- change the & to &amp; -->
					<c:set var="newresponsestrand" value="${fn:replace( xmlResponseStrand, '&' , '&amp;')}"/>
					<x:transform xslt="${f:removeNamespacesXsl()}" xml="${newresponsestrand}" var="stranddoc"/>

					<c:set var="myStrand"><x:out select='$stranddoc//FullText' /></c:set>
					<c:set var="myStrand" value="${fn:toLowerCase(myStrand)}"/>
					
					<x:choose>
						<x:when select="$stranddoc//InternalRelationship">
							<x:forEach select="$stranddoc//CatalogID">
								<c:set var="somemapid">
									<x:out select="@CatalogNumber" />
								</c:set>
								<c:choose>
									<c:when test="${fn:containsIgnoreCase(somemapid, 'MAP')}">
										<!--// if same map id do it //-->
										<c:set var="keywordcount"><x:out select="count($stranddoc//keyword)"/></c:set>
										<c:if test="${somemapid == map}">
										
					
					<c:set var="number" value="0" />
							<x:forEach select="$stranddoc//keyword">
							<c:set var="number" value="${number + 1}" />
							<c:choose>
								<c:when test="${number == 1}">
									<c:choose>
									<c:when test="${not empty strandkeywords}">
										<c:set var="strandkeywords">${strandkeywords} OR "<x:out select="." />"</c:set>
									</c:when>
									<c:otherwise>
										<c:set var="strandkeywords">"<x:out select="." />"</c:set>
									</c:otherwise>
								</c:choose>
								</c:when>
								<c:when test="${number != 1}" >
									<c:set var="strandkeywords">${strandkeywords} OR "<x:out select="." />"</c:set>
								</c:when>
							</c:choose>
							</x:forEach>
</c:if>

										
									</c:when>
								</c:choose>
							</x:forEach>
						</x:when>
					</x:choose>		
				</c:when>	
			</c:choose>
		</x:forEach>
	</x:when>
</x:choose>

<%-- The maximum character length of the description that gets displayed in the initial search results. 
		A smaller value here will make the search results page more compact. Leave blank to 
		display the full description text regardles off its length --%>
<c:set var="maxDescriptionLength" value="400" />
<c:set var="maxTitleLength" value="90" />
<%-- The maximum character length of the URL that gets displayed in the UI. A smaller
		value here will prevent problems with HTML wrapping --%>
<c:set var="maxUrlLength" value="85" />
<%-- Store the base URL to the service to use in the request below --%>
<c:set var="ddswsBaseUrl" value="http://nsdl.org/dds-search"/> 
<c:if test="${not empty keywords}"> 
	<%-- Set up the variables used for paging through results--%>
	<c:set var="startingOffset"> 
		<c:if test="${empty s}">0</c:if> 
		<c:if test="${!empty s}"><c:out value="${s}"/></c:if> 
	</c:set> 

	<%--grade range--%>
<c:set var="number" value="0" />
<x:forEach select="$testdoc//GradeRange">
	<c:set var="number" value="${number + 1}" />
</x:forEach>
<c:set var="n2" value="0" />
<c:set var="grade">
<x:forEach select="$testdoc//GradeRange">
	<c:set var="n2" value="${n2 + 1}" />
	<c:choose>
		<c:when test="${n2 == 1}">
			<c:set var="testgrade">
				<x:out select="." />
			</c:set>
		</c:when>
	</c:choose>
</x:forEach>
</c:set>

		<c:if test="${testgrade == '9'}"><c:set var="audience" value='(/key//nsdl_dc/educationLevel:("High School")'/></c:if> 
		<c:if test="${testgrade == '6'}"><c:set var="audience" value='(/key//nsdl_dc/educationLevel:("Middle School")'/></c:if> 
		<c:if test="${testgrade == '3'}"><c:set var="audience" value='(/key//nsdl_dc/educationLevel:("Upper Elementary")'/></c:if> 
		<c:if test="${testgrade == 'K'}"><c:set var="audience" value='(/key//nsdl_dc/educationLevel:("Early Elementary")'/></c:if> 
	<!--//DON'T SHOW 
	Benchmark collection:2063768
	"oai:nsdl.org:crs:498742",	// CiteSeer
	"oai:nsdl.org:crs:5101",	// arXive
	"oai:nsdl.org:crs:2577221",	// Springer Pubs
	"oai:nsdl.org:crs:4727",	// OSTI
	"oai:nsdl.org:crs:491770",	// DOAJ
	"oai:nsdl.org:crs:1549969",	// PubMed
	"oai:nsdl.org:crs:27008",	// CITIDEL
	"oai:nsdl.org:crs:498820",	// US EPA
	"oai:nsdl.org:crs:464485",	// BioOne
	"oai:nsdl.org:crs:297935",	// Project Euclid
	"oai:nsdl.org:crs:297937",	// DSpace at MIT
	"oai:nsdl.org:crs:316881",	// Networked Computer Science
	"oai:nsdl.org:crs:65230",	// Alexandria Digital Library
	"oai:nsdl.org:crs:297938"	// VT-ETD
	NEED american journal of physics
	
	//-->
	<c:set var="noncollections" value='NOT ky:"2063768"' /> 
	<c:set var="queryall" value='${keywords} OR titlestems:(${keywords}) OR descriptionstems:(${keywords}) ${noncollections}'/> 
	
<c:choose>
<c:when test="${not empty subjects}">
<c:set var="query" value='titlestems:((${keywords}) AND (${strandkeywords})) AND descriptionstems:((${keywords}) AND (${strandkeywords})) AND /stems//nsdl_dc/subject:((${keywords}) AND (${strandkeywords}) AND (${subjects})) AND (${audience}) ${noncollections}'/> 
</c:when>
<c:otherwise>
<c:set var="query" value='titlestems:((${keywords}) AND (${strandkeywords})) AND descriptionstems:((${keywords}) AND (${strandkeywords})) AND /stems//nsdl_dc/subject:((${keywords}) AND (${strandkeywords})) AND (${audience}) ${noncollections}'/> 
</c:otherwise>
</c:choose>
<br/>


	<%-- Issue the request to the web service. If a connection error occurs, store it in variable 'serviceError' --%>
	<c:catch var="serviceError"> 
		<%-- Construct the http request to send to the web service and store it in variable 'webServiceRequest' --%>
		<c:url value="${ddswsBaseUrl}" var="webServiceRequest"> 
			<%-- Define each of the http parameters used in the request --%>
			<c:param name="verb" value="Search"/> 
			<%-- Begin the result at the current offset --%>
			<c:param name="s" value="${startingOffset}"/> 
			<%-- Return 5 results --%>
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
		
		
		<%-- Issue the request to the Web service server and store the response in variable 'xmlResponse' --%>
		<c:import url="${webServiceRequest}" var="xmlResponse" charEncoding="UTF-8" /> 
		<%-- Remove namespaces from the XML and create the DOM --%>
		<x:transform xslt="${f:removeNamespacesXsl()}" xml="${xmlResponse}" var="xmlDom"/> 
		<c:if test="${not empty serviceError}"> Sorry, our system has encountered a problem and we were unable to perform your search at this time. Please try again later. </c:if> 
		<%-- Display the record metadata to the user (if no connection error occured) --%>
		
		<c:if test="${empty serviceError}"> 
		<c:set var="content">
			<x:choose> 
				<%-- If the total number of results is greater than zero, display them --%>
				<x:when select="$xmlDom/DDSWebService/Search/resultInfo/totalNumResults > 0"> 
					<%-- ------ Begin paging logic ------ --%>
					<%-- Save the number of results in variable 'numResults' --%>
					<c:set var="numResults"> 
						<x:out select="$xmlDom/DDSWebService/Search/resultInfo/totalNumResults"/> 
					</c:set> 

					<%-- Create and store the HTML for the pager in variable 'pager' --%>
					<c:set var="pager"> 
						<nobr> Now viewing ${numResults > 1 ? 'resources':'resource'} 
							<c:out value="${startingOffset +1}"/> - 
							<c:if test="${startingOffset + 5 > numResults}"> 
								<c:out value="${numResults}"/> 
							</c:if> 
							<c:if test="${startingOffset + 5 <= numResults}"> 
								<c:out value="${startingOffset + 5}"/> 
							</c:if> 
						</nobr> 
						<nobr>out of <span id="numResults${section}"><c:out value="${numResults}"/></span></nobr> 
						<br/><c:if test="${(startingOffset - 5) >= 0 && param.view != 'print'}"> 
							<a href="?startingOffset=${startingOffset - 5}&mapId=${map}&bmId=${bm}&mapName=${mapName}">&lt;&lt; Prev</a> &nbsp;
						</c:if> 
						
						<!--//The total number of pages we can display based on the number of search results//-->
					<c:set var="total_pages_full">${numResults div 5}</c:set>
					<fmt:formatNumber type="number" value="${total_pages_full}" var="total_pages" maxFractionDigits='0'/>
					<c:set var="total_pages_fraction">${fn:substringAfter(total_pages_full,'.')}</c:set>
					<c:set var="total_pages_integer">${fn:substringBefore(total_pages_full,'.')}</c:set>
					<c:if test="${((total_pages_fraction > 0) && (total_pages_fraction < 5)) && (total_pages_integer > 0)}">
						<c:set var="total_pages">${total_pages + 1}</c:set>
					</c:if>
					<!--//The result page we are currently on (add 1 to it)//-->
					<c:set var="current_page">${fn:substringBefore((startingOffset div 5), '.') + 1}</c:set>
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
						<a href="?startingOffset=0&mapId=${map}&bmId=${bm}&mapName=${mapName}">1</a>...
					</c:when>
					</c:choose>
					</c:if>
					<c:if test="${total_pages > 1}">
					<c:forEach var="i" begin="${start_page}" end="${end_page}" varStatus="status">
					
					<c:choose>
					<c:when test="${i == current_page}">
						<strong>${i}</strong>
					</c:when>
					<c:otherwise>
						<c:set var="next_skip">${(i*5)-5}</c:set>
						<a href="?startingOffset=${next_skip}&mapId=${map}&bmId=${bm}&mapName=${mapName}">${i}</a>
					</c:otherwise>
					</c:choose>
					</c:forEach>
					</c:if>
					<c:if test="${(current_page < (total_pages - 5)) && (total_pages > (set_page_display - 1))}">
					<c:set var="next_skip">${(total_pages*5)-5}</c:set>
						...<a href="?startingOffset=${next_skip}&mapId=${map}&bmId=${bm}&mapName=${mapName}">${total_pages}</a>
					
					</c:if>
						<c:if test="${(startingOffset + 5) < numResults && param.view != 'print'}"> 
							<a href="?startingOffset=${startingOffset + 5}&mapId=${map}&bmId=${bm}&mapName=${mapName}">Next &gt;&gt;</a> &nbsp;
						</c:if>
						
					</c:set> 
					
					<%-- ------ end paging logic ------ --%>
					<c:set var="mySectionIndex">
						itemIndex<c:out value="${section}"/>
					</c:set>
					<span id="${mySectionIndex}" class="navIndex">${pager}</span>
					<%-- Render a gray line --%>
					<hr/>
					<%-- Loop through each of the record nodes --%>
					
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
								<a href='${resourceURL}' target="_blank" class="boldlink">${resourceTitle}</a>
							</div>
							<div class="resourceUrl"><a href='${resourceURL}'>
								<c:choose>
									<c:when test="${ fn:length(resourceURL) > maxUrlLength }">
										<a href="${resourceURL}" target="_blank">${fn:substring(resourceURL,0,maxUrlLength)} ...</a>	
									</c:when>
									<c:otherwise>
										<a href="${resourceURL}" target="_blank">${resourceURL}</a>
									</c:otherwise>
								</c:choose>
							</a>
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
						
					</x:forEach> 
					<span id="${mySectionIndex}" class="navIndex">${pager}</span>
				</x:when> 
				<%-- If there were no matches, report to user --%>
				<x:otherwise> <p>No related resources are currently available for this benchmark. </p>
 							<p>New resources are regularly added to NSDL, please check back later.</p>
				
				</x:otherwise>	
			</x:choose> 
			</c:set>
			${content}
		</c:if> 
	</c:catch> 
</c:if> 

<!-- ${webServiceRequest} //-->
