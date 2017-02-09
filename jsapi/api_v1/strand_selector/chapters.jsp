<%@ include file="/jsapi/TagLibIncludes.jsp" %>

<%@ page import="java.util.*, java.lang.*" %>
<%
	if(getServletContext().getAttribute("jsServiceCache") == null ) 
		getServletContext().setAttribute("jsServiceCache",new java.util.HashMap());
%>
<c:choose>
      <c:when test="${not empty applicationScope.jsServiceCache['chapters_jsp']}">
      	<c:set var="chapters_jsp" value="${applicationScope.jsServiceCache['chapters_jsp']}"/>
   	  </c:when>
      <c:otherwise>
      	<c:set var="chapters_jsp"> 
			<%-- Sets the default host,port and path for rest of the tags used in this page --%>
			<smsU:DefaultHost host="@LOCAL_HOST@"/> 
			<smsU:DefaultPort port="@LOCAL_PORT@"/> 
			<smsU:DefaultPath path="@QUERY_URL_PATH@"/> 
			
			<x:parse var="ChapterResponseXML">
				<sms:ChapterList/>
			</x:parse>
			<x:transform xslt="${f:removeNamespacesXsl()}" xml="${ChapterResponseXML}" var="xmldoc"/>
			
			<x:forEach select="$xmldoc//itemRecord">
				<c:set var="chapterId"><x:out select="Admin/IDNumber"/></c:set>
				<c:set var="chapterName"><x:out select="Data/Name"/></c:set>
				<c:url value="./" var="link"/>
				<option value="${chapterId}"><a href="${link}">${chapterName}</a></option>
			</x:forEach>
			
		</c:set>
		<c:set target="${applicationScope.jsServiceCache}" property="chapters_jsp" value="${chapters_jsp}"/>
		
	</c:otherwise>
</c:choose>
${chapters_jsp}
