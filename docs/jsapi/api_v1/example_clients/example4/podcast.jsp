<%@ include file="../../../../TagLibIncludes.jsp" %>
<h2>Podcast</h2>
<p>This tab demonstrates how to display a podcast/rss feed using a Science Friday podcast as an example</p>

<%-- Issue the request to the web service. If a connection error occurs, store it in variable 'serviceError' --%>
<c:catch var="serviceError"> 
	<%-- Construct the http request to send to the web service and store it in variable 'webServiceRequest' --%>
	<c:url value="http://www.sciencefriday.com/audio/scifriaudio.xml" var="webServiceRequest"></c:url> 

	<%-- Issue the request to the Web service server and store the response in variable 'xmlResponse' --%>
	<c:import url="${webServiceRequest}" var="xmlResponse" charEncoding="UTF-8" /> 
	<%-- Remove namespaces from the XML and create the DOM --%>
	<x:transform xslt="${f:removeNamespacesXsl()}" xml="${xmlResponse}" var="xmlDom"/> 
	<c:if test="${not empty serviceError}"> Sorry, our system has encountered a problem and we were unable to perform your search at this time. Please try again later. </c:if> 
	<%-- Display the record metadata to the user (if no connection error occured) --%>
	<c:if test="${empty serviceError}"> 
		<c:set var="countnum">0</c:set>
			<%-- Loop through each of the record nodes --%>
						<x:forEach select="$xmlDom/rss/channel/item"> 
						<%-- We are already at XPath $xmlDom/rss/channel/item
						so we can continue our path from there --%>
						<c:set var="resourceURL">
							<x:out select="guid"/>
						</c:set>
						<c:set var="resourceTitle">
							<x:out select="title"/>
						</c:set>
						<c:set var="description">
							<x:out select="description"/> 
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
								<c:choose>
								<c:when test="${countnum == 0}">
								<embed src="${resourceURL}" height="60" width="144" autostart="false" controller="true" />
								<c:set var="countnum" value="1"/>
								</c:when>
								<c:otherwise>
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
								</c:otherwise>
								</c:choose>
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
						</div>
				

		</c:if> 
	</c:catch> 

<!-- ${webServiceRequest} //-->
