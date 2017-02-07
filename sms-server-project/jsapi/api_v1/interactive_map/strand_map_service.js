var StrandMapJSAPI = {
	version: '1.0.0',
	loadService: function() {
		var params = window.location.search;
		if(params.length == 0)
			params = '?api=v1';
		else
			params = params + '&api=v1';	
		document.write('<link rel="stylesheet" type="text/css" href="'+baseJsapiUrl+'/api_v1/common_styles.css"/>');
		document.write('<!--[if IE]><link rel="stylesheet" type="text/css" href="'+baseJsapiUrl+'/api_v1/common_styles_ie.css"/><![endif]-->');
		if(params.indexOf('view=print') != -1)
			document.write('<link rel="stylesheet" type="text/css" href="'+baseJsapiUrl+'/api_v1/print_view_styles.css"/>');

		document.write('<script type="text/javascript" src="'+baseJsapiUrl+'/lib/zxml.js"></script>');
		document.write('<script type="text/javascript" src="'+baseJsapiUrl+'/lib/browser.js"></script>');
		document.write('<script src="//ajax.googleapis.com/ajax/libs/prototype/1.7.1.0/prototype.js"></script>');
		document.write('<script type="text/javascript" src="'+baseJsapiUrl+'/lib/scriptaculous_1.7.1_b3/effects.js"></script>');

		document.write('<script type="text/javascript" src="'+baseJsapiUrl+'/api_v1/interactive_map/strand_map_implementation.js"></script>');
		document.write('<script type="text/javascript" src="'+baseJsapiUrl+'/api_v1/interactive_map/strand_map_public_js_api.js"></script>');
		document.write('<script type="text/javascript" src="'+baseJsapiUrl+'/api_v1/interactive_map/call_out_widget.js"></script>');
		document.write('<script type="text/javascript" src="'+baseJsapiUrl+'/api_v1/strand_selector/strand_selector.js"></script>');
		
		if(params.indexOf('asnid=') == -1 && !(params.indexOf('bm')!=-1 && params.indexOf('id')==-1))
			document.write('<script type="text/javascript" src="'+baseJsapiUrl+'/maps-impl'+params+'"></script>');
	}
}
StrandMapJSAPI.loadService();