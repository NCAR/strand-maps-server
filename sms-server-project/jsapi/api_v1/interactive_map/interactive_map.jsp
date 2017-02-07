<%@ include file="/jsapi/TagLibIncludes.jsp" %>
<c:set var="baseUrl" value="@GLOBAL_CONTEXT_URL@/jsapi/api_v1/interactive_map"/>

<div id="smsMisconceptions" style="display:none;"><div id="smsMisconceptionsData"></div></div>
<div id="smsMisconceptionsLinkHolder" onclick="toggleMisconceptions()" ontouchstart="toggleMisconceptions()" style="display:none;"><div class="misconceptionLinkClosed"><a href="javascript:void(0)" id="smsMisconceptionsLink">View Research on Student Learning</a></div></div>
<div id="viewableMap" style="width:600px; height:600px;">
	<div style="display:none" id="linkToPage">
		<div>Paste link in <b>email</b> to share this view of the map</div>
		<div><input type="text" size="55" id="linkToPageUrlBox"/></div>
		<div><a id="linkToPageUrl" href="">Open link</a></div>
		<!-- 
		<div id="linkToPageClose" onclick="hideLinkToPage();enableViewableMapEvents();" ontouchstart="hideLinkToPage();enableViewableMapEvents();"></div>
		-->
		
		<div ontouchstart="hideLinkToPage();enableViewableMapEvents();" style="top:-6; right:-6; height:40; width:40; position:absolute; border: 0px none; margin: 0px; padding: 0px;">
			<div id="_link_to_page_close" class="closeOut" onmouseover="$('_link_to_page_close').addClassName('closeOver');" onmouseout="$('_link_to_page_close').removeClassName('closeOver');" onclick="hideLinkToPage();enableViewableMapEvents();"  style="top:16; left:13; height:14; width:14; position:relative;border: 0px none; margin: 0px; padding: 0px;"></div>
		</div>
	</div>
	<div id="mapLoadingMsg" style="position: absolute; z-index:200; top: 26; left: 20; font-size: 12pt; color: #666666;">
		<div id="mapLdImg" style="display:none">
			<img src="@GLOBAL_CONTEXT_URL@/jsapi/api_v1/interactive_map/images/spinner.gif" onload="$('mapLdImg').show();"/> &nbsp;Loading...
		</div>
	</div>
	<div id="wholeMap" style="width:600px; height:600px;">
		<div id="_co" style="width:260px; height:260px; z-index: 5; display: none; position: absolute; overflow:hidden; cursor: auto;">		
			<!-- The four corners -->
			<div id="_co_top_left" class="calloutImgFrame" style="width: 25px; height: 25px; left: 0px; top: 0px;">
				<div class="calloutImg" style="left: 0; top: 0;"></div>
			</div>
			<div id="_co_top_right" class="calloutImgFrame" style="width: 35px; height: 25px; right: 0px; top: 0px;">
				<div class="calloutImg" style="left: -680; top: 0; "></div>
			</div>								
			<div id="_co_bottom_left" class="calloutImgFrame" style="width: 25px; height: 35px; left: 0px; bottom: 30px;">
				<div class="calloutImg" style="left: 0; top: -680;"></div>
			</div>			
				<div id="_co_bottom_right" class="calloutImgFrame" style="width: 35px; height: 35px; right: 0px; bottom: 30px;">
				<div class="calloutImg" style="left: -680; top: -680; "></div>
			</div>

			<!-- Top -->
			<div id="_co_top_border" class="calloutImgFrame" style="left: 25px; width: 300px; height:100%;">
				<div class="calloutImgFrame" style="left: 0; width: 1950px; height:100%;">				
					<div class="calloutImgFrame" style="width: 650px; height: 25px; left: 0px; top: 0px;">
						<div class="calloutImg" style="left: -25; top: 0;"></div>
					</div>
					<div class="calloutImgFrame" style="width: 650px; height: 25px; left: 650px; top: 0px;">
						<div class="calloutImg" style="left: -25; top: 0;"></div>
					</div>
					<div class="calloutImgFrame" style="width: 650px; height: 25px; left: 1300px; top: 0px;">
						<div class="calloutImg" style="left: -25; top: 0;"></div>
					</div>						
					
				</div>
			</div>
			
			<!-- Bottom (default callout view) -->
			<div id="_co_bottom_border" class="calloutImgFrame" style="left: 25px; width: 300px; height:100%;">
				<div class="calloutImgFrame" style="left: -1140; width: 2650px; height:100%;">
					<div class="calloutImgFrame" style="width: 650px; height: 35px; left: 0px; bottom: 30px;">
						<div class="calloutImg" style="left: -25; top: -680; "></div>
					</div>
					<div class="calloutImgFrame" style="width: 650px; height: 35px; left: 650px; bottom: 30px;">
						<div class="calloutImg" style="left: -25; top: -680; "></div>
					</div>						
					<!-- The callout graphic -->
					<div class="calloutImgFrame" style="width: 50px; height: 75px; left: 1300px; bottom: 0px;">
						<div class="calloutImg" style="left: -40; top: -716; "></div>
					</div>						
					<div class="calloutImgFrame" style="width: 650px; height: 35px; left: 1350px; bottom: 30px;">
						<div class="calloutImg" style="left: -25; top: -680; "></div>
					</div>
					<div class="calloutImgFrame" style="width: 650px; height: 35px; left: 2000px; bottom: 30px;">
						<div class="calloutImg" style="left: -25; top: -680; "></div>
					</div>						
				</div>
			</div>
			
			<!-- Left -->
			<div id="_co_left_border" class="calloutImgFrame" style="left: 0px; top: 25px; height: 170px; width:100%;">
				<div class="calloutImgFrame" style="top: 0; height: 1950px; width:100%;">				
					<div class="calloutImgFrame" style="width: 20px; height: 650px; left: 0px; top: 0px;">
						<div class="calloutImg" style="left: 0; top: -25; "></div>
					</div>
					<div class="calloutImgFrame" style="width: 20px; height: 650px; left: 0px; top: 650px;">
						<div class="calloutImg" style="left: 0; top: -25; "></div>
					</div>
					<div class="calloutImgFrame" style="width: 20px; height: 650px; left: 0px; top: 1300px;">
						<div class="calloutImg" style="left: 0; top: -25; "></div>
					</div>						
				</div>
			</div>
			
			<!-- Right -->
			<div id="_co_right_border" class="calloutImgFrame" style="right: 0px; top: 25px; height: 170px; width:100%;">
				<div class="calloutImgFrame" style="top: 0; height: 1950px; width:100%;">					
					<div class="calloutImgFrame" style="width: 35px; height: 650px; right: 0px; top: 0px;">
						<div class="calloutImg" style="left: -680; top: -25; "></div>
					</div>				
					<div class="calloutImgFrame" style="width: 35px; height: 650px; right: 0px; top: 650px;">
						<div class="calloutImg" style="left: -680; top: -25; "></div>
					</div>			
					<div class="calloutImgFrame" style="width: 35px; height: 650px; right: 0px; top: 1300px;">
						<div class="calloutImg" style="left: -680; top: -25; "></div>
					</div>
				</div>					
			</div>
		
			<!-- Middle background fill -->
			<div id="_co_middle" class="calloutImgFrame" style="background: #F3F3F3; left: 20px; top: 25px; height: 50; width: 50;"></div>
			
			<!-- Title -->
			<div id="_co_title" class="isLoading" style="font: 12px Geneva, Arial, Helvetica, sans-serif; font-weight: bold; top:4; left:12; height:16; width:100%; position:absolute; border: 0px none; margin: 0px; padding: 0px; overflow:hidden;">
				<span id="_co_title_content">&nbsp;</span>
			</div>					
			
			<!-- Close [X] -->
			<div ontouchstart="javascript:hideCallOut(null);enableViewableMapEvents();" style="top:-10; right:13; height:40; width:40; position:absolute; border: 0px none; margin: 0px; padding: 0px;">
				<div id="_co_close" class="closeOut" onclick="javascript:hideCallOut(null);" onmouseout="$('_co_close').removeClassName('closeOver');" onmouseover="$('_co_close').addClassName('closeOver');" style="top:16; left:13; height:14; width:14; position:relative;border: 0px none; margin: 0px; padding: 0px;"></div>
			</div>
			
			<!-- Content pane -->
			<div id="_co_content" style="left: 1; top: 24; overflow:auto; position:absolute; height:100px; width:100px;">
				<div id="_co_content_body" class="coContent"></div>
				<div id="_co_content_tabs" class="coContent"></div>
			</div>
		</div>
	
		<div style="position:absolute; width:100%; height:100%; z-index:2; background-image:url('${baseUrl}/images/transparent.gif');"></div>
		<div id="wholeMapTiles" style="display:none"></div>
	</div>		
</div>

<div id="navigatorArrows" style="position: absolute; top: 20px; right: 20px; width: 80; height: 80; overflow: hidden; z-index: 2; display: none;" onmouseout="stopPan()">
	<img style="position: absolute; left: 24px; top: 0px; cursor:pointer;" src="@GLOBAL_CONTEXT_URL@/jsapi/api_v1/interactive_map/images/up.gif" width="25" height"25" border="0" onmousedown="pan('up')" onmouseup="stopPan()" alt="Pan up" title="Pan up"/>
	<img style="position: absolute; left: 24px; top: 34px; cursor:pointer;" src="@GLOBAL_CONTEXT_URL@/jsapi/api_v1/interactive_map/images/down.gif" width="25" height"25" border="0" onmousedown="pan('down')" onmouseup="stopPan()" alt="Pan down" title="Pan down"/>
	<img style="position: absolute; left: 0px; top: 17px; cursor:pointer;" src="@GLOBAL_CONTEXT_URL@/jsapi/api_v1/interactive_map/images/left.gif" width="25" height"25" border="0" onmousedown="pan('left')" onmouseup="stopPan()" alt="Pan left" title="Pan left"/>
	<img style="position: absolute; left: 48px; top: 17px; cursor:pointer;" src="@GLOBAL_CONTEXT_URL@/jsapi/api_v1/interactive_map/images/right.gif" width="25" height"25" border="0" onmousedown="pan('right')" onmouseup="stopPan()" alt="Pan right" title="Pan right"/>
</div>

<div id="navigatorPane" style="border-top: 1px solid #888888; border-left: 1px solid #888888; position: relative; right: 0px; bottom: 0px; overflow: hidden; display: none;">
	<div id="viewableNavMap" style="border: 1px solid #888888; margin: 0px; padding: 0px; position: absolute; right: 0px; bottom: 0px; background: #ffffff; overflow: hidden;">
		<div id="navImage" style="border:0px; margin: 0px; padding: 0px; position: absolute; overflow: hidden;"></div>
		
		<div id="navOverlay" style="position: absolute; z-index: 50;">
			<div id="navOverlayBorder1" style="position: absolute; left: 1px; top: 1px; filter: alpha(opacity=70); border-style: solid; border-width: 1px;">
				<div id="navOverlayBorder2" style="overflow: hidden; ">
					<div id="navOverlayFill" style="filter: alpha(opacity=15); opacity: 0.15;"></div>
				</div>
			</div>
		</div>			
	</div>			
</div>

<div id="cachedResources" style="display: none">
	<img src="@GLOBAL_CONTEXT_URL@/jsapi/api_v1/interactive_map/images/callout-bg-top-bar.png"
		style="cursor: url('@GLOBAL_CONTEXT_URL@/jsapi/api_v1/interactive_map/images/grabbing.cur'), move;"/>
	<img src="@GLOBAL_CONTEXT_URL@/jsapi/api_v1/interactive_map/images/buttons/close.gif"
		style="cursor: url('@GLOBAL_CONTEXT_URL@/jsapi/api_v1/interactive_map/images/grab.cur'), move;"/>
	<img src="@GLOBAL_CONTEXT_URL@/jsapi/api_v1/interactive_map/images/transparent.gif"/>
	<img src="@GLOBAL_CONTEXT_URL@/jsapi/api_v1/interactive_map/images/arrow_right_gray.gif"/>
	<img src="@GLOBAL_CONTEXT_URL@/jsapi/api_v1/interactive_map/images/arrow_down_gray.gif"/>
</div>

<script type="text/javascript">
	var bgClass = 'calloutImgBG';
	if(browser.isIE6down)
		bgClass = 'calloutImgBGIE6Down';		

	$$('.calloutImg').each(function(el) {
		el.addClassName(bgClass);	
	});
</script>
