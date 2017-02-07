<%@ include file="/jsapi/TagLibIncludes.jsp" %>

<%-- Sets the default host,port and path for rest of the tags used in this page --%>
<smsU:DefaultHost host="@LOCAL_HOST@"/> 
<smsU:DefaultPort port="@LOCAL_PORT@"/> 
<smsU:DefaultPath path="@QUERY_URL_PATH@"/> 

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"

<html>
<head>
<title>Strand selector</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

</head>

<body>


<c:choose>
	<c:when  test="${param.keyword != null}">
		<c:set var="key">
			<str:trim>
				<str:replace replace='"' with="">
					<str:replace replace="'" with="">
						<str:replace replace="*" with="">
							<str:replace replace="+" with="">
								<str:replace replace="~" with="">
									<str:replace replace="." with="">
										<str:replace replace="?" with="">
											<str:replace replace="," with="">
												<str:replace replace=";" with="">
													<str:replace replace=":" with="">
														<str:replace replace="&lt;" with="">
															<str:replace replace="&gt;" with="">
																<str:replace replace="&#039;" with="">
																	<str:replace replace="&#034;" with="">
																		<str:replace replace="&amp;" with="">
																			<c:out value="${param.keyword}"/>
																		</str:replace>	
																	</str:replace>	
																</str:replace>
															</str:replace>
														</str:replace>
													</str:replace>
												</str:replace>
											</str:replace>
										</str:replace>
									</str:replace>
								</str:replace>
							</str:replace>
						</str:replace>
					</str:replace>
				</str:replace>
			</str:trim>
		</c:set>
	</c:when>	
	<c:otherwise>
		<c:set var="key" value=""/>
	</c:otherwise>
</c:choose>

<table width="100%" border="0" cellpadding="8" cellspacing="0">
  <!--DWLayoutTable-->
  <tr bgcolor="#F8C98C"> 
    <td valign="top" align="center" width="40%" nowrap>
	
	
		<form action="#start" method="get">
			  <input name="keyword" type="text" size="30" maxlength="50">
			  <input type="submit" value="Search for Concepts">
		</form>
    
    </td>
    	<td width="7%" align="center" valign="top" nowrap><a href="test_selector.jsp">SHOW ALL MAPS </a> </td>

	<td valign="top">
			<x:parse var="FoundMapResponseXML">
				<sms:FindMaps>
					<sms:SimpleSearch method="Contains-all-words">
						<c:out value="${key}"/>
					</sms:SimpleSearch>
				</sms:FindMaps>
			</x:parse>
			<x:choose>
				<x:when select="$FoundMapResponseXML//MapName">
					<b>Your search for <i><c:out value="${key}"/></i> was found in concepts in the following maps:</b>
				</x:when>
				<x:otherwise>
					<c:choose>
						<c:when test="${key != ''}">
							<b>Your search for <i>"<c:out value="${key}"></c:out>"</i> yielded no results</b>
						</c:when>
					</c:choose>
				</x:otherwise>
			</x:choose>
				</td>
  </tr>
  <tr>
    <td height="29" colspan="4" valign="top" align="center"  >

	        		<%!	int counter=0; %>
	        		<%!	int noInRow=5; %>
	        		<%!	int cellSizeX=170; %>
	        		<%!	int cellSizeY=160; %>
	        		<%!	int imageSizeX=170; %>
	        		<%!	int imageSizeY=121; %>
	        		<%!	int sepSizeWidth=60; %>
	        		<%!	int sepSizeHeight=20; %>
	        		<%!	String bkColor0="#FFFFFF"; %>
	        		<%!	String bkColor1="#EEEEEE"; %>
					
					<%counter = 0;%>

	<c:choose>
		<c:when test="${key != ''}">

			<table border="0">
					
					<x:forEach select="$FoundMapResponseXML//MapName">
							<c:set var="mapName"><x:out select="."/></c:set>
							<c:set var="mapNumber"><x:out select="./@id"/></c:set>
							<c:url value="./mapFrame.jsp" var="link">
								<c:param name="mapid" value="${mapNumber}"/>
								<c:param name="tab">
									<c:choose>
										<c:when test="${mapName == 'Changes in the Earth&#039;s Surface'}">0</c:when>
										<c:when test="${mapName == 'Plate Tectonics'}">1</c:when>
										<c:when test="${mapName == 'Evidence and Reasoning in Inquiry'}">2</c:when>
										<c:when test="${mapName == 'Scientific Investigations'}">3</c:when>
										<c:when test="${mapName == 'Solar System'}">4</c:when>
										<c:when test="${mapName == 'States of Matter'}">5</c:when>
										<c:when test="${mapName == 'Gravity'}">6</c:when>
										<c:when test="${mapName == 'Flow of Energy in Ecosystems'}">7</c:when>
										<c:when test="${mapName == 'Flow of Matter in Ecosystems'}">8</c:when>
										<c:when test="${mapName == 'Weather and Climate'}">9</c:when>
									</c:choose>
								</c:param>
							</c:url>							
				
					<%if(counter % noInRow == 0){%>
				        <tr>        	
					<%}%>	
				        	<td width="<%=cellSizeX%>" height="<%=cellSizeY%>" align="center" valign="top">
				        	<div id="mapname1" style="color:blue;font-size:small;">
							
							<table width="<%=cellSizeX%>" border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td align="center" bgcolor="<%=bkColor0%>">
										<%="<a href=\""%><c:out value="${link}"/><%="\"  style=\"text-decoration:none;color:blue;\" >"%>
								     	<x:out select="."/>
								     	</a>
									</td>
								</tr>
								<tr>
									<td align="center" bgcolor="<%=bkColor1%>">
										<%="<a href=\""%><c:out value="${link}"/><%="\"  style=\"text-decoration:none;color:blue;\" >"%>
										<br/>
							            <br/>
							            </a>
									</td>
								</tr>
								<tr>
									<td align="left" bgcolor="<%=bkColor1%>">
										<%="<a href=\""%><c:out value="${link}"/><%="\"  style=\"text-decoration:none;color:blue;\" >"%>
	
											<c:set var="mapName">
												<x:out select="./@id"/>
											</c:set>
											
											<x:parse var="Strands">
												<sms:StrandList upper="${mapName}"/> 
											</x:parse>
											
											<x:forEach select="$Strands//*[local-name()='itemRecord']">
												<x:out select="*[local-name()='Data']/*[local-name()='Name']"/>
												<br/>											
											</x:forEach>
											
											
										</a>
									</td>
								</tr>
							</table>
				        	</div>
				        	</td>
		
					<%if(counter % noInRow != noInRow-1){%>
		    		    	<td width="<%=sepSizeWidth%>" valign="top" bgcolor="<%=bkColor0%>"><!--DWLayoutEmptyCell-->&nbsp;</td>
					<%}%>	
	
					<%if(counter % noInRow == noInRow-1){%>
					    </tr>
				
				        <tr>
				            <td height="<%=sepSizeHeight%>" colspan="<%=noInRow*2-1%>>" valign="top" bgcolor="<%=bkColor0%>"><!--DWLayoutEmptyCell-->&nbsp;</td>
				        </tr>
					<%}%>	
					<%counter++;%>		
					</x:forEach>
	
					<%
						int diff = (counter+1) % noInRow;
						
						for(int index=0;index<diff-1;index++)
						{
					%>
				        	<td width="168" height="100" align="center" valign="middle" bgcolor="<%=bkColor0%>"></td>
					<%if(index < diff-2){%>
		    		    	<td width="22" valign="top" bgcolor="<%=bkColor0%>"><!--DWLayoutEmptyCell-->&nbsp;</td>
					<%}	
					}
					%>
			</table>



		
		</c:when>
		<c:otherwise>
			<x:parse var="MapResponseXML">
					<sms:MapList/>
			</x:parse>
	
			<table border="0">
					
					<x:forEach select="$MapResponseXML//*[local-name()='itemRecord']">
							<c:set var="mapNumber"><x:out select="*[local-name()='Admin']/*[local-name()='IDNumber']"/></c:set>
							<c:url value="./mapFrame.jsp" var="link">
								<c:param name="mapid" value="${mapNumber}"/>
								<c:param name="tab">
									<c:choose>
										<c:when test="${mapNumber == 'SMS-MAP-0048'}">0</c:when>
										<c:when test="${mapNumber == 'SMS-MAP-0049'}">1</c:when>
										<c:when test="${mapNumber == 'SMS-MAP-1200'}">2</c:when>
										<c:when test="${mapNumber == 'SMS-MAP-1207'}">3</c:when>
										<c:when test="${mapNumber == 'SMS-MAP-1282'}">4</c:when>
										<c:when test="${mapNumber == 'SMS-MAP-1341'}">5</c:when>
										<c:when test="${mapNumber == 'SMS-MAP-1372'}">6</c:when>
										<c:when test="${mapNumber == 'SMS-MAP-1422'}">7</c:when>
										<c:when test="${mapNumber == 'SMS-MAP-9001'}">8</c:when>
										<c:when test="${mapNumber == 'SMS-MAP-9030'}">9</c:when>
									</c:choose>								
								</c:param>
							</c:url>
				
					<%if(counter % noInRow == 0){%>
				        <tr>        	
					<%}%>	
				        	<td width="<%=cellSizeX%>" height="<%=cellSizeY%>" align="center" valign="top">
				        	<div id="mapname1" style="color:blue;font-size:small;">
							
							<table width="<%=cellSizeX%>" border="0" cellpadding="5" cellspacing="0">
								<tr>
									<td align="center" bgcolor="<%=bkColor0%>">
										<%="<a href=\""%><c:out value="${link}"/><%="\"  style=\"text-decoration:none;color:blue;\" >"%>
								     	<font face="Arial" size="+1"><x:out select="*[local-name()='Data']/*[local-name()='Name']"/></font>
								     	</a>
									</td>
								</tr>
								<tr>
									<td align="left" bgcolor="<%=bkColor1%>">
										&nbsp;
									</td>
								</tr>
								<tr>
									<td align="left" bgcolor="<%=bkColor1%>">
										<%="<a href=\""%><c:out value="${link}"/><%="\"  style=\"text-decoration:none;color:blue;\" >"%>
	
											<c:set var="mapName">
												<x:out select="*[local-name()='Admin']/*[local-name()='IDNumber']"/>
											</c:set>
											
											<x:parse var="Strands">
												<sms:StrandList upper="${mapName}"/> 
											</x:parse>
											
											<x:forEach select="$Strands//*[local-name()='itemRecord']">
												  <str:capitalizeAllWords>
													  <x:out select="*[local-name()='Data']/*[local-name()='Name']"/>
												  </str:capitalizeAllWords>
												<br/>											
											</x:forEach>
											
											
										</a>
									</td>
								</tr>
							</table>
				        	</div>
				        	</td>
		
					<%if(counter % noInRow != noInRow-1){%>
		    		    	<td width="<%=sepSizeWidth%>" valign="top" bgcolor="<%=bkColor0%>"><!--DWLayoutEmptyCell-->&nbsp;</td>
					<%}%>	
	
					<%if(counter % noInRow == noInRow-1){%>
					    </tr>
				
				        <tr>
				            <td height="<%=sepSizeHeight%>" colspan="<%=noInRow*2-1%>>" valign="top" bgcolor="<%=bkColor0%>"><!--DWLayoutEmptyCell-->&nbsp;</td>
				        </tr>
					<%}%>	
					<%counter++;%>		
					</x:forEach>
	
					<%
						int diff = (counter+1) % noInRow;
						
						for(int index=0;index<diff-1;index++)
						{
					%>
				        	<td width="168" height="100" align="center" valign="middle" bgcolor="<%=bkColor0%>"></td>
					<%if(index < diff-2){%>
		    		    	<td width="22" valign="top" bgcolor="white"><!--DWLayoutEmptyCell-->&nbsp;</td>
					<%}	
					}
					%>
			</table>
		
		</c:otherwise>
	</c:choose>

	

	</td>
  </tr>
  
</table>

</body>
</html>

