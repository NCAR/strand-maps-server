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
							<input type="text" id="keywordBox" onFocus="clear_keywordbox()" name="keyword" class="inputText" value="Search term(s) - e.g., keywords, science topic, map title" />
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
				<ul id="smsMultiNav">
					<li><div class="smsMultiNavTopItem menuController" onmouseover="id_smsMultiNavTopItem.toggleClassName('smsMultiNavTopItem_hover')" onmouseout="id_smsMultiNavTopItem.toggleClassName('smsMultiNavTopItem_hover')" id="id_smsMultiNavTopItem"><img src="@GLOBAL_CONTEXT_URL@/jsapi/api_v1/strand_selector/images/arrows/menu-open.gif" class="smsMultiNavArrow smsTopItemArrow" />Browse Topics</div>
					    <ul class="menuClosed" id='id_nav_menu'>
					        <%@ include file="chapters_maps_list.jsp" %>
					    </ul>
					</li>
				</ul>
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
			<a href='javascript:printPage()' title="Open a view optimized for printing">Print view</a>
			<a href='javascript:pageToPdf()' title="Open a PDF of the map image">PDF of map</a>
			<a href='javascript:showLinkToPage()' title="Get the full link to the current map display">Link to this page</a>
		</div>
	</div>
</div>
