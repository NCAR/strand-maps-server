<%@ include file="/jsapi/TagLibIncludes.jsp" %>

<%-- 
Parameters:
	id - A map ID
	bm - a benchmark ID (optional)
	startingOffset - start of search results (optional)
	--%>

<div id="printBodyDiv">
	<div id="printLoadMsg" style="height: 50px;">
		<img src="@GLOBAL_CONTEXT_URL@/jsapi/api_v1/interactive_map/images/spinner.gif"/> &nbsp;Preparing page for print...
	</div>
	<div id="printContent" style="display:none">
		<c:url value="" var="printReturnUrl">
			<c:if test="${not empty param.id}">
				<c:param name="id" value="${param.id}"/>	
			</c:if>
			<c:if test="${not empty param.bm}">
				<c:param name="bm" value="${param.bm}"/>	
			</c:if>
			<c:if test="${not empty param.parentmap}">
				<c:param name="parentmap" value="${param.parentmap}"/>	
			</c:if>
		</c:url>
		
		<div class="hideOnPrint">
			<form>
				<input title="Back to the interactive map" type="button" value="Back to Map" onclick="window.location='${f:jsEncode(printReturnUrl)}'" style="cursor:pointer"/>
				<input title="Open a PDF of the map image" type="button" value="PDF of Map" id="mapPdfButton" style="cursor:pointer"/>
				<input title="Print the map and related information" type="button" value="Print" onclick="performPrint()" style="cursor:pointer"/>
			</form>
		</div>		
		
		<c:set var="tPos">
			<c:if test="${not empty param.id && !fn:contains(param.id,'BMK')}">
				position: absolute; top:0; 
			</c:if>
		</c:set>
		
		<div style="position: relative; padding:0; margin:0;">
			<div style="${tPos} z-index: 5; background: #ffffff; padding-left: 4; padding-bottom:2;">
				<div id="printViewHeading" class="pvHeading"></div>
				<%-- <div id="printReturnLink">
					<a href="${printReturnUrl}" style="font-size: 10px">Return to interactive map</a>
				</div> --%>		
			</div>
			<img id="mapImg" src="" style="position: relative; top:0"/>
		</div>
				
		<%-- Full benchmark text/display gets injected via JavaScript: --%>
		<div id="benchmarkText"></div>
		
		<%-- Aligned NSDL Resources text/display gets injected via JavaScript: --%>
		<div id="nsdlAlignedText"></div>		
		
		<%-- Related NSDL Resources text/display gets injected via JavaScript: --%>
		<div id="nsdlRelatedText"></div>	
		
		<%-- NGSS text/display gets injected via JavaScript: --%>
		<div id="ngssText"></div>	
		
		<%-- AAAS Assesments text/display gets injected via JavaScript: --%>
		<div id="aaasAssessmentText"></div>	
		
		
		<%-- AAAS Misconception text/display gets injected via JavaScript: --%>
		<div id="aaasMisconceptionText"></div>	
		
		<div style="padding-bottom:10; padding-top:20;">
			<div id="customPrintContent"></div>
		</div>
		
		<c:if test="${not empty param.bm}">	
			<c:if test="${param.bm != param.id}">
				<div style="padding-top:25">
					<div class="pvHeading">Related Benchmarks</div>
					<img id="relatedBenchmarkImg" src="" />
				</div>
			</c:if>
		</c:if>
		
		<%-- Student misconceptions text/display gets injected via JavaScript: --%>
		<div id="misconceptionsText"></div>		
	</div>
</div>


