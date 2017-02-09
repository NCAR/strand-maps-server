var registerQueryTemplates 	= new Array();
	
registerQueryTemplates["SeeAllQueries"]	= '<SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'
									+'\n\t<RegisterQuery CharacterEncoding="UTF-8">'
									+'\n\t\t<SeeAllQueries>'
											+'\n\t\t\t<Operation>List</Operation>'
										+'\n\t\t</SeeAllQueries>'
									+'\n\t</RegisterQuery>'
								+'\n</SMS-CSIP>';

registerQueryTemplates["Lookup"]	= '<SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
									  '\n\t<RegisterQuery CharacterEncoding="UTF-8">'+
									  '\n\t\t<Lookup>'+
									  '\n\t\t\t<Operation>Find</Operation>'+
									  '\n\t\t\t<Term>MyQuery</Term>'+
									  '\n\t\t</Lookup>'+
									  '\n\t</RegisterQuery>'+
									  '\n</SMS-CSIP>';

registerQueryTemplates["AddQuery"]	= '<SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
									  '\n\t<RegisterQuery CharacterEncoding="UTF-8">'+
									  '\n\t\t<Functional>'+
									  '\n\t\t\t<Operation>Add Query String</Operation>'+
									  '\n\t\t\t<PublishName>MyQuery</PublishName>'+
									  '\n\t\t\t<AuthenticationCode>Sample</AuthenticationCode>'+
									  '\n\t\t\t<QueryHost>localhost</QueryHost>'+
									  '\n\t\t\t<QueryString>ID=<IDNumber></IDNumber></QueryString>'+
									  '\n\t\t\t<ObjectType>ALL</ObjectType>'+
									  '\n\t\t</Functional>'+
									  '\n\t</RegisterQuery>'+
									  '\n</SMS-CSIP>';

registerQueryTemplates["UpdateQuery"]= '<SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
									  '\n\t<RegisterQuery CharacterEncoding="UTF-8">'+
									  '\n\t\t<Functional>'+
									  '\n\t\t\t<Operation>Update Query String</Operation>'+
									  '\n\t\t\t<PublishName>MyQuery</PublishName>'+
									  '\n\t\t\t<AuthenticationCode>Sample</AuthenticationCode>'+
									  '\n\t\t\t<QueryHost>localhost</QueryHost>'+
									  '\n\t\t\t<QueryString>ObjectIDNumber=<IDNumber></IDNumber></QueryString>'+
									  '\n\t\t\t<ObjectType>ALL</ObjectType>'+
									  '\n\t\t</Functional>'+
									  '\n\t</RegisterQuery>'+
									  '\n</SMS-CSIP>';

registerQueryTemplates["ChangeCode"] ='<SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
									  '\n\t<RegisterQuery CharacterEncoding="UTF-8">'+
									  '\n\t\t<Authentication>'+
									  '\n\t\t\t<Operation>Change Authentication Code</Operation>'+
									  '\n\t\t\t<PublishName>MyQuery</PublishName>'+
									  '\n\t\t\t<AuthenticationCode>Sample</AuthenticationCode>'+
									  '\n\t\t\t<NewAuthenticationCode>Another Sample</NewAuthenticationCode>'+
									  '\n\t\t</Authentication>'+
									  '\n\t</RegisterQuery>'+
									  '\n</SMS-CSIP>';

registerQueryTemplates["DisableQuery"]='<SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
									   '\n\t<RegisterQuery CharacterEncoding="UTF-8">'+
									   '\n\t\t<Admin>'+
									   '\n\t\t\t<Operation>Disable</Operation>'+
									   '\n\t\t\t<PublishName>MyQuery</PublishName>'+
									   '\n\t\t\t<AuthenticationCode>Sample</AuthenticationCode>'+
									   '\n\t\t</Admin>'+
									   '\n\t</RegisterQuery>'+
									   '\n</SMS-CSIP>';

registerQueryTemplates["EnableQuery"] ='<SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
									   '\n\t<RegisterQuery CharacterEncoding="UTF-8">'+
									   '\n\t\t<Admin>'+
									   '\n\t\t\t<Operation>Enable</Operation>'+
									   '\n\t\t\t<PublishName>MyQuery</PublishName>'+
									   '\n\t\t\t<AuthenticationCode>Sample</AuthenticationCode>'+
									   '\n\t\t</Admin>'+
									   '\n\t</RegisterQuery>'+
									   '\n</SMS-CSIP>';

registerQueryTemplates["RemoveQuery"] ='<SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
									   '\n\t<RegisterQuery CharacterEncoding="UTF-8">'+
									   '\n\t\t<Admin>'+
									   '\n\t\t\t<Operation>Remove</Operation>'+
									   '\n\t\t\t<PublishName>MyQuery</PublishName>'+
									   '\n\t\t\t<AuthenticationCode>Sample</AuthenticationCode>'+
									   '\n\t\t</Admin>'+
									   '\n\t</RegisterQuery>'+
									   '\n</SMS-CSIP>';

registerQueryTemplates["ContentQuery"]='<SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
									   '\n\t<Query Color="skyblue" DetailLevel="Skeleton" Format="SMS" Scope="ALL" ThirdPartyQuery="">'+
									   '\n\t\t<Content-Query>'+
									   '\n\t\t</Content-Query>'+
									   '\n\t</Query>'+
									   '\n</SMS-CSIP>';

registerQueryTemplates["NavigationalQuery"]='<SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
									    '\n\t<Query Color="skyblue" DetailLevel="Skeleton" Format="SMS" Scope="ALL" ThirdPartyQuery="">'+
										'\n\t\t<Navigational-Query>'+
										'\n\t\t\t<ObjectID>SMS-BMK-0009</ObjectID>'+
										'\n\t\t\t<Relation>'+
										'\n\t\t\t\t<Any></Any>'+
										'\n\t\t\t</Relation>'+
										'\n\t\t</Navigational-Query>'+
									    '\n\t</Query>'+
									    '\n</SMS-CSIP>';
									  
registerQueryTemplates["ASNLookupQuery"]='<SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
									   '\n\t<Query Color="skyblue" DetailLevel="Skeleton" Format="SMS" Scope="ALL" ThirdPartyQuery="">'+
									   '\n\t\t<ASNLookup-Query>'+
									   '\n\t\t</ASNLookup-Query>'+
									   '\n\t</Query>'+
									   '\n</SMS-CSIP>';

registerQueryTemplates["SWF"]		   ='<SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
									   '\n\t<Query Color="skyblue" DetailLevel="Skeleton" Format="SMS" Scope="ALL" ThirdPartyQuery="">'+
									   '\n\t\t<Content-Query>'+
									   '\n\t\t\t<FullText MatchType="Contains-all-words">Ocean floor</FullText>'+
									   '\n\t\t</Content-Query>'+
									   '\n\t</Query>'+
									   '\n</SMS-CSIP>';

registerQueryTemplates["SIAMF"]		   ='<SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
									   '\n\t<Query Color="skyblue" DetailLevel="Skeleton" Format="SMS" Scope="ALL" ThirdPartyQuery="">'+
									   '\n\t\t<Content-Query>'+
									   '\n\t\t\t<Term MatchType="Contains-any-word">Wind energy waves</Term>'+
									   '\n\t\t</Content-Query>'+
									   '\n\t</Query>'+
									   '\n</SMS-CSIP>';

registerQueryTemplates["GLOM"]		  ='<SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
									   '\n\t<Query Color="skyblue" DetailLevel="Skeleton" Format="SMS" Scope="Map" ThirdPartyQuery="">'+
									   '\n\t\t<Content-Query>'+
									   '\n\t\t</Content-Query>'+
									   '\n\t</Query>'+
									   '\n</SMS-CSIP>';

registerQueryTemplates["FABHE"]		   ='<SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
									   '\n\t<Query Color="skyblue" DetailLevel="Skeleton" Format="SMS" Scope="Benchmark" ThirdPartyQuery="">'+
									   '\n\t\t<Content-Query>'+
									   '\n\t\t\t<Term MatchType="Contains-any-word">Earthquakes</Term>'+
									   '\n\t\t</Content-Query>'+
									   '\n\t</Query>'+
									   '\n</SMS-CSIP>';

registerQueryTemplates["FAOCB"]		   ='<SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
									   '\n\t<Query Color="skyblue" DetailLevel="Skeleton" Format="SMS" Scope="ALL" ThirdPartyQuery="">'+
									   '\n\t\t<Content-Query>'+
									   '\n\t\t\t<InternalRelationships>'+
									   '\n\t\t\t\t<InternalRelationship Relation="Contains" Object="SMS-BMK-0009"></InternalRelationship>'+
									   '\n\t\t\t</InternalRelationships>'+
									   '\n\t\t</Content-Query>'+
									   '\n\t</Query>'+
									   '\n</SMS-CSIP>';

registerQueryTemplates["UACSC"]		   ='<SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
									   '\n\t<Query Color="skyblue" DetailLevel="Skeleton" Format="SMS" Scope="ALL" ThirdPartyQuery="">'+
									   '\n\t\t<Content-Query>'+
									   '\n\t\t\t<AND>'+
									   '\n\t\t\t\t<Name MatchType="Contains-phrase">Plate tectonics</Name>'+
									   '\n\t\t\t\t<GradeRanges MatchType="Contains-all-words">9,10</GradeRanges>'+
									   '\n\t\t\t</AND>'+
									   '\n\t\t</Content-Query>'+
									   '\n\t</Query>'+
									   '\n</SMS-CSIP>';

registerQueryTemplates["UOCSC"]		   ='<SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
									   '\n\t<Query Color="skyblue" DetailLevel="Skeleton" Format="SMS" Scope="ALL" ThirdPartyQuery="">'+
									   '\n\t\t<Content-Query>'+
									   '\n\t\t\t<OR>'+
									   '\n\t\t\t\t<Name MatchType="Contains-phrase">Plate tectonics</Name>'+
									   '\n\t\t\t\t<GradeRanges MatchType="Contains-all-words">9,10</GradeRanges>'+
									   '\n\t\t\t</OR>'+
									   '\n\t\t</Content-Query>'+
									   '\n\t</Query>'+
									   '\n</SMS-CSIP>';

registerQueryTemplates["UNOCSC"]	   ='<SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
									   '\n\t<Query Color="skyblue" DetailLevel="Skeleton" Format="SMS" Scope="ALL" ThirdPartyQuery="">'+
									   '\n\t\t<Content-Query>'+
									   '\n\t\t\t<NOT-OR>'+
									   '\n\t\t\t\t<Name MatchType="Contains-any-word">Plate tectonics Telescopes</Name>'+
									   '\n\t\t\t\t<GradeRanges MatchType="Contains-all-words">9,10</GradeRanges>'+
									   '\n\t\t\t</NOT-OR>'+
									   '\n\t\t</Content-Query>'+
									   '\n\t</Query>'+
									   '\n</SMS-CSIP>';

registerQueryTemplates["RAB"]	      ='<SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
									   '\n\t<Query Color="skyblue" DetailLevel="Detailed" Format="SMS" Scope="ALL" ThirdPartyQuery="">'+
									   '\n\t\t<Content-Query>'+
									   '\n\t\t\t<ObjectID>SMS-BMK-0009</ObjectID>'+
									   '\n\t\t</Content-Query>'+
									   '\n\t</Query>'+
									   '\n</SMS-CSIP>';

registerQueryTemplates["LUA"]	      ='<SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
									   '\n\t<Query Color="skyblue" DetailLevel="Detailed" Format="SMS" Scope="ALL" ThirdPartyQuery="">'+
									   '\n\t\t<ASNLookup-Query>'+
									   '\n\t\t\t<ASNID>http://asn.jesandco.org/resources/S100AA12</ASNID>'+
									   '\n\t\t</ASNLookup-Query>'+
									   '\n\t</Query>'+
									   '\n</SMS-CSIP>';
									   
registerQueryTemplates["GAMIGF"]      ='<SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
									   '\n\t<Query Color="skyblue" Format="SVG">'+
									   '\n\t\t<Content-Query>'+
									   '\n\t\t\t<ObjectID>SMS-MAP-1200</ObjectID>'+
									   '\n\t\t</Content-Query>'+
									   '\n\t</Query>'+
									   '\n</SMS-CSIP>';

registerQueryTemplates["GAPM"]        ='<SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
									   '\n\t<Query Color="skyblue" Format="PDF">'+
									   '\n\t\t<Content-Query>'+
									   '\n\t\t\t<ObjectID>SMS-MAP-1200</ObjectID>'+
									   '\n\t\t</Content-Query>'+
									   '\n\t</Query>'+
									   '\n</SMS-CSIP>';

registerQueryTemplates["FPOAB"]        ='<SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
									    '\n\t<Query Color="skyblue" DetailLevel="Skeleton" Format="SMS" Scope="ALL" ThirdPartyQuery="">'+
										'\n\t\t<Navigational-Query>'+
										'\n\t\t\t<ObjectID>SMS-BMK-0027</ObjectID>'+
										'\n\t\t\t<Relation>'+
										'\n\t\t\t\t<Prerequisite></Prerequisite>'+
										'\n\t\t\t</Relation>'+
										'\n\t\t</Navigational-Query>'+
									    '\n\t</Query>'+
									    '\n</SMS-CSIP>';

registerQueryTemplates["FPOAB"]        ='<SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
									    '\n\t<Query Color="skyblue" DetailLevel="Skeleton" Format="SMS" Scope="ALL" ThirdPartyQuery="">'+
										'\n\t\t<Navigational-Query>'+
										'\n\t\t\t<ObjectID>SMS-BMK-0027</ObjectID>'+
										'\n\t\t\t<Relation>'+
										'\n\t\t\t\t<Prerequisite></Prerequisite>'+
										'\n\t\t\t</Relation>'+
										'\n\t\t</Navigational-Query>'+
									    '\n\t</Query>'+
									    '\n</SMS-CSIP>';

registerQueryTemplates["GTMCTM"]       ='<SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
									    '\n\t<Query Color="skyblue" DetailLevel="Skeleton" Format="SMS" Scope="ALL" ThirdPartyQuery="">'+
										'\n\t\t<Navigational-Query>'+
										'\n\t\t\t<ObjectID>SMS-STD-0036</ObjectID>'+
										'\n\t\t\t<Relation>'+
										'\n\t\t\t\t<Is-part-of/>'+
										'\n\t\t\t</Relation>'+
										'\n\t\t</Navigational-Query>'+
									    '\n\t</Query>'+
									    '\n</SMS-CSIP>';

registerQueryTemplates["IOSAG"]       ='<SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
									   '\n\t<Query Color="skyblue" Format="SVG">'+
									   '\n\t\t<Content-Query>'+
									   '\n\t\t\t<InternalRelationships>'+
									   '\n\t\t\t\t<InternalRelationship Relation="Is part of" Object="SMS-STD-1374"></InternalRelationship>'+
					    			   '\n\t\t\t\t<InternalRelationship Relation="Is part of" Object="SMS-GRD-1378"></InternalRelationship>'+
									   '\n\t\t\t</InternalRelationships>'+
									   '\n\t\t</Content-Query>'+
									   '\n\t</Query>'+
									   '\n</SMS-CSIP>';

function sendRequest(URL,method,body,async,xml)
{
	var req = null;
	
    if (window.XMLHttpRequest) 
        req = new XMLHttpRequest();
    else if (window.ActiveXObject) 
        req = new ActiveXObject("Microsoft.XMLHTTP");
    
    req.open(method, URL, async);
    req.send(body);
	
	if(xml)
		return req.responseXML;
	else
		return req.responseText;
 	
}


function trim(sString)
{
	while (sString.substring(0,1) == ' ')
		sString = sString.substring(1, sString.length);

	while (sString.substring(sString.length-1, sString.length) == ' ')

	sString = sString.substring(0,sString.length-1);

	return sString;
}

function launchServiceDescriptionRequest()
{
	var URL	= trim(document.bURL.cmsURL.value);
	URL += "/ServiceDescription";
	
	newWindow = window.open(URL,"_blank",'height=600,width=600,resizable=yes,left=200,top=200,status=no');
}

function launchSubmitResource()
{
	var URL			= trim(document.bURL.cmsURL.value);
	var oid 		= trim(document.SubRes.OID.value);
	var res 		= trim(document.SubRes.RES.value);
	var eml 		= trim(document.SubRes.email.value);
	var emlString 	= "&email="+eml;
	var xmlDoc 		= null;

	URL += "/SubmitResource?";
	
	if(oid == "")
	{
		alert ("Please enter a valid value for the Object Identifier");
		return false;
	}

	if(res == "")
	{
		alert ("Please enter a valid value for the resource");
		return false;
	}

	if(eml == "")
	{
		alert ("Please enter a valid value for the email address");
		return false;
	}

		
	URL += "ObjectID="+oid+"&Resource="+res+emlString;
	
	xmlDoc = trim(sendRequest(URL,"GET","",false,false));

	newWindow = window.open(URL,"_blank",'height=600,width=600,resizable=yes,left=200,top=200,status=no');
	
	if(xmlDoc == "")
	{
		newWindow.document.write("Resource was submitted successfully to CMS for review and inclusion");
		newWindow.document.close();
	}
}


function loadTemplate(templateName,textareaName)
{
	document.getElementsByName(textareaName).item(0).value =	registerQueryTemplates[templateName];	
}

function submitRQ(path)
{
	var forms 				= new Array();
	
	forms['Query'] 			= document.queryForm;
	forms['RegisterQuery'] 	= document.registerForm;

    forms[path].action = trim(document.bURL.cmsURL.value)+"/"+path;

	return true;
}

