<!doctype html public "-//w3c//dtd html 4.0 transitional//en" "http://www.w3.org/TR/REC-html40/strict.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Strand Map Service: Overview</title>

<style>
	LI {
		margin-left: 15px;
	}
</style>

</head>

<body>

	<%-- Insert the menus top: --%>
	<%@ include file="/docs/menus_insertion_top.jsp" %>

<!-- Header -->
<table width="95%">
    <tr><td>
	<h1>View the Maps</h1>
		
	  <p>The <a href="http://strandmaps.dls.ucar.edu/">Science Literacy Maps</a> are the reference implementation of the Strand Map Service.</p>


    	<h1>Overview</h1>
		
	  <p> The Strand Map Service (SMS) provides an interactive graphical interface that helps K-12 teachers and students understand the relationships between science concepts. The interactive maps are available through public JavaScript and REST APIs that let developers embed the maps in   Web sites and display educational resources and other content in the maps.</p>
		<p> Based on the learning goals from the AAAS Benchmarks for Science Literacy and the visualizations from the AAAS Atlas of Science Literacy (<a href="http://www.project2061.org/">AAAS Project 2061</a>), the Strand Maps demonstrate the connectedness of ideas and skills that students should develop over time. The maps illustrate learning goals for different grades, and the relationships between goals, for K-12 students across a range of science, technology, engineering, and mathematics (STEM) disciplines.</p>
		<p>This documentation describes how to use one or both of the APIs to create and customize an interactive map or to access information from within the AAAS Strand Map information space. The	two APIs are the	 SMS JavaScript API and the REST-based Concept Space Interchange Protocol (CSIP).</p>
		
		<h3>SMS JavaScript API</h3>
		<p>
			The SMS JavaScript API lets Web developers insert interactive AAAS Strand Maps into Web pages
			using JavaScript and place custom content into the bubble inside the maps.
			<ul>
					<li><a href="jsapi/index.jsp">JavaScript API Overview</a></li>
			</ul>
		</p>
	
	<h3>Concept Space Interchange Protocol (CSIP)</h3>
	<p>
		The Concept Space Interchange Protocol (CSIP) is a REpresentational State Transfer (REST) service API that lets developers 
		search through the AAAS information space.			
		  <ul>
			 <li><a href="cms/index.jsp">CSIP Overview</a></li>
		  </ul>
	</p>
		<br/>
		<hr width="98%"/>
		<br/>
	  <h3>Open Archives Initiative (OAI)</h3>
			<p>
				The full set of benchmarks in the Strand Map Service may be harvested using the <a href="http://openarchives.org">Open Archives Initiative</a> Protocol for Metadata Harvesting (OAI-PHM) in either oai_dc or nsdl_dc format.
				To harvest the benchmarks, use the following baseURL:
			  <ul>
				 <li>OAI provider baseURL: <code>${f:contextUrl(pageContext.request)}/OAI-PMH</code></li>
			  </ul>
			 </p>
	  
	  <h3>Acknowledgements</h3>
			<p>
				The Strand Map Service is created by researchers from the University of Colorado at Boulder and <a href="http://dls.ucar.edu/">Digital Learning Sciences</a> (DLS).
			</p>


    </td></tr>
</table>

		<br/>
		<br/>
		


	<%-- Insert the menus bottom: --%>
	<%@ include file="/docs/menus_insertion_bottom.jsp" %> 

</body>
</html>
