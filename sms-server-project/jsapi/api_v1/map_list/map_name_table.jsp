<%-- Included from map_list/index.jsp Set vars mapDoc, mapName, currentCount first... --%>
<c:set var="tabId" value="map-tab-${currentCount}"/>
<table id="${tabId}"
	class="mapTable" 
	onmouseover="JavaScript:onMapTableOver('${tabId}');"
	onmouseout="JavaScript:onMapTableOut('${tabId}');"
	onmouseup="JavaScript:window.location='${link}';">
	<tr>
		<td class="mapCell" align="left" valign="middle">
			<div><a class="mapTitle" href="${link}">${mapName}</a></div>
			<div>
				<ul>
					<x:forEach select="$mapDoc//itemRecord">
						<li><x:out select="Data/Name"/></li>											
					</x:forEach>
				</ul>
			</div>									
		</td>
	</tr>
</table>
