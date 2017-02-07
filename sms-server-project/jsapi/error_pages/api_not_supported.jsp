<%@ page contentType="text/javascript" %><%@ include file="/jsapi/TagLibIncludes.jsp" %>
<c:choose>
	<c:when test="${not empty param.api}">
		alert('The SMS JavaScript API requested, "${param.api}", is not supported.');
	</c:when>
	<c:otherwise>
		alert('No SMS JavaScript API version was indicated. Please pass in an api parameter, for example ...?api=v1');
	</c:otherwise>
</c:choose>