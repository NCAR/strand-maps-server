<?php
$keywords = $_REQUEST['keywords'];
$offset = $_REQUEST['offset'];
$toDisplay = 10;

// separate the keywords
$a_kw = explode('|',$keywords);
foreach($a_kw as $key=>$val){
	if(!$kw){
		$kw = '"'.$val.'"';	
	} else {
		$kw = $kw .' OR "'.$val.'"';	
	}	
}
// check the metadata description and titles only for these keywords
$kw = 'description:('.$kw.') AND title:('.$kw.')';

// for this example we only want high school level resources
$grades = '/key//nsdl_dc/educationLevel:("high school")';

// only the NASA Earth Science Reviewed Collection
$collections = 'ky:"2802786"';

// form the query
$query = 'xmlFormat:nsdl_dc AND '.$kw .' AND '.$grades.' AND '.$collections;	



$url = 'http://nsdl.org/dds-search?s='.$offset.'&n='.$toDisplay.'&transform=localize&xmlFormat=nsdl_dc&q='.rawurlencode($query);
echo $url;
function parseResults($url){
	if(!$curld = curl_init($url)){
		$o_XML->error = 'Could not initialize session';	
	} else {
		$options = array(CURLOPT_RETURNTRANSFER => true,
							CURLOPT_POST => true,
							CURLOPT_CONNECTTIMEOUT => 30,
							CURLOPT_TIMEOUT => 30);
		curl_setopt_array($curld,$options);
		$s_xml = curl_exec($curld);
		
		try{
			$o_XML = new SimpleXMLElement($s_xml);
		} catch(Exception $e){
		    $o_XML->error = 'Could not parse XML';	
		}
	}
		
	if(!$o_XML->error){
		return $o_XML;		
	}
}

function displayResults($o_XML,$offset,$toDisplay){
	if(($total = $o_XML->Search->resultInfo->totalNumResults) > 0){
		
		// pagination 
		echo 'Displaying: '.($offset+1);
		if($offset + $toDisplay > $total) {
			echo ' - '.$total;
		} else if($offset + $toDisplay <= $total) {
			echo ' - '.($offset + $toDisplay);
		}
		
		echo ' out of '.$total;
		if($total > 1) {
			echo ' results';
		} else {
			echo ' result';
		}
		
		// previous and next links
		$prev = $offset - $toDisplay;
		$next = $offset + $toDisplay;
	
		if($prev >= 0){
			echo ' <a href="javascript:sendResRequest('.$prev.')">Prev</a>';
		}
		if($prev >= 0 && $next < $total){
			echo ' | ';
		}
		if($next < $total){
			echo ' <a href="javascript:sendResRequest('.$next.')">Next</a>';
		}
		
		// display the records
		$records = $o_XML->Search->results;	
		foreach($records->record as $index=>$item){
			// pick a title - we'll use the first one
			$a_titles = explode(' ~^ ',$item->metadata->title);
			$a_descriptions = explode(' ~^ ',$item->metadata->description);
			$s_link = $item->xpath('//metadata/identifier[@type="dct:URI"]';
			echo '<p><a href="'.$s_link.'">'.$a_titles.'</a><br/>'.$a_descriptions.'</p>';
		}	
	} else {
		echo '<p>There are no related resources for this benchmark.</p>';
	}
}

$xml = parseResults($url);
displayResults($xml,$offset,$toDisplay);
?>