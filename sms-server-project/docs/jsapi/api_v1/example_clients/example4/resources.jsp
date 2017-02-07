<%-- 
	Includes all JSTL and Struts tag libraries, without adding whitespace to the page.
	Source this file using: <%@ include file="TagLibIncludes.jsp" %>
--%><%@ page language="java" %><%@ page isELIgnored="false" 
%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" 
%><%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" 
%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" 
%><%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" 
%><%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" 
%><%@ taglib prefix="f" uri="http://www.dlese.org/dpc/dds/tags/dleseELFunctions" 
%><%@ taglib prefix="str"  uri="/WEB-INF/tlds/taglibs-string.tld"
%><%@ taglib prefix="sms"  uri="/WEB-INF/tlds/SMSTags.tld"
%><%@ taglib prefix="smsU" uri="/WEB-INF/tlds/SMSUtils.tld" %>

<%
String startingOffset = request.getParameter("offset");
String keywords = request.getParameter("keywords");

%>

<c:set var="startingOffset" value="<%=startingOffset%>"/>
<c:set var="kw" value="<%=keywords%>"/>

<c:set var="keywords" value=""/>
<c:forTokens var="keyword" items="${kw}" delims="|">
<c:choose>
	<c:when test="${empty keywords}">
		<c:set var="keywords">"${keyword}"</c:set>
	</c:when>
	<c:otherwise>
		<c:set var="keywords">${keywords} OR "${keyword}"</c:set>
	</c:otherwise>
</c:choose>	
</c:forTokens>

<c:set var="audience" value='/key//nsdl_dc/educationLevel:("High School")'/>
<c:set var="collections" value='ky:"2802786"'/>

<c:set var="query" value='(${keywords} AND titlestems:(${keywords}) AND descriptionstems:(${keywords})) AND ${audience} AND ${collections}'/> 
<%-- The maximum character length of the description that gets displayed in the initial search results. 
		A smaller value here will make the search results page more compact. Leave blank to 
		display the full description text regardles off its length --%>
<c:set var="maxDescriptionLength" value="400" />
<c:set var="maxTitleLength" value="90" />
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
	<c:url value="http://nsdl.org/dds-search" var="webServiceRequest"> 
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
			<x:choose> 
				<%-- If the total number of results is greater than zero, display them --%>
				<x:when select="$xmlDom/DDSWebService/Search/resultInfo/totalNumResults > 0"> 
				<p>These resources were selected by performing a keyword search over items in the NSDL library.</p>
					<%-- ------ Begin paging logic ------ --%>
					<%-- Save the number of results in variable 'numResults' --%>
					<c:set var="numResults"> 
						<x:out select="$xmlDom/DDSWebService/Search/resultInfo/totalNumResults"/> 
					</c:set> 
					<c:set var="pageIndex"> 
					<%-- Create and store the HTML for the pager in variable 'pager' --%>
					
						<nobr> ${numResults > 1 ? 'results':'result'} 
						<c:out value="${startingOffset +1}"/> - 
						<c:if test="${startingOffset + 5 > numResults}"> 
							<c:out value="${numResults}"/> 
						</c:if> 
						<c:if test="${startingOffset + 5 <= numResults}"> 
							<c:out value="${startingOffset + 5}"/> 
						</c:if> 
						</nobr> 
						<nobr>out of <span id="numResults${section}"><c:out value="${numResults}"/></span></nobr> 
						<br/>
						<c:set var="page_prev"> 
							${startingOffset - 5}
						</c:set>
						<c:set var="page_next"> 
							${startingOffset + 5}
						</c:set>
						
						<c:if test="${(startingOffset - 5) >= 0 && param.view != 'print'}"> 
							<a href="javascript:sendResRequest(${startingOffset - 5})">&lt;&lt; Prev</a> &nbsp;
						</c:if> 
						<!--//The total number of pages we can display based on the number of search results//-->
						<c:set var="total_pages_full">${numResults div 5}</c:set>
						<c:set value="${fn:substringBefore(total_pages_full,'.')}" var="total_pages" />
						<c:set var="total_pages_fraction">${fn:substringAfter(total_pages_full,'.')}</c:set>
						<c:set var="total_pages_integer">${fn:substringBefore(total_pages_full,'.')}</c:set>
						<c:if test="${(total_pages_fraction > 0) && (total_pages_integer > 0)}">
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
									<a href="javascript:sendResRequest(0)">1</a>...
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
										<a href="javascript:sendResRequest(${next_skip})">${i}</a>
									</c:otherwise>
								</c:choose>
							</c:forEach>
						</c:if>
						<c:if test="${(current_page < (total_pages - 5)) && (total_pages > (set_page_display - 1))}">
							<c:set var="next_skip">${(total_pages*5)-5}</c:set>
							...<a href="javascript:sendResRequest(${next_skip},'${displaytype}')">${total_pages}</a>
						</c:if>
						<c:if test="${(startingOffset + 5) < numResults && param.view != 'print'}"> 
							<a href="javascript:sendResRequest(${startingOffset + 5})">Next &gt;&gt;</a> &nbsp;
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
						<x:forEach select="$xmlDom/DDSWebService/Search/results/record"> 
						<%-- We are already at XPath $xmlDom/DDSWebService/Search/results/record
						so we can continue our path from there --%>
						<c:set var="resourceURL">
							<x:out select="metadata/nsdl_dc//identifier[@type='dct:URI']"/>
						</c:set>
						<c:set var="resourceTitle">
							<x:out select="metadata/nsdl_dc//title"/>
						</c:set>
						
						<c:set var="description">
							<x:out select="metadata/nsdl_dc//description"/> 
						</c:set>
						
						<c:set var="audience">
							<x:out select="metadata/nsdl_dc//educationLevel"/>
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
								
								<div class="resourceUrl">
									<c:choose>
										<c:when test="${ fn:length(resourceURL) > maxUrlLength }">
											<a href="${resourceURL}" target="_blank">${fn:substring(resourceURL,0,maxUrlLength)} ...</a>	
										</c:when>
										<c:otherwise>
											<a href="${resourceURL}" target="_blank">${resourceURL}</a>
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
						</x:forEach> 
						<span id="${mySectionIndex}" class="navIndex">${pager}</span>
					</div>
					
					${pageIndex}
				</x:when> 
				<%-- If there were no matches, report to user --%>
				<x:otherwise> 
				</x:otherwise>	
			</x:choose> 

		</c:if> 
	</c:catch> 


