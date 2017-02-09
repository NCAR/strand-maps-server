<%@ include file="/jsapi/TagLibIncludes.jsp" %>
<c:set var="baseUrl" value="@GLOBAL_CONTEXT_URL@/jsapi_client/"/>
<div id="smsNavigation">
	<table cellpadding="2" cellspacing="0" margin="0" padding="0" border="0">
		<tr>
			<td align="left">
				<div title="You can use any search term such as science topic, keywords, or map title.">
					<nobr>
						Search for maps
					</nobr>
				</div>
			</td>			
			<td align="left">
				<form action="" method="get" id="smsSearch" class="smsForm">
					<nobr>
						<c:choose>
							<c:when test="${empty param.keyword}">
								<input type="text" id="keywordBox" name="keyword" class="inputText" value="Search term(s) - e.g., keywords, science topic, map title" />
							</c:when>
							<c:otherwise>
								<input type="text" id="keywordBox" name="keyword" class="inputText" value="${param.keyword}" />
							</c:otherwise>
						</c:choose>
						<input type="submit" value="Search" id="submitSearch" class="inputSubmit" />
					</nobr>
				</form>
			</td>
			<td align="left" style="padding-left:10px; padding-right:10px">
				or
			</td>			
			<td align="left">
				<form action="" method="get" id="smsBrowse" class="smsForm">
					<nobr> 
						<select name="chapter" id="chapter" onChange="$('smsBrowse').submit()">
						<option value="SELECT">-- Select a Topic --</option>
						<%@ include file="chapters.jsp" %>
						<option value="ALL">View All Topics</option>
						</select>
						<input type="submit" value="Go" id="submitBrowse" class="hide"/>
					</nobr>
				</form>
			</td>
		</tr>
	</table>
	

</div>
<div id="smsMapTitleBar">
	<div style="padding:3px">
		<div id="smsMapTitleBarLeft">
			<div id="smsMapTitleBarContent"></div>
		</div>
		<div id="smsMapTitleBarRight" style="display:none">
			<form>
				<input title="Open a view optimized for printing" type="button" value="Print view" onclick="printPage()" ontouchstart="printPage()" style="cursor:pointer"/>
				<input title="Open a PDF of the map image" type="button" value="PDF of map" onclick="window.open(getMapImagePdfUrl())" ontouchstart="window.open(getMapImagePdfUrl())" style="cursor:pointer"/>
				<input title="Get the full link to the current map display" type="button" value="Link to this page" onclick="showLinkToPage()" ontouchstart="showLinkToPage()" style="cursor:pointer"/>
			</form>
		</div>
	</div>
</div>
