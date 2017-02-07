// Controls the behavior of the call out widget for Interactive Strand Map Service
var CallOut = {
	// Define the default four corners...
	top: 0,
	right: 260,
	bottom: [260,260],
	left: 0,
	tabs: new Array(),
	
	onHide: null,
	onShow: null,
	
	// Render the default callout at the given coordinates:
	renderDefaultAt: function(top,left) {
		var default_height = 210;
		var default_width = 260;	
		var default_left = left - Math.ceil( default_width/2 );
		var coords = {
			"bottom":	{ "top":top, "left":left },
			"top":		top - default_height,			
			"left": 	default_left,
			"right":	default_left + default_width
		};
		
		return this.renderUpAt(coords);
	},
	renderUpAt: function ( coords ) {
		this.setCoords( coords );
		
		// A marker to test positioning...
		//var marker = '<div style="position: absolute; z-index: 30; height: 4; width: 4; background-color: red; top:' + (this.top) + '; left:' + (this.right - 20) + ';"></div>';
		//var marker = '<div style="position: absolute; z-index: 3; height: 3; width: 3; background-color: red; top:' + this.bottom[1] + '; left:' + this.bottom[0] + '; border:0; margin:0; padding:0; overflow: hidden;"></div>';
		//new Insertion.Top('wholeMap', marker);
		
		//Effect.Appear('callOut', { duration: 0.15 });			
		this.calculateAll();			
	},
	setCoords: function ( coords ) {
		if( coords ) {
			if( coords.bottom ) {
				if( coords.bottom.left )
					this.bottom[0] = coords.bottom.left;
				if( coords.bottom.top )
					this.bottom[1] = coords.bottom.top;
			}
			if( coords.left )
				this.left = coords.left;
			if( coords.right )
				this.right = coords.right;
			if( coords.top )
				this.top = coords.top;
		}		
	},
	getCoords: function () {
		var coords = {
			bottom:	{ top: this.bottom[1], left: this.bottom[0] },
			top:	this.top,			
			left: 	this.left,
			right:	this.right
		};
		return coords;
	},
	setContentFromUrl: function(url, params) {
		CallOut.setIsLoading(true);
		new Ajax.Request(
			url, 
			{
				method: 'get', 			
				onSuccess: this.setContent,
				onFailure: this.onFailure
			});
	},
	setContent: function(content) {
		var c;
		if(content.responseText)
			c = content.responseText;
		else
			c = content;
		CallOut.setIsLoading(false);
		$('_co_content_body').update(c);
	},
	getContent: function() {
		return $('_co_content_body').innerHTML;
	},	
	setTitle: function(title) {
		var _co_title_content = $('_co_title_content');
		if(_co_title_content)
			_co_title_content.update(title);	
	},
	getTitle: function() {
		var _co_title_content = $('_co_title_content');
		if(_co_title_content)
			return _co_title_content.innerHTML;
		return '';
	},	
	addTab: function(infoBubbleTab) {
		if(isPrintView())
			return;
		var tabNum = infoBubbleTab._tabId;
		var label = infoBubbleTab._label;
		if($('_co_content_tabs') == null)
			alert('_co_content_tabs is null! onLoad() must happen first! Work on event timing!');
		
		if($('tabBarLabels') == null)
			new Insertion.Top('_co_content_tabs', '<ul id="tabBarLabels"></ul>');

		var tabClass = (tabNum == 0 ? 'tabOn' : 'tabOff');
		var tabLabelHTML = '<li id="tab'+tabNum+'" class="'+tabClass+'">';
		tabLabelHTML += '<a href="JavaScript:CallOut.selectTab(\''+tabNum+'\')">'+label+'</a>';
		tabLabelHTML += '<span id="num'+tabNum+'" class="redHiLite"></span></li>';	
		new Insertion.Bottom('tabBarLabels', tabLabelHTML);
		
		var contentClass = (tabNum == 0 ? 'sectionOn' : 'sectionOff');
		var tabContentHTML = '<div id="content'+tabNum+'" class="'+contentClass+'">';
		tabContentHTML += '<div class="tabContent"><div id="smsTab'+tabNum+'"></div></div></div>';

		new Insertion.Bottom('_co_content_tabs', tabContentHTML); 				
		this.tabs[this.tabs.length] = infoBubbleTab;
	},
	// Select a tab by its ID:
	selectTab: function(tabId) {
		var selectedTab = null;
		for(var i=0;i<this.tabs.length;i++) {
			var myTabId = this.tabs[i]._tabId;
			if(tabId == myTabId){
				var thisTab = 'tab' + myTabId;
				var thisSection = 'content' + myTabId;
				var myTab = $(thisTab);
				var mySection = $(thisSection);
				
				myTab.className = 'tabOn';
				mySection.className = 'contentOn';
				selectedTab = this.tabs[i];
			} else {
				var thisTab = 'tab' + myTabId;
				var thisSection = 'content' + myTabId;
				var myTab = $(thisTab);
				var mySection = $(thisSection);
							
				myTab.className = 'tabOff';
				mySection.className = 'contentOff';
			}
		}
		
		// On tab select callback:
		if(selectedTab != null)
			selectedTab._fireEvent("onselect");
	},
	// Select a tab at the given position:
	selectTabAtPosition: function(pos) {
		if(pos < this.tabs.length)
			this.selectTab(this.tabs[pos]._tabId);
	},
	// Hide the tab without removing it:
	hideTab: function(tabId) {
		var thisTab = $('tab' + tabId);
		if(thisTab)
			thisTab.hide();	
		var thisSection = $('content' + tabId);
		if(thisSection)
			thisSection.hide();		
	},
	// Show the tab (opposite of hideTab):
	showTab: function(tabId) {
		var thisTab = $('tab' + tabId);
		if(thisTab)
			thisTab.show();
		var thisSection = $('content' + tabId);
		if(thisSection)
			thisSection.show();			
	},
	// Hide all tabs without removing them:
	hideTabs: function(dm) {
		var tabs = $('_co_content_tabs');
		if(tabs) {
			tabs.hide();
			if($('tabLdMsg'))
				$('tabLdMsg').remove();
			if(dm) {
				var t = '<div id="tabLdMsg">';
				t += '<img src="'+baseJsapiUrl+'/api_v1/interactive_map/images/spinner.gif" id="bmk-ld-img" width="16" height="16" style="vertical-align: middle; display:none" onload="$(\'bmk-ld-img\').show();"/>';
				t += '&nbsp;Loading...</div>';
				new Insertion.Before(tabs, t);
			}
		}
	},
	// Show all tabs (opposite of hideTabs):
	showTabs: function() {
		var tabs = $('_co_content_tabs');
		if(tabs)
			tabs.show();
		if($('tabLdMsg'))
			$('tabLdMsg').remove();		
	},
	numTabs: function() {
		return this.tabs.length;
	},		
	onFailure: function(msg) {
		CallOut.setIsLoading(false);
		$('_co_content_body').innerHTML = 'Error: ' + msg;	
	},		
	setContentOverflow: function(style) {
		Element.setStyle('_co_content',{overflow:style});
	},	
	hide: function (doOnHide) {
		var co = $('_co');
		if ( co.style.display== '' ) {
			co.style.display='none';
			if(this.onHide != null && (typeof(doOnHide) == 'undefined' || doOnHide))
				this.onHide();
		}
	},
	show: function () {
		var _co = $('_co');
		if ( _co && _co.style.display== 'none' ) {		
			if(this.onShow != null)
				this.onShow();			
			_co.style.display='';
		}
	},
	setIsLoading: function (isLoading) {
		var _co_title_content = $('_co_title_content');
		var _co_title = $('_co_title');
		if(_co_title_content && _co_title){
			if(isLoading) {
				$('_co_title_content').hide();
				$('_co_title').addClassName('isLoading');
			}
			else {
				$('_co_title').removeClassName('isLoading');
				$('_co_title_content').show();
			}
		}
	},
	onHide: function (func) {
		this.onHide = func;
	},
	onShow: function (func) {
		this.onShow = func;
	},
	fireEventOnAllTabs: function (event) {
		for(var i=0;i<this.tabs.length;i++)
			this.tabs[i]._fireEvent(event);
	},		
	isHidden: function () {
		var _co = $('_co');
		return (_co == null || _co.style.display=='none');	
	},
	calculateAll: function () {
		var callOutHOffset = 1327;		
		
		// Ensure mimimum width padding
		if(this.right < this.bottom[0] + 60)
			this.right = this.bottom[0] + 60;
		if(this.left > this.bottom[0] - 25)
			this.left = this.bottom[0] - 25;
		
		// Ensure miminum height:
		if(this.bottom[1] - this.top < 120)
			this.top = this.bottom[1] - 120;
		
		// Fix IE rendering caused by odd delta
		if( (this.left + this.right) % 2 == 1 )
			this.left++;
		if( (this.top + this.bottom[1]) % 2 == 1 )
			this.top++;		
		
		var h = this.bottom[1] - this.top + 20;
		var w = this.right - this.left + 16;		
		   
		var elm;		

		// Assume the callout is inside another element, with top/left at 0,0
		elm = $('_co');		
		elm.style.width = w;
		elm.style.height = h;		
		elm.style.left = this.left;   
		elm.style.top = this.top;
			
		elm = $('_co_bottom_border');		
		elm.style.width = w - 60;		
		elm.getElementsByTagName('div')[0].style.left = this.bottom[0] - this.left - callOutHOffset; 
		
		elm = $('_co_top_border');		
		elm.style.width = w - 60;		

		elm = $('_co_left_border');		
		elm.style.height = h - 90;

		elm = $('_co_right_border');		
		elm.style.height = h - 90;
		
		elm = $('_co_middle');
		elm.style.width = w - 55;
		elm.style.height = h - 85;

		elm = $('_co_content');
		elm.style.height = h - 85;		
		elm.style.width = w - 17;
		
		$('_co_title').setStyle({ width: w-60 });
	},
	getCallOutElement: function() {
		return $('_co');
	},
	getCallOutContentBodyElement: function() {
		return $('_co_content_body');
	}
}
