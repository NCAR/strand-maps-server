<!doctype html public "-//w3c//dtd html 4.0 transitional//en" "http://www.w3.org/TR/REC-html40/strict.dtd">
<html>
    <head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <title>Strand Map Service JavaScript API</title>

</head>

<body>

	<%-- Insert the menus top: --%>
	<%@ include file="/docs/menus_insertion_top.jsp" %>

	<!-- Header -->
	<table width="95%">
		<tr><td>
			<h1>SMS JavaScript API</h1>
			
			<p>
			The SMS JavaScript API lets Web developers insert interactive AAAS Strand Maps into
			Web pages using JavaScript and place custom content into the bubble inside the maps.
			</p>
			
			<p>
				The API is described and illustrated formally here:
			</p>
			<ul>
				<li><a href="api_v1/index.jsp">Documentation</a> - The documentation describes the API in detail, with information  
				about how to insert an interactive map into a Web page and the methods used to customize 
				and insert content into the map InfoBubble.</li>
							
				<li><a href="api_v1/json_explorer.jsp">JSON Explorer</a> - The JSON explorer provides access 
				to the JSON data that is available from the service.</li>		
	
				<li><a href="api_v1/image_explorer.jsp">Image Explorer</a> - The image explorer provides access 
				to the JPG, PNG, PDF and SVG images that are available from the service.</li>
					
				
				<li><a href="api_v1/example_clients/index.jsp">Example Code</a> - The example code section contains
				working clients that illustrate how to use the API, and may be used as a template for customizing the
				interactive maps within a Web site.</li>
			</ul>			

	
			<br/>
			
			
			<h3>SMS Version</h3>
			<p>
				This is version @VERSION@.  
				See <a href="<c:url value='/docs/CHANGES.txt'/>">list of changes in the software and APIs</a>.
				API changes are generally backward-compatible with previous versions.
			</p>
			
			<%-- NOTE: Removed iframe as it is broken in IE 9. Not sure it adds much anyway... --%>
			<%-- <h3>Interactive Map: Changes in the Earth's Surface</h3>
			
			<table>
				<tr><td>
					<iframe width="766" height="616" frameborder="0" scrolling="no" marginheight="0" marginwidth="0" src="map_for_iframe.html?id=SMS-MAP-0048&bm=SMS-BMK-0027"></iframe>
				</td></tr>
			</table> --%>
	
		</td></tr>
	</table>	

	<br/>
	<br/>	

	<%-- Insert the menus bottom: --%>
	<%@ include file="/docs/menus_insertion_bottom.jsp" %> 

</body>
</html>
