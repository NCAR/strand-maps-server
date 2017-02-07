//Include the following array to limit the NSDL Top Pick resources to the specified NSDL collections only (default is to show all)
//var smsCollections = new Array('dlese.org','439869','ncs-NSDL-COLLECTION-000-003-112-013')

SMSEvent.addListener(StrandMap,"onload", setUpStrandMap);

function setUpStrandMap() {
	StrandMap.enableMisconceptions(true);
	infoBubble = StrandMap.getInfoBubble();	
	SMSEvent.addListener(StrandMap,"onbenchmarkselect",onBenchmarkSelect);
	infoBubble.setMaxSize(700,550);
	infoBubble.setMinWidth(675);
	// Use the built-in tabs for displaying related benchmarks and nses standards:
	
	
	infoBubble.addBuiltinTab("toppicks","Top Picks");
	infoBubble.addBuiltinTab("nses","NSES Standards");
	infoBubble.addBuiltinTab("relatedbenchmarks","Related Benchmarks");
	
	addAnnotations();
}
function onBenchmarkSelect() {
	StrandMap.getTopPicks();
	infoBubble.setTitle("Benchmark Details");
	
	// Tell the event handler to show the strands the benchmark resides in within the bubble 
	infoBubble.setBuiltinContent("benchmarkrelatedmaps", ['show_strands']);
	infoBubble.selectTab(_toppicksTab);
}

/*Custom method that displays a Loading totals div at the top of the viewable area to let the user know
 * that the browser is currently fetching totals to display
 */
function displayLoadingTotalsMessage(show)
{
	if(show)
	{
		style =     
			 "   background-color: #FFF1A8;"+
			 "   border-color: -moz-use-text-color #FFF1A8 #FFF1A8;"+
			 "   border-radius: 0 0 4px 4px;"+
			 "   border-style: none solid solid;"+
			 "   border-width: 0 2px 2px;"+
			 "   font-size: 80%;"+
			 "   font-weight: bold;"+
			 "   padding: 3px;"+
			 " left:-55px;"+
			 " position:relative"

		html = "<div style='"+style+"'>Loading Totals...</div>"
	}
	else
	{
		html = null;
	}
	
	// Note that we use the term viewableMap as the object Id, This is the viewable screen the the cleint is looking at
	// Therefore even if they scroll the image the loading totals will stay at the top middle. Which is what is desired.
	// If you wanted the top of the entire image you would use the id 'mapImage'
	StrandMap.setMapObjectAnnotation('viewableMap', 'top', 'middle', html);
}

// Because of the event we are listening for on top. This method will be called once
// The mapImage has finished loading and all objects have been created and loaded into the dom
function addAnnotations() { 
	
	// Display a message to the user, saying we are now fetching totals
	displayLoadingTotalsMessage(true)
	
	// We can now get all the benchmark Ids
	var bmIds = StrandMap.getBenchmarkIds();
	var bmIdsString = '';

	// In order to send all benchmark ids to the server we use pipes instead of
	// sending them as seperate params
	for(i=0;i<bmIds.length;i++){
		bmId = bmIds[i]
		if(i == 0){
			bmIdsString += bmId;
		} else  {
			bmIdsString += '|' + bmId;
		}
	}
	
	// retrieve specified collections if any, Above we could of defined the collections
	// we want the nsdl resources to be pulled from. Its important to set this globally
	// since the showNsdlResources tab uses it too.
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
	
	// Make the ajsax call to the server
	nsdlAlignmentCountURL = baseJsapiUrl+"/api_v1/bubble/benchmarkDetails.jsp";
	new Ajax.Request( nsdlAlignmentCountURL,
			{ method:'GET',
			parameters:{"bmIds":bmIdsString,"collections":collectionList},
			onSuccess: function( transport ) { handleBenchmarksAnnotationsCountInfo( transport ); },
			onFailure: function( transport ) { displayLoadingTotalsMessage(false) }
			}); 
}


var countStyle =  " background-color: #FFFFFF; border: 1px solid #808080; border-radius: 4px; height: auto; padding: 2px;"+
"position: absolute; width: auto; z-index: 5;background-color: #FFFFFF;font-size:10px;"

var benchmarkCountStyle = countStyle+"top:-15px;left:-20px"
var textCountStyle = countStyle+"top:2px"

// Is called once the ajax call from above comes back with a json response
function handleBenchmarksAnnotationsCountInfo(transport)
{
	// Get all textIds, which will be grade bands and strands
	textIds = StrandMap.getTextIds();
	textIdCounts = {}
	
	// 0 out all texts so we can sum them up as we go through all the benchmarks
	for(i=0;i<textIds.length;i++)
	{
		textId = textIds[i]
		if(textId.startsWith('SMS'))
			textIdCounts[textIds[i]] = 0
	}		
	var benchmarkDetails = transport.responseText.evalJSON();

	// Loop through all benchmarks, adding a annotation to the top right, and keeping a total
	// for the grade and strands it belongs to
	for( key in benchmarkDetails ) {
		if( benchmarkDetails.hasOwnProperty( key ) ) {
			benchmarkDetail = benchmarkDetails[key]
			nsdlResourcesAligned = benchmarkDetail['nsdlResourcesAligned']

			// Public method that adds the annotation to the map. Note we add it to the top
			// right corner of the benchmark then use styling to move it to where we want it
			// globally for all benchmarks
			StrandMap.setMapObjectAnnotation( key, 'top', 
					'right', 
					"<div title='The number of nsdl resources that are aligned to this benchmark' style='"+benchmarkCountStyle+"'>"+numberWithCommas(nsdlResourcesAligned)+"</div>" );
			
			isPartOfList = benchmarkDetail['isPartOf']
			// Go through all the isPartOfs if the response and add the count to them
			// if they exist on the page. Note since a benchmark might be contained within
			// another strand or grade on another map, these will not be added since they are
			// not part of textIdCounts array.
			for(i=0;i<isPartOfList.length;i++)
			{
				isPartOf =  isPartOfList[i]
				if( textIdCounts.hasOwnProperty( isPartOf ) ) {
					textIdCounts[isPartOf]+=parseInt(nsdlResourcesAligned)
				}
			}
		}
	} 

	// Finally display the annotation for grades and strands on the top right corner. Then 
	// style it globally for all text in the html
	for( key in textIdCounts ) {
		StrandMap.setMapObjectAnnotation( key, 'top', 'right', "<div title='The total number of nsdl resources that are aligned to the contained benchmarks' style='"+textCountStyle+"'>"+numberWithCommas(textIdCounts[key])+"</div>" );
	}
	
	// Finally remove the total header on top of the page
	displayLoadingTotalsMessage(false)
}

function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}