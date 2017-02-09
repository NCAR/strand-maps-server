function submitQuery(URL,query,returnObj)
{
	var req			= null;
	
	document.results.queryResult.value = "";
	
    if (window.XMLHttpRequest) 
        req = new XMLHttpRequest();
    else 
    	if (window.ActiveXObject) 
	        req = new ActiveXObject("Microsoft.XMLHTTP");
    
    req.open("POST",URL,false);
    req.send(query.value);
    
	returnObj.value = req.responseText;
}