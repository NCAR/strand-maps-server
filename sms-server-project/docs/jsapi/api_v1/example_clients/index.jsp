<!doctype html public "-//w3c//dtd html 4.0 transitional//en" "http://www.w3.org/TR/REC-html40/strict.dtd">
<html>
    <head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <title>SMS JavaScript API: Example Code</title>

</head>

<body>

	<%-- Insert the menus top: --%>
	<%@ include file="/docs/menus_insertion_top.jsp" %>

<!-- Header -->
<table width="95%">
    <tr><td>
    	<h1>Example Code</h1>
		
		<p>
		These example clients illustrate how the API is used to create a custom page. The clients
		may be downloaded and used as a template for starting a new page. 
		</p>
		
		<h3>Clients:</h3>
		<ul>
			<li>
				<a href="example1/index.html" target="_blank">Example 1</a> - 
					Displays a map and shows summary information including which strand the benchmark belongs to in the information bubble 
					when the user selects a benchmark in the map.  Demonstrates how to include the Top Picks and student misconception research tabs and how to choose which NSDL collections to search over.
					Also demonstrates how to place custom annotations next to benchmarks, strands, grades and viewable area of the map, which in this example displays the total number of NSDL Top Pick resources for each.								
			</li>					
			<li>
				<a href="example2/index.html" target="_blank">Example 2</a> - 
				Access data in JSON form and displays information about benchmarks and the
				parent nodes for a given benchmark, Pulls in HTML, video and a Google map to the information bubble using AJAX. 
				It also shows how to display custom content in the 
				print view and to display a simple help screen for the user.
			</li>
				<li>
				<a href="example3/index.html" target="_blank">Example 3</a> - 
				Displays a single map using an iframe, and selects a specific collection for resources.  Two examples are provide to demonstrate how to use an ASN ID, or just the SMS-BMK id to reference the benchmark and render the corresponding map.
			</li>		
			<li>
				<a href="example4/index.html" target="_blank">Example 4</a> - 
				Provides access to a subset of maps with a custom strand selector.
			</li>
			
		</ul>			

    </td></tr>
</table>

<br>

	<%-- Insert the menus bottom: --%>
	<%@ include file="/docs/menus_insertion_bottom.jsp" %> 

</body>
</html>
