<%@ include file="/jsapi/TagLibIncludes.jsp" %>
<%-- Sets the default host,port and path for rest of the tags used in this page --%>
<%@ page import="java.util.*, java.lang.*" %>
<%
	if(getServletContext().getAttribute("jsServiceCache") == null ) 
		getServletContext().setAttribute("jsServiceCache",new java.util.HashMap());
%>

 <c:choose>
      <c:when test="${not empty applicationScope.jsServiceCache['chapters_maps_list_jsp']}">
      	<c:set var="chapters_maps_list_jsp" value="${applicationScope.jsServiceCache['chapters_maps_list_jsp']}"/>
   	  </c:when>
      <c:otherwise>
              <c:set var="chapters_maps_list_jsp">
              	<smsU:DefaultHost host="@LOCAL_HOST@"/> 
				<smsU:DefaultPort port="@LOCAL_PORT@"/> 
				<smsU:DefaultPath path="@QUERY_URL_PATH@"/> 
				
				<x:parse var="ChapterResponseXML">
					<sms:ChapterList/>
				</x:parse>
				<x:transform xslt="${f:removeNamespacesXsl()}" xml="${ChapterResponseXML}" var="xmldoc"/>
				
				<x:forEach select="$xmldoc//itemRecord" varStatus="theCount">
					<c:set var="chapter"><x:out select="Admin/IDNumber"/></c:set>
					<c:set var="chapterName"><x:out select="Data/Name"/></c:set>
					<li><a href="#" class="menuController"><img src="@GLOBAL_CONTEXT_URL@/jsapi/api_v1/strand_selector/images/arrows/menu-closed.gif" class="smsMultiNavArrow"/>${chapterName}</a><ul class="menuClosed"><c:if test="${chapter != null}"><li>
					<div id='id_nav_header_${theCount.index}' class="smsMultiNavMapHeader" onclick="window.location.href='?chapter=${chapter}'" ontouchstart="window.location.href='?chapter=${chapter}'" onmouseover="$('id_nav_header_${theCount.index}').toggleClassName('smsMultiNavMapHeader_hover')" onmouseout="$('id_nav_header_${theCount.index}').toggleClassName('smsMultiNavMapHeader_hover')">${chapterName}</div></li>
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
								<c:set var="newresponse" value="${fn:replace( xmlResponse, '&' ,'&amp;')}"/>
								<x:transform xslt="${f:removeNamespacesXsl()}" xml="${newresponse}" var="chapterdoc"/>
								<x:forEach select="$chapterdoc//itemRecord">
									<c:set var="chapterName"><x:out select="Data/Name"/></c:set>
								</x:forEach>
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
									<x:forEach select="$clusterXML//itemRecord">
										<c:set var="clusterNumber"><x:out select="Admin/IDNumber"/></c:set>
										<x:parse var="Maps">
											<sms:MapList upper="${clusterNumber}"/> 
										</x:parse>
										<x:transform xslt="${f:removeNamespacesXsl()}" xml="${Maps}" var="mapXML"/>	
										<x:forEach select="$mapXML//itemRecord">
											<c:set var="mapName">
												<x:out select="Data/Name"/>
											</c:set>
											<c:set var="mapId">
												<x:out select="Admin/IDNumber"/>
											</c:set>
											<li><a href=?id=${mapId}>${mapName}</a></li>
										</x:forEach>
									</x:forEach>
						</c:if></ul></li>
				</x:forEach>
              </c:set>
              
              <c:set target="${applicationScope.jsServiceCache}" property="chapters_maps_list_jsp" value="${chapters_maps_list_jsp}"/>
              
      </c:otherwise>
</c:choose>
${chapters_maps_list_jsp}
