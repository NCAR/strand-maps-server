<!doctype html public "-//w3c//dtd html 4.0 transitional//en" "http://www.w3.org/TR/REC-html40/strict.dtd">
<%@ include file="/docs/TagLibIncludes.jsp" %>
<html>
    
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>SMS JavaScript API: JSON Explorer</title>
<script type="text/javascript" src='api_docs_script.js'></script>
<script type="text/javascript" src='<c:url value="/jsapi/lib/prototype_1.5.1.1.js"/>'></script>

</head>

<body>

	<%-- Insert the menus top: --%>
	<%@ include file="/docs/menus_insertion_top.jsp" %>

<!-- Header -->
<table width="95%">
    
  <tr> 
    <td> 
	  <h1>JSON Explorer</h1>
		<p>
			Use the forms in this page to access and explore the JSON data that is available from the service.			
			The service provides JSON data for maps, grade groups, strands, benchmarks, clusters, chapters and the atlas, via URL. 
			See the <a href="index.jsp#json" title="JSON documentation">JSON documentation </a> for more information.
		</p>
		
		
		<h3>SMS JSON</h3>
		
		<p>
			URL pattern for JSON data:<br/>
			<code><nobr>${f:contextUrl(pageContext.request)}/jsapi/json?
			<br/>ObjectID=SMS-MAP-0048&amp;Format=SMS-JSON&amp;callBack=myCallbackFn&amp;DetailLevel=Detailed</nobr></code><br/>
		</p>

		<p>
			Construct the URL:
		</p>		
		
		<p>
		
		<form name="jsonForm" action="javascript:mkJsonReq('')">
		<div>Required parameters:</div>
		<table>	
			<tr>
				<td nowrap="nowrap">
					ObjectID:
				</td>
				<td nowrap="nowrap">
					<input name="identifier" size="15" type="text" value="${empty param.ObjectID ? 'SMS-BMK-0025' : param.ObjectID}"/>
				</td>
				<td nowrap="nowrap">			
					output format:
					<select name="formats">		
							<option value="SMS-JSON" ${param.Format == 'SMS-JSON' ? 'selected' : ''}>SMS-JSON</option>	
							<option value="SVG-JSON" ${param.Format == 'SVG-JSON' ? 'selected' : ''}>SVG-JSON</option>				
					</select>
				</td>
			</tr>
		</table>
		<div>Optional parameters:</div>
		<table>
			<tr>
				<td nowrap="nowrap">
					JavaScript callback function:
				</td>
				<td nowrap="nowrap">
					<input name="callback" size="20" type="text" value="${param.callBack}"/>
				</td>
				<td>&nbsp;</td>
				<td nowrap="nowrap">	
					detail level:
					<select name="detail">
							<option value="none">-- Use default (Detailed) --</option>	
							<option value="Detailed" ${param.DetailLevel == 'Detailed' ? 'selected' : ''}>Detailed</option>	
							<option value="Skeleton" ${param.DetailLevel == 'Skeleton' ? 'selected' : ''}>Skeleton</option>				
					</select>
				</td>				
			</tr>
		</table>
		<input title="View JSON" value="View JSON" onclick='mkJsonReq("")' type="button">
		<input title="Reset" value="Reset" onclick="window.location='json_explorer.jsp'" type="button">

		</form>
		
		</p>	
		
		
    </td>
  </tr>
</table>

<c:if test="${not empty param.ObjectID}">
<c:url var="jsonRequestUrl" value="${f:contextUrl(pageContext.request)}/jsapi/json">
	<c:param name="ObjectID" value="${param.ObjectID}"/>
	<c:param name="Format" value="${param.Format}"/>
	<c:if test="${not empty param.callBack}">
		<c:param name="callBack" value="${param.callBack}"/>
	</c:if>
	<c:if test="${not empty param.DetailLevel}">
		<c:param name="DetailLevel" value="${param.DetailLevel}"/>
	</c:if>	
</c:url>
<c:import url="${jsonRequestUrl}" var="jsonResponse"/>

<p>
	<h2>JSON service response </h2>
	<p>For url: <code>${jsonRequestUrl}</code></p>
	<div id="obInfo"></div>
</p>

<script>
	var parms = window.location.search.parseQuery();
	
	function makeCatEntryHtml(CatalogEntry){
		var objId = CatalogEntry.CatalogNumber;
		var myParams = 'ObjectID=' + objId + '&Format='+parms.Format;
		var content = '<nobr><br/> - ' + CatalogEntry.RelationType + ' - ' + objId;
		if(objId.length == 12)
			content += ' [ <a href="json_explorer.jsp?'+myParams+'">explore</a> ]';
		if(objId.include('-BMK-') || objId.include('-GRD-') || objId.include('-STD-') || objId.include('-MAP-'))
			content += ' [ <a href="<c:url value="${f:contextUrl(pageContext.request)}/jsapi/map_images/default"/>/'+objId+'.JPG" target="_blank">view image</a> ]';
		content += '</nobr>';
		return content;
	}

	<c:choose>
		<c:when test="${empty param.callBack}">
			var jsonResponse = ${jsonResponse};
		</c:when>
		<c:otherwise>
			var jsonResponse = null;
			function ${param.callBack}(jsonData){
				jsonResponse = jsonData;
			}
			${jsonResponse};
		</c:otherwise>
	</c:choose>
	
	var recordJson = jsonResponse['SMS-CSIP'].QueryResponse.SMS.Record;
	var myId = recordJson.itemRecord.Admin.IDNumber;
	var content = '<p><b>' + recordJson.itemRecord.Data.Name + '</b>';
	content += ' (' + recordJson.itemRecord.Data.ObjectType;
	content += ' - ' + myId + ')';
	if(myId.length == 12)
		content += ' [ <a href="${jsonRequestUrl}" target="_blank">open raw JSON</a> ]';
	if(myId.include('-BMK-') || myId.include('-GRD-') || myId.include('-STD-') || myId.include('-MAP-'))
			content += ' [ <a href="<c:url value="${f:contextUrl(pageContext.request)}/jsapi/map_images/default"/>/'+myId+'.JPG" target="_blank">view image</a> ]';		
	
	var asnArray = recordJson.itemRecord.Data.ASNIDs.ASNID;	
	content += '</p><p>ASN IDs:';
	if(typeof(asnArray.ASNNumber) == 'string')
		content += makeCatEntryHtml(asnArray);
	else
		for(var i=0; i< asnArray.length; i++)
			content += makeCatEntryHtml(asnArray[i]);
	content += '</p>';
			
	var relArray = recordJson.itemRecord.Data.InternalRelationship.CatalogID;	
	content += '</p><p>Internal relationships:';
	if(typeof(relArray.CatalogNumber) == 'string')
		content += makeCatEntryHtml(relArray);
	else
		for(var i=0; i< relArray.length; i++)
			content += makeCatEntryHtml(relArray[i]);
	content += '</p>';

	$('obInfo').update(content);
</script>

<table style="background-color: #eeeeee; border: 1px solid black; padding: 10; margin-left: 10;"><tr><td>
<pre><code>
<c:out value="${jsonResponse}" escapeXml="true"/>
</code></pre>
</td></tr></table>

</c:if>


<br>

	<%-- Insert the menus bottom: --%>
	<%@ include file="/docs/menus_insertion_bottom.jsp" %>

</body>
</html>
