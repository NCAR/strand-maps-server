 // define which collections to search over for top picks resources
var smsCollections = new Array('dlese.org','843818');	
// Harvard Smithsonian Digital Video Library = 843818
// DLESE = dlese.org	
		
SMSEvent.addListener(StrandMap,"onload", setUpStrandMap);

function setUpStrandMap() {
	StrandMap.enableMisconceptions(true);
	infoBubble = StrandMap.getInfoBubble();	
	
	StrandMap.getInfoBubble().setTitle("Benchmark Details");
	SMSEvent.addListener(StrandMap,"onbenchmarkselect",onBenchmarkSelect);	

	infoBubble.addBuiltinTab("toppicks","Top Picks");
	infoBubble.addBuiltinTab("nses","NSES Standards");
	infoBubble.addBuiltinTab("relatedbenchmarks","Related Benchmarks");
	
	SMSEvent.addListener(StrandMap,"onbenchmarkselect", function() {
		infoBubble.selectTab(_toppicksTab);
	});
}
function onBenchmarkSelect() {
	StrandMap.getInfoBubble().setBuiltinContent("benchmarkrelatedmaps");
	
}