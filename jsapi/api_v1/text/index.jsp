<%@ include file="/jsapi/TagLibIncludes.jsp" %>
<%-- Sets the default host,port and path for rest of the tags used in this page --%>
<%@ page import="java.lang.*"%>
<smsU:DefaultHost host="@LOCAL_HOST@"/> 
<smsU:DefaultPort port="@LOCAL_PORT@"/> 
<smsU:DefaultPath path="@QUERY_URL_PATH@"/> 
<c:set var="baseUrl" value="@LOCAL_CONTEXT_URL@/Query" />
<%
String bmId = request.getParameter("bmId");
String mapId = request.getParameter("mapId");
String mapName = request.getParameter("mapName");
String startingOffset = request.getParameter("startingOffset");
%>
<c:set var="bmId" value="<%=bmId%>"/>
<c:set var="mapId" value="<%=mapId%>"/>
<c:set var="mapName" value="<%=mapName%>"/>
<c:set var="startingOffset" value="<%=startingOffset%>"/>
<%@ include file="header.jsp" %>
<c:choose>
<c:when test="${not empty bmId}">
<%-- The maximum character length of the description that gets displayed in the initial search results. 
		A smaller value here will make the search results page more compact. Leave blank to 
		display the full description text regardles off its length --%>
<c:set var="maxDescriptionLength" value="150" />
<%-- The maximum character length of the URL that gets displayed in the UI. A smaller
		value here will prevent problems with HTML wrapping --%>
<c:set var="maxUrlLength" value="85" />
<%-- Store the base URL to the service to use in the request below --%>
Navigation > <a href="./">Table of Contents</a> > <a href="?mapId=${mapId}&mapName=${fn:replace(mapName,' ','%20')}">${mapName} map</a>
<c:set var="baseUrl" value="@LOCAL_CONTEXT_URL@/Query" /> 

<c:set var="queryforbm">
	<SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
		 <Query Color="skyblue" Format="SMS" Scope="ALL" DetailLevel="Detailed" ThirdPartyQuery="DLESE XML">
			<Content-Query>
					<ObjectID><c:out value="${bmId}" /></ObjectID>
			</Content-Query>
		 </Query>
	</SMS-CSIP>
</c:set>
<%-- populate related benchmark info --%>

<c:url value="${baseUrl}" var="req">
    <c:param name="Query" value="${queryforbm}"/>
</c:url>
<c:import url="${req}" var="xmlResponse" charEncoding="UTF-8" />
<!-- change the & to &amp; -->
<c:set var="newresponse" value="${fn:replace( xmlResponse, '&' ,'&amp;')}"/>
<x:transform xslt="${f:removeNamespacesXsl()}" xml="${newresponse}" var="bmdoc"/>

<c:set var="standards" >
 	<x:out select="$bmdoc//Standards"/>
</c:set>
<h1>AAAS Benchmark</h1>
<x:out select="$bmdoc//FullText" /><p><em>Grade range</em>: 
<c:set var="number" value="0" />
<x:forEach select="$bmdoc//GradeRange">
	<c:set var="number" value="${number + 1}" />
</x:forEach>
<c:set var="n2" value="0" />
<x:forEach select="$bmdoc//GradeRange">
	<c:set var="n2" value="${n2 + 1}" />
	<c:choose>
		<c:when test="${n2 == 1}">
			<x:out select="." />
		</c:when>
		<c:when test="${n2 == number}" >
			- <x:out select="." />
		</c:when>
	</c:choose>
</x:forEach>

<c:set var="number" value="0" />
<c:set var="terms">
<x:forEach select="$bmdoc//keyword">
	<c:set var="number" value="${number + 1}" />
	<c:choose>
		<c:when test="${number == 1}">
			<x:out select="." />
		</c:when>
		<c:when test="${number != 1}" >
			OR <x:out select="." />
		</c:when>
	</c:choose>
</x:forEach>
</c:set>
<br>

<c:set var="count" value="0" />
<x:choose>
	<x:when select="$bmdoc//InternalRelationship">
		<x:forEach select="$bmdoc//CatalogID">
			<c:set var="someid">
				<x:out select="@CatalogNumber" />
			</c:set>
			<c:choose>
				<c:when test="${fn:containsIgnoreCase(someid, 'STD')}">
					<c:set var="count" value="${count + 1}" />
				</c:when>
			</c:choose>
		</x:forEach>
	</x:when>
</x:choose>	

<c:set var="num" value="0" />
<x:choose>
	<x:when select="$bmdoc//InternalRelationship">
	<em>This benchmark is found in </em> 
	<ul>
		<x:forEach select="$bmdoc//CatalogID">
			<c:set var="someid">
				<x:out select="@CatalogNumber" />
			</c:set>
			<c:choose>
				<c:when test="${fn:containsIgnoreCase(someid, 'STD')}">
					<c:set var="num" value="${num + 1}" />
					<c:set var="queryforstrand">
						<SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
							<Query Color="skyblue" Format="SMS" Scope="ALL" DetailLevel="Detailed" ThirdPartyQuery="DLESE XML">
								<Content-Query>
									<ObjectID>
										<c:out value="${someid}" />
									</ObjectID>
								</Content-Query>
							</Query>
						</SMS-CSIP>
					</c:set>
					<c:url value="${baseUrl}" var="reqstrand">
						<c:param name="Query" value="${queryforstrand}"/>
					</c:url>
					<c:import url="${reqstrand}" var="xmlResponseStrand" charEncoding="UTF-8" />
					<!-- change the & to &amp; -->
					<c:set var="newresponsestrand" value="${fn:replace( xmlResponseStrand, '&' , '&amp;')}"/>
					
					<x:transform xslt="${f:removeNamespacesXsl()}" xml="${newresponsestrand}" var="stranddoc"/>
					
					<c:set var="queryformap">
					<SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
						<Query Color="skyblue" DetailLevel="Skeleton" Format="SMS" Scope="ALL" ThirdPartyQuery="">
						<Navigational-Query>
							<ObjectID><x:out select="$stranddoc//IDNumber" /></ObjectID>
						<Relation>
							<Is-part-of/>
						</Relation>
						</Navigational-Query>
						</Query>
					</SMS-CSIP>
					</c:set>
					
					<c:url value="${baseUrl}" var="reqmap">
						<c:param name="Query" value="${queryformap}"/>
					</c:url>
					<c:import url="${reqmap}" var="xmlResponseMap" charEncoding="UTF-8" />
					<!-- change the & to &amp; -->
					<c:set var="newresponsemap" value="${fn:replace( xmlResponseMap, '&' , '&amp;')}"/>
					<x:transform xslt="${f:removeNamespacesXsl()}" xml="${newresponsemap}" var="mapdoc"/>
					<c:set var="viewMapId"><x:out select="$mapdoc//IDNumber" /></c:set>
					<c:set var="viewMapName"><x:out select="$mapdoc//Name" /></c:set>
					<li><em><x:out select="$stranddoc//Name" /></em> strand in the <a href="?mapId=${viewMapId}&amp;mapName=${fn:replace(viewMapName,' ','%20')}"><em>${viewMapName}</em> map</a></li>
						
				</c:when>	
			</c:choose>
			
		</x:forEach>
		</ul>
	</x:when>
</x:choose>
</p>

<c:choose>
	<c:when test="${not empty standards}">
	<h2>Educational Standards</h2>
	<c:set var="delim" value="+"/>
	<c:set var="array" value="${fn:split(standards, delim)}"/>
	<c:set var="arraysize" value="${fn:length(array)}" />
	<div id="standards">
	<p><strong>NSES <c:out value="${array[3]}" /> </strong>

	<c:set var="headtext" value="${fn:replace( array[4], '&#034;' , '')}"/>
	<c:set var="headtext2" value="${fn:replace( headtext, '&#039;' , '')}"/>


       <em><c:out value="${headtext2}" /></em><br/>
          <!-- heading 2 -->
          
	  <c:set var="sttext" value="${fn:replace( array[5], '&#034;' , '')}"/>
	  <c:set var="sttext2" value="${fn:replace( sttext, '&#039;' , '')}"/>
	<c:out value="${sttext2}" /> (<a href='<c:out value="${array[2]}" />' target="_blank" >NSES Full Text</a>) </p>
</div>
</c:when>
</c:choose>


<c:set var="queryforprereq">
<SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<Query Color="skyblue" DetailLevel="Skeleton" Format="SMS" Scope="ALL" ThirdPartyQuery="">
		<Navigational-Query>
			<ObjectID>${bmId}</ObjectID>
			<Relation>
				<Prerequisite></Prerequisite>
			</Relation>
		</Navigational-Query>
	</Query>
</SMS-CSIP>
</c:set>
<c:url value="${baseUrl}" var="reqmap">
	<c:param name="Query" value="${queryforprereq}"/>
</c:url>
<c:import url="${reqmap}" var="xmlResponsePreReq" charEncoding="UTF-8" />
<!-- change the & to &amp; -->
<c:set var="newresponsemap" value="${fn:replace( xmlResponsePreReq, '&' , '&amp;')}"/>
<x:transform xslt="${f:removeNamespacesXsl()}" xml="${newresponsemap}" var="prereqdoc"/>

<c:set var="test"><x:out select="$prereqdoc//*[local-name()='itemRecord']/*[local-name()='Admin']/*[local-name()='IDNumber']"/></c:set>
<c:choose>
<c:when test="${not empty test}">
<h2>Pre-requisite benchmarks</h2>
<c:set var="count">0</c:set>
<ol>
<x:forEach select="$prereqdoc//*[local-name()='itemRecord']">
	<c:set var="newBmId"><x:out select="*[local-name()='Admin']/*[local-name()='IDNumber']"/></c:set>
	<c:set var="count">${count + 1}</c:set>
	
	<li><x:out select="*[local-name()='Data']/*[local-name()='Description']"/><ul>
	<c:set var="pastMapID"></c:set>
	<x:forEach select="*[local-name()='Data']/*[local-name()='InternalRelationship']/*[local-name()='CatalogID']">
			<c:set var="someid">
				<x:out select="@CatalogNumber" />
			</c:set>
			<c:choose>
				<c:when test="${fn:containsIgnoreCase(someid, 'STD')}">
					<c:set var="queryformapsource">
						<SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
							<Query Color="skyblue" DetailLevel="Skeleton" Format="SMS" Scope="ALL" ThirdPartyQuery="">
								<Navigational-Query>
									<ObjectID>${someid}</ObjectID>
									<Relation>
										<Is-part-of/>
									</Relation>
								</Navigational-Query>
							</Query>
						</SMS-CSIP>
					</c:set>
					<c:url value="${baseUrl}" var="reqMap">
   					 	<c:param name="Query" value="${queryformapsource}"/>
					</c:url>
					<c:import url="${reqMap}" var="xmlResponseMap" charEncoding="UTF-8" />
					<!-- change the & to &amp; -->
					<c:set var="newresponseMap" value="${fn:replace( xmlResponseMap, '&' ,'&amp;')}"/>
					<x:transform xslt="${f:removeNamespacesXsl()}" xml="${newresponseMap}" var="mapsourcedoc"/>
					<c:set var="newMapID"><x:out select="$mapsourcedoc//IDNumber" /></c:set>
					<c:set var="newMapName"><x:out select="$mapsourcedoc//Name" /></c:set>
					<c:if test="${newMapID ne pastMapID}">
						<li><a href="?bmId=${newBmId}&amp;mapId=${newMapID}&amp;mapName=${fn:replace(newMapName,' ','%20')}" title="View pre-requisite benchmark ${count} from the ${newMapName} Map">From ${newMapName} Map</a></li>
					</c:if>
					<c:set var="pastMapID">${newMapID}</c:set>
				</c:when>
			</c:choose>
		</x:forEach>
</ul>
</li>
</x:forEach>
</ol>
</c:when>
<c:otherwise>
There are no pre-requisite benchmarks
</c:otherwise>
</c:choose>



<!-- post reqs //-->

<c:set var="queryforprereq">
<SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<Query Color="skyblue" DetailLevel="Skeleton" Format="SMS" Scope="ALL" ThirdPartyQuery="">
		<Navigational-Query>
			<ObjectID>${bmId}</ObjectID>
			<Relation>
				<Post-Requisite></Post-Requisite>
			</Relation>
		</Navigational-Query>
	</Query>
</SMS-CSIP>
</c:set>
<c:url value="${baseUrl}" var="reqmap">
	<c:param name="Query" value="${queryforprereq}"/>
</c:url>
<c:import url="${reqmap}" var="xmlResponsePreReq" charEncoding="UTF-8" />
<!-- change the & to &amp; -->
<c:set var="newresponsemap" value="${fn:replace( xmlResponsePreReq, '&' , '&amp;')}"/>
<x:transform xslt="${f:removeNamespacesXsl()}" xml="${newresponsemap}" var="prereqdoc"/>

<c:set var="test"><x:out select="$prereqdoc//*[local-name()='itemRecord']/*[local-name()='Admin']/*[local-name()='IDNumber']"/></c:set>
<c:choose>
<c:when test="${not empty test}">
<h2>Post-requisite benchmarks</h2>
<c:set var="count">0</c:set>
<ol>
<x:forEach select="$prereqdoc//*[local-name()='itemRecord']">
	<c:set var="newBmId"><x:out select="*[local-name()='Admin']/*[local-name()='IDNumber']"/></c:set>
	<c:set var="count">${count + 1}</c:set>
	
	<li><x:out select="*[local-name()='Data']/*[local-name()='Description']"/><ul>
	<c:set var="pastMapID"></c:set>
	<x:forEach select="*[local-name()='Data']/*[local-name()='InternalRelationship']/*[local-name()='CatalogID']">
			<c:set var="someid">
				<x:out select="@CatalogNumber" />
			</c:set>
			
			<c:choose>
				<c:when test="${fn:containsIgnoreCase(someid, 'STD')}">
					<c:set var="queryformapsource">
						<SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
							<Query Color="skyblue" DetailLevel="Skeleton" Format="SMS" Scope="ALL" ThirdPartyQuery="">
								<Navigational-Query>
									<ObjectID>${someid}</ObjectID>
									<Relation>
										<Is-part-of/>
									</Relation>
								</Navigational-Query>
							</Query>
						</SMS-CSIP>
					</c:set>
					<c:url value="${baseUrl}" var="reqMap">
   					 	<c:param name="Query" value="${queryformapsource}"/>
					</c:url>
					<c:import url="${reqMap}" var="xmlResponseMap" charEncoding="UTF-8" />
					<!-- change the & to &amp; -->
					<c:set var="newresponseMap" value="${fn:replace( xmlResponseMap, '&' ,'&amp;')}"/>
					<x:transform xslt="${f:removeNamespacesXsl()}" xml="${newresponseMap}" var="mapsourcedoc"/>
					<c:set var="newMapID"><x:out select="$mapsourcedoc//IDNumber" /></c:set>
					<c:set var="newMapName"><x:out select="$mapsourcedoc//Name" /></c:set>
						<c:if test="${newMapID ne pastMapID}">
							<li><a href="?bmId=${newBmId}&amp;mapId=${newMapID}&amp;mapName=${fn:replace(newMapName,' ','%20')}" title="View post-requisite benchmark ${count} from the ${newMapName} Map">From ${newMapName} Map</a></li>
						</c:if>
						<c:set var="pastMapID">${newMapID}</c:set>
					</c:when>
				</c:choose>
				
		</x:forEach>
</ul>
</li>
</x:forEach>
</ol>
</c:when>
<c:otherwise>
There are no post-requisite benchmarks
</c:otherwise>
</c:choose>

<!-- post req //-->
<h2>Educational Resources</h2>
<c:if test="${empty startingOffset}">
	<c:set var="startingOffset">0</c:set>
</c:if>
<jsp:include page="resources.jsp" flush="true">
    <jsp:param name="bmId" value="${bmId}"/>
	<jsp:param name="mapName" value="${mapName}"/>
	<jsp:param name="mapId" value="${mapId}"/>
	<jsp:param name="startingOffset" value="${startingOffset}"/>
</jsp:include>


</c:when>
<c:when test="${not empty mapId}">


<%-- Sets the default host,port and path for rest of the tags used in this page --%>

Navigation > <a href="index.jsp">Table of Contents</a>
<table border="1" summary="Benchmarks found in the ${mapName} Map organizing benchmarks by associated strands and grade ranges">
<caption><h1>${mapName} Map</h1></caption>
<thead>
<tr><th scope="col">Grade Range</td>
<x:parse var="Strands">
	<sms:StrandList upper="${mapId}"/> 
</x:parse>		
<x:forEach select="$Strands//*[local-name()='itemRecord']">
	<th scope="col"><x:out select="*[local-name()='Data']/*[local-name()='Name']"/></th>				
</x:forEach>
</tr>
</thead>
<x:parse var="Grades">
	<sms:GradeList upper="${mapId}"/> 
</x:parse>	
<x:forEach select="$Grades//*[local-name()='itemRecord']">
	<c:set var="gradeId"><x:out select="*[local-name()='Admin']/*[local-name()='IDNumber']"/></c:set>	
	<c:set var="gradeName"><x:out select="*[local-name()='Data']/*[local-name()='Name']"/></c:set>	
	<tr>
		<th scope="row">${gradeName}</th>
	<x:forEach select="$Strands//*[local-name()='itemRecord']">
		<c:set var="strandId"><x:out select="*[local-name()='Admin']/*[local-name()='IDNumber']"/></c:set>	
		<c:set var="strandName"><x:out select="*[local-name()='Data']/*[local-name()='Name']"/></c:set>	
		<c:set var="queryforbm">
			<SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			<Query Color="skyblue" DetailLevel="Skeleton" Format="SMS" Scope="Benchmark" ThirdPartyQuery="">
			<Content-Query>
				<InternalRelationships>
					<InternalRelationship Relation="Is part of" Object="${strandId}"></InternalRelationship>
					<InternalRelationship Relation="Is part of" Object="${gradeId}"></InternalRelationship>
				</InternalRelationships>
			</Content-Query>
			</Query>
			</SMS-CSIP>
		</c:set>
		<c:url value="${baseUrl}" var="req">
    		<c:param name="Query" value="${queryforbm}"/>
		</c:url>
		<c:import url="${req}" var="xmlResponse" charEncoding="UTF-8" />
		<!-- change the & to &amp; -->
		<c:set var="newresponse" value="${fn:replace( xmlResponse, '&' ,'&amp;')}"/>
		<x:transform xslt="${f:removeNamespacesXsl()}" xml="${newresponse}" var="bmdoc"/>
		<td valign="top">
			<ul>
			<x:forEach select="$bmdoc//*[local-name()='itemRecord']">
				<c:set var="bmId"><x:out select="*[local-name()='Admin']/*[local-name()='IDNumber']"/></c:set>
				<li><a href="?bmId=${bmId}&amp;mapId=${mapId}&amp;mapName=${fn:replace(mapName,' ','%20')}"><x:out select="*[local-name()='Data']/*[local-name()='Description']"/></a></li>
			</x:forEach>
			</ul>
		</td>
	</x:forEach>
	</tr>	
</x:forEach>
</table>

</c:when>
<c:otherwise>
<%@ include file="header.jsp" %>
<h1>Knowledge Progression Maps </h1>
<h2>Table of Contents</h2>
<x:parse var="ChapterResponseXML">
	<sms:ChapterList/>
</x:parse>
<x:transform xslt="${f:removeNamespacesXsl()}" xml="${ChapterResponseXML}" var="chpdoc"/>

<x:forEach select="$chpdoc//itemRecord">
	<c:set var="chapterId"><x:out select="Admin/IDNumber"/></c:set>
	<c:set var="chapterName"><x:out select="Data/Name"/></c:set>
	<ul><li>${chapterName}
	
	<x:parse var="Cluster">
		<sms:ClusterList upper="${chapterId}"/> 
	</x:parse>
	<x:forEach select="$Cluster//*[local-name()='itemRecord']">
		<c:set var="clusterId"><x:out select="*[local-name()='Admin']/*[local-name()='IDNumber']"/></c:set>
		<x:parse var="Maps">
			<sms:MapList upper="${clusterId}"/> 
		</x:parse>
		<x:forEach select="$Maps//*[local-name()='itemRecord']">
			<c:set var="mapId"><x:out select="*[local-name()='Admin']/*[local-name()='IDNumber']"/></c:set>
			<c:set var="mapName"><x:out select="*[local-name()='Data']/*[local-name()='Name']"/></c:set>
			<ul><li><a href="?mapId=${mapId}&amp;mapName=${fn:replace(mapName,' ','%20')}"><x:out select="*[local-name()='Data']/*[local-name()='Name']"/></a></li></ul>										
		</x:forEach>									
	</x:forEach>
	</li></ul>
</x:forEach>
</c:otherwise>
</c:choose>
<%@ include file="footer.jsp" %>