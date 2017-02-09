// Public Strand Map JS API
	
// Event handler base class:
var EventHandler = Class.create();
var alignedResComplete = false;
var alignedResExists = false;
var relatedResComplete = false;
var relatedResExists = false;
var nsdltoppicksResComplete = false;
var nsdltoppicksResExists = false;
var toppicksResComplete = false;
var toppicksResExists = false;
var ngssComplete = false;
var ngssExists = false;
var aaasAssessmentComplete = false;
var aaasAssessmentExists = false;
var aaasMisconceptionComplete = false;
var aaasMisconceptionExists = false;
var nsdlAlignedLabel = '';
var nsdlRelatedLabel = '';
var aaasAssessmentLabel = '';
var aaasMisconceptionLabel = '';
var relatedMapContent = '';
var navigatorArrows = false;
Array.prototype.contains = function ( needle ) {
	   for (i in this) {
	       if (this[i] === needle) return true;
	   }
	   return false;
	}

EventHandler.prototype = {
	initialize: function() { },
	_addEventHandler: function(event,callback,isPriority) {
		if(this._validEvents == null){
			alert("Error: Unable to add event handler '" + event + "'.  No events are availble for this object");
			return;
		}
		else if(this._validEvents.indexOf(event) == -1) {
			alert("Error: Unable to add event handler '" + event + "'.  Events must be one of: " + this._validEvents.inspect());
			return;
		}
		
		if(this.allHandlers == null)
			this.allHandlers = $H();
		var handlers = this.allHandlers[event];
		if(handlers == null)
			handlers = new Array();
		handlers[handlers.length] = callback;
		if(isPriority){
			var p0 = handlers[0];
			var pm = handlers[handlers.length-1];
			handlers[0] = pm;
			handlers[handlers.length-1] = p0;
		}
		this.allHandlers[event] = handlers;
	},
	_fireEvent: function(event) {
		if(this.allHandlers != null){
			var handlers = this.allHandlers[event];
			if(handlers != null){
				for(var i = 0; i < handlers.length; i++)
					handlers[i]();
			}	
		}
	},
	// Override by sub-classes
	_validEvents: null
};

// Public InfoBubble API:
var InfoBubble = Class.create();
InfoBubble.prototype = Object.extend(new EventHandler(), {
	setTitle: function(titleHTML) {
		CallOut.setTitle(titleHTML);
	},
	getTitle: function() {
		return CallOut.getTitle();
	},	
	setContent: function(contentHTML) {
		CallOut.setContent(contentHTML);
	},
	getContent: function() {
		return CallOut.getContent();
	},	
	setBuiltinContent: function(t, opts) {
		if(t == 'benchmarkdetails') {
			var bmHtml = StrandMap.getSelectedBenchmarkHtml();
			if(bmHtml != null)
				this.setContent(bmHtml);
		} else if(t == 'benchmarkonly') {
			var bmHtml = StrandMap.getSelectedBenchmarkOnly();
			if(bmHtml != null)
				this.setContent(bmHtml);
		} else if(t == 'benchmarkrelatedmaps') {
			var bmHtml = StrandMap.getSelectedBenchmarkRelatedMaps(null, opts);
			if(bmHtml != null)
				this.setContent(bmHtml);
		} 
		else
			alert('Content "'+t+'" is not a valid built-in option for content.');			
	},
	setMaxSize: function(w,h) {
		maxCallOutW = w;
		maxCallOutH = h;
		sizeCallout();		
	},
	setMinWidth: function(w) {
		minCallOutW = w;
		sizeCallout();		
	},		
	addTab: function(infoBubbleTab) {
		CallOut.addTab(infoBubbleTab);
	},
	addBuiltinTab: function(tabName,label) {
		if(tabName == 'relatedbenchmarks') {
			_bmTab = new InfoBubbleTab(label);
			SMSEvent.addListener(_bmTab,"onselect",this._bmTabCb);
			var handler = function () {
				_bmTab.setContent(null);	
			};
			StrandMap._addEventHandler("onbenchmarkclose",handler,true);
			CallOut.addTab(_bmTab);
			return _bmTab;
		} else if(tabName == 'nses') {
			_nsesTab = new InfoBubbleTab(label);
			SMSEvent.addListener(_nsesTab,"onselect",this._nsesTabCb);
			var handler = function () {
				_nsesTab.setContent(null);	
			};
			StrandMap._addEventHandler("onbenchmarkclose",handler,true);
			CallOut.addTab(_nsesTab);
			return _nsesTab;
		} else if(tabName == 'ngss') {
			_ngssTab = new InfoBubbleTab(label);
			ngssLabel = label;
			SMSEvent.addListener(_ngssTab,"onselect",this._ngssTabCb);
			var handler = function () {
				_ngssTab.setContent(null);	
			};
			StrandMap._addEventHandler("onbenchmarkclose",handler,true);
			CallOut.addTab(_ngssTab);
			return _ngssTab;
		
		} else if(tabName == 'nsdltoppicks'||tabName == 'toppicks') {
			_nsdltoppicksTab = new InfoBubbleTab(label);
			
			// depercating nsdltoppicks, to do this without a huge amount of code changes we are
			// just going to say they are the same. use of the same tab
			_toppicksTab = _nsdltoppicksTab
			nsdltoppicksLabel = label;
			SMSEvent.addListener(_nsdltoppicksTab,"onselect",this._nsdltoppicksTabCb);
			var handler = function () {
				// reseting label to blank label since we add a total number in tab
				_nsdltoppicksTab.changeLabel(null);
				_nsdltoppicksTab.setContent(null);	
			};
			StrandMap._addEventHandler("onbenchmarkclose",handler,true);
			CallOut.addTab(_nsdltoppicksTab);
			return _nsdltoppicksTab;
		} else if(tabName == 'nsdlaligned') {
			/* this tab along with nsdlrelated are deprecated and their corresponding called functions have
			 * been removed from the documentation. These are around just in case some clients are  
			 * using the old tabs. The preferred tab is nsdltoppicks which shows all records assigned
			 */
			_nsdlalignedTab = new InfoBubbleTab(label);
			nsdlAlignedLabel = label;
			SMSEvent.addListener(_nsdlalignedTab,"onselect",this._nsdlalignedTabCb);
			var handler = function () {
				_nsdlalignedTab.setContent(null);	
			};
			StrandMap._addEventHandler("onbenchmarkclose",handler,true);
			CallOut.addTab(_nsdlalignedTab);
			return _nsdlalignedTab;
		}else if(tabName == 'nsdlrelated') {
			/* this tab along with nsdlrelated are deprecated and their corresponding called functions have
			 * been removed from the documentation. These are around just in case some clients are  
			 * using the old tabs. The preferred tab is nsdltoppicks which shows all records assigned
			 */
			_nsdlrelatedTab = new InfoBubbleTab(label);
			nsdlRelatedLabel = label;
			SMSEvent.addListener(_nsdlrelatedTab,"onselect",this._nsdlrelatedTabCb);
			var handler = function () {
				_nsdlrelatedTab.setContent(null);	
			};
			StrandMap._addEventHandler("onbenchmarkclose",handler,true);
			CallOut.addTab(_nsdlrelatedTab);
			return _nsdlrelatedTab;
		} else if(tabName == 'aaasassessment') {
			_aaasassessmentTab = new InfoBubbleTab(label);
			aaasAssessmentLabel = label;
			SMSEvent.addListener(_aaasassessmentTab,"onselect",this._aaasassessmentTabCb);
			var handler = function () {
				_aaasassessmentTab.setContent(null);	
			};
			StrandMap._addEventHandler("onbenchmarkclose",handler,true);
			CallOut.addTab(_aaasassessmentTab);
			return _aaasassessmentTab;
		} else if(tabName == 'aaasmisconception') {
			_aaasmisconceptionTab = new InfoBubbleTab(label);
			aaasMisconceptionLabel = label;
			SMSEvent.addListener(_aaasmisconceptionTab,"onselect",this._aaasmisconceptionTabCb);
			var handler = function () {
				_aaasmisconceptionTab.setContent(null);	
			};
			StrandMap._addEventHandler("onbenchmarkclose",handler,true);
			CallOut.addTab(_aaasmisconceptionTab);
			return _aaasmisconceptionTab;
		}
		else
			alert('Tab "'+tabName+'" is not a valid built-in tab.');
	},	
	selectTab: function(infoBubbleTab) {
		CallOut.selectTab(infoBubbleTab.getTabId());	
	},
	hideTab: function(infoBubbleTab) {
		CallOut.hideTab(infoBubbleTab.getTabId());	
	},
	showTab: function(infoBubbleTab) {
		CallOut.showTab(infoBubbleTab.getTabId());	
	},
	hideTabPane: function(dm) {
		CallOut.hideTabs(dm);	
	},
	showTabPane: function() {
		CallOut.showTabs();	
	},	
	_bmTabCb: function () {
		if(_bmTab.getContent() == null) {
			var bmId = StrandMap.getSelectedBenchmarkId();
			var t = '<div id="_bm_related"></div>';
			t += '<p><div id="bmk-ld-msg" style="color: #666666;">';
			t += '<img src="'+baseJsapiUrl+'/api_v1/interactive_map/images/spinner.gif" id="bmk-ld-img" width="16" height="16" style="vertical-align: middle; display:none" onload="$(\'bmk-ld-img\').show();"/>';
			t += '&nbsp;Loading...';
			t += '</div></p>';
			t += '<div id="bmk-img" style="display:none;">';
			t += '<div style="padding-bottom:4">';
			t += '<a href="?id='+bmId+'&parentmap='+StrandMap.getMapId()+'">Click to open these benchmarks in the interactive browser</a></div>';
			t += '<img border="0" src="'+ getBmImageUrl(bmId) +'" onload="$(\'bmk-img\').show(); $(\'bmk-ld-msg\').hide();" />';
			t += '</div>';
			_bmTab.setContent(t);
		}
	},	
	_nsesTabCb: function () {
		if(_nsesTab.getContent() == null) {
			var mainContent = '';
			var bmJson = StrandMap.getSelectedBenchmarkRecordJson();
			if(bmJson.itemRecord.Data.Standards.length > 0) {
				mainContent += '<div id="standards" style="padding-top: 6;padding-left:12;">';
				mainContent += retrieveStandards(bmJson);
				mainContent += '</div>';
			} else {
				mainContent = 'There are no NSES standards aligned with this benchmark.';	
			}
			
			_nsesTab.setContent(mainContent);
		}
	},	
	_ngssTabCb: function () {
		
		if(_ngssTab.getContent() == null) {
			StrandMap.getNGSS();
			
		}
	},	
	
	_nsdltoppicksTabCb: function () {
		if(_nsdltoppicksTab.getContent() == null) {
			StrandMap.getNsdlTopPicks();
		}
	},
	_nsdlalignedTabCb: function () {
		if(_nsdlalignedTab.getContent() == null) {
			StrandMap.getNsdlAlignedResources();
		}
	},
	_nsdlrelatedTabCb: function () {
		if(_nsdlrelatedTab.getContent() == null) {
			StrandMap.getNsdlRelatedResources();
		}
	},
	_aaasassessmentTabCb: function () {
		if(_aaasassessmentTab.getContent() == null) {
			StrandMap.getAaasAssessment();
		}
	},
	_aaasmisconceptionTabCb: function () {
		if(_aaasmisconceptionTab.getContent() == null) {
			StrandMap.getAaasMisconception();
		}
	},
	_validEvents: ["onopen","onclose"]
});
var _bmTab = null;
var _nsesTab = null;
var _ngssTab = null;
var _nsdlalignedTab = null;
var _nsdltoppicksTab = null;
var _toppicksTab = null;
var _nsdlrelatedTab = null;
var _aaasassessmentTab = null;
var _aaasmisconceptionTab = null;

// This object interacts directly with the CallOut widget
var _tabIdCount = 0;
var InfoBubbleTab = Class.create();
InfoBubbleTab.prototype = Object.extend(new EventHandler(), {
	initialize: function(label,builtin) {
		this._label  = label;
		this._builtin = builtin;
		this._tabId = ++_tabIdCount;
	},
	setContent: function(content) {
		this._content = content;
		var tc = $('smsTab'+this._tabId);
		if(tc)
			tc.update(content == null ? '' : content);
	},
	getContent: function() {
		return this._content;
	},	
	getTabId: function() {
		return this._tabId;
	},
	appendToLabel:function(appendText){
		var labelAnchor = $$('#tab'+this._tabId+" a")[0];
		
		if(appendText!=null)
			this.changeLabel(labelAnchor.innerHTML+appendText)
		else
			this.changeLabel(null)
	},
	changeLabel:function(newLabel){
		var labelAnchor = $$('#tab'+this._tabId+" a")[0];
		if(newLabel!=null)
			labelAnchor.update(newLabel)
		else
			labelAnchor.update(this._label)
		
	},
	// ---- Private methods ----: 	
	// Debugging output:
	_show: function() {
		alert("Tab '" + this._label + "' tabId: " + this._tabId);
	},
	_validEvents: ["onselect"]
});


// Public StrandMap API:
var theInfoBubble = new InfoBubble();
var _StrandMap = Class.create();
_StrandMap.prototype = Object.extend(new EventHandler(), {
	setPrintViewContent: function(content) {
		setCustomPrintViewContent(content);
	},
	getInfoBubble: function() {
		return theInfoBubble;
	},
	openInfoBubbleOnBenchmark: function(bmId) {
		openCallOutOnBenchmark(bmId);
	},	
	getSelectedBenchmarkId: function() {
		return this._selectedBenchmarkId;
	},
	getSelectedBenchmarkRecordJson: function() {
		if(this._selectedBenchmarkId == null)
			return null;
		return mapBenchmarksJson[this._selectedBenchmarkId];
	},	
	getMapId: function() {
		return _mapid;
	},
	getBenchmarkIds: function() {
		return _bmIds;
	},	
	getTextIds: function() {
		return _textIds;
	},	
	getMapJson: function() {
		return _mapSmsJson;
	},	
	getParentIds: function() {
		return _parentIds;
	},	
	// When the 'Related banchmarks' are being displayed, this is the referring map:
	getReferringMapId: function() {
		return parms.parentmap;
	},
	getSelectedBenchmarkHtml: function(displayStds) {
		var bmJson = this.getSelectedBenchmarkRecordJson();
		if(bmJson == null)
			return null;
		return this._bmContentHtml(bmJson,displayStds);
	},	
	getSelectedBenchmarkOnly: function() {
		var bmJson = this.getSelectedBenchmarkRecordJson();
		if(bmJson == null)
			return null;
		return this._bmContentOnly(bmJson);
	},
	getSelectedBenchmarkRelatedMaps: function(displayRelatedMaps, opts) {
		var bmJson = this.getSelectedBenchmarkRecordJson();
		if(bmJson == null)
			return null;
		return this._bmContentRelatedMaps(bmJson,displayRelatedMaps, opts);
	},
	getMisconceptionsHtml: function() {
		if(this._misconceptionHtml == null) {
			this._misconceptionHtml = retrieveMisconceptions(this.getMapJson());
		}
		return this._misconceptionHtml;
	},
	enableMisconceptions: function (enable) {
		if(enable) {
			if(this._misconceptionHtml == null) {
				this._misconceptionHtml = retrieveMisconceptions(this.getMapJson());
				if(this._misconceptionHtml != null) {
					if( $('smsMisconceptionsData') )
						$('smsMisconceptionsData').update(this._misconceptionHtml );
					if( $('smsMisconceptionsLinkHolder') )
						$('smsMisconceptionsLinkHolder').show();
				}
			}
		} else {
			if( $('smsMisconceptions') )
				$('smsMisconceptions').hide();
			if( $('smsMisconceptionsLinkHolder') )
				$('smsMisconceptionsLinkHolder').hide();			
		}
	},
	enableNavigatorArrows: function (enable) {
		this._navigatorArrows = enable
	},
	getEnabledNavigatorArrows: function () {
		return this._navigatorArrows
	},
	getNGSS: function(offset, displaytype) {
		ngssComplete = false;
		ngssExists = false;
		var ngss_string = '';
		var bmJson = StrandMap.getSelectedBenchmarkRecordJson();
		var ExtNode = bmJson.itemRecord.Data.ExternalRelationship
		if(typeof(ExtNode.AlignedTo) != 'undefined'){
			var itemNode = ExtNode.AlignedTo.NGSS.ItemID;
			
			if(typeof(itemNode.content) != 'undefined'){
				mainContent = 'Loading NGSS standards alignments.';	
				_ngssTab.setContent(mainContent);
				ngss_string = bmJson.itemRecord.Data.ExternalRelationship.AlignedTo.NGSS.ItemID.content.replace("http://asn.jesandco.org/resources/","");
				
			} else if(typeof(itemNode.length) != 'undefined'){
				mainContent = 'Loading NGSS standards alignments.';	
				_ngssTab.setContent(mainContent);
				
				var ngss = new Array();
				var counter = 0;
				for(var i = 0; i < itemNode.length; i++){
					ngss[counter] = itemNode[i].content.replace("http://asn.jesandco.org/resources/","");
					counter++;
				}
				ngss_string = ngss.join("|");
				
			}
		}
			
		if(ngss_string.length > 0){
			
			var reqUrl = baseJsapiUrl+"/api_v1/bubble/ngss.jsp?ngss="+ngss_string;
			
			var mapScriptReq = document.createElement( 'script' );
			mapScriptReq.src = reqUrl;
			mapScriptReq.charset = "utf-8";
			mapScriptReq.type = "text/javascript";
			document.getElementsByTagName('head')[0].appendChild( mapScriptReq );	
				
			//mainContent += bmJson.itemRecord.Data.ExternalRelationship.AlignedTo.NGSS.ItemID[i].content;
		} else {
			mainContent = 'There are no NGSS standards aligned with this benchmark.';	
			_ngssTab.setContent(mainContent);
			ngssComplete = true;
		}
		
	},
	getNsdlAlignedResources: function(page, displaytype) {
		/* this along with getNsdlRelatedResources are deprecated and their calling function has been removed from
		 * the documentation. These are around just in case some clients might still be using the nsdl aligned
		 * and related tabs. This has been changed to just show them all in one tab which is NSDL Top picks
		 * this method should be removed in the future
		 */
		alignedResComplete = false;
		alignedResExists = false;
		
		startingOffset = 0;
		maxTotalResults = 5
		maxPerPage = 5
		
		StrandMap.getNsdlResources(startingOffset, maxTotalResults, maxPerPage, page, 
				displaytype, "getNsdlAlignedResources", "displayAlignedRes", _nsdlalignedTab)
	},
	getNsdlRelatedResources: function(page, displaytype) {
		/* this along with getNsdlAlignedResources are deprecated and their calling function has been removed from
		 * the documentation. These are around just in case some clients might still be using the nsdl aligned
		 * and related tabs. This has been changed to just show them all in one tab which is NSDL Top picks
		 * this method should be removed in the future
		 */
		relatedResComplete = false;
		relatedResExists = false;
		
		startingOffset = 5;
		maxTotalResults = null
		maxPerPage = 5
		
		StrandMap.getNsdlResources(startingOffset, maxTotalResults, maxPerPage, page, 
				displaytype, 'getNsdlRelatedResources', 'displayRelatedRes', _nsdlrelatedTab )
	},
	getTopPicks: function(page, displaytype) {
		StrandMap.getNsdlTopPicks(page, displaytype)
		
	},
	getNsdlTopPicks: function(page, displaytype) {
		
		nsdltoppicksResComplete = false;
		nsdltoppicksResExists = false;
		toppicksResComplete = false;
		toppicksResExists = false;
		startingOffset = 0;
		maxTotalResults = null
		maxPerPage = 5
		
		StrandMap.getNsdlResources(startingOffset, maxTotalResults, maxPerPage, page, 
				displaytype, 'getNsdlTopPicks', 'displayNSDLTopPicks', _nsdltoppicksTab)
	},
	getNsdlResources: function(startingOffset, maxTotalResults, maxPerPage, page, displaytype, calling_function, callback, tab) {
		if (typeof page == 'undefined')
			page = 1

		if(displaytype != 'print'){
			tab.setContent('<img src="'+baseJsapiUrl+'/api_v1/interactive_map/images/spinner.gif" id="bmk-ld-img" width="16" height="16" style="vertical-align: middle; display:none" onload="$(\'bmk-ld-img\').show();"/>&nbsp;Loading...');
		}
		
		var json = StrandMap.getSelectedBenchmarkRecordJson();
		var id = StrandMap.getSelectedBenchmarkId();	
		<!--// get the map id //-->
		var referringMapId = StrandMap.getReferringMapId();
		if(referringMapId != null){
			var mapId = referringMapId;
		} else {
			var mapId = StrandMap.getMapId();
		}
		
		if(!displaytype){
			displaytype='';	
		}
		
		var AAASCode = json.itemRecord.Data.AAASCode;
		var re = new RegExp('/[A-Z]*');
		var grdloc = AAASCode.search(re);
		var newCode = AAASCode.substring(0,grdloc-1)+ '.' + AAASCode.substring(grdloc-1);
		var subCode = newCode.replace(re,'.');
		
		var re2 = new RegExp('a?b?$');
		var paraloc = subCode.search(re2);
		var lastCode = subCode.substring(0,paraloc);
		
		// retrieve specified collections if any
		var collectionList = '';
		if (typeof smsCollections != 'undefined') {
			var i=0;
			for(i;i<=smsCollections.length;i++){
				if(i == 0){
					collectionList = smsCollections[i];
				} else if(i != smsCollections.length) {
					collectionList += '|' + smsCollections[i];
				}
			}
		}

		var reqUrl = baseJsapiUrl+"/api_v1/bubble/resources.jsp?displaytype="+displaytype+"&collections="+collectionList+"&maxPerPage="+maxPerPage+"&page="+page+"&bmId="+ id + "&mapId="+mapId+"&AAASCode="+lastCode+"&callback="+callback+"&callingFunction="+calling_function+"&startingOffset="+startingOffset;
		
		if(maxTotalResults!=null)
			reqUrl+="&maxTotalResults="+maxTotalResults;
		var mapScriptReq = document.createElement( 'script' );
		mapScriptReq.src = reqUrl;
		mapScriptReq.charset = "utf-8";
		mapScriptReq.type = "text/javascript";
		document.getElementsByTagName('head')[0].appendChild( mapScriptReq );	
	},
	getAaasAssessment: function(displaytype) {

		aaasAssessmentComplete = false;
		aaasAssessmentExists = false;
		
		if(displaytype != 'print'){
			_aaasassessmentTab.setContent('<img src="'+baseJsapiUrl+'/api_v1/interactive_map/images/spinner.gif" id="bmk-ld-img" width="16" height="16" style="vertical-align: middle; display:none" onload="$(\'bmk-ld-img\').show();"/>&nbsp;Loading...');
		}
		var bmJson = StrandMap.getSelectedBenchmarkRecordJson();
		var id = StrandMap.getSelectedBenchmarkId();	
		var AAASCode = bmJson.itemRecord.Data.AAASCode;
		var re = new RegExp('/[A-Z]*');
		var grdloc = AAASCode.search(re);
		var newCode = AAASCode.substring(0,grdloc-1)+ '.' + AAASCode.substring(grdloc-1);
		var subCode = newCode.replace(re,'.');
		
		var re2 = new RegExp('a?b?$');
		var paraloc = subCode.search(re2);
		var lastCode = subCode.substring(0,paraloc);
		var reqUrl = baseJsapiUrl+"/api_v1/bubble/aaasAssessment.jsp?bmId="+id+"&displaytype="+displaytype+"&AAASCode="+lastCode;
		var mapScriptReq = document.createElement( 'script' );
		mapScriptReq.src = reqUrl;
		mapScriptReq.charset = "utf-8";
		mapScriptReq.type = "text/javascript";
		document.getElementsByTagName('head')[0].appendChild( mapScriptReq );	
		
		
		
		
	},
	getAaasMisconception: function(displaytype) {
		aaasMisconceptionComplete = false;
		aaasMisconceptionExists = false;
		
		if(displaytype != 'print'){
			_aaasmisconceptionTab.setContent('<img src="'+baseJsapiUrl+'/api_v1/interactive_map/images/spinner.gif" id="bmk-ld-img" width="16" height="16" style="vertical-align: middle; display:none" onload="$(\'bmk-ld-img\').show();"/>&nbsp;Loading...');
		}
		
		var bmJson = StrandMap.getSelectedBenchmarkRecordJson();
		var id = StrandMap.getSelectedBenchmarkId();	
		var AAASCode = bmJson.itemRecord.Data.AAASCode;
		var re = new RegExp('/[A-Z]*');
		var grdloc = AAASCode.search(re);
		var newCode = AAASCode.substring(0,grdloc-1)+ '.' + AAASCode.substring(grdloc-1);
		var subCode = newCode.replace(re,'.');
		
		var re2 = new RegExp('a?b?$');
		var paraloc = subCode.search(re2);
		var lastCode = subCode.substring(0,paraloc);
		var reqUrl = baseJsapiUrl+"/api_v1/bubble/aaasMisconception.jsp?bmId="+id+"&displaytype="+displaytype+"&AAASCode="+lastCode;
		var mapScriptReq = document.createElement( 'script' );
		mapScriptReq.src = reqUrl;
		mapScriptReq.charset = "utf-8";
		mapScriptReq.type = "text/javascript";
		document.getElementsByTagName('head')[0].appendChild( mapScriptReq );	
		
	},
	_bmContentHtml: function (bmJson,displayStds) {		
		var mainContent = '<div style="margin-bottom:10;padding-top:6;">';
		mainContent += bmJson.itemRecord.Data.Description;
		mainContent += ' <em>' + bmJson.itemRecord.Data.AAASCode + '</em> ';
		mainContent += ' <span style="font-size:smaller;">(ID: ' + bmJson.itemRecord.Admin.IDNumber + ')</span>';
		mainContent += '<div style="padding-top:8"><em>Grade range</em>: ';
		var grArray = bmJson.itemRecord.Data.GradeRanges.GradeRange;	
		mainContent += grArray[0] + ' - ' + grArray[grArray.length-1] + '</div>';
		
		var ds = (displayStds == 'undefined' ? 'false' : displayStds);
		
		if(bmJson.itemRecord.Data.Standards.length > 0) {
			mainContent += '<div style="padding-top:8"><a id="viewStandardsTag" href="javascript:_toggleStandards();" style="' + (ds ? 'display:none;' : '') + '">View standards</a><a id="hideStandardsTag" href="javascript:_toggleStandards();" style="' + (ds ? '' : 'display:none;') + '">Hide standards</a></div>';
			mainContent += '<div id="standards" style="' + (ds ? '' : 'display:none;') + ' padding-top: 6;padding-left:12;">';
			mainContent += retrieveStandards(bmJson);
			mainContent += '</div>';
		}
		
		mainContent += '</div>';
		return mainContent;
	},
	_bmContentOnly: function (bmJson) {		
		var mainContent = '<div style="margin-bottom:10;padding-top:6;">';
		mainContent += bmJson.itemRecord.Data.Description;
		mainContent += ' <em>' + bmJson.itemRecord.Data.AAASCode + '</em> ';
		mainContent += ' <span style="font-size:smaller">(ID: ' + bmJson.itemRecord.Admin.IDNumber + ')</span>';
		mainContent += '<div style="padding-top:8"><em>Grade range</em>: ';
		var grArray = bmJson.itemRecord.Data.GradeRanges.GradeRange;	
		mainContent += grArray[0] + ' - ' + grArray[grArray.length-1] + '</div>';
		mainContent += '</div>';
		return mainContent;
	},
	_bmContentRelatedMaps: function (bmJson,displayRelatedMaps,opts) {		
		var mainContent = '<div style="margin-bottom:10;padding-top:6;">';
		mainContent += bmJson.itemRecord.Data.Description;
		mainContent += ' <em>' + bmJson.itemRecord.Data.AAASCode + '</em> ';
		mainContent += ' <span style="font-size:smaller">(ID: ' + bmJson.itemRecord.Admin.IDNumber + ')</span>';
		mainContent += '<div style="padding-top:8"><em>Grade range</em>: ';
		var grArray = bmJson.itemRecord.Data.GradeRanges.GradeRange;	
		mainContent += grArray[0] + ' - ' + grArray[grArray.length-1] + '</div>';
		mainContent += '</div>';
		
		// If one of the options is to show strand
		if(typeof opts!= 'undefined' && opts.contains('show_strands'))
		{
			retrieveBenchmarkStrands(bmJson);
			mainContent += '<div style="padding-bottom:10px;display:none;" id="benchmarkStrandsContainer"><em><span id="benchmarkStrandsLabel"></span></em>: <div id="benchmarkStrands" style="padding-top:5px;padding-bottom:5px;display:inline;">';
			mainContent += '<span id="benchmarkStrands"></span>';
			mainContent += '</div></div>';
		}
		// for related maps
		var drm = (displayRelatedMaps == 'undefined' ? 'false' : displayRelatedMaps);
		
		var relatedMaps = retrieveRelatedMaps(bmJson);
		if(relatedMaps){
			mainContent += '<div style="padding-bottom:10px;display:none;" id="relatedMapsContainer">This benchmark is found in the following maps: <div id="relatedMaps" style="padding-top:5px;padding-bottom:5px;display:inline;">';
			mainContent += '<span id="relatedMaps"></span>';
			mainContent += '</div></div>';
		}
		
		return mainContent;
	},
	setMapObjectAnnotation: function (objectID, yLocation, xLocation, html)
	{
		if(objectID=='mapImage')
		{
			elems = $$('.mapImage');
			if(elems.length>0)
				elem = elems[0]
		}
		else if(objectID.startsWith('SMS'))
			elem = $('region-'+objectID);
		else
			elem = $(objectID);
		
		if(elem==null)
			return
		width =  parseInt(elem.getStyle('width'))
		height =  parseInt(elem.getStyle('height'))
		y =  parseInt(elem.getStyle('top'))
		x =  parseInt(elem.getStyle('left'))
		
		yLocation = yLocation.toLowerCase()
		xLocation = xLocation.toLowerCase()
		annotationTop = 0
		annotationLeft = 0
		
		// figure out the left
		if(xLocation=="left")
		{
			annotationLeft = x 
		}
		else if(xLocation=="middle")
		{
			annotationLeft = x + (width/2)
		}
		else if(xLocation=="right")
		{
			annotationLeft = x + width
		}
		else
		{
			throw xLocation + " is not a valid choice for xLocation. Options are left, middle, or right"
		}
		
		// figure out the top
		if(yLocation=="top")
		{
			annotationTop = y 
		}
		else if(yLocation=="middle")
		{
			annotationTop = y + (height/2)
		}
		else if(yLocation=="bottom")
		{
			annotationTop = y + width
		}
		else
		{
			throw yLocation + " is not a valid choice for yLocation. Options are top, middle, or bottom"
		}
		/* The annotation for the object in that location might already exist, therefore we 
		// check to see if it does. If it does we do a replace. Otherwise its an insertion into the
		dom */
		

		var newId = "objectAnnotation-"+objectID+"-"+yLocation+xLocation;
		currentAnnotation = $(newId)
		
		
		if(currentAnnotation)
		{
			if(html==null||html=="")
				currentAnnotation.remove();
			else
			{
				currentAnnotation.update(html)
			}
		}
		else if(html!=null && html!="")
		{
			new Insertion.After( elem, '<div id="' +
					newId +
			'" class="objectAnnotation" >'+html+'</div>'
			); 
			var newDiv = $(newId);
			newDiv.setStyle({'left':annotationLeft,'top':annotationTop, 'position':'absolute', 'z-index':'5'} );
		}
	},
	_selectedBenchmarkId: null,
	_misconceptionHtml: null,
	_navigatorArrows:false,
	_validEvents: ["onload","onbenchmarkselect","onprintviewdisplay","onbenchmarkclose"]
});

// The StrandMap instance:
var StrandMap = new _StrandMap();

// Public Event API:
var SMSEvent = {
	addListener: function(source,event,handler) {
		source._addEventHandler(event,handler);
	},
	fireEvent: function(source,event) {
		source._fireEvent(event,handler);
	}	
}
function saveRelatedMaps(resp){
	var relatedMapContent = resp.content;
	if($('relatedMaps')){
		$('relatedMaps').update(relatedMapContent);
		$('relatedMapsContainer').show();
	}
}

function saveBenchmarkStrands(resp){
	var benchmarkStrandsContent = resp.content;
	if($('benchmarkStrands')){
		label = "Strand"
		if(benchmarkStrandsContent.indexOf(',')!=-1)
			label+='s';
		
		$('benchmarkStrandsLabel').update(label)
		
		$('benchmarkStrands').update(benchmarkStrandsContent);
		$('benchmarkStrandsContainer').show();
	}
}

/* this along with displayRelatedRes are deprecated and their calling function has been removed from
 * the documentation. These are around just in case some clients might still be using the nsdl aligned
 * and related tabs. This has been changed to just show them all in one tab which is NSDL Top picks
 * this method should be removed in the future
 */
function displayRelatedRes(resp){
	var displaytype = resp.displaytype;
	var content = resp.nsdlRes;

	if(checkContentExists(content)){
		if(displaytype == 'print'){
			if($('nsdlRelatedText'))
				$('nsdlRelatedText').update('<div style="padding-top:25; padding-bottom:10;"></div><h3>'+nsdlRelatedLabel+'</h3>' + content);
		} else {
			_nsdlrelatedTab.setContent(content);
		}
		relatedResComplete = true;
		relatedResExists = true;
	} else {
		if(displaytype != 'print'){
			_nsdlrelatedTab.setContent("There are no resources related to this benchmark.");
		}
		relatedResComplete = true;
		relatedResExists = false;
	}
}
function displayNSDLTopPicks(resp){
	var displaytype = resp.displaytype;
	var content = resp.nsdlRes;
	_nsdltoppicksTab.changeLabel(null);
	
	if(checkContentExists(content)){
		if(displaytype == 'print'){
			if($('nsdlTopPicksText'))
				$('nsdlTopPicksText').update('<div style="padding-top:25; padding-bottom:10;"></div><h3>'+nsdltoppicksLabel+'</h3>' + content);
		} else {
			_nsdltoppicksTab.setContent(content);
			resultCount = $('numResultsdisplayNSDLTopPicks').innerHTML;
			_nsdltoppicksTab.appendToLabel("("+resultCount+")");
		}
		nsdltoppicksResComplete = true;
		nsdltoppicksResExists = true;
		toppicksResComplete = true;
		toppicksResExists = true;
		
	} else {
		if(displaytype != 'print'){
			_nsdltoppicksTab.setContent("There are no resources related to this benchmark.");
		}
		nsdltoppicksResComplete = true;
		nsdltoppicksResExists = false;
		toppicksResComplete = true;
		toppicksResExists = false;
	}
}

function displayNGSS(resp){
	var displaytype = resp.displaytype;
	var content = resp.ngssRes;

	if(checkContentExists(content)){
		if(displaytype == 'print'){
			if($('ngssText'))
				$('ngssText').update('<div style="padding-top:25; padding-bottom:10;"></div><h3>'+ngssLabel+'</h3>' + content);
		} else {
			_ngssTab.setContent(content);
		}
		ngssComplete = true;
		ngssExists = true;
	} else {
		if(displaytype != 'print'){
			_ngssTab.setContent("There are no NGSS standards related to this benchmark.");
		}
		ngssComplete = true;
		ngssExists = false;
	}
}

/* this along with displayRelatedRes are deprecated and their calling function has been removed from
 * the documentation. These are around just in case some clients might still be using the nsdl aligned
 * and related tabs. This has been changed to just show them all in one tab which is NSDL Top picks
 * this method should be removed in the future
 */
function displayAlignedRes(resp){
	var displaytype = resp.displaytype;
	var content = resp.nsdlRes;
	
	if(checkContentExists(content)){
		if(displaytype == 'print'){
			if($('nsdlAlignedText'))
				$('nsdlAlignedText').update('<div style="padding-top:25; padding-bottom:10;"></div><h3>'+nsdlAlignedLabel+'</h3>' + content);
		} else {
			_nsdlalignedTab.setContent(content);
		}
		alignedResComplete = true;
		alignedResExists = true;
	} else {
		if(displaytype != 'print'){
			_nsdlalignedTab.setContent("There are no resources aligned with this benchmark.");
		}
		alignedResComplete = true;
		alignedResExists = false;
	}
}
function displayAaasAssessment(resp){
	var displaytype = resp.displaytype;
	var content = resp.aaasAssessment;
	if(checkContentExists(content)){
		if(displaytype == 'print'){
			if($('aaasAssessmentText'))
				$('aaasAssessmentText').update('<div style="padding-top:25; padding-bottom:10;"></div><h3>'+aaasAssessmentLabel+'</h3>' + content);
		} else {
			_aaasassessmentTab.setContent(content);
		}
		aaasAssessmentComplete = true;
		aaasAssessmentExists = true;
		
	} else {
		if(displaytype != 'print'){
			_aaasassessmentTab.setContent("There are no assessments related to this benchmark.");
		}
		aaasAssessmentComplete = true;
		aaasAssessmentExists = false;
	}
}
function displayAaasMisconception(resp){
	var displaytype = resp.displaytype;
	var content = resp.aaasMisconception;
	if(checkContentExists(content)){
		if(displaytype == 'print'){
			if($('aaasMisconceptionText'))
				$('aaasMisconceptionText').update('<div style="padding-top:25; padding-bottom:10;"></div><h3>'+aaasMisconceptionLabel+'</h3>' + content);
		} else {
			_aaasmisconceptionTab.setContent(content);
		}
		aaasMisconceptionComplete = true;
		aaasMisconceptionExists = true;
	} else {
		if(displaytype != 'print'){
			_aaasmisconceptionTab.setContent("There are no misconception related to this benchmark.");
		}
		aaasMisconceptionComplete = true;
		aaasMisconceptionExists = false;
	}
}
// Toggles 'View standards' 
function _toggleStandards(){
	$('standards').toggle();
	$('viewStandardsTag').toggle();
	$('hideStandardsTag').toggle()
}	

// preformats NSES standards
function retrieveStandards(bmJson){
	var content = '';
	var sa = bmJson.itemRecord.Data.Standards.toString().split('+');
	var stdContentArray = new Array();
	var stdNameArray = new Array();
	var stdArray = new Array();
	var indexArray = 0;
	var indexContentArray = 0;
	var indexNameArray = 0;
				
	try{
		for (var i = 0; i< sa.length; i+=6) {
			if(i==0){
				stdArray[i] = sa[i] + ' ' + sa[i+3];
				stdContentArray[sa[i] + ' ' + sa[i+3]] = new Array(sa[i+4]);
				stdNameArray[sa[i+4]] = new Array(sa[i+5]);	
			} else {
				if(stdArray.toString().indexOf(sa[i] + ' ' + sa[i+3]) == -1){
					<!--// if new content //-->
					var newIndex = stdArray.length;
					stdArray[newIndex] = sa[i] + ' ' + sa[i+3];
					stdContentArray[sa[i] + ' ' + sa[i+3]] = new Array(sa[i+4]);
					stdNameArray[sa[i+4]] = new Array(sa[i+5]);
				} else {
					<!--// Content Already exists //-->
					var oldIndex = stdArray.toString().indexOf(sa[i] + ' ' + sa[i+3]);
					if(stdContentArray[sa[i] + ' ' + sa[i+3]].toString().search(sa[i+4]) == -1){
						<!--// if new content //-->
						var contentLength = stdContentArray[sa[i] + ' ' + sa[i+3]].length;
							stdContentArray[sa[i] + ' ' + sa[i+3]][contentLength] = sa[i+4];
						stdNameArray[sa[i+4]] = new Array(sa[i+5]);
					} else {
						<!--// Content Already exists //-->
						if(stdNameArray[sa[i+4]].toString().search(sa[i+5]) == -1){
							var nameLength = stdNameArray[sa[i+4]].length;
							stdNameArray[sa[i+4]][nameLength] = sa[i+5];
						}
					}		
				}
			}
		}
	} catch(e) {}
	
	content += '<ul>';
	for(var k=0;k<stdArray.length;k++){
		content += '<li><strong>'+ stdArray[k]+'</strong>';
					
		content += '<ul>';
		for(var m=0;m<stdContentArray[stdArray[k]].length;m++){
			content += '<li><em>'+ stdContentArray[stdArray[k]][m]+'</em>';
						
			content += '<ul>';
			for(var p = 0; p<stdNameArray[stdContentArray[stdArray[k]][m]].length;p++){
				content += '<li>'+ stdNameArray[stdContentArray[stdArray[k]][m]][p] + '</li>';
			}
			content += '</ul>';
		}
		content += '</ul></li>';
	}
	content += '</ul>';
				
	return content;	
	
}


// preformats related maps
function retrieveRelatedMaps(bmJson){
	var catIdNode = bmJson.itemRecord.Data.InternalRelationship.CatalogID;
	var bmID = StrandMap.getSelectedBenchmarkId();
	var thismap = StrandMap.getMapId();

	var grades = '';
	var grdAry = new Array();
	
	// retrieve all of the grades this bm is a member of
	if(typeof(catIdNode.length) != 'undefined'){
		for(var i = 0; i < catIdNode.length; i++){
			if(catIdNode[i].RelationType.toLowerCase() == 'is part of' && (catIdNode[i].CatalogNumber.search('SMS-GRD') != -1)){
				if(grades == ''){
					grades += catIdNode[i].CatalogNumber;
				} else {
					grades += '|'+ catIdNode[i].CatalogNumber;
				}
				grdAry[grdAry.length] = catIdNode[i].CatalogNumber;
			}
		}
		var reqUrl = baseJsapiUrl+"/api_v1/map_list/relatedMaps.jsp?bmid="+bmID+"&mapid="+thismap+"&id="+grades;
		
		var mapScriptReq = document.createElement( 'script' );
		mapScriptReq.src = reqUrl;
		mapScriptReq.charset = "utf-8";
		mapScriptReq.type = "text/javascript";
		document.getElementsByTagName('head')[0].appendChild( mapScriptReq );		
					
		return true;
		
		
	}
	return false;	
}


function retrieveBenchmarkStrands(bmJson){
	var bmID = StrandMap.getSelectedBenchmarkId();
	var thismap = StrandMap.getMapId();
	var reqUrl = baseJsapiUrl+"/api_v1/map_list/benchmarkStrands.jsp?bmid="+bmID+"&mapid="+thismap;
	
	var mapScriptReq = document.createElement( 'script' );
	mapScriptReq.src = reqUrl;
	mapScriptReq.charset = "utf-8";
	mapScriptReq.type = "text/javascript";
	document.getElementsByTagName('head')[0].appendChild( mapScriptReq );		
	return true;
}

// misconceptions
var isMisconceptionsDown = false;
function toggleMisconceptions(){
	if(isMisconceptionsDown) {
		Effect.BlindUp('smsMisconceptions',{duration:0.5});
		$('smsMisconceptionsLink').update('View Research on Student Learning');
		$$('.misconceptionLinkOpen').each(function(elm) { 
			elm.removeClassName('misconceptionLinkOpen');
		});
		setMouseWheelListener(true);
	}
	else{
		hideLinkToPage();
		Effect.BlindDown('smsMisconceptions',{duration:0.5});
		$('smsMisconceptionsLink').update('Close Research on Student Learning');
		$$('.misconceptionLinkClosed').each(function(elm) { 
			elm.addClassName('misconceptionLinkOpen');
		}); 
		setMouseWheelListener(false);
	}
	isMisconceptionsDown = !isMisconceptionsDown;
}	

// get any associated misconceptions
function retrieveMisconceptions(mapJson){
	var misconceptionText = '';
	var misconceptionsReference = '';
	var mapConceptions = mapJson.itemRecord.Data.NarrativeStudentIdeas.Conception;		
	var sourcecount = 1;

	if(mapConceptions != undefined) {
		try {
			if(mapConceptions.length == undefined) {
				misconceptionText += "<p>";
				
				if(mapConceptions.Statement.length == undefined){
					var mcStatement = mapConceptions.Statement;
						
					misconceptionText += mcStatement.Text + " <sup>["+sourcecount+"]</sup> ";
					misconceptionsReference += "<p> ["+sourcecount+"] ";
					if(!objIsArray(mcStatement.Source)){
						var mcSource = mcStatement.Source;
						
						var authors = '';
						if(!objIsArray(mcSource.Author)){
							authors = mcSource.Author;	
						} else {
							for(var m = 0; m<mcSource.Author.length;m++){
								if(authors == ''){
									authors = mcSource.Author[m];
								} else {
									authors += ", "+ mcSource.Author[m];	
								}
							}
						}
							
						misconceptionsReference += authors + " ("+ mcSource.Publication['year']+"). ";
						if(mcSource.Title && mcSource.Publication['content'] && (mcSource.Title != mcSource.Publication['content'])){
							misconceptionsReference += mcSource.Title+'. '; 
						}
						if(mcSource.Publication['editor']){
							misconceptionsReference += "In " + mcSource.Publication['editor'] + " (Ed.), ";
						}
						if(mcSource.Publication['content']){
							misconceptionsReference += " <em>"+ mcSource.Publication['content'] + "</em>";
						} else if(mcSource.Title && (mcSource.Title != mcSource.Publication['content'])) {
							misconceptionsReference += " <em>"+ mcSource.Title + "</em>";
						}
						if(mcSource.Publication['volume']){
							misconceptionsReference += ", " + mcSource.Publication['volume']+', ';
						}
						if(mcSource.Publication['pages']){
							if(mcSource.Publication['editor']){
								misconceptionsReference += " (pp. " + mcSource.Publication['pages'] + ").";
							} else {
								if(!mcSource.Publication['volume']){
									misconceptionsReference += ", " + mcSource.Publication['pages'] + ".";
								} else {
									misconceptionsReference += " " + mcSource.Publication['pages'] + ".";
								}
							}
						}else if(mcSource.Publication['content'] || (!mcSource.Publication['content'] && mcSource.Title && (mcSource.Title != mcSource.Publication['content']))){
							misconceptionsReference += ". ";
						}
						if(mcSource.Publication['publisher']){
							misconceptionsReference += " " + mcSource.Publication['publisher'] + ".";
						}
						misconceptionsReference += "<br/><br/>";
							
					} else {
						for(var k=0;k< mcStatement.Source.length;k++){
							var mcSource = mcStatement.Source[k];
							
							var authors = '';
								
							if(!objIsArray(mcSource.Author)){
								authors = mcSource.Author;	
							} else {
								for(var m = 0; m<mcSource.Author.length;m++){
									if(authors == ''){
										authors = mcSource.Author[m];
									} else {
										authors += ", "+ mcSource.Author[m];	
									}
								}
							}
							misconceptionsReference += authors + " ("+ mcSource.Publication['year']+"). ";
							if(mcSource.Title && mcSource.Publication['content'] && (mcSource.Title != mcSource.Publication['content'])){
								misconceptionsReference += mcSource.Title+'. '; 
							}
							if(mcSource.Publication['editor']){
								misconceptionsReference += "In " + mcSource.Publication['editor'] + " (Ed.), ";
							}
							if(mcSource.Publication['content']){
								misconceptionsReference += " <em>"+ mcSource.Publication['content'] + "</em>";
							} else if(mcSource.Title && (mcSource.Title != mcSource.Publication['content'])) {
								misconceptionsReference += " <em>"+ mcSource.Title + "</em>";
							}
							if(mcSource.Publication['volume']){
								misconceptionsReference += ", " + mcSource.Publication['volume']+', ';
							}
							if(mcSource.Publication['pages']){
								if(mcSource.Publication['editor']){
									misconceptionsReference += " (pp. " + mcSource.Publication['pages'] + ").";
								} else {
									if(!mcSource.Publication['volume']){
										misconceptionsReference += ", " + mcSource.Publication['pages'] + ".";
									} else {
										misconceptionsReference += " " + mcSource.Publication['pages'] + ".";
									}
								}
							}else if(mcSource.Publication['content'] || (!mcSource.Publication['content'] && mcSource.Title && (mcSource.Title != mcSource.Publication['content']))){
								misconceptionsReference += ". ";
							}
							if(mcSource.Publication['publisher']){
								misconceptionsReference += " " + mcSource.Publication['publisher'] + ".";
							}
							misconceptionsReference += "<br/><br/>";
						}
					}
					sourcecount++;	
				} else {
					for(var j=0;j< mapConceptions.Statement.length;j++){
						var mcStatement = mapConceptions.Statement[j];
							
						misconceptionText += mcStatement.Text + " <sup>["+sourcecount+"]</sup> ";
						misconceptionsReference += "<p> ["+sourcecount+"] ";
						if(!objIsArray(mcStatement.Source)){
							var mcSource = mcStatement.Source;
								
							var authors = '';
							if(!objIsArray(mcSource.Author)){
								authors = mcSource.Author;	
							} else {
								for(var m = 0; m<mcSource.Author.length;m++){
									if(authors == ''){
										authors = mcSource.Author[m];
									} else {
										authors += ", "+ mcSource.Author[m];	
									}
								}
							}
							misconceptionsReference += authors + " ("+ mcSource.Publication['year']+"). ";
							if(mcSource.Title && mcSource.Publication['content'] && (mcSource.Title != mcSource.Publication['content'])){
								misconceptionsReference += mcSource.Title+'. '; 
							}
							if(mcSource.Publication['editor']){
								misconceptionsReference += "In " + mcSource.Publication['editor'] + " (Ed.), ";
							}
							if(mcSource.Publication['content']){
								misconceptionsReference += " <em>"+ mcSource.Publication['content'] + "</em>";
							} else if(mcSource.Title && (mcSource.Title != mcSource.Publication['content'])) {
								misconceptionsReference += " <em>"+ mcSource.Title + "</em>";
							}
							if(mcSource.Publication['volume']){
								misconceptionsReference += ", " + mcSource.Publication['volume']+', ';
							}
							if(mcSource.Publication['pages']){
								if(mcSource.Publication['editor']){
									misconceptionsReference += " (pp. " + mcSource.Publication['pages'] + ").";
								} else {
									if(!mcSource.Publication['volume']){
										misconceptionsReference += ", " + mcSource.Publication['pages'] + ".";
									} else {
										misconceptionsReference += " " + mcSource.Publication['pages'] + ".";
									}
								}
							}else if(mcSource.Publication['content'] || (!mcSource.Publication['content'] && mcSource.Title && (mcSource.Title != mcSource.Publication['content']))){
								misconceptionsReference += ". ";
							}
							if(mcSource.Publication['publisher']){
								misconceptionsReference += " " + mcSource.Publication['publisher'] + ".";
							}
							misconceptionsReference += "<br/><br/>";
						} else {
							for(var k=0;k< mcStatement.Source.length;k++){
								var mcSource = mcStatement.Source[k];
									
								var authors = '';
								if(!objIsArray(mcSource.Author)){
									authors = mcSource.Author;	
								} else {
									for(var m = 0; m<mcSource.Author.length;m++){
										if(authors == ''){
											authors = mcSource.Author[m];
										} else {
											authors += ", "+ mcSource.Author[m];	
										}
									}
								}
								misconceptionsReference += authors + " ("+ mcSource.Publication['year']+"). ";
								if(mcSource.Title && mcSource.Publication['content'] && (mcSource.Title != mcSource.Publication['content'])){
									misconceptionsReference += mcSource.Title+'. '; 
								}
								if(mcSource.Publication['editor']){
									misconceptionsReference += "In " + mcSource.Publication['editor'] + " (Ed.), ";
								}
								if(mcSource.Publication['content']){
									misconceptionsReference += " <em>"+ mcSource.Publication['content'] + "</em>";
								} else if(mcSource.Title && (mcSource.Title != mcSource.Publication['content'])) {
									misconceptionsReference += " <em>"+ mcSource.Title + "</em>";
								}
								if(mcSource.Publication['volume']){
									misconceptionsReference += ", " + mcSource.Publication['volume']+', ';
								}
								if(mcSource.Publication['pages']){
									if(mcSource.Publication['editor']){
										misconceptionsReference += " (pp. " + mcSource.Publication['pages'] + ").";
									} else {
										if(!mcSource.Publication['volume']){
											misconceptionsReference += ", " + mcSource.Publication['pages'] + ".";
										} else {
											misconceptionsReference += " " + mcSource.Publication['pages'] + ".";
										}
									}
								}else if(mcSource.Publication['content'] || (!mcSource.Publication['content'] && mcSource.Title && (mcSource.Title != mcSource.Publication['content']))){
									misconceptionsReference += ". ";
								}
								if(mcSource.Publication['publisher']){
									misconceptionsReference += " " + mcSource.Publication['publisher'] + ".";
								}
								misconceptionsReference += "<br/><br/>";
							}
						}
						sourcecount++;
					}
				}
				misconceptionText += "</p>";
			} else {
				for(var i=0;i<mapConceptions.length;i++){
					misconceptionText += "<p>";
					if(mapConceptions[i].Statement.length == undefined){
						var mcStatement = mapConceptions[i].Statement;
					
						misconceptionText += mcStatement.Text + " <sup>["+sourcecount+"]</sup> ";
						misconceptionsReference += "<p> ["+sourcecount+"] ";
						if(!objIsArray(mcStatement.Source)){
							var mcSource = mcStatement.Source;
							
							var authors = '';
							if(!objIsArray(mcSource.Author)){
								authors = mcSource.Author;	
							} else {
								for(var m = 0; m<mcSource.Author.length;m++){
									if(authors == ''){
										authors = mcSource.Author[m];
									} else {
										authors += ", "+ mcSource.Author[m];	
									}
								}
							}
							misconceptionsReference += authors + " ("+ mcSource.Publication['year']+"). ";
							if(mcSource.Title && mcSource.Publication['content'] && (mcSource.Title != mcSource.Publication['content'])){
								misconceptionsReference += mcSource.Title+'. '; 
							}
							if(mcSource.Publication['editor']){
								misconceptionsReference += "In " + mcSource.Publication['editor'] + " (Ed.), ";
							}
							if(mcSource.Publication['content']){
								misconceptionsReference += " <em>"+ mcSource.Publication['content'] + "</em>";
							} else if(mcSource.Title && (mcSource.Title != mcSource.Publication['content'])) {
								misconceptionsReference += " <em>"+ mcSource.Title + "</em>";
							}
							if(mcSource.Publication['volume']){
								misconceptionsReference += ", " + mcSource.Publication['volume']+', ';
							}
							if(mcSource.Publication['pages']){
								if(mcSource.Publication['editor']){
									misconceptionsReference += " (pp. " + mcSource.Publication['pages'] + ").";
								} else {
									if(!mcSource.Publication['volume']){
										misconceptionsReference += ", " + mcSource.Publication['pages'] + ".";
									} else {
										misconceptionsReference += " " + mcSource.Publication['pages'] + ".";
									}
								}
							}else if(mcSource.Publication['content'] || (!mcSource.Publication['content'] && mcSource.Title && (mcSource.Title != mcSource.Publication['content']))){
								misconceptionsReference += ". ";
							}
							if(mcSource.Publication['publisher']){
								misconceptionsReference += " " + mcSource.Publication['publisher'] + ".";
							}
							misconceptionsReference += "<br/><br/>";
						} else {
							for(var k=0;k< mcStatement.Source.length;k++){
								var mcSource = mcStatement.Source[k];
								
								var authors = '';
								if(!objIsArray(mcSource.Author)){
									authors = mcSource.Author;	
								} else {
									for(var m = 0; m<mcSource.Author.length;m++){
										if(authors == ''){
											authors = mcSource.Author[m];
										} else {
											authors += ", "+ mcSource.Author[m];	
										}
									}
								}
								misconceptionsReference += authors + " ("+ mcSource.Publication['year']+"). ";
								if(mcSource.Title && mcSource.Publication['content'] && (mcSource.Title != mcSource.Publication['content'])){
									misconceptionsReference += mcSource.Title+'. '; 
								}
								if(mcSource.Publication['editor']){
									misconceptionsReference += "In " + mcSource.Publication['editor'] + " (Ed.), ";
								}
								if(mcSource.Publication['content']){
									misconceptionsReference += " <em>"+ mcSource.Publication['content'] + "</em>";
								} else if(mcSource.Title && (mcSource.Title != mcSource.Publication['content'])) {
									misconceptionsReference += " <em>"+ mcSource.Title + "</em>";
								}
								if(mcSource.Publication['volume']){
									misconceptionsReference += ", " + mcSource.Publication['volume']+', ';
								}
								if(mcSource.Publication['pages']){
									if(mcSource.Publication['editor']){
										misconceptionsReference += " (pp. " + mcSource.Publication['pages'] + ").";
									} else {
										if(!mcSource.Publication['volume']){
											misconceptionsReference += ", " + mcSource.Publication['pages'] + ".";
										} else {
											misconceptionsReference += " " + mcSource.Publication['pages'] + ".";
										}
									}
								}else if(mcSource.Publication['content']) {
									misconceptionsReference += ". ";
								}
								if(mcSource.Publication['publisher']){
									misconceptionsReference += " " + mcSource.Publication['publisher'] + ".";
								}
								misconceptionsReference += "<br/><br/>";
							}
						}
						sourcecount++;	
					} else {
						for(var j=0;j< mapConceptions[i].Statement.length;j++){
							var mcStatement = mapConceptions[i].Statement[j];
							
							misconceptionText += mcStatement.Text + " <sup>["+sourcecount+"]</sup> ";
							misconceptionsReference += "<p> ["+sourcecount+"] ";
							
							// issue here
							if(!objIsArray(mcStatement.Source)){
								var mcSource = mcStatement.Source;
								var authors = '';
								
								if(!objIsArray(mcSource.Author)){
									authors = mcSource.Author;	
								} else {
									for(var m = 0; m<mcSource.Author.length;m++){
										if(authors == ''){
											authors = mcSource.Author[m];
										} else {
											authors += ", "+ mcSource.Author[m];	
										}
									}
								}
								
								misconceptionsReference += authors + " ("+ mcSource.Publication['year']+"). ";
								if(mcSource.Title && mcSource.Publication['content'] && (mcSource.Title != mcSource.Publication['content'])){
									misconceptionsReference += mcSource.Title+'. '; 
								}
								if(mcSource.Publication['editor']){
									misconceptionsReference += "In " + mcSource.Publication['editor'] + " (Ed.), ";
								}
								if(mcSource.Publication['content']){
									misconceptionsReference += " <em>"+ mcSource.Publication['content'] + "</em>";
								} else if(mcSource.Title && (mcSource.Title != mcSource.Publication['content'])) {
									misconceptionsReference += " <em>"+ mcSource.Title + "</em>";
								}
								if(mcSource.Publication['volume']){
									misconceptionsReference += ", " + mcSource.Publication['volume']+', ';
								}
								if(mcSource.Publication['pages']){
									if(mcSource.Publication['editor']){
										misconceptionsReference += " (pp. " + mcSource.Publication['pages'] + ").";
									} else {
										if(!mcSource.Publication['volume']){
											misconceptionsReference += ", " + mcSource.Publication['pages'] + ".";
										} else {
											misconceptionsReference += " " + mcSource.Publication['pages'] + ".";
										}
									}
								}else if(mcSource.Publication['content'] || (!mcSource.Publication['content'] && mcSource.Title && (mcSource.Title != mcSource.Publication['content']))){
									misconceptionsReference += ". ";
								}
								if(mcSource.Publication['publisher']){
									misconceptionsReference += " " + mcSource.Publication['publisher'] + ".";
								}
								misconceptionsReference += "<br/><br/>";
							} else {
								for(var k=0;k< mcStatement.Source.length;k++){
									var mcSource = mcStatement.Source[k];
									
									var authors = '';
									if(!objIsArray(mcSource.Author)){
										authors = mcSource.Author;	
									} else {
										for(var m = 0; m<mcSource.Author.length;m++){
											if(authors == ''){
												authors = mcSource.Author[m];
											} else {
												authors += ", "+ mcSource.Author[m];	
											}
										}
									}
									misconceptionsReference += authors + " ("+ mcSource.Publication['year']+"). ";
									if(mcSource.Title && mcSource.Publication['content'] && (mcSource.Title != mcSource.Publication['content'])){
										misconceptionsReference += mcSource.Title+'. '; 
									}
									if(mcSource.Publication['editor']){
										misconceptionsReference += "In " + mcSource.Publication['editor'] + " (Ed.), ";
									}
									if(mcSource.Publication['content']){
										misconceptionsReference += " <em>"+ mcSource.Publication['content'] + "</em>";
									} else if(mcSource.Title && (mcSource.Title != mcSource.Publication['content'])) {
										misconceptionsReference += " <em>"+ mcSource.Title + "</em>";
									}
									if(mcSource.Publication['volume']){
										misconceptionsReference += ", " + mcSource.Publication['volume']+', ';
									}
									if(mcSource.Publication['pages']){
										if(mcSource.Publication['editor']){
											misconceptionsReference += " (pp. " + mcSource.Publication['pages'] + ").";
										} else {
											if(!mcSource.Publication['volume']){
												misconceptionsReference += ", " + mcSource.Publication['pages'] + ".";
											} else {
												misconceptionsReference += " " + mcSource.Publication['pages'] + ".";
											}
										}
									}else if(mcSource.Publication['content'] || (!mcSource.Publication['content'] && mcSource.Title && (mcSource.Title != mcSource.Publication['content']))){
										misconceptionsReference += ". ";
									}
									if(mcSource.Publication['publisher']){
										misconceptionsReference += " " + mcSource.Publication['publisher'] + ".";
									}
									misconceptionsReference += "<br/><br/>";
								}
							}
							sourcecount++;
						}
					}
					misconceptionText += "</p>";
				}	
			}
			
		} catch (e) {
			// Exception is thrown in Safari if a value is undifined 
			// alert("error catch: " + e);
		}		
	}

	if(misconceptionText != '') {
		return "<table id='misconceptionsTable'><tr><th>Research on Student Learning</th><th>References</th></tr><tr><td valign='top'>" + misconceptionText + "</td><td valign='top'>"+misconceptionsReference+"</td></tr></table>";
	} else {
		return null;
	}
}

//chk if an object is an array or not.
function objIsArray(obj) {
	return obj && obj.constructor == Array;
}

function checkContentExists(content){
	var re = new RegExp('/[A-Z]*');
	var reAAASitems = new RegExp('assessment-web-svc items results empty');
	var reAAASmiscons = new RegExp('assessment-web-svc miscons results empty');
	var contentCheck = content.search(re);
	var contentCheckAAASitems = content.search(reAAASitems);
	var contentCheckAAASmiscons = content.search(reAAASmiscons);
	if(contentCheck > -1 && contentCheckAAASmiscons == -1 && contentCheckAAASitems == -1){
		return true;
	} else {
		return false;
	}
}

function sendToGoogleTracker(gaFunction, gaUrl, pager, collectionid, resUrl, resPos){
	if(typeof(nsdlSmsTracker) != 'undefined') {
		switch(gaFunction){
			case 'gaTrackResource':
				gaTrackResource(gaUrl,collectionid,resUrl,resPos);
				break;	
			case 'resStrictPagerTrack':
				resStrictPagerTrack(gaUrl,pager)
				break;	
			case 'resPagerTrack':
				resPagerTrack(gaUrl,pager)
				break;	
			case 'gaTrackResViewMore':
				gaTrackResViewMore(gaUrl,collectionid,resUrl,resPos);
				break;	
		}
	}	
	
}