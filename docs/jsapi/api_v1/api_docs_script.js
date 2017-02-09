// -------- Explorer helper functions ---------

function popUp(url) {
	var imgWin = window.open (url);
	if(imgWin)
		imgWin.focus();
}

function mkDefaultImg() {	
	var fm = document.defaultImgForm;
	var format = fm.formats.options[fm.formats.selectedIndex].value;
	var id = fm.identifier.value;
	popUp("@JSAPI_SERVICE_URL@/map_images/default/"+id+"."+format); 
}

function mkCustomImg() {	
	var fm = document.customImgForm;
	var format = fm.formats.options[fm.formats.selectedIndex].value;
	var id = fm.identifier.value;
	var scale = fm.scale.value;
	var color = fm.color.value;
	var concept_size = fm.concept_size.options[fm.concept_size.selectedIndex].value;
	popUp("@JSAPI_SERVICE_URL@/map_images/"+color+"/"+concept_size+"/"+scale+"/"+id+"."+format); 
}

function mkJsonReq() {	
	var fm = document.jsonForm;
	var format = fm.formats.options[fm.formats.selectedIndex].value;
	var id = fm.identifier.value;
	var detail = fm.detail.options[fm.detail.selectedIndex].value;
	var callback = fm.callback.value;
	var paramString = "ObjectID="+id+"&Format="+format;
	if(callback.strip().length >0)
		paramString += "&callBack="+callback;
	if(!detail.startsWith('none'))
		paramString += "&DetailLevel="+detail;
	window.location='json_explorer.jsp?'+paramString; 
}
