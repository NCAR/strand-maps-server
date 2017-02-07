<!doctype html public "-//w3c//dtd html 4.0 transitional//en" "http://www.w3.org/TR/REC-html40/strict.dtd">

<html>

    

<head>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<title>SMS JavaScript API: Documentation</title>



</head>



<body>



	<%-- Insert the menus top: --%>

	<%@ include file="/docs/menus_insertion_top.jsp" %>



<!-- Header -->

<table width="95%">

    

  <tr> 

    <td> <h1>SMS JavaScript API Documentation</h1>

	

	<p>

	The JavaScript API lets Web developers insert interactive AAAS Strand Maps into Web pages using JavaScript and place custom content into the bubble inside the maps. The dynamic interfaces that are generated by this service require no plug-ins and are compatible in Internet Explorer, Firefox and Safari browsers.</p>

	

      <p>Documentation for the JavaScript API v1.0</p>

      <p>This documentation assumes familiarity with HTML, JavaScript and CSS.</p>

      <p>&nbsp;</p>

	  

	  <h3>Contents</h3>

	  <p>

	  <ul>

        <li><a href="#page">Creating an interactive map</a></li>

        <li>
			<a href="#api">The JavaScript API</a>
			<ul>
				<li><a href="#StrandMap">Class StrandMap</a></li>
				<li><a href="#InfoBubble">Class InfoBubble</a></li>
				<li><a href="#InfoBubbleTab">Class InfoBubbleTab</a></li>
				<li><a href="#SMSEvent">Namespace SMSEvent</a></li>
			</ul>
		</li>

        <li><a href="#externalApis">Included APIs</a></li>

        <li><a href="#styles">CSS Styles</a></li>

        <li><a href="#exampleCode">Example Code</a></li>

        <li><a href="#json">JSON Data</a></li>

        <li><a href="#mapImages">Map Images</a></li>

      </ul>

	  </p>

	  <p>&nbsp;</p>

	  

	  

	  

	  <a name="page"></a>

	  <h3>Creating an interactive map using the SMS JavaScript API</h3>

	  <p>Follow these simple steps to place an interactive strand map in your page and customize the content displayed within it.</p>
	  <p>&nbsp;</p>
	  <p><strong>Step 1:</strong> Include the following DOCTYPE declaration at the top of the HTML page:</p>

      <p><code>&lt;!DOCTYPE HTML PUBLIC &quot;-//W3C//DTD HTML 3.2 Final//EN&quot;&gt;</code></p>
      <p>This Document Type Declarion is required for the interactive maps to function properly. </p>
      <p><strong>Step 2</strong>: Insert the map JavaScript library into the header of the HTML 

        page:</p>
      <p><code>&lt;script type=&quot;text/javascript&quot; src=&quot;${f:contextUrl(pageContext.request)}/jsapi/maps?api=v1&quot;&gt;&lt;/script&gt;</code></p>

      <p><strong>Step 3:</strong> Create a script tag to include code from the <a href="#api">JavaScript API</a> to customize 

        and display information in the map:</p>

      <p><code>&lt;script type=&quot;text/javascript&quot; language=&quot;javascript&quot;&gt;</code>

      <blockquote><code>// Your JavaScript code goes here...</code></blockquote>

      <p><code>&lt;/script&gt;</code></p>

      <p><code>or</code></p>

      <p><code>&lt;script type=&quot;text/javascript&quot; src=&quot;your_javascript.js&quot;&gt;&lt;/script&gt;</code></p>

      <p><strong>Step 4:</strong> Create a style tag or specify an external style sheet to define 

        styles for the page and to override the default <a href="#styles">CSS 

        styles</a>, which are automatically applied:</p>

      <p><code>&lt;style type=&quot;text/css&quot;&gt;</code>

<blockquote><code>// Your styles go here...</code></blockquote>

      <p><code>&lt;/style&gt;</code></p>

      <p><code>or</code></p>

      <p><code>&lt;LINK href=&quot;your_styles.css&quot; rel=&quot;stylesheet&quot; 

        type=&quot;text/css&quot;&gt;</code></p>

      <p><strong>Step 5:</strong> Insert DIV tags to include the desired elements from the service: 

        A custom header, the strand map selector, the interactive strand map and/or 

        a default content section for the page:</p>

      <p><code>&lt;!-- Place all content that goes above the strand selector and strand map in this element. --&gt;<br>

        &lt;div id=&quot;customHeader&quot;&gt;</code><br/>

	  <code>&lt;p&gt;This content is displayed at the top of the page&lt;/p&gt;</code><br/>

	  <code>&lt;/div&gt;</code></p>

      <p><code>&lt;!-- The Strand Selector renders a widget for selecting the strand maps (optional) --&gt;<br>
        Optional attributes:<br>
        -multiselect - The type of selector to display: 'true' to diplay a multi-level selector that includes topics and maps 
        in sub-menus; 'false' displays a flat list of topics only (defaults to false)</code></p>
        
      <p><code>&lt;div id=&quot;strandSelector&quot; multiselect=&quot;true&quot;&gt;&lt;/div&gt;</code></p>

      <p><code>&lt;!-- The Strand Map element renders the interactive maps and 
        table of contents.<br>
        Optional attributes:<br>
        -mapColor - The color of the map boxes. Defaults to #E2E8F6.<br>
        -highlightColor - The color of the highlight around the map boxes. Defaults 
        to #E2E8F6.<br>
        -mapHeight - The height of the map. If not specified, the map will resize 
        itself to fit the maximum height in the browser window.<br>
        -mapWidth - The width of the map. If not specified, the map will resize 
        itself to fit the maximum width in the browser window. </code><code>--&gt;<br>
        &lt;div id=&quot;strandMap&quot; mapColor=&quot;#A7DFC4&quot; highlightColor=&quot;#A7DFC4&quot;&gt;&lt;/div&gt;</code></p>

      <p><code>&lt;!-- Place all content that goes below the strand selector and strand map in this element. --&gt;<br>

        &lt;div id=&quot;defaultContent&quot; style=&quot;display:none&quot;&gt;<br>

      </code><code>&lt;p&gt;This content is displayed in the body of the page only when the 

              interactive map is not being displayed.&lt;/p&gt;<br>

      </code><code>&lt;/div&gt; </code></p>

        <p>&nbsp;</p>

	  

	  

	  <a name="api"></a>

      <h3>The JavaScript API</h3>

	  <p>The JavaScript API provides objects and methods that allow you to customize the maps that 

	  are displayed within your page.</p>

      <p>&nbsp;</p>
	  
	   <a name="StrandMap"></a>
      <h4>Class StrandMap</h4>

      <p> StrandMap is a singleton object that controls the appearance, features and behaviors associated with the interactive maps. It provides a handle to the InfoBubble object and allows you to register actions that are performed when  map-level events occur, such as when a user clicks on a benchmark in a map. It also provides access to  data about the basic objects in the concept map information space such as the benchmarks, other maps, chapters and details about each.</p>

      <p><em>Methods</em></p>

      <p><code>getMapId() -&gt; String </code> - Gets the  internal SMS ID of the current map.</p>

      <p><code>getMapJson() -&gt; JSON </code> - Gets the record data 

      for the current map returned in JSON form. See this <a href="${f:contextUrl(pageContext.request)}/jsapi/json?ObjectID=SMS-BMK-1716&Format=SMS-JSON">example JSON record</a> for an example of this data format. The data returned from this function starts at the 'itemRecord' node.</p>

      <p><code>getParentIds() -&gt; Array of Strings </code> - Gets the internal SMS IDs of all nodes in the SMS space for which the current map has relationship of 'is part of,' as an array of Strings.</p>

      <p><code>getBenchmarkIds() -&gt; Array of Strings</code> - Gets the internal SMS IDs of all benchmarks within the current map, as an array of Strings. </p>

      <p><code>getInfoBubble() -&gt; InfoBubble </code>  - Gets the InfoBubble object.</p>

      <p><code>getSelectedBenchmarkId() -&gt; String </code> - Gets the internal SMS ID for the 

        selected benchmark. If no benchmark is selected, returns null. This is typically called after the <code>onbenchmarkselect</code> event is fired.</p>

      <p><code>openInfoBubbleOnBenchmark(benchmarkId)</code> - Opens the InfoBubble on the given benchmark and fires all associated events. If the given benchmark does not exist within the current map, nothing is done. </p>

      <blockquote>

        <p><code>benchmarkId</code> - An internal SMS ID for a given benchmark.</p>

      </blockquote>      
      <p><code>getSelectedBenchmarkRecordJson() -&gt; JSON </code> - Gets the record data 

        for the selected benchmark returned in JSON form, or null if no benchmark 

        is currently selected. The data returned from this function starts at the 'itemRecord' node.</p>

      <p><code>getReferringMapId() -&gt; String </code> - Gets the internal SMS ID of the map that was clicked 

        to view this map, which occurs when a user views the related benchmarks 

        in the interactive map viewer, or null if not available.</p>

      <p><code>getSelectedBenchmarkHtml() -&gt; String </code>- Gets HTML that describes the 

        selected benchmark, or null if none is currently selected.</p>

      <p><code>setPrintViewContent(content) </code>- Sets the content to display 

        in the print view portion of the map.</p>

      <blockquote> 

        <p><code>content</code> - HTML content</p>
      </blockquote>		

      <p><code>enableMisconceptions(Boolean) </code>- Enables or disables the ability to view misconceptions for a given map. When enabled, the user is presented with a link button to view/hide the misconceptions for those maps that have them, displayed directly over the map. Default behavior is disabled. </p>
      
      <p><code>enableNavagatorArrows(Boolean) </code>- Enables or disables Navigator arrows appearing in the Strand Map. These arrows are an alternative to navigate within the strand without having to drag and drop.  Default behavior is disabled. </p>

      <p><code>setMapObjectAnnotation(objectID, yLocation, xLocation, html) </code>- 
      	Places HTML near an interactive region in the strand map at a location
      	defined at xLocation, and yLocation.  Each object can only have one annotation at a given location. Calling this method again with the same location will replace the existing content. To remove an annotation, call this method by sending in empty html or null.
      	<blockquote> 

	        <p><code>objectID</code> - SMS object id or special id that is contained within the DOM. See below for more details</p>
	        <p><code>html</code> - Any valid HTML that should be used as an annotation. Any positioning done will be relative to the yLocation and xLocation defined. May send in value of null or empty string to designate that the current annotation should be removed</p>
			<p><code>yLocation</code> - The Y location of an object that the HTML should be placed relative to the object's center. Options are (top, middle, bottom) </p>
	        <p><code>xLocation</code> - The X location of an object that the HTML should be placed relative to the object's center. Options are (left, middle, right) </p>
			<p style="font-style:italic;">Example placing annotation on a benchmark</br>
				<img src="@GLOBAL_CONTEXT_URL@/jsapi/api_v1/interactive_map/images/annotationLocations.gif"/>
			</p>
			<p style="font-style:italic;">Examples of objectId</br>
				<ul>
					<li><code>SMS ID</code> - Id which corresponds to an SMS object. Examples might include SMS-BMK-0027, SMS-STD-0039 and SMS-GRD-0045, which corresponds to 
							a benchmark, strand and grade band id respectively. Benchmark ids can be dynamically retrieved using getBenchmarkIds method. Strands and Grade IDs can be dynamically retrieved using the getTextIds method.
					<li><code>viewableMap</code> - Container which encompasses the viewable area of the image. If an annotation is placed in the viewableMap the annotation will not move even if the client scrolls the image around.</li>
					<li><code>imageMap</code> Container which encompasses the entire strand map image. An annotation placed here will act like it is part of the image and will move accordingly if the client scrolls the image.</li>
				</ul>		
			</p>
      </blockquote>		
      
      </p>

      <p><code>getTextIds() -&gt; Array of Strings</code> - Gets the internal Text IDs of all text regions displayed on the screen. More specifically this will contain Grade Band ids and Strand Ids </p>


      <p><em>Events</em></p>

      <p><code>onload</code> - This event is fired when the StrandMap first loads 

        and is ready to accept calls to its methods.</p>

      <p><code>onbenchmarkselect</code> -This event is fired each time a benchmark 

        is selected.</p>
		
	   <p><code>onbenchmarkclose</code> -This event is fired each time a benchmark info bubble
        is closed. This can be done by clicking outside the benchmark, using the close button in pop
        up or by clicking on another benchmark.</p>
        
      <p><code>onprintviewdisplay</code> - This event is fired each time the print 

        view is displayed. If a benchmark is displayed in the print view it will 

        be returned from the <code>getSelectedBenchmarkId</code>() and <code>getSelectedBenchmarkRecordJson()</code> 

        methods. </p>
  	
      <p>&nbsp;</p>
	  
	   <a name="InfoBubble"></a>
      <h4>Class InfoBubble</h4>

      <p>InfoBubble is a singleton object that controls the content, appearance, features and behaviors associated with the information bubble widget that appears in the maps. It allows you to add or remove tabs, register actions that are performed when the bubble is opened and closed, and access data associated with the bubble.</p>

      <p><em>Methods</em></p>

      <p><code>setTitle(title)</code> - Sets the title displayed in the bubble.</p>

      <blockquote> 

        <p><code>title</code> - HTML content</p>
      </blockquote>

      <p><code>getTitle() -&gt; String </code> - Gets the title displayed in the bubble.</p>
      <p><code>setContent(content)</code> - Sets the content displayed in the 

        top portion of the bubble. If no tabs are added to the InfoBubble, this 

        will be the only content displayed.</p>

      <blockquote> 

        <p><code>content</code> - HTML content</p>
      </blockquote>

      <p><code>getContent() -&gt; String </code> - Gets the content displayed in the top portion of the bubble.</p>
      <p><code>setBuiltinContent(contentType, [options])</code> - Sets the content area with 

        built-in content, which displays a full description of the benchmark.</p>

      <blockquote> 

        <p><code>contentType</code> - Values include: <br/>&nbsp;&nbsp;&nbsp;&nbsp;<code>benchmarkonly</code> 

          - Displays a full description of the benchmark and the associated grade range.<br/>
          &nbsp;&nbsp;&nbsp;&nbsp;<code>benchmarkdetails</code> 

          - Displays a full description of the benchmark, the associated grade range, and any aligned NSES standards.<br/>
          &nbsp;&nbsp;&nbsp;&nbsp;<code>benchmarkrelatedmaps</code> 

          - Displays a list of maps in which the selected benchmark appears, with links to those maps.
      		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;options - Values Include<br/>
      		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<code>show_strands</code> - Shows the strands the selected benchmark is part of, with links to those maps
      	</p>
      </blockquote>

      <p><code>setMaxSize(width,height)</code> - Sets the maximum size of the bubble and adjusts its size if it is visible. Default size is 650w X 600h if not specified.</p>
      <blockquote>
        <p><code>width</code> - The maximum width of the bubble, in pixels<br>
        <code>height</code> - The maximum height of the bubble, in pixels        </p>
      </blockquote>
      <p><code>setMinWidth(width)</code> - Sets the minimum width of the bubble and adjusts its size if it is visible. Default width is 300w if not specified.</p>
      <blockquote>
        <p><code>width</code> - The minimum width of the bubble, in pixels<br>
        <code>height</code> - The minimum height of the bubble, in pixels        </p>
      </blockquote>
      <p><code>addTab(infoBubbleTab)</code> - Adds a tab in the InfoBubble. Tabs 

        appear in the order they are added.</p>

      <blockquote> 

        <p><code>infoBubbleTab</code> - An InfoBubbleTab instance.</p>

      </blockquote>

      <p><code>addBuiltinTab(tabType, label) -&gt; InfoBubbleTab </code>- Adds a built-in tab to the 

        InfoBubble.</p>

      <blockquote> 

        <p><code>tabType</code> - Values include: <br/>&nbsp;&nbsp;&nbsp;&nbsp;<code>relatedbenchmarks</code> 

          - Displays the related benchmarks for the selected benchmark.<br>
          
          &nbsp;&nbsp;&nbsp;&nbsp;<code>nses</code> 

          - Displays the NSES standards aligned to the selected benchmark.<br>
          
           &nbsp;&nbsp;&nbsp;&nbsp;<code>aaasmisconception</code> 

          - Displays the student misconception research for the selected benchmark.<br>
          
           &nbsp;&nbsp;&nbsp;&nbsp;<code>aaasassessment</code> 

          - Displays the student understanding assessments research for the selected benchmark.<br>
          
          
           &nbsp;&nbsp;&nbsp;&nbsp;<code>toppicks</code> 

          - Displays the "Top Pick" educational resources from UCAR. These resources for classroom use are aligned or related to the concept in the selected benchmark, 
            ordered with the most relevant appearing at the top of the list.  Define an optional array in your JavaScript smsCollections with a list of collection keys 
            to limit the scope of included resources to those from the specified NSDL collections. Default is to show all.<br>
          
          
          &nbsp;&nbsp;&nbsp;&nbsp;<code>nsdltoppicks(Deprecated, use toppicks instead)</code> 

          - Displays the "Top Pick" educational resources from NSDL. These resources for classroom use are aligned or related to the concept in the selected benchmark, 
            ordered with the most relevant appearing at the top of the list.  Define an optional array in your JavaScript smsCollections with a list of collection keys 
            to limit the scope of included resources to those from the specified NSDL collections. Default is to show all.

          </p>

          <p><code>label</code> - The label for tab (text).</p>

      </blockquote>

      <p><code>selectTab(infoBubbleTab) </code>- Selects the given tab and fires 

        the 'onselect' event on the tab.</p>

      <blockquote> 

        <p><code>infoBubbleTab</code> - An InfoBubbleTab instance.</p>

      </blockquote>
	  
      <p><code>hideTab(infoBubbleTab) </code>- Makes a tab non-visible without changing it's contents.<code></code></p>

      <blockquote> 

        <p><code>infoBubbleTab</code> - An InfoBubbleTab instance.</p>

      </blockquote>	
	  
      <p><code>showTab(infoBubbleTab) </code>- Makes a tab visible without changing it's contents, reversing the action applied with method <code>hideTab(infoBubbleTab)</code>.</p>

      <blockquote> 

        <p><code>infoBubbleTab</code> - An InfoBubbleTab instance.</p>
      </blockquote>		    

      <p><code>hideTabPane(showLoadingMsg) </code>- Makes the entire tab pane non-visible without changing it's contents. This method works independently from the <code>hideTab(infoBubbleTab)</code> and <code>showTab(infoBubbleTab)</code> methods. </p>
      <blockquote> 

        <p><code>showLoadingMsg</code> - A boolean value. If set to true, a 'Loading...' message is displayed in place of the tab pane until <code>showTabPane()</code> is called. </p>
      </blockquote>		      
	  
	  <p><code>showTabPane() </code>- Makes the entire tab pane visible without changing it's contents, reversing the action applied with method <code>hideTabs()</code>. This method works independently from the <code>hideTab(infoBubbleTab)</code> and <code>showTab(infoBubbleTab)</code> methods. </p>
      <blockquote>&nbsp;</blockquote>
      <p><em>Events</em></p>

      <p><code>onopen</code> - This event is fired each time the InfoBubble is 

        opened.</p>

      <p><code>onclose</code> - This even is fired each time the InfoBubble is 

        closed.</p>

      <p>&nbsp;</p>
	  
	   <a name="InfoBubbleTab"></a>
      <h4>Class InfoBubbleTab</h4>

      <p>InfoBubbleTab objects are used to control the tabs that appear inside the InfoBubble widget. Each InfoBubbleTab object describes a single tab, its content and any action that occurs when a user selects the tab.</p>

      <p><em>Constructor</em></p>

      <p><code>InfoBubbleTab(label)</code> - Constructs a new InfoBubbleTab with 

        the given label.</p>

      <blockquote> 

        <p><code>label</code> - The label displayed on the tab.</p>

      </blockquote>

      <p><em>Methods</em></p>

      <p><code>setContent(content)</code> - Sets the content displayed in the 

        tab.</p>

      <blockquote> 

        <p><code>content</code> - HTML content</p>

      </blockquote>

      <p><code>getContent() -&gt; String </code>- Gets the content currently displayed in the 

        tab.</p>

	  <p><code>appendToLabel(textToAppend)</code>- Appends text to the current label of the tab.</p>
	   <blockquote> 
	  		<p><code>textToAppend</code> - text to be appended to the current label. If null is used the label will
	  				default back to the label that the tab was initialized with.</p>
	  </blockquote>
	  
	  <p><code>changeLabel(newLabel)  </code>- Sets the text of the current label. </p>
	  <blockquote> 
	  		<p><code>newLabel</code> - text for the new label. If null is used the label will
	  				default back to the label that the tab was initialized with.</p>
	  </blockquote>


      <p><em>Events</em></p>

      <p><code>onselect</code> - This event is fired each time the tab is selected.</p>

      <p>&nbsp;</p>
	  
	   <a name="SMSEvent"></a>
      <h4>Namespace SMSEvent</h4>

      <p>This namespace contains functions used to register event handlers for 

        all objects.</p>

      <p><em>Methods</em></p>

      <p><code>addListener(object, eventName, handler) </code>- Adds a listener 

        and handler on the given object for the given event.</p>

      <blockquote> 

        <p><code>object</code> - The object to listen on<br>

          <code>eventName</code> - The event to listen for<br>

          <code>handler</code> - The function that is called when the given event 

          is fired.</p>

        <p>&nbsp;</p>

      </blockquote>

	  

	  



	  <a name="externalApis"></a>

	  <h3>Included APIs:</h3>

		<p>

			The SMS service includes two externally developed open source JavaScript APIs that can be used

			in conjunction with the SMS API to simplify your coding: <a href="http://www.prototypejs.org/api/">Prototype</a> and 

			<a href="http://wiki.script.aculo.us/scriptaculous/">Scriptaculous</a>.

			These libraries are included in your page automatically when you use the API

			and do not need to be referenced separately. The SMS JavaScript uses these in

			it's own implementation.

		</p>	  

	    

      <ul>

        <li><a href="http://www.prototypejs.org/api/">Prototype</a> - <em>&quot;Prototype 

          is a JavaScript Framework that aims to ease development of dynamic web 

          applications. Featuring a unique, easy-to-use toolkit for class-driven 

          development and the nicest Ajax library around, Prototype is quickly 

          becoming the codebase of choice for web application developers everywhere.&quot;</em> 

          Prototype v1.5.1.1 is included for you. </li>

        <li><a href="http://wiki.script.aculo.us/scriptaculous/">Scriptaculous</a> 

          - <em>&quot;script.aculo.us provides you with easy-to-use, cross-browser 

          user interface JavaScript libraries to make your web sites and web applications 

          fly.&quot;</em> Scriptaculous v1.7.1_b3 is included for you. Note that 

          only the Effects library is provided by the SMS. </li>

      </ul>

      <p>&nbsp;</p>

      <p><a name="styles" id="styles"></a> </p>

      <h3>CSS Styles:</h3>

      <p> The SMS service provides a set of CSS styles that are applied automatically. 

        These styles are used to define default colors and fonts for the content 

        that is displayed in the maps and information bubble, as well as to control 

        the sizing and margins of the objects that are displayed. When customizing 

        your map you can override the default styles to apply your own color, 

        font and other preferences. To do so, simply include a style element in 

        the header of your page or specify an external style sheet after the point 

        in your code where the service JavaScript is referenced. Use the links 

        below to view the styles that are being applied by the service.</p>

      <ul>

        <li><a href="${f:contextUrl(pageContext.request)}/jsapi/api_v1/common_styles.css" target="_blank">View the 

          default styles</a> - These styles are applied to all pages.</li>

        <li><a href="${f:contextUrl(pageContext.request)}/jsapi/api_v1/print_view_styles.css" target="_blank">View 

          the print styles</a> - These styles are applied to the print view in 

          addition to the default styles.</li>		  

      </ul>

      <p>&nbsp;</p>

      <a name="exampleCode"></a>

	  <h3>Example Code:</h3>

	  <ul>

		<li>See <a href="example_clients/index.jsp">Example clients</a></li>

	  </ul>

	<p>&nbsp;</p>	  

	  

	  <a name="json"></a>

	  <h2>JSON Data</h2>

		

      <p>The service provides data in JSON (JavaScript Object Notation) form for 

        all objects in the SMS information 

        space, via URL.  The space contains objects for maps, grade groups, strands, benchmarks, clusters, chapters and the atlas. These data may be accessed using JavaScript and optionally 

        returned asynchronously to a callback function. Using the service and the relationships supplied in the datum for each object, it is possible to traverse the nodes in the  graph and discover the attributes of all objects.</p>

      <p>See the <a href="json_explorer.jsp">JSON Explorer</a> to access and explore 

        the JSON data from the SMS service. </p>

      <p>JSON is widely used in AJAX style JavaScript programming and is found 

        in public APIs such as those provided Yahoo! and in rich Web applications 

        such as GMail. For more information about this data format and how it 

        may be used, see Douglas Crockford's site <a href="http://json.org/">JSON.org</a> 

        and <a href="http://www.json.org/xml.html">JSON: The Fat-Free Alternative 

        to XML</a> and the <a href="http://developer.yahoo.com/common/json.html">Yahoo! 

        developer documentation</a>.</p>

		

		<h3>JSON Requests and Responses</h3>

		<p>

			SMS JSON service requests are expressed as HTTP argument/value pairs. These requests must be in either GET or POST format. 

			Responses are returned in JSON format, which varies in structure and content depending on the request as shown below 

			in the examples section of this document.

		</p>

		<p>

			The JSON responses contain the same data that is returned by the CSIP service when requesting the SMS-JSON format,

			as described in the <a href='<c:url value="/docs/cms/cms1-2/CMS_specification.jsp#Query"/>'>CSIP Query documentation</a>.

			The JSON format is a direct transformation from the CSIP XML output to JSON.

		</p>

		

		<p>

	  <ul>

				<li><i>Base URL</i> - the base URL used to access the service. This is the portion of the request that precedes the request arguments. 

				For example ${f:contextUrl(pageContext.request)}/jsapi/json

				</li>

				<li><i>Request arguments</i> - the argument=value pairs that make up the request and follow the base URL. 

				</li><li><i>JSON response envelope</i> - the JSON container used to return data. This container returns different types of data depending on the request made.

				</li>

	  </ul>

			

		<p><em>URL Pattern</em></p>

		<p>

			The format of the request consists of the base URL followed by the ? character followed by one or more 

			argument=value pairs, which are separated by the &amp; character.

			All arguments must be encoded using the <a href="http://www.ietf.org/rfc/rfc2396.txt">syntax rules for URIs</a>. 

			This is the same <a href="http://www.openarchives.org/OAI/2.0/openarchivesprotocol.htm#SpecialCharacters">encoding scheme that is described by the OAI-PMH</a>.		

		</p>	

		<p><em>Sample Request</em></p>

		

      <p><code><nobr>${f:contextUrl(pageContext.request)}/jsapi/json?<br/>

        ObjectID=SMS-MAP-0048&amp;Format=SMS-JSON</nobr>&amp;callBack=myCallbackFn<nobr>&amp;DetailLevel=Detailed</nobr></code></p>

		<p><em>Arguments</em></p>

		

      <ul>

        <li><code>ObjectID</code> (required) - The SMS object identifier</li>

        <li><code>Format</code> (required) - The format. Must be either SMS-JSON 

          (to retrieve details about the object) or SVG-JSON (to retrieve the 

          object's visualization SVG in JSON format).</li>

        <li><code>callBack</code> (optional) - A callback function to wrap the 

          JSON response in. If none is supplied, the JSON will be returned without 

          a callback function.</li>

        <li><code>DetailLevel</code> (optional) - The data detail level (defaults 

          to 'Detailed' if not specified)</li>

      </ul>

		<p><em>Examples</em></p>

		<p>

			<code><nobr>${f:contextUrl(pageContext.request)}/jsapi/json?<br/>

        ObjectID=SMS-MAP-0048&amp;callBack=myCallbackFn&amp;Format=SMS-JSON&amp;DetailLevel=Detailed</nobr></code> 

        (<a href="${f:contextUrl(pageContext.request)}/jsapi/json?ObjectID=SMS-MAP-0048&amp;callBack=myCallbackFn&amp;Format=SMS-JSON&amp;DetailLevel=Detailed">view</a>) 

        - Full data for map ID SMS-MAP-0048. </p>	  

	  <p>&nbsp;</p>

		

		

	  

		<a name="mapImages"></a>

		<h2>Map Images</h2>

		<p>The service provides access to images for all map visualizations via URLs.

		The images may be useful for applications or pages that wish to access or 

		display images  without the interactive features.

	  Images are available for  maps, strands, grade groups, and related benchmarks in JPG, PNG, PDF and SVG format. Images are not available for clusters, chapters or the atlas object. </p>
		<p>

			See the <a href="image_explorer.jsp">Image Explorer</a> to access and explore the images from the service.
The images may also be retrieved using the CSIP service.
		</p>		

		

		<h3>Default Map Images</h3>

		<p>

			Default images are available in blue color (hex code #E2E8F6), with no scaling applied and a concept box size of 4. The URL pattern to 

			access these images is as follows:

		</p>

		<p><em>URL Pattern</em></p>

		<p><code><nobr>${f:contextUrl(pageContext.request)}/jsapi/map_images/default/{sms-id}.{ext}</nobr></code></p>

		<blockquote>

			<p><code>{sms-id}</code> - The SMS ID for a map, strand, grade band or related benchmark.</p>

			<p><code>{ext}</code> - The image extension. One of JPG, PNG, PDF or SVG (case sensitive).</p>

	  </blockquote>

		<p><em>Examples</em></p>

		<p>

			<code><nobr>${f:contextUrl(pageContext.request)}/jsapi/map_images/default/SMS-MAP-0048.PNG</nobr></code> (<a href="${f:contextUrl(pageContext.request)}/jsapi/map_images/default/SMS-MAP-0048.PNG">view</a>)

			- PNG image for map &quot;Changes in the Earth's Surface.&quot;

		</p>

		<p>

			<code><nobr>${f:contextUrl(pageContext.request)}/jsapi/map_images/default/SMS-MAP-1232.JPG</nobr></code> (<a href="${f:contextUrl(pageContext.request)}/jsapi/map_images/default/SMS-MAP-1232.JPG">view</a>)

			- JPG image for map &quot;Mathematical Processes.&quot;

		</p>

		<p>

			<code><nobr>${f:contextUrl(pageContext.request)}/jsapi/map_images/default/SMS-BMK-1717.PDF</nobr></code> (<a href="${f:contextUrl(pageContext.request)}/jsapi/map_images/default/SMS-BMK-1717.PDF">view</a>)

			- PDF for benchmarks related to &quot;Scientists' explanations about what happens in the world come partly from what they observe, partly from what they think.&quot;

		</p>		



		<h3>Custom Map  Images</h3>

		<p>

			Custom map images are available in all Web colors, scaled from 1% to 200%, and generated with a variety of 

			concept box sizes.

		</p>

		<p><em>URL Pattern</em></p>

		<p><code><nobr>${f:contextUrl(pageContext.request)}/jsapi/map_images/{color}/{concept-size}/{scale}/{sms-id}.{ext}</nobr></code></p>

		<blockquote>

			<p><code>{color}</code> - The color of the image. Value must be a valid named or hexadecimal color. See <a href="http://en.wikipedia.org/wiki/Web_colors">Web Colors</a> on Wikipedia

			for a list of named and hexadecimal color values.</p>

			<p><code>{concept-size}</code> - The size of the concept boxes in the image. Value must be an integer from 1 to 6, where 1 generates a smaller map with  minimum text displayed in the boxes and 6 generates a larger map with the maximum text displayed. Default images use a value of 4.</p>

			<p><code>{scale}</code> - The scaling percentage applied to the image. Value must be an integer from 1 to 200. Scaling is applied only to JPG and PNG images. 

				Scaling is ignored for PDF and SVG images, however a value must still be supplied.</p>					

			<p><code>{sms-id}</code> - The SMS ID for a map, strand, grade band or related benchmark.</p>

			<p><code>{ext}</code> - The image extension. One of JPG, PNG, PDF or SVG (case sensitive).</p>

		</blockquote>

		<p><em>Examples</em></p>

		<p>

			<code><nobr>${f:contextUrl(pageContext.request)}/jsapi/map_images/LightBlue/6/15/SMS-MAP-0048.PNG</nobr></code> (<a href="${f:contextUrl(pageContext.request)}/jsapi/map_images/LightBlue/6/15/SMS-MAP-0048.PNG">view</a>)

			- PNG image, color LightBlue, concept size 6, scaled to 15%, for map &quot;Changes in the Earth's Surface.&quot;

		</p>

		<p>

			<code><nobr>${f:contextUrl(pageContext.request)}/jsapi/map_images/8ECF8E/4/100/SMS-MAP-1232.JPG</nobr></code> (<a href="${f:contextUrl(pageContext.request)}/jsapi/map_images/8ECF8E/4/100/SMS-MAP-1232.JPG">view</a>)

			- JPG image, color #8ECF8E, concept size 4, scaled to 100%, for map &quot;Mathematical Processes.&quot;

		</p>

		<p>

			<code><nobr>${f:contextUrl(pageContext.request)}/jsapi/map_images/Gold/6/50/SMS-BMK-1717.PDF</nobr></code> (<a href="${f:contextUrl(pageContext.request)}/jsapi/map_images/Gold/6/50/SMS-BMK-1717.PDF">view</a>)

			- PDF, color Gold, concept size 6, for benchmarks related to &quot;Scientists' explanations about what happens in the world come partly from what they observe, partly from what they think.&quot; 

			Note that scaling is ignored for PDF and SVG images.

		</p>	  

		

		<p>&nbsp;</p>

		<p>

			<em>

			Author: John Weatherley<br/>

			Last revised $Date: 2014/10/22 21:10:46 $

			</em>

		</p>

    </td>

  </tr>

</table>



<br>



	<%-- Insert the menus bottom: --%>

	<%@ include file="/docs/menus_insertion_bottom.jsp" %>



</body>

</html>

