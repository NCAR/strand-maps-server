<%@ include file="/jsapi/TagLibIncludes.jsp" %>	
<c:set var="chapter" value="${param.chapter}"/>
<div id="mapList">
<c:choose>
	<c:when test="${chapter == 'SELECT'}">
		<div class="mapListTitle">You did not select a topic.  Please select a topic from the drop-down list above.</div>
	</c:when>
	<c:otherwise>
			
		<%-- Sets the default host,port and path for rest of the tags used in this page --%>
		<smsU:DefaultHost host="@LOCAL_HOST@"/> 
		<smsU:DefaultPort port="@LOCAL_PORT@"/> 
		<smsU:DefaultPath path="@QUERY_URL_PATH@"/> 
		
		<c:choose>
			<c:when test="${chapter != null}">
				<c:set var="queryforchapter">
					<SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
						<Query Color="skyblue" DetailLevel="Detailed" Format="SMS" Scope="ALL" ThirdPartyQuery="">
							<Content-Query>
								<ObjectID>${chapter}</ObjectID>
							</Content-Query>
						</Query>
					</SMS-CSIP>
				</c:set>
				
				<c:url value="@LOCAL_CONTEXT_URL@/Query" var="req">
					<c:param name="Query" value="${queryforchapter}"/>
				</c:url>
				<c:import url="${req}" var="xmlResponse" charEncoding="UTF-8" />
				<!-- change the & to &amp; -->
				<c:set var="newresponse" value="${fn:replace( xmlResponse, '&' ,'&amp;')}"/>
				<x:transform xslt="${f:removeNamespacesXsl()}" xml="${newresponse}" var="chapterdoc"/>
				<x:forEach select="$chapterdoc//itemRecord">
					<c:set var="chapterName"><x:out select="Data/Name"/></c:set>
				</x:forEach>
				<c:choose>
					<c:when test="${chapter == 'ALL'}">
						<%-- <div class="mapListTitle">All available maps:</div> --%>
						<script type="text/javascript">
							var content = '<span id="smsMapTitle">All Topics</span>';
							setTitleBar( content );
							document.title = document.title + ': All Topics';
						</script>									
					</c:when>
					<c:otherwise>
						<%-- <div class="mapListTitle"><em><c:out value="${chapterName}"/></em> contains the following maps:</div> --%>
						<script type="text/javascript">
							var content = '<span id="smsMapTitle">${chapterName}</span>';
							setTitleBar( content );
							document.title = document.title + ': ${f:jsEncode(chapterName)}';
						</script>											
					</c:otherwise>
				</c:choose>
				<x:parse var="Clusters">
					<sms:ClusterList upper="${chapter}"/> 
				</x:parse>
				<x:transform xslt="${f:removeNamespacesXsl()}" xml="${Clusters}" var="clusterXML"/>	
				<%-- get total maps --%>
					<c:set var="totalMaps" value="0"/>
					<x:forEach select="$clusterXML//itemRecord">
						<c:set var="clusterNumber"><x:out select="Admin/IDNumber"/></c:set>
						<x:parse var="Maps">
							<sms:MapList upper="${clusterNumber}"/> 
						</x:parse>
						<x:transform xslt="${f:removeNamespacesXsl()}" xml="${Maps}" var="mapXML"/>	
						<x:forEach select="$mapXML//itemRecord">
							<c:set var="totalMaps" value="${totalMaps + 1}"/>
						</x:forEach>
					</x:forEach>
				<c:set var="halfMapsDec" value="${totalMaps div 2}"/>
				<fmt:formatNumber var="halfMaps" value="${halfMapsDec}" type="number" maxFractionDigits="0"/>
				<c:set var="currentCount" value="1"/>
				
				<table border="0" cellspacing="10"><tr><td valign="top">
				<x:forEach select="$clusterXML//itemRecord">
					
					<c:set var="clusterNumber"><x:out select="Admin/IDNumber"/></c:set>
				
					<x:parse var="Maps">
						<sms:MapList upper="${clusterNumber}"/> 
					</x:parse>
					<x:transform xslt="${f:removeNamespacesXsl()}" xml="${Maps}" var="mapXML"/>	
				
					<x:forEach select="$mapXML//itemRecord">
					
						<c:set var="mapName"><x:out select="Data/Name"/></c:set>
						<c:set var="mapNumber"><x:out select="Admin/IDNumber"/></c:set>
						<c:url value="" var="link">
							<c:param name="id" value="${mapNumber}"/>
						</c:url>	
					
						<x:parse var="Strands">
							<sms:StrandList upper="${mapNumber}"/> 
						</x:parse>
						<x:transform xslt="${f:removeNamespacesXsl()}" xml="${Strands}" var="mapDoc"/>		
						<%@ include file="map_name_table.jsp" %>
						
						<c:if test="${halfMaps == currentCount}">			
						</td>
						<td valign="top">
						</c:if>	
						<c:set var="currentCount" value="${currentCount + 1}"/>
					</x:forEach>
				</x:forEach>
				</td></tr></table>
			</c:when>
			<c:otherwise>
			
			<c:choose>
			<c:when test="${param.keyword != null}">
				<c:set var="key">
					<str:trim>
						<str:replace replace='"' with="">
							<str:replace replace="'" with="">
								<str:replace replace="*" with="">
									<str:replace replace="+" with="">
										<str:replace replace="~" with="">
											<str:replace replace="." with="">
												<str:replace replace="?" with="">
													<str:replace replace="," with="">
														<str:replace replace=";" with="">
															<str:replace replace=":" with="">
																<str:replace replace="&lt;" with="">
																	<str:replace replace="&gt;" with="">
																		<str:replace replace="&#039;" with="">
																			<str:replace replace="&#034;" with="">
																				<str:replace replace="&amp;" with="">
																					<c:out value="${param.keyword}"/>
																				</str:replace>	
																			</str:replace>	
																		</str:replace>
																	</str:replace>
																</str:replace>
															</str:replace>
														</str:replace>
													</str:replace>
												</str:replace>
											</str:replace>
										</str:replace>
									</str:replace>
								</str:replace>
							</str:replace>
						</str:replace>
					</str:trim>
				</c:set>
			</c:when>	
			<c:otherwise>
				<c:set var="key" value=""/>
			</c:otherwise>
		</c:choose>
			
				<x:parse var="FoundMapResponseXML">
					<sms:FindMaps>
						<sms:SimpleSearch method="Contains-all-words">
							<c:out value="${key}"/>
						</sms:SimpleSearch>
					</sms:FindMaps>
				</x:parse>
				<x:choose>
					<x:when select="$FoundMapResponseXML//MapName">
						<div class="mapListTitle">Your search - <em>${key}</em> - returned the following maps:</div>
					</x:when>
					<x:otherwise>
						<c:choose>
							<c:when test="${key != ''}">
								<div class="mapListTitle">Your search - <em><c:out value="${key}"></c:out></em> - was not found in any map</div>							
							</c:when>
							<c:otherwise>
								<div class="mapListTitle">You did not enter any keywords - please enter one or more keywords above to search for concept maps</div>
							</c:otherwise>
						</c:choose>
					</x:otherwise>
				</x:choose>
				<script type="text/javascript">
					var content = '<span id="smsMapTitle">Search results</span>';
					setTitleBar( content );
					document.title = document.title + ': ${f:jsEncode("Search results")}';
				</script>				
				
				<x:set var="totalMaps" select="count($FoundMapResponseXML//MapName)"/>
				<c:set var="halfMapsDec" value="${totalMaps div 2}"/>
				<fmt:formatNumber var="halfMaps" value="${halfMapsDec}" type="number" maxFractionDigits="0"/>
				<c:set var="currentCount" value="0"/>
				<table border="0" cellspacing="10"><tr><td valign="top">
				<x:forEach select="$FoundMapResponseXML//MapName">
					
					<c:set var="mapName"><x:out select="."/></c:set>
					<c:set var="mapNumber"><x:out select="./@id"/></c:set>
					<c:url value="" var="link">
						<c:param name="id" value="${mapNumber}"/>
					</c:url>	
			
					<x:parse var="Strands">
						<sms:StrandList upper="${mapNumber}"/> 
					</x:parse>
					<x:transform xslt="${f:removeNamespacesXsl()}" xml="${Strands}" var="mapDoc"/>
					<%@ include file="map_name_table.jsp" %>					
					
					<c:if test="${halfMaps == currentCount}">			
						
						</td>
						<td valign="top">
					</c:if>	
			
					<c:set var="currentCount" value="${currentCount + 1}"/>
				</x:forEach>
				</td></tr></table>
			</c:otherwise>
		</c:choose>
	</c:otherwise>
</c:choose>
</div>
