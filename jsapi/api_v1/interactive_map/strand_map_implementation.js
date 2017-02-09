// Interactive Strand Map Viewer, AJAX implementation

// Sizing options for the CallOut bubble
var maxCallOutW = 650;	
var maxCallOutH = 600;
var minCallOutH = 180;
var minCallOutW = 300;
var minViewableW = 750;

// How far off the edge of the real map can we go?
var mapPadding = 100;
var showPaddingInNav = true;

var hideNavWithCallOut = false;

var wholeMapTop = 0;
var wholeMapLeft = 0;

var iAmDragging = false;
var	iAmDraggingOverlay = false;
var dragStartX = 0;
var dragStartY = 0;

var rowMode = 'locked';
var columnMode = 'locked';

// These vars are set dynamically with setMapImage()
var tileWidth = 10;
var tileHeight = 10;

var maxMapWidth = 10;
var maxMapHeight = 10;

// Column and row count must be odd numbers (provides padding around the edges...):
var wholeMapColumnCount = 5; 
var wholeMapRowCount = 5;
var mapImagePath = '';

var imageExt = "PNG";
var navImageScale = 7; // % of total

// Zoom level 0 is navigator view

// Zoom levels as a percentage of map image size from 1 to 200%:
var zoomLevel = 3;
var maxZoom = 3;
var minZoom = 1;

// Use scriptaculous effects?
var useEffects = false;

// The map we're currently viewing
var _mapid = null;
var _parentIds = null;
var _bmIds = null;
var _textIds = null;
var _asnId = null;
var mapColor = 'E2E8F6';
var highlightColor = 'E2E8F6';

var parms = window.location.search.parseQuery();
// if provided the asnid, get the id and bmid before including maps-impl
if(typeof(parms.asnid) != 'undefined' && typeof(parms.id) == 'undefined'){
		_asnid = parms.asnid;
		// from here retrieve that bm id for this asn ID
		// Get the map data in var map_json:
		var myUrl = baseJsapiUrl+'/json?callBack=processSMSFromASNJson&Format=SMS-JSON&ASNID='+_asnid;
		var mapScriptReq = document.createElement( 'script' );
		mapScriptReq.src = myUrl;
				    
		// Insert the script, callback method processMapJson()
		document.getElementsByTagName('head')[0].appendChild( mapScriptReq );	
} else if(typeof(parms.bm) != 'undefined' && typeof(parms.id) == 'undefined'){
	
	var _bmId = parms.bm;
	// from here retrieve that map id for this bm ID
	// Get the map data in var map_json:
	var myUrl = baseJsapiUrl+'/json?callBack=processSMSFromASNJson&Format=SMS-JSON&ObjectID='+_bmId;
	var mapScriptReq = document.createElement( 'script' );
	mapScriptReq.src = myUrl;
				    
	// Insert the script, callback method processMapJson()
	document.getElementsByTagName('head')[0].appendChild( mapScriptReq );	
}
if(browser.isGecko) {
	var grabCursorStyle = 'grabMoz';
	var grabbingCursorStyle = 'grabbingMoz';
}
else {
	var grabCursorStyle = 'grabIm';
	var grabbingCursorStyle = 'grabbingIm';
}
function onPageLoad() {
    // retrieve sms ids if asn id was provided and regular id is empty
    waitForLoad();
}

/* This wait for load is a fix for an Internet Explorer issue when only asid or bm is sent in
 * in this case the code needs to fetch the asn/bm map first then load the page. Ie would try
 * to call loadSMS before the map and strand selector were loaded. Waiting 2 seconds seems to 
 * work the best in this case
 * */
function waitForLoad()
{
    if(typeof(mapHtml) == 'undefined')
    {
            setTimeout(waitForLoad, 2000);
    }
    else
    {       
            loadSMS();
    }
}
function loadSMS() {
	
	var strandMap = $('strandMap');
    var strandSelector = $('strandSelector');

	if(strandSelector && !isPrintView()) {
		// here check for specialty strand selector options
		if(strandSelector.getAttribute("multiselect") == "true"){
			strandSelector.update(strandSelectorHtmlMulti);
		} else {
			strandSelector.update(strandSelectorHtml);
		}
		
		if( strandMap ) {
			var w = strandMap.getAttribute("mapWidth");
			if(w){
				frameWidth = Math.abs(w);
				var geckoOs = (browser.isGecko ? 2 : 0);
				if( frameWidth > 0 ) {
					if( $('smsMapTitleBar') )
						$('smsMapTitleBar').setStyle( { width: frameWidth} );
					if( $('smsNavigation') )
						$('smsNavigation').setStyle( { width: frameWidth} );
					if( $('strandSelector') )
						$('strandSelector').setStyle( { width: frameWidth} );
					if( $('customHeader') )
						$('customHeader').setStyle( { width: frameWidth} );
					
					frameWidth = frameWidth + geckoOs;
					if( $('strandMap') ) 
						$('strandMap').setStyle( { width: frameWidth } );
					//if( $('defaultContent') )
						//$('defaultContent').setStyle( { width: frameWidth } );
				}
			}
		}
		
		onPageLoadSelector();	
	}
	var defaultContent = $('defaultContent');	
	
	if(strandMap) {
		var c = strandMap.getAttribute("mapColor");
		
		if(c != null)
			mapColor = c;
		if(mapColor.startsWith('#'))
			mapColor = mapColor.substring(1,mapColor.length);
		highlightColor = mapColor;
		var hc = strandMap.getAttribute("highlightColor");
		if(hc != null)
			highlightColor = hc;
		if(highlightColor.startsWith('#'))
			highlightColor = highlightColor.substring(1,highlightColor.length);		
				
		strandMap.update(mapHtml);
		var search = window.location.search;
		
		// If no dynamic content is to be displayed, display the default content
		if(	search == null || 
			(((typeof(parms.id) == 'undefined')) &&
			(search.indexOf('?chapter') == -1) && 
			(search.indexOf('?keyword') == -1) )) {
			if(defaultContent)
				defaultContent.show();
			strandMap.hide();
		}			
		
		// If the map is being displayed...
		if(typeof(parms.id) != 'undefined'){
			_mapid = parms.id;
			
		}
		// If a map listing is being displayed...
		else
			return;
	}
	else {
		if(defaultContent)
			defaultContent.show();		
		return;
	}
	
	if(isPrintView())
		return renderPrintView();
	
	if(	browser.isIE6up ||
		(browser.isGecko && !browser.isLinux )|| 
		browser.isSafari )
		useEffects = true;

	CallOut.onHide( onCallOutHide );
	CallOut.onShow( onCallOutShow );

	// Render the map title, clickable boxes, etc
	renderMapInfo();

}


function loadStrandMapEvent(){
	// Move map with arrow keys
	Event.observe(document,'keydown', function(event){
		if(event.keyCode == Event.KEY_LEFT || event.keyCode == Event.KEY_DOWN || event.keyCode == Event.KEY_UP || event.keyCode == Event.KEY_RIGHT){
			var keywordBox = $('keywordBox');
			if(keywordBox)
				keywordBox.blur();			
			if(event.keyCode == Event.KEY_LEFT)
				pan('left');
			else if(event.keyCode == Event.KEY_DOWN)
				pan('down');
			else if(event.keyCode == Event.KEY_UP)
				pan('up');
			else if(event.keyCode == Event.KEY_RIGHT)
				pan('right');
			stopPan();
		}
	});	
}
function showLinkToPage() {
	if($('linkToPageUrlBox')) {
		if(StrandMap.getEnabledNavigatorArrows() && $('navigatorArrows'))
			$('navigatorArrows').hide();
		$('linkToPageUrlBox').value = window.location.protocol + '//' + window.location.host + window.location.pathname + getPageUrl();
		$('linkToPageUrl').href = getPageUrl();
		if($('linkToPage').visible())
		{
			hideLinkToPage();
			enableViewableMapEvents();
		}
		else {
			disableViewableMapEvents();
			if(isMisconceptionsDown)
				toggleMisconceptions();		
			$('linkToPage').show();
		}
		$('linkToPageUrlBox').select();
		$('linkToPageUrlBox').focus();
	}
}

function hideLinkToPage() {
	if($('linkToPage')) {
		$('linkToPage').hide();
		if(StrandMap.getEnabledNavigatorArrows() && $('navigatorArrows'))
			$('navigatorArrows').show();		
	}
}

function getPageUrl(){
	var url = "";
	if(_mapid){
		url = "?id=" + _mapid;
		if(parms.parentmap)
			url = url + "&parentmap=" + parms.parentmap;
		var bm = StrandMap._selectedBenchmarkId;
		if(!CallOut.isHidden() && bm != null)
			url = url + "&bm=" + bm;
	}
	else
		url = window.location.search;	
	return url;
}

function isPrintView(){
	return (parms.view == 'print');
}

function printPage(){
	if(_mapid == null) {
		window.print();
		return;
	}
	window.location = getPageUrl() + "&view=print";
}

function pageToPdf(){
	window.open( getMapImagePdfUrl())
}

function performPrint() {
	if(browser.isSafari)
		alert("To print, choose print from the menu above");
	else
		window.print();
}

function setCustomPrintViewContent(content) {
	if( $('customPrintContent') ) 
		$('customPrintContent').update( (content == null ? '' : content) );
}

function renderPrintView() {
	if(typeof(parms.bm) != 'undefined')
		StrandMap._selectedBenchmarkId = parms.bm;
	StrandMap._fireEvent("onprintviewdisplay");	
	
	$$('body').each( function(elm) {
		elm.setStyle({backgroundColor:'#fff'}); 
	}); 
	
	if($('customHeader'))
		$('customHeader').hide();
	if($('strandSelector'))
		$('strandSelector').hide();
	var printViewHeading = $('printViewHeading');
	setTitle(_mapSmsJson,'printViewHeading');
	
	$('mapImg').src = getMapImageUrl();
	$('mapImg').setStyle(calcImgPrintDims(mapSvgJson));
	
	Event.observe('mapPdfButton', 'click', function() {
		window.open(getMapImagePdfUrl());
	});
	
	var misconceptionHtml = StrandMap.getMisconceptionsHtml();
	if(misconceptionHtml != null) {
		$('misconceptionsText').update('<div style="padding-top:25; padding-bottom:10;"></div>' + misconceptionHtml);
	}
	
	var bmHtml = StrandMap.getSelectedBenchmarkHtml(true);
	if(bmHtml != null){
		if($('relatedBenchmarkImg'))
			$('relatedBenchmarkImg').src = getBmImageUrl(parms.bm);
		$('benchmarkText').update('<div style="padding-top:25; padding-bottom:10;"><div class="pvHeading">Selected Benchmark</div></div>' + bmHtml);
	
		if(_nsdlalignedTab){
			var nsdlAlignedHtml = StrandMap.getNsdlAlignedResources('0','print');	
		}	
		if(_nsdlrelatedTab){
			var nsdlRelatedHtml = StrandMap.getNsdlRelatedResources('0','print');	
		}	
		if(_aaasassessmentTab){
			var aaasAssessmentHtml = StrandMap.getAaasAssessment('print');	
		}	
		if(_aaasmisconceptionTab){
			var aaasMisconceptionHtml = StrandMap.getAaasMisconception('print');	
		}
	}	
	
	var relatedBenchmarkImg = $('relatedBenchmarkImg');
	var imgCount = 1;
	var numloaded = 0;
	var onImgLoad = function() {
		numloaded++;
		if(imgCount == numloaded) {
			$('printContent').show();
			$('printLoadMsg').hide();
			//new Insertion.After('printContent', '<img onload="window.print();" src="@GLOBAL_CONTEXT_URL@/jsapi/api_v1/interactive_map/images/transparent.gif"/>');
		}
	}
	Event.observe('mapImg', 'load', onImgLoad, false);
	if(relatedBenchmarkImg){
		relatedBenchmarkImg.setStyle(calcImgPrintDims(bmSvgJson));
		imgCount++;
		Event.observe(relatedBenchmarkImg, 'load', onImgLoad, false);
	}
	

}

function calcImgPrintDims(svgJson){
	var maxW = 650;
	var maxH = 900;
	var w = Math.floor(svgJson.svg.width);
	var h = Math.floor(svgJson.svg.height);
	w = calcImgWidth(w);
	if(w > maxW){
		h = Math.floor( h*(maxW/w) );
		w = maxW;
	}
	if(h > maxH){
		w = Math.floor( w*(maxH/h) );
		h = maxH;
	}
	return {width:w,height:h}
}

function setMouseWheelListener(isListening) {
	if(isListening)
		var fn = Event.observe;
	else
		var fn = Event.stopObserving;	
	
	if(browser.isIE || browser.isSafari)
		fn('viewableMap', 'mousewheel', mousewheel, false);
	else if(browser.isFirefox)
		fn('viewableMap', 'DOMMouseScroll', mousewheel, false);
}

function enableViewableMapEvents(event) { doViewableMapEvents(event,true); }
function disableViewableMapEvents(event) { doViewableMapEvents(event,false); }
function doViewableMapEvents(event,isEnabled) {
	if(event)
		Event.stop(event);
	
	if(isEnabled)
		var fn = Event.observe;
	else
		var fn = Event.stopObserving;
	
	// These are events for mobile devices, which will be ignored on regular sites
    fn('viewableMap', 'touchstart', startDrag, false);
    fn('viewableMap', 'touchmove', dragging, false);
    fn('viewableMap', 'touchend', stopDrag, false);
    fn('viewableMap', 'touchstart', hideCallOut, false);
    fn('viewableMap', 'touchend', hideCallOut, false);
	
    // These are the events for a regular browser, which will be ignore on mobile
	fn('viewableMap', 'mouseover', startDragable, false);	
	fn('viewableMap', 'mousedown', startDrag, false);
	fn('viewableMap', 'mousemove', dragging, false);
	fn('viewableMap', 'mouseup', stopDrag, false);
	fn('viewableMap', 'mouseout', stopDrag, false);
	
	fn('viewableMap', 'mousedown', hideCallOut, false);
	fn('viewableMap', 'mouseup', hideCallOut, false);

	fn('viewableMap', 'mouseover', stopDragOverlay, false);
}

function eventDoneOnTouchScreen(event)
{
	try
	{
		return event.hasOwnProperty('changedTouches');
	}
	catch(err)
	{
		// Old browsers don't have hasOwnProperty therefore we just assume its
		// not touch screen
		return false
	}
}

function getEventX(event)
{
	if(eventDoneOnTouchScreen(event))
		return event.changedTouches[0].pageX
	else
		return Event.pointerX(event);
}
function getEventY(event)
{
	if(eventDoneOnTouchScreen(event))
		return event.changedTouches[0].pageY
	else
		return Event.pointerY(event);
}

function setMapImage(w,h,path) {
	//debug('setMapImage(): w:' + w + ' h:' + h + ' path:' + path);
	tileWidth = w;
	tileHeight = h;
	maxMapWidth = w+mapPadding*2;
	maxMapHeight = h+mapPadding*2;	
	mapImagePath = path;
	setWholeMapSize();	
}

// Set the size of the map image:
function setWholeMapSize() {
   var wholeMap = $('wholeMap');
   wholeMap.style.width = (wholeMapColumnCount * tileWidth);
   wholeMap.style.height = (wholeMapRowCount * tileHeight);
}

function wholeMapHeightOffset(){
	return tileHeight*Math.floor(wholeMapRowCount/2);
}

function wholeMapWidthOffset(){
	return tileWidth*Math.floor(wholeMapColumnCount/2);
}

// Set the size of the viewable window over the map:
function setViewableMapSize() {
		
	var strandMap = $('strandMap');
	var viewableMap = $('viewableMap');
	var smsMapTitleBar = $('smsMapTitleBar');
	var smsNavigation = $('smsNavigation');
	var strandSelector = $('strandSelector');
	var smsMisconceptions = $('smsMisconceptions');
	var customHeader = $('customHeader');
	
	var dim = getFrameDimensions();
	frameWidth = dim.width;
	frameHeight = dim.height;
	
	if(frameWidth > maxMapWidth)
		frameWidth = maxMapWidth;
	if(frameHeight > maxMapHeight)
		frameHeight = maxMapHeight;	
	
	var origW = stripPx(viewableMap.style.width);
	var origH = stripPx(viewableMap.style.height);
	
	if( minViewableW > frameWidth )
		frameWidth = minViewableW;
	
	if( frameWidth > 0 && frameHeight > 0 ) {
		if(strandSelector){
			smsMapTitleBar.setStyle( { width: frameWidth} );
			smsNavigation.setStyle( { width: frameWidth } );	
			strandSelector.setStyle( { width: frameWidth } );
			if(customHeader)
				customHeader.setStyle( { width: frameWidth } );			
		}
		if(smsMisconceptions){
			smsMisconceptions.setStyle({ 	
				width: frameWidth
			});
		}
		viewableMap.setStyle({ 	
			width: frameWidth,
			height: frameHeight,
			top: '0',
			left: '0' 
		});
	}

	var geckoOs = (browser.isGecko ? 2 : 0);
	strandMap.style.width = viewableMap.getWidth() + geckoOs;
	strandMap.style.height = viewableMap.getHeight() + geckoOs;
	strandMap.style.top = stripPx(viewableMap.style.top);
	strandMap.style.left = stripPx(viewableMap.style.left);
	
	var wholeMap = $('wholeMap');
	if(wholeMap) {
		// Move the wholeMap to keep the CallOut visible
		if(!CallOut.isHidden()){
			var dx = origW - frameWidth;		
			var dy = origH - frameHeight;
			
			var newTop = stripPx(wholeMap.style.top) - dy;
			var newLeft = stripPx(wholeMap.style.left) - dx;
			moveWholeMapTo( newLeft, newTop );
			
			var curCoords = CallOut.getCoords();
			var newCoords = getMoveToCoords(curCoords.bottom.top - wholeMapHeightOffset(),curCoords.bottom.left - wholeMapWidthOffset());
			moveWholeMapTo( newCoords.left, newCoords.top );
		}
		
		checkBounds();
		calcVisibleTiles();
		positionNavigator();
		drawNavigatorOverlay();
		sizeCallout();
	}
}

function getFrameDimensions(){
	
	var offset = [ 0, 0 ];
	var viewableMap = $('viewableMap');
	var strandMap = $('strandMap');
	if(strandMap)
		offset = Position.cumulativeOffset(strandMap);
	
	// Size according to the window (versus fixed size set by user...):
	if (self.innerWidth)
	{
		var frameWidth = self.innerWidth - offset[0] - 20;
		var frameHeight = self.innerHeight - offset[1] - 20;
	}
	if (document.documentElement && document.documentElement.clientWidth && !browser.isSafari)
	{
		var frameWidth = document.documentElement.clientWidth - offset[0] - 20;
		var frameHeight = document.documentElement.clientHeight - offset[1] - 20;
	}
	if (document.body && !browser.isSafari)
	{
		var frameWidth = document.body.clientWidth - offset[0] - 20;
		var frameHeight = document.body.clientHeight - offset[1] - 20;
	}

	var h = strandMap.getAttribute("mapHeight");
	var w = strandMap.getAttribute("mapWidth");
	if(w && w != 'auto') {
		frameWidth = w;
		minViewableW = w;
	}
	frameHeight = (h && h != 'auto') ? h : frameHeight;
	
	return { "width": frameWidth, "height": frameHeight };
}

function renderMapInfo() {
	if(typeof(_mapSmsJson) != 'undefined'){
		return processSmsJson(_mapSmsJson);
	}
	
	// Get the map data in var map_json:
	var myUrl = baseJsapiUrl+'/json?callBack=processSmsJson&Format=SMS-JSON&ObjectID='+_mapid;
	var mapScriptReq = document.createElement( 'script' );
    mapScriptReq.src = myUrl;
    
	// Insert the script, callback method processMapJson()
	document.getElementsByTagName('head')[0].appendChild( mapScriptReq );		
}
function processMapFromASNJson( json ) {
	var parentID = null;

	var catIdNode = json["SMS-CSIP"].QueryResponse.SMS.Record.itemRecord.Data.InternalRelationship.CatalogID;
	if(typeof(catIdNode.length) == 'undefined'){
		if(catIdNode["RelationType"].toLowerCase() == 'is part of'){
			parentID = catIdNode["CatalogNumber"];	
		}
	} else {
		for(var i = 0; i < catIdNode.length; i++){
			if(catIdNode[i]["RelationType"].toLowerCase() == 'is part of'){
				parentID = catIdNode[i]["CatalogNumber"];	
				break;
			}
		}
	}
	parms.id = parentID;
	parms.asnid = null;
	//now that we have the map id, load maps-impl again with the correct id
	var myUrl = baseJsapiUrl+"/maps-impl?id="+parentID+"&bm="+parms.bm+"&api=v1";
    var mapScriptReq = document.createElement( 'script' );
	mapScriptReq.src = myUrl;
				    
	// Insert the script, callback method processMapJson()
	document.getElementsByTagName('head')[0].appendChild( mapScriptReq );	
	// try again
}

function processSMSFromASNJson( json ) {

	if(json["SMS-CSIP"].QueryResponse.SMS.Record.length > 1){
		var jsn = json["SMS-CSIP"].QueryResponse.SMS.Record[0];
	} else {
		var jsn = json["SMS-CSIP"].QueryResponse.SMS.Record;
	}
	if(jsn != undefined){
		var smsID = jsn.itemRecord.Admin.IDNumber;
		parms.bm = smsID;
		var parentID = null;
	
		var catIdNode = jsn.itemRecord.Data.InternalRelationship.CatalogID;
		if(typeof(catIdNode.length) == 'undefined'){
			if(catIdNode["@RelationType"].toLowerCase() == 'is part of'){
				parentID = catIdNode["@CatalogNumber"];	
			}
		} else {
			for(var i = 0; i < catIdNode.length; i++){
				if(catIdNode[i]["RelationType"].toLowerCase() == 'is part of'){
					parentID = catIdNode[i]["CatalogNumber"];	
					break;
				}
			}
		}
		// from here retrieve that bm id for this asn ID
		// Get the map data in var map_json:
		var myUrl = baseJsapiUrl+'/json?callBack=processMapFromASNJson&Format=SMS-JSON&ObjectID='+parentID;
		var mapScriptReq = document.createElement( 'script' );
		mapScriptReq.src = myUrl;
		// Insert the script, callback method processMapJson()
		document.getElementsByTagName('head')[0].appendChild( mapScriptReq );	
		
		var strandMap = $('strandMap');
		if(strandMap){
			var msg = "<div style=\"padding:20px;background-color:#ffffff;border:1px solid #888888;\">"+
			"<img src=\""+baseJsapiUrl+"/api_v1/interactive_map/images/spinner.gif\" /> Retrieving map...</div>";
			strandMap.update(msg);
		}
	} else {
		// this item could not be resolved, so let the user know what happened.
		var strandMap = $('strandMap');
		if(strandMap){
			var msg = "<div style=\"padding:20px;background-color:#ffffff;border:1px solid #888888;\">The ASN ID provided does not match a AAAS Benchmark in our application.</div>";
			strandMap.update(msg);
		}
	}
}

function setTitle( smsJson, headingEle ){
	if(typeof(smsJson) != 'undefined'){
		var data = smsJson.itemRecord.Data;
		var title = data.Name;
		var heading = $(headingEle);
		if(data.ObjectType == 'Benchmark' || data.ObjectType == 'benchmark'){
			if(heading)
				heading.update('Related benchmarks for: <span class="breadcrumb">' + title + '</span>');
			document.title = document.title + ': Related benchmarks for: ' + title;
		}
		else if(data.ObjectType.toLowerCase() == 'strand' || data.ObjectType.toLowerCase() == 'grade group'){
			var mapLinked = '';
			var mapTitle = '';
			if(typeof(greatgrandparentJson) != 'undefined'){
				mapLinked = '<span class="breadcrumb linkable_breadcrumb"><a href="?chapter=' + greatgrandparentJson.ObjectID + '">' + greatgrandparentJson.Name + '</a></span> &gt;  ';
			}
			if(typeof(parentJson) != 'undefined'){
				mapLinked = mapLinked + '<span class="breadcrumb linkable_breadcrumb"><a href="?id=' + parentJson.ObjectID + '">' + parentJson.Name + '</a></span> &gt;  ';
			}
			if(heading)
				heading.update(mapLinked + '<span class="breadcrumb"> ' + title + '</span>');
			document.title = document.title + ': ' + title;
		}
		else {
			var cpt = '';
			var chapter = '';
			if(typeof(grandparentJson) != 'undefined'){
				cpt = '<span class="breadcrumb linkable_breadcrumb"><a href="?chapter=' + grandparentJson.ObjectID + '">' + grandparentJson.Name + '</a></span> &gt;  ';	
			}
			if(heading)
				heading.update(cpt + '<span class="breadcrumb"> ' + title + '</span>');
			document.title = document.title + ': ' + title;
		}		
	}
}

function setTitleBar( content ) {
	var smsMapTitleBarContent = $('smsMapTitleBarContent');
	if(smsMapTitleBarContent)
		smsMapTitleBarContent.update(content);	
}

function processSmsJson( json ) {
	
	_parentIds = new Array();
	var catIdNode = json.itemRecord.Data.InternalRelationship.CatalogID;

	if(typeof(catIdNode.length) == 'undefined')
		addParentId(catIdNode);
	else
		for(var i = 0; i < catIdNode.length; i++)
			addParentId(catIdNode[i]);	
	setTitle(json,'smsMapTitleBarContent');
	
	// Render the map images and clickable regions:
	renderInteractiveMap();
}
function addParentId( catIdNode ) {
	if(catIdNode.RelationType.toLowerCase() == 'is part of')
		_parentIds[_parentIds.length] = catIdNode.CatalogNumber;	
}

function renderInteractiveMap() {
	if(typeof(mapSvgJson) != 'undefined'){
		return processMapJson(mapSvgJson);	
	}
	
	// Get the map data in var map_json:
	var myUrl = baseJsapiUrl+'/json?callBack=processMapJson&Format=SVG-JSON&ConceptSize=4&ObjectID='+_mapid;
	var mapScriptReq = document.createElement( 'script' );
    mapScriptReq.src = myUrl;
    
	// Insert the script, callback method processMapJson()
	document.getElementsByTagName('head')[0].appendChild( mapScriptReq );	
}

function processMapJson(map_json) {
	try{
		if(map_json) {
			var w = Math.floor(map_json.svg.width);
			if(w+(mapPadding*2) < minViewableW)
				mapPadding = Math.abs( (minViewableW - w)/2 );
			
			renderMap(w, Math.floor(map_json.svg.height));
		}
		else
			alert("processMapJson no map_json!");
	} catch (error) {
		alert("processMapJson() error caught: " + error);
	}
	
	loadStrandMapEvent();
}

function renderMapRegions(){
	if(typeof(mapSvgJson) != 'undefined') {
		_bmIds = new Array();
		mapSvgJson.svg.g.g.each( renderMapRegion );
	}	
}

function renderTextRegions(){
	_textIds = new Array();
	if(typeof(mapSvgJson) != 'undefined' && typeof(mapSvgJson.svg.g.text)!= 'undefined') {
		if(mapSvgJson.svg.g.text instanceof Array)
			mapSvgJson.svg.g.text.each( renderTextRegion );
		else
			renderTextRegion(mapSvgJson.svg.g.text)
	}	
}

function getRegionCoords(rect){
	var xOff = 136;
	var yOff = 36;
	
	if(_mapid.indexOf('SMS-BMK') != -1) {
		 xOff = -4;
		 yOff = 26;
	}
	var t = Math.floor(rect.y) + yOff;
	var l = Math.floor(rect.x) + xOff;
	var w = Math.floor(rect.width) + 5;
	var h = Math.floor(rect.height) + 4;
	return { top: t, left: l, width: w, height: h };	
}

function renderMapRegion(g){
	var id = g.OID;
		
	_bmIds[_bmIds.length] = id;
	var coords = getRegionCoords(g.rect);
		
	var regionElement =
        '<div ' +
        ' id="region-' + id + '"' +
        ' ontouchend="JavaScript:renderCallOut(' + coords.top + ',' + coords.left + ', \'' + id + '\')"' +
        ' onclick="JavaScript:renderCallOut(' + coords.top + ',' + coords.left + ', \'' + id + '\')"' +
        ' onmouseover="this.style.opacity=1;this.style.borderWidth=\'2px\';"' +
        ' onmouseout="this.style.opacity=0;this.style.borderWidth=\'0px\';"' +
        ' style="cursor:pointer; border-color: ' + highlightColor + '; border-radius: 15px; border-width: 0px; position:absolute; width:'+ coords.width + 'px; height:' + coords.height + 'px; left:' + (coords.left + wholeMapWidthOffset()) + 'px; top:' + (coords.top  + wholeMapHeightOffset() )  + 'px; z-index:4; ' +
        ' border-style: solid; opacity:0' + '">' +
        '</div>';
		
	new Insertion.Top('wholeMap',regionElement);
	Event.observe('region-' + id, 'touchstart', disableViewableMapEvents, false);
	//Event.observe('region-' + id, 'mouseout', enableViewableMapEvents, false);
}


// This is used to show the the bottom border for the divs that contain the strand names and grade names, We
// Had to do it this way instead of per div. Since strand names can wrap, and the wrapping is done by a new line
// in svg. Therefore there is a div per line. Doing this allows us to show the bottom border for all lines of a strand
// id
function headerHoverToggle(id)
{
	$$('.region-'+id).each( function(elm) {elm.toggleClassName('header_hover');elm.toggleClassName('header_hover_off');})
}

function renderTextRegion(text){

	
	var id = text.OID;
	if(typeof(id)=='undefined')
	{
		return
	}
	_textIds[_textIds.length] = id;
	text.y = text.y - Math.round(text.height/2)-2
	text.height = text.height - 5
	var coords = getRegionCoords(text);
	if(!$('region-' + id))
		html_id = 'region-' + id
	else
		html_id = 'region-' + id + text.y;
	var regionElement =
		'<div ' +
		' id="' + html_id+'"' +
		' class="header_hover_off region-' + id + '"' +
		' ontouchend="JavaScript:loadMap(\''+ id+'\')"' +
		' onclick="JavaScript:loadMap(\''+ id+'\')"' +			
		' onmouseover="JavaScript:headerHoverToggle(\''+ id+'\')"' +
		' onmouseout="JavaScript:headerHoverToggle(\''+ id+'\')"' +
		' style="cursor:pointer; border-color: ' + highlightColor + '; position:absolute; width:'+ coords.width + 'px; height:' + coords.height + 'px; left:' + (coords.left + wholeMapWidthOffset()) + 'px; top:' + (coords.top  + wholeMapHeightOffset() )  + 'px; z-index:4; ' +
		'border-style: solid; ">' +
		'</div>';
	
		
	new Insertion.Top('wholeMap',regionElement);
	Event.observe(html_id, 'touchstart', disableViewableMapEvents, false);
	//Event.observe('region-' + id, 'mouseout', enableViewableMapEvents, false);
}

function loadMap(oid)
{
	window.location.href = "?id="+oid
}
// Convert from SVG width to actual JPEG width
function calcImgWidth(w){
	w+=140;
	if(w<650)
		w=650;
	return w;	
}

function getMapImageUrl(){
	return baseJsapiUrl + "/map_images/" + mapColor + "/" + conceptSize + "/100/" + _mapid + "." + imageExt;	
}
function getMapImagePdfUrl(){
	return baseJsapiUrl + "/map_images/" + mapColor + "/" + conceptSize + "/100/" + _mapid + ".PDF";	
}
function getNavImageUrl(){
	return baseJsapiUrl + "/map_images/" + mapColor + "/" + conceptSize + "/" + navImageScale + "/" + _mapid + "." + imageExt;
}
function getBmImageUrl(bmId){
	return baseJsapiUrl+'/map_images/' + mapColor + '/' + conceptSize + '/100/' + bmId + '.' + imageExt;
}

function renderMap(w,h){
	w = calcImgWidth(w);
	setMapImage(w,h, getMapImageUrl() );	
	setNavigatorImage(Math.ceil(w*navImageScale/100), Math.ceil(h*navImageScale/100), getNavImageUrl() );
	var wholeMap = $('wholeMap');
	wholeMap.style.top = 0;
	wholeMap.style.left = 0;
		
	calcVisibleTiles();
	
	var strandMapParent = $('strandMap').parentNode.parentNode;
	
	// Events on the main map:	
	enableViewableMapEvents();

	// Setting up events on the navigator section of the screen
	
	// Events for mobile touch devices
	Event.observe('navigatorPane', 'touchstart', disableViewableMapEvents, false);
	Event.observe('navigatorPane', 'touchend', enableViewableMapEvents, false);
	
	//Event.observe(CallOut.getCallOutElement(), 'touchstart', disableViewableMapEvents, false);
	//Event.observe(CallOut.getCallOutElement(), 'touchend', enableViewableMapEvents, false);

	Event.observe('navOverlay', 'touchstart', startDragOverlay, false);
	Event.observe('navOverlay', 'touchend', mouseoutDragOverlay, false);
	Event.observe('navigatorPane', 'touchstart', mouseoutDragOverlay, false);		
	Event.observe('navigatorPane', 'touchmove', draggingOverlay, false);
	Event.observe(strandMapParent, 'touchend', stopDragOverlay, false);

	// Events for a regular browser 
	Event.observe('navigatorPane', 'mouseover', disableViewableMapEvents, false);
	Event.observe('navigatorPane', 'mouseout', enableViewableMapEvents, false);
	
	Event.observe(CallOut.getCallOutElement(), 'mouseover', disableViewableMapEvents, false);
	Event.observe(CallOut.getCallOutElement(), 'mouseout', enableViewableMapEvents, false);
	
	Event.observe('navOverlay', 'mouseover', startDragableOverlay, false);
	Event.observe('navOverlay', 'mousedown', startDragOverlay, false);
	Event.observe('navOverlay', 'mouseout', mouseoutDragOverlay, false);
	Event.observe('navigatorPane', 'mouseover', mouseoutDragOverlay, false);		
	Event.observe('navigatorPane', 'mousemove', draggingOverlay, false);
	Event.observe(strandMapParent, 'mouseup', stopDragOverlay, false);
	Event.observe(strandMapParent, 'mouseover', stopDragOverlay, false);
	
	setMouseWheelListener(true);
	
	Event.observe(window, 'resize', setViewableMapSize, false);
	
	setViewableMapSize();
	
	moveWholeMapTo( -wholeMapWidthOffset(), -wholeMapHeightOffset() );
}

var img_count = 0;
function onMapImageLoad() {
	img_count++;
	if(img_count == 2) {
		if($('smsMapTitleBarRight'))
			$('smsMapTitleBarRight').show();		
		$('navigatorPane').show();
		if(StrandMap.getEnabledNavigatorArrows())
			$('navigatorArrows').show();
		$('wholeMapTiles').show();
		renderMapRegions();
		
		renderTextRegions();
		$('mapLoadingMsg').hide();

		// If a benchmark is open...
		if(typeof(parms.bm) != 'undefined')
			openCallOutOnBenchmark(parms.bm);
		
		checkBounds();
		calcVisibleTiles();
		positionNavigator();
		drawNavigatorOverlay();
		sizeCallout();
		img_count = 0;
		StrandMap._fireEvent("onload");
	}
	
}

function openCallOutOnBenchmark(bmId) {
	if(typeof(mapSvgJson) == 'undefined' || typeof(bmId) == 'undefined')
		return;
	disableViewableMapEvents();
	mapSvgJson.svg.g.g.each( function(g){
		if(g.OID == bmId) {
			var coords = getRegionCoords(g.rect);
			renderCallOut(coords.top,coords.left,bmId);
			return;
		}	
	});
}

function rightPaddingWhenCallOutOpen() {
	return (stripPx($('navigatorPane').style.width) + 65);	
}

var test_counter = 0;
function renderCallOut(top, left, bm) {
	
	hideLinkToPage();
	StrandMap._selectedBenchmarkId = bm;

	top = top + 10;
	left = left + 105;
	
	if(hideNavWithCallOut) {
		if(useEffects)
			Effect.Fade('navigatorPane', {duration: 0.18} );	
		else
			Element.setStyle('navigatorPane', {display:'none'});
	}
	
	var newCoords = getMoveToCoords(top,left);
	
	if(!CallOut.isHidden())
	{
		StrandMap._fireEvent("onbenchmarkclose");
		CallOut.hide(false);
	}
	var doAfterMove = function() {
		var coords = {
			bottom: { top: (top + wholeMapHeightOffset()), left: (left + wholeMapWidthOffset()) }
		};	
		CallOut.setCoords(coords);	
		sizeCallout();
		
		StrandMap._fireEvent("onbenchmarkselect");
		CallOut.show();
	}
	moveWholeMapTo( newCoords.left, newCoords.top, false, true, doAfterMove );	
}


// Calculate where to move wholeMap to frame the callOut best at boundaries
function getMoveToCoords(top,left) {
	var wholeMap = $('wholeMap');	
	var viewableMap = $('viewableMap');
	    	
	var viewableMinH = stripPx(viewableMap.style.height) - 20;
	var minH = (maxCallOutH < viewableMinH ? maxCallOutH : viewableMinH);
	
	var currentTop = stripPx(wholeMap.style.top);
	var padBottom = 45;
	
	moveTopTo = -wholeMapHeightOffset() - top + minH - padBottom;
	
	var leftPadding = 120;
	var rightPadding = rightPaddingWhenCallOutOpen();
	var currentLeft = stripPx(wholeMap.style.left);
	if( currentLeft < (-wholeMapWidthOffset() - left + leftPadding) )
		var moveLeftTo = -wholeMapWidthOffset() - left + leftPadding;
	else if( currentLeft > (stripPx(viewableMap.style.width) -wholeMapWidthOffset() - left - rightPadding) )
		var moveLeftTo = (stripPx(viewableMap.style.width) -wholeMapWidthOffset() - left - rightPadding);
	else
		var moveLeftTo = currentLeft;
	
	return { top: moveTopTo, left: moveLeftTo }; 	
}

// Size the callout to fit the full extent of the visisble map:
function sizeCallout() {		
	var coords = CallOut.getCoords();
	
	var wholeMap = $('wholeMap');	
	var viewableMap = $('viewableMap');
	
	if(!wholeMap || !viewableMap)
		return;

	var boundaryLeft = -stripPx(wholeMap.style.left) + 15;
	var boundaryRight = boundaryLeft + stripPx(viewableMap.style.width) - 35 - stripPx($('navigatorPane').style.width);
	
	var left,right;
	
	// Enforce max/in width:
	var diffW = boundaryRight - boundaryLeft;
	
	if( diffW  < maxCallOutW && (diffW > minCallOutW)) {
		left = boundaryLeft;
		right = boundaryRight;
	} else {
		left = coords.bottom.left - Math.floor(maxCallOutW/2);
		right = left + maxCallOutW;
		var d;
		if(left < boundaryLeft){
			d = boundaryLeft - left;
			left += d;
			right +=d;
		}
		else if(right > boundaryRight){
			d = right - boundaryRight;
			left -= d;
			right -=d;
		}
		diffW = right-left;
		if( diffW  > maxCallOutW) {
			right = minCallOutW;
		} else if( diffW < minCallOutW) {
			right = minCallOutW;
		}
	}	
	
	var marginTop = 18;
	if($('smsMisconceptionsLinkHolder').visible())
		marginTop = 24;
	
	var top = -stripPx(wholeMap.style.top) + marginTop;
	
	// Enforce max/min height
	if(coords.bottom.top - top > maxCallOutH)
		top = coords.bottom.top - maxCallOutH;	
	if(coords.bottom.top - top < minCallOutH)
		top = coords.bottom.top - minCallOutH;	
	
	var new_coords = {
		bottom:	{ top: coords.bottom.top, left: coords.bottom.left },
		top:	top,			
		left: 	left,
		right:	right
	};	
	
	//CallOut.renderDefaultAt(new_coords.bottom.top, new_coords.bottom.left);
	CallOut.renderUpAt(new_coords);
}

var hideCallOutClickStart = 0;
function hideCallOut(event) {
	// If a short click, hide the call out, otherwise we're dragging the map, so don't hide
	
	if(event && event!=null) {
		var time = new Date().getTime();
		if(event.type == 'mousedown'){
			hideCallOutClickStart = time;
		}
		if(event.type == 'mouseup'){
			if(hideCallOutClickStart != null && ((hideCallOutClickStart + 150) > time)){ 
				
				if(!CallOut.isHidden())
				{
					StrandMap._fireEvent("onbenchmarkclose");
					CallOut.hide();
				}
				
			}
		}
			
		Event.stop(event);
	}
	else
	{
		if(!CallOut.isHidden())
		{
			StrandMap._fireEvent("onbenchmarkclose");
			CallOut.hide();
		}
	}
}

function onCallOutHide() {
	hideLinkToPage();
	setMouseWheelListener(true);	
	var wholeMap = $('wholeMap');
	var wholeMapRight = stripPx(wholeMap.style.left) + stripPx(wholeMap.style.width);	
	var wholeMapTop = stripPx(wholeMap.style.top);

	var viewableMap = $('viewableMap');
	var viewableMapRight = stripPx(viewableMap.style.left) + stripPx(viewableMap.style.width);		

	var dx = 0; 
	var dy = 0;
	
	// If the map has moved out of the range of normal padding, move it back:
	if(viewableMapRight > wholeMapRight -wholeMapWidthOffset() + mapPadding) {
		dx = viewableMapRight - (wholeMapRight -wholeMapWidthOffset() + mapPadding);
	}
	if(-wholeMapHeightOffset() + mapPadding < wholeMapTop) {
		dy = -wholeMapHeightOffset() + mapPadding - wholeMapTop;
	}
	
	var afterMove = function() {
		drawNavigatorOverlay();
		if(useEffects)
			Effect.Appear('navigatorPane', {duration: 0.12} );
			//Effect.BlindDown('navigatorPane', {duration: 0.3, scaleX: true} );
		else
			$('navigatorPane').style.display='';
		
		StrandMap.selectedBenchmark = null;
		theInfoBubble._fireEvent("onclose");		
	}
	
	if( dx != 0 || dy != 0) {
		if(useEffects) {
			Effect.MoveBy('wholeMap',dy,dx,{duration: 0.15, afterFinish:afterMove });
		} else {
			checkBounds();
			afterMove();
		}
	}
	else 
		afterMove();
}

function onCallOutShow() {
	hideLinkToPage();
	theInfoBubble._fireEvent("onopen");
	setMouseWheelListener(false);
	//Effect.Fade('navigatorPane', {duration: 0.08} );	
	//$('navigatorPane').style.display='none';
}

function startDragable(event) {
	$('wholeMap').addClassName(grabCursorStyle).removeClassName(grabbingCursorStyle);
	Event.stop(event);
}

function startDragableOverlay(event) {
	if(!iAmDraggingOverlay){
		$('navOverlay').addClassName(grabCursorStyle).removeClassName(grabbingCursorStyle);
	}
	Event.stop(event);
}

function startDrag(event) {
	iAmDragging = true;
	if(!browser.isIE)
		CallOut.setContentOverflow('hidden');	
	
	dragStartX = getEventX(event);
	dragStartY = getEventY(event);
	
	//capture the current top,left of wholeMap
	var wholeMap = $('wholeMap');
	wholeMapTop = stripPx(wholeMap.style.top);
	wholeMapLeft = stripPx(wholeMap.style.left);
	
	wholeMap.addClassName(grabbingCursorStyle).removeClassName(grabCursorStyle);
	
	Event.stop(event);
}

function startDragOverlay(event) {
	iAmDraggingOverlay = true;
	if(!browser.isIE)	
		CallOut.setContentOverflow('hidden');	
		
	//capture the initial point where dragging began
	dragStartX = getEventX(event);
	dragStartY = getEventY(event);

	//capture the current top,left of wholeMap
	var wholeMap = $('wholeMap');
	wholeMapTop = stripPx(wholeMap.style.top);
	wholeMapLeft = stripPx(wholeMap.style.left);
	$('navigatorPane').addClassName(grabbingCursorStyle).removeClassName(grabCursorStyle);
	$('navOverlay').addClassName(grabbingCursorStyle).removeClassName(grabCursorStyle);
	
	Event.stop(event);
}

function stopDrag(event) {	
	iAmDragging = false;
	
	//change the mouse cursor
	var wholeMap = $('wholeMap');
	if(event.type == 'mouseup'){
		wholeMap.addClassName(grabCursorStyle).removeClassName(grabbingCursorStyle);
	}
	else
		wholeMap.removeClassName(grabCursorStyle).removeClassName(grabbingCursorStyle);
	
	Event.stop(event);
	
	if(!browser.isIE)
		CallOut.setContentOverflow('auto');	
}

function stopDragOverlay(event) {
	
	//change the mouse cursor
	var navOverlay = $('navOverlay');
	var navigatorPane = $('navigatorPane');	
	if(event.type == 'mouseup' && iAmDraggingOverlay){
		navOverlay.addClassName(grabCursorStyle).removeClassName(grabbingCursorStyle);
		navigatorPane.addClassName(grabCursorStyle).removeClassName(grabbingCursorStyle);
	}
	else{
		navOverlay.removeClassName(grabCursorStyle).removeClassName(grabbingCursorStyle);
		navigatorPane.removeClassName(grabCursorStyle).removeClassName(grabbingCursorStyle);
	}
		
	iAmDraggingOverlay = false;
	Event.stop(event);
	
	if(!browser.isIE)
		CallOut.setContentOverflow('auto');		
}


function mouseoutDragOverlay(event) {
	if(!iAmDraggingOverlay) {
		$('navOverlay').removeClassName(grabCursorStyle).removeClassName(grabbingCursorStyle);
		$('navigatorPane').removeClassName(grabCursorStyle).removeClassName(grabbingCursorStyle);			
	}	
	Event.stop(event);
}


function dragging(event) {
   if(iAmDragging) {
		var left = wholeMapLeft + (getEventX(event) - dragStartX); 
		var top = wholeMapTop + (getEventY(event) - dragStartY);
		moveWholeMapTo(left,top);
   }
   Event.stop(event);
}

function draggingOverlay(event) {
   if(iAmDraggingOverlay) {				
		var navigatorRatio = tileHeight / stripPx($('navImage').style.height);

		var left = Math.ceil( wholeMapLeft - (((getEventX(event) - dragStartX) ) * navigatorRatio) );
		var top = Math.ceil( wholeMapTop - (((getEventY(event) - dragStartY) ) * navigatorRatio) );		
		
		moveWholeMapTo(left,top);
   }
   Event.stop(event);
}

function mousewheel(event) {
	if(event) {
		var delta = 0;
		if(browser.isIE || browser.isSafari)
			delta = event.wheelDelta;
		else if(browser.isFirefox)
			delta = -event.detail*40;
		var wholeMap = $('wholeMap');
		var wholeMapTop = stripPx(wholeMap.style.top);
		var wholeMapLeft = stripPx(wholeMap.style.left);
				
		wholeMapTop = wholeMapTop + Math.floor( delta/3 );
		
		if(!browser.isIE)
			CallOut.setContentOverflow('hidden');			
		
		moveWholeMapTo(wholeMapLeft,wholeMapTop);
		
		if(!browser.isIE)
			CallOut.setContentOverflow('auto');			
	}
	Event.stop(event);
}

var panning=false;
var panDir = '';
function pan(dir){
	panDir = dir;
	if(!browser.isIE)
		CallOut.setContentOverflow('hidden');
	panning = true;
	doPan();
}

function doPan(){
	if(panning){
		var wholeMap = $('wholeMap');
		var d = browser.isIE ? 60 : 40;
		var wholeMapTop = stripPx(wholeMap.style.top);
		var wholeMapLeft = stripPx(wholeMap.style.left);		
		if(panDir=='up')
			wholeMapTop+=d;
		else if(panDir=='down')
			wholeMapTop-=d;
		else if(panDir=='left')
			wholeMapLeft+=d;
		else if(panDir=='right')
			wholeMapLeft-=d;
		moveWholeMapTo(wholeMapLeft,wholeMapTop,true,false);
		if(panning)
			setTimeout("doPan()", 50);
		else if(!browser.isIE)
			CallOut.setContentOverflow('auto');
	}
	else if(!browser.isIE)
		CallOut.setContentOverflow('auto');	
}

function stopPan(){
	panning=false;
}

function moveWholeMapTo(left,top,doCheckBounds,annimate,afterFinishFunc) {	
	var wholeMap = $('wholeMap');
	
	var afterFinishFuncs = function() {
		if(doCheckBounds == null || doCheckBounds)
			checkBounds();
		calcVisibleTiles();
		drawNavigatorOverlay();
		if(afterFinishFunc)
			afterFinishFunc();
	}
	
	if(annimate == null || !annimate || !useEffects) {
		wholeMap.style.left = left;
		wholeMap.style.top = top;
		afterFinishFuncs();
	} else {
		var x = stripPx(wholeMap.style.left) - left;
		var y = stripPx(wholeMap.style.top) - top;
		var speed = Math.abs(Math.abs(x) > Math.abs(y) ? x : y)*0.00160;
		speed = speed < 0.25 ? 0.25 : (speed > 1.8 ? 1.8 : speed);
		Effect.MoveBy(wholeMap,-y,-x,{duration: speed, afterFinish: afterFinishFuncs, afterUpdate: drawNavigatorOverlay });
	}
}

function checkBounds() {
	var wholeMap = $('wholeMap');
	var wholeMapBottom = stripPx(wholeMap.style.top) + stripPx(wholeMap.style.height);
	var wholeMapRight = stripPx(wholeMap.style.left) + stripPx(wholeMap.style.width);
	
	var viewableMap = $('viewableMap');
	var viewableMapBottom = stripPx(viewableMap.style.top) + stripPx(viewableMap.style.height);
	var viewableMapRight = stripPx(viewableMap.style.left) + stripPx(viewableMap.style.width);		
	
	if(CallOut.isHidden()){
		var topPadding = mapPadding;
		var rightPadding = mapPadding;
	}
	else {
		var topPadding = maxCallOutH - mapPadding;
		var rightPadding = rightPaddingWhenCallOutOpen();		
	}
	
	if(rowMode == 'locked') {
		if(-wholeMapHeightOffset() + topPadding < stripPx(wholeMap.style.top)) {
		  wholeMap.style.top = -wholeMapHeightOffset() + topPadding;
		  stopPan();
		}
		else if(viewableMapBottom > wholeMapBottom -wholeMapHeightOffset() + mapPadding) {
		  wholeMap.style.top = viewableMapBottom - stripPx(wholeMap.style.height) + wholeMapHeightOffset() - mapPadding;
		  stopPan();
		}
	}
	
	if(columnMode == 'locked') {
		if(-wholeMapWidthOffset() + mapPadding < stripPx(wholeMap.style.left)) {
		  wholeMap.style.left = -wholeMapWidthOffset() + mapPadding;
		  stopPan();
		}
		else if(viewableMapRight > wholeMapRight -wholeMapWidthOffset() + rightPadding) {
		  wholeMap.style.left = viewableMapRight - stripPx(wholeMap.style.width) + wholeMapWidthOffset() - rightPadding;
		  stopPan();
		}
	}
}

// Set the dimensions of the navigator image and surrounding elements:
function setNavigatorImage(width,height,src) {
	//debug("	setNavigatorImage() w:" + width + " h:" + height + " src: " + src);
	var wholeMap = $('wholeMap');
	var wholeMapHeight = stripPx(wholeMap.style.height);
	var navigatorRatio = height / tileHeight;
	var padding = Math.ceil(mapPadding*navigatorRatio);	
	
	var viewableNavMap = $('viewableNavMap');
	viewableNavMap.style.width = width + (showPaddingInNav ? padding*2 : 0);
	viewableNavMap.style.height = height + (showPaddingInNav ? padding*2 : 0);
	
	positionNavigator(); 	

	var navImage = $('navImage');
	navImage.setStyle({ width: width, height: height }); 
	
	if(showPaddingInNav) {
		navImage.setStyle({ top: padding, left: padding }); 
	}
	
	imgId = 'navImageImg';
	navImage.update("<img id='"+imgId+"' src='" + src + "'/>");	
	// Need to do this using prototype events because android has a bug where img onload attribute fires it 3 times
	Event.observe($(imgId), 'load', onMapImageLoad, false);
	
	drawNavigatorOverlay();
}

function positionNavigator() {
	var borderSize = (browser.isIE ? 10 : 8);

	var viewableNavMap = $('viewableNavMap');
	var navigatorPane = $('navigatorPane');
	var viewableMap = $('viewableMap');
	var navImage = $('navImage');
	var w = stripPx(navImage.style.width);
	var h = stripPx(navImage.style.height);	
	var navW = stripPx(viewableNavMap.style.width) + borderSize;
	var navH = stripPx(viewableNavMap.style.height) + borderSize;
	navigatorPane.style.width = navW;
	navigatorPane.style.height = navH;
	var frameWidth = stripPx(viewableMap.style.width);
	var frameHeight = stripPx(viewableMap.style.height);	
	navigatorPane.style.right = navW - frameWidth - (browser.isIE && w%2 == 1 ? 0:1);
	navigatorPane.style.bottom = navH - frameHeight - (browser.isIE && h%2 == 1 ? 0:1);
	//$('navigatorArrows').setStyle({bottom:(navH)});
}

function drawNavigatorOverlay() {
	var wholeMap = $('wholeMap');
	var navImage = $('navImage');
	var h = stripPx(navImage.style.height);
	var w = stripPx(navImage.style.width);
	var navigatorRatio = h / tileHeight;
	var padding = Math.ceil(mapPadding*navigatorRatio);	

	var navOverlayTop = Math.ceil( (stripPx(wholeMap.style.top) + wholeMapHeightOffset() )*navigatorRatio) ;
	var navOverlayLeft = Math.ceil( (stripPx(wholeMap.style.left) + wholeMapWidthOffset() )*navigatorRatio) ;
	navOverlayTop = -navOverlayTop - (browser.isIE && h%2 == 1 ? 1:0) - 1;
	navOverlayLeft = -navOverlayLeft - (browser.isIE && w%2 == 1 ? 1:0) - 1;	
			
	var viewableMap = $('viewableMap');	
	var navOverlayHeight = Math.abs(Math.ceil(viewableMap.offsetHeight * navigatorRatio));
	var navOverlayWidth = Math.abs(Math.ceil(viewableMap.offsetWidth * navigatorRatio));
	//navOverlayHeight += navOverlayHeight%2 == 1 ? 1:0;	
	//navOverlayWidth += navOverlayWidth%2 == 1 ? 1:0;	

	var navImageTop = stripPx(navImage.style.top);
	var navImageLeft = stripPx(navImage.style.left);
	
	// Reposition the navImage if necessary:
	if(!showPaddingInNav) {
		var navImageBottom = navImageTop + h;
		var navOverlayBottom = navOverlayTop + navOverlayHeight;
		var deltaBottom = (navOverlayBottom - navImageBottom);		

		var navImageRight = navImageLeft + w;
		var navOverlayRight = navOverlayLeft + navOverlayWidth;
		var deltaRight = (navOverlayRight - navImageRight);	
		
		if(navOverlayTop < 0) {
			navImageTop = -navOverlayTop - 1;
			navImage.style.top = navImageTop;
		}
		if(navOverlayLeft < 0) {
			navImageLeft = -navOverlayLeft - 1;
			navImage.style.left = navImageLeft;
		}
		if(deltaBottom > 0) {
			navImageTop = -navOverlayBottom + h -1;
			navImage.style.top = navImageTop;
		}
		if(deltaRight > 0) {
			navImageLeft = -navOverlayRight + w -1;
			navImage.style.left = navImageLeft;
		}		
	}
	
	var navOverlay = $('navOverlay');
	navOverlay.style.top = navImageTop + navOverlayTop + (browser.isIE && h%2 == 1 ? 1:0);	
	navOverlay.style.left = navImageLeft + navOverlayLeft + (browser.isIE && w%2 == 1 ? 1:0);	
		
	var navOverlayBorder1 = $('navOverlayBorder1');
	navOverlayBorder1.style.height = navOverlayHeight-2;	
	navOverlayBorder1.style.width = navOverlayWidth-2;
		
	var navOverlayBorder2 = $('navOverlayBorder2');
	navOverlayBorder2.style.height = navOverlayHeight-4;	
	navOverlayBorder2.style.width = navOverlayWidth-4;
	
	var navOverlayFill = $('navOverlayFill');
	navOverlayFill.style.height = navOverlayHeight-4;	
	navOverlayFill.style.width = navOverlayWidth-4;					 
}

var numCalcVisibleTiles = 0;
function calcVisibleTiles() {
	//debug("calcVisibleTiles() num " + (++numCalcVisibleTiles));
	
	var viewableMap = $('viewableMap');
 	
	// These two vars arn't used, but for some reason referencing them greatly increases rendering performance in IE!
	var vw = viewableMap.offsetWidth;
	var vh = viewableMap.offsetHeight; 
	
	var viewableWidth = stripPx(viewableMap.style.width);
	var viewableHeight = stripPx(viewableMap.style.height);
	var columnCount = Math.ceil(viewableWidth / tileWidth);
	var rowCount = Math.ceil(viewableHeight / tileHeight);
	
	var wholeMap = $('wholeMap');
	var startingColumn = Math.floor(Math.abs(stripPx(wholeMap.style.left) / tileWidth));
	var startingRow = Math.floor(Math.abs(stripPx(wholeMap.style.top) / tileHeight));
	
	var endingColumn = startingColumn + columnCount;
	var endingRow = startingRow + rowCount;   
	
	var wholeMapTiles = $('wholeMapTiles');
	var visibleTiles = {};
	for(r = startingRow; r <= endingRow; r++) {
		for(c = startingColumn; c <= endingColumn; c++) {
			var tileId = addTile(wholeMapTiles, c, r);
			if(tileId)
				visibleTiles[tileId] = true;
		}
	} 
	
	//remove non-visible tiles from wholeMap
	var allTiles = wholeMapTiles.getElementsByTagName('img');
	for(i = 0; i < allTiles.length; i++) {
		var id = allTiles[i].getAttribute('id');
		if(!visibleTiles[id]) {
			wholeMapTiles.removeChild(allTiles[i]);
			i--; //we're removing a node; make sure that we don't skip the next one
		}
	}  
}

function addTile(wholeMapTiles, c, r) {
	var tileId = zeroPad(c) + "-" + zeroPad(r);
	var filename = baseJsapiUrl + "/map_images/" + mapColor + "/" + conceptSize + "/" + zoomLevel + "/" + tileId + "." + imageExt;
	var tileTop = r * tileHeight;
	var tileLeft = c * tileWidth;
	
	//debug('addTile() tileId:' + tileId + ' filename:' + filename + ' tileTop:' + tileTop + ' tileLeft:' + tileLeft);
	
	// For this application, the only real tile is the center (where the map resides), all others are blank for padding...
	var centerColumn = Math.floor(wholeMapColumnCount/2);
	var centerRow = Math.floor(wholeMapRowCount/2);
	var centerTileId = zeroPad(centerColumn) + "-" + zeroPad(centerRow);
	
	if(tileId == centerTileId) {
		filename = mapImagePath;
	}
	else
		return null;
	
	//is the img already loaded?
	if(!$(tileId)) {
		new Insertion.Top('wholeMapTiles', 
			"<img id='" + tileId + "' class='mapImage' src='" + filename + "' style='position:absolute; top:" + tileTop + "; left:" + tileLeft + "'/>"); 
		// Need to do this using prototype events because android has a bug where img onload attribute fires it 3 times
		Event.observe($(tileId), 'load', onMapImageLoad, false);
	}
	
	return tileId;
}

function zeroPad(value) {
   if(value < 10) {
      return "0" + value;
   }
   else {
      return value;
   }
}


function removeAllTiles() {
   var wholeMapTiles = $('wholeMapTiles');
   var allTiles = wholeMapTiles.getElementsByTagName('img');
   while(allTiles.length > 0) {
      wholeMapTiles.removeChild(allTiles[0]);
   }
}


function clickableZoomIn(event) {
	var elem = $('zoomIn');

	elem.style.cursor = 'pointer';
	Event.stop(event);
}

function clickableZoomOut(event) {
	var elem = $('zoomOut');

	elem.style.cursor = 'pointer';
	Event.stop(event);
}


function setZoomLevel(requestedLevel) {
   //ensure the requestedLevel remains in bounds
   requestedLevel = (requestedLevel < minZoom) ? minZoom : requestedLevel;
   requestedLevel = (requestedLevel > maxZoom) ? maxZoom : requestedLevel;
   zoomLevel = requestedLevel;
   switch(zoomLevel) {
      case 0:
         wholeMapColumnCount = 4;
         wholeMapRowCount = 2;
         break;
      case 1:
         wholeMapColumnCount = 6;
         wholeMapRowCount = 3;
         break;
      case 2:
         wholeMapColumnCount = 8;
         wholeMapRowCount = 4;
         break;
      case 3:
         wholeMapColumnCount = 1;
         wholeMapRowCount = 1;
         break;         
   }

   setWholeMapSize();

   removeAllTiles();
   calcVisibleTiles();
}

function stripPx(value) {
   if(value == "") {
      return 0;
   }
   else {
      return parseFloat(value.substring(0, value.length - 2));
   }
}
function doTogglePE(id) {
	var obj = $(id);
	var buttonId = id;

	id = buttonId.replace('pe_toggle_','');
	id = 'pe_container_'+id;

	if($(id).hasClassName('hide')){
		$(buttonId).removeClassName('pe_toggle_closed')
		$(buttonId).addClassName('pe_toggle_opened');
		$(id).removeClassName('hide')
		$(buttonId).update('Hide Performance Expectation(s)');
	} else {
		$(id).addClassName('hide')
		$(buttonId).removeClassName('pe_toggle_opened')
		$(buttonId).addClassName('pe_toggle_closed');
		$(buttonId).update('Show Performance Expectation(s)');
	}
}

function debug(message) {
	var debugPane = $("debugPane");
	if(debugPane) {
		debugPane.style.padding = 20;
		//new Insertion.Bottom('debugPane', '<div>' + message + '</div>');
		debugPane.update(message);
	}
}



Event.observe(window, 'load', onPageLoad, false);
