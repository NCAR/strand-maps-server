<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ include file="../../TagLibIncludes.jsp" %>
<c:set var="domain" value="${f:serverUrl(pageContext.request)}"/>
<c:set var="baseCMSURL" value='${f:contextUrl(pageContext.request)}' />

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">


<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		
		<script type="text/javascript" src="scripts/ServiceExplorer.js"></script>
	
		<title>CSIP Explorer</title>		
		 				
	</head>
	<body>
	
	<%-- Insert the menus top: --%>
	<%@ include file="/docs/menus_insertion_top.jsp" %>

		<h1>CSIP Explorer</h1>
		<p>This page will allow you to test the result of different queries. You can send the queries to CSIP server and check the response before encoding them into the client code.</p>
		<h2>Base URL</h2>		
		<form name="bURL"><p><textarea name="cmsURL" rows="2" cols="60">${baseCMSURL}</textarea></p></form>
		
		<h2>Requests</h2>
		<h3>Test ServiceDescription request</h3>
		<p>
			Press this  button <input type="button" value=" Service Description " onclick="launchServiceDescriptionRequest()"></input> to test the service description request.
		</p>
		<h3>Test SubmitResource request</h3>		

		<form name="SubRes">
			<table width="80%">
				<thead>
					<tr height="40px">
						<td align="center" width="20%"><b>Parameter</b></td>
						<td align="center" width="50%"><b>Value</b></td>
						<td align="center" width="30%"></td>
					</tr>
				</thead>
				<tr height="40px">
					<td align="center">
						ObjectID
					</td>
					<td align="left" colspan="1">
						<input type="text" name="OID" size="80">
					</td>
					<td>Pattern: <nobr>[3 letters]-[3 letters]-[4 digits]</nobr></td>
				</tr>
				<tr height="40px">
					<td align="center">
						Resource
					</td>
					<td align="left" colspan="2">
						<input type="text" name="RES" size="80">
					</td>
				</tr>
				<tr height="40px">
					<td align="center">
						email
					</td>
					<td align="left" colspan="2">
						<input type="text" name="email" size="80">
					</td>
				</tr>
				<tr height="40px"><td colspan="3" align="center"><input align="middle" type="button" onclick="launchSubmitResource()" value="          Submit Resource          " /> </td></tr>
			</table>
		</form>		
		
		<h3>Test RegisterQuery request</h3>
		<p>Please select and fill in the template below and press the submit button to test:</p>
		
		<form name="registerForm" method="post" target="_blank" onsubmit="return submitRQ('RegisterQuery');" enctype="text/xml" >

			<p>
				<table width="100%" border="0">
					<thead>
						<tr>
							<td align="center"><b>Select Operation Template</b></td>
							<td align="center"><b>Register Query Request Template</b></td>
						</tr>
					</thead>
					<tr>
						<td align="center" width="20%" valign="top">
							<br/>
							<input type="button" value="See registered queries   -->" onclick="loadTemplate('SeeAllQueries','RegisterQuery')" class="rqbutton"/><br/>
							<input type="button" value="Lookup query   -->" onclick="loadTemplate('Lookup','RegisterQuery')" class="rqbutton"/><br/>
							<input type="button" value="Add Query   -->" onclick="loadTemplate('AddQuery','RegisterQuery')" class="rqbutton"/><br/>
							<input type="button" value="Update Query   -->" onclick="loadTemplate('UpdateQuery','RegisterQuery')" class="rqbutton"/><br/>
							<input type="button" value="Change authentication code   -->" onclick="loadTemplate('ChangeCode','RegisterQuery')" class="rqbutton"/><br/>
							<input type="button" value="Disable Query   -->" onclick="loadTemplate('DisableQuery','RegisterQuery')" class="rqbutton"/><br/>
							<input type="button" value="EnableQuery   -->" onclick="loadTemplate('EnableQuery','RegisterQuery')" class="rqbutton"/><br/>
							<input type="button" value="RemoveQuery   -->" onclick="loadTemplate('RemoveQuery','RegisterQuery')" class="rqbutton"/><br/>
						</td>
						<td width="80%" align="left" valign="middle">
							<textarea rows="14" cols="115" name="RegisterQuery"></textarea>
						</td>
					</tr>
				</table>
				<br/>
				<table width="100%" border="0">
					<tr>
						<td width="20%"></td>
						<td align="center">
							<input type="submit" value="          Submit Register Query Request          "/>
						</td>
					</tr>
				</table>
			</p>
		</form>
		
		
		<h3>Test Query request</h3>
		<p>Please select and fill in the template below and press the submit button to test:</p>

		<form name="queryForm" method="post" target="_blank" onsubmit="return submitRQ('Query');" enctype="text/xml" >

			<p>
				<table width="100%" border="0">
					<thead>
						<tr>
							<td align="center" width="20%"><b>Select Query Template</b></td>
							<td align="center" width="80%"><b>Query Request Template</b></td>
						</tr>
					</thead>
					<tr>
						<td align="left" width="20%" valign="top">
							<div style="">
								<div align="left"><span style="font-weight:bold;color:#8b0911;font-size:80%">Generic Query Templates</span></div><br/>
								<input type="button" value="Content Query   -->" onclick="loadTemplate('ContentQuery','Query')" class="rqbutton"/><br/>
								<input type="button" value="Navigational Query   -->" onclick="loadTemplate('NavigationalQuery','Query')" class="rqbutton"/><br/>
							</div>
							<br/>
							<div style="">
								<div align="left"><span style="font-weight:bold;color:#8b0911;font-size:80%">Some Common Query Templates</span></div><br/>
								<input type="button" value="Search Within Fulltext  -->" onclick="loadTemplate('SWF','Query')" class="rqbutton"/><br/>
								<input type="button" value="Search in All Metadata Fields   -->" onclick="loadTemplate('SIAMF','Query')" class="rqbutton"/><br/>
								<input type="button" value="Get List of Maps   -->" onclick="loadTemplate('GLOM','Query')" class="rqbutton"/><br/>
								<input type="button" value="Find All Benchamrks having Earthquakes   -->" onclick="loadTemplate('FABHE','Query')" class="rqbutton"/><br/>
								<input type="button" value="Find an Object Containing Benchmark -->" onclick="loadTemplate('FAOCB','Query')" class="rqbutton"/><br/>
								<input type="button" value="Use And to Combine Search Criteria -->" onclick="loadTemplate('UACSC','Query')" class="rqbutton"/><br/>
								<input type="button" value="Use Or to Combine Search Criteria -->" onclick="loadTemplate('UOCSC','Query')" class="rqbutton"/><br/>
								<input type="button" value="Use Not-Or to Combine Search Criteria -->" onclick="loadTemplate('UNOCSC','Query')" class="rqbutton"/><br/>
								<input type="button" value="Retrieve a Benchmark  -->" onclick="loadTemplate('RAB','Query')" class="rqbutton"/><br/>
								<input type="button" value="Retrieve a Benchmark by ASN ID  -->" onclick="loadTemplate('LUA','Query')" class="rqbutton"/><br/>
								<input type="button" value="Get a Map in Graphical Format (SVG)  -->" onclick="loadTemplate('GAMIGF','Query')" class="rqbutton"/><br/>
								<input type="button" value="Get a Printable Map (PDF)  -->" onclick="loadTemplate('GAPM','Query')" class="rqbutton"/><br/>
								<input type="button" value="Find Pre-requisites of a Benchmark  -->" onclick="loadTemplate('FPOAB','Query')" class="rqbutton"/><br/>
								<input type="button" value="Get the Map Containing a Strand  -->" onclick="loadTemplate('GTMCTM','Query')" class="rqbutton"/><br/>
								<input type="button" value="Intersection of Strand & Grade  -->" onclick="loadTemplate('IOSAG','Query')" class="rqbutton"/><br/>
							</div>
						</td>
						<td width="80%" align="center" valign="middle">
							<textarea rows="20" cols="85" name="Query"></textarea>
						</td>
					</tr>
				</table>
				<br/>
				<table width="100%" border="0">
					<tr>
						<td width="20%"></td>
						<td align="center" width="80%">
							<input type="submit" value="          Submit Query Request          "/>
						</td>
					</tr>
				</table>
			</p>
		</form>

	<%-- Insert the menus bottom: --%>
	<%@ include file="/docs/menus_insertion_bottom.jsp" %> 
		
	</body>
</html>