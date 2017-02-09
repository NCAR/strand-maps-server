<!doctype html public "-//w3c//dtd html 4.0 transitional//en" "http://www.w3.org/TR/REC-html40/strict.dtd">
<%@ include file="/docs/TagLibIncludes.jsp" %>
<html>
    
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>SMS JavaScript API: Image Explorer</title>
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
		<h1>Image Explorer</h1>
		<p>			
			The service provides access to images for all map visualizations via URLs. Use the forms on this page
			to access and explore the images, which are available for maps, strands, grade groups, and related benchmarks 
			in JPG, PNG, PDF and SVG format. Images are not available for clusters, chapters or the atlas object.
			
			See the <a href="index.jsp#mapImages" title="map image documentation">map image documentation </a> for more information.
		</p>
		
		<h3>Default Map Images</h3>
		
		<p>
			URL pattern for default map images:<br/>
			<code><nobr>${f:contextUrl(pageContext.request)}/jsapi/map_images/default/{sms-id}.{ext}</nobr></code><br/>
		</p>

		<p>
			Construct the URL:
		</p>		
		
		<p>
	
		<table>
			<form name="defaultImgForm" action="javascript:mkDefaultImg('')">
			<tbody>
				<tr>
					<td nowrap="nowrap">
						ID:
					</td>
					<td nowrap="nowrap">
						<input name="identifier" size="15" type="text" value="SMS-MAP-1207">
					</td>
					<td>&nbsp;</td>
					<td nowrap="nowrap">			
						Image format:
						<select name="formats">
								<option value="JPG">JPG</option>
								<option value="PDF">PDF</option>	
								<option value="PNG">PNG</option>	
								<option value="SVG">SVG</option>				
						</select>
					</td>
					<td nowrap="nowrap">
						<input title="View the image" value="View map image" onclick='mkDefaultImg("")' type="button">
					</td>			
				</tr>
			</tbody>
			</form>
		</table>
		
		</p>
		
		<h3 style="padding-top:15">Custom Map Images</h3>
		<p>
			URL pattern for custom map images:<br/>
			<code><nobr>${f:contextUrl(pageContext.request)}/jsapi/map_images/{color}/{concept-size}/{scale}/{sms-id}.{ext}</nobr></code><br/>
		</p>

		<p>
			Construct the URL:
		</p>				
		
		<p>
		<table>
			<form name="customImgForm" action="javascript:mkCustomImg('')">
			<tbody>
				<tr>
					<td nowrap="nowrap">
						color:
					</td>				
					<td cnowrap="nowrap">
						<input name="color" size="5" type="text" value="gold"/>
					</td>
					<td nowrap="nowrap">			
						concept box size:
						<select name="concept_size">		
								<option value="1">1</option>	
								<option value="2">2</option>	
								<option value="3">3</option>	
								<option selected value="4">4</option>
								<option value="5">5</option>	
								<option value="6">6</option>								
						</select>
					</td>					
					<td nowrap="nowrap">
						scale:
					</td>				
					<td nowrap="nowrap">
						<input name="scale" size="5" type="text" value="100"/>
					</td>					
					<td nowrap="nowrap">
						ID:
					</td>
					<td nowrap="nowrap">
						<input name="identifier" size="15" type="text" value="SMS-MAP-1240"/>
					</td>
					<td nowrap="nowrap">			
						Image format:
						<select name="formats">		
								<option value="JPG">JPG</option>
								<option value="PDF">PDF</option>	
								<option value="PNG">PNG</option>	
								<option value="SVG">SVG</option>				
						</select>
					</td>
					<td nowrap="nowrap">
						<input title="View the image" value="View map image" onclick='mkCustomImg("")' type="button"/>
					</td>			
				</tr>
			</tbody>
			</form>
		</table>
		</p>
		
				
		
    </td>
  </tr>
</table>

<br>

	<%-- Insert the menus bottom: --%>
	<%@ include file="/docs/menus_insertion_bottom.jsp" %>

</body>
</html>
