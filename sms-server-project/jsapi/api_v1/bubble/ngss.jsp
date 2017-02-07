<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="../../TagLibIncludes.jsp" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="org.dlsciences.ngss.ngssAlignments" %>
<%@ page import="org.dlsciences.ngss.ngssAlignmentItem" %>

<%-- Grab the required service URLs (defined in web.xml or server.xml): --%>
<c:set var="httpUserAgentJavaScriptAPI" value="${initParam.httpUserAgentJavaScriptAPI}" />
		
<%

String ngss = request.getParameter("ngss");
%>



<c:set var="ngss" value="<%=ngss%>"/>

<%
// try a scriptlet
String ngss_id = new String();
List<String> ngssIdList = new ArrayList<String>();
HashMap<String,HashMap<String,List<ngssAlignmentItem>>> ngssAlignmentHash = new HashMap<String,HashMap<String,List<ngssAlignmentItem>>>();

%>	

<c:forTokens var="id" items="${ngss}" delims="|">
	<c:set var="ngss_id">http://asn.jesandco.org/resources/<c:out value="${id}"/></c:set>
	<%
		ngss_id = pageContext.getAttribute("ngss_id").toString();
		ngssIdList.add(ngss_id);
	%>
</c:forTokens>
	<%
		ngssAlignments ngssIds = new ngssAlignments(ngssIdList);
		ngssAlignmentHash = ngssIds.getNgssAlignmentsHash();
	%>
	
<c:set var="ngssResults">

<c:set var="sep" value=""/>
<c:set var="dci" value=""/>
<c:set var="cc" value=""/>

<c:set var="ngssHash" value="<%=ngssAlignmentHash%>"/>
<c:set var="alignment_counter" value="0"/>
<c:forEach var="type" items="${ngssHash}">
	<c:set var="sectionTitle" value="${type.key}"/>
	<c:choose>
		<c:when test="${sectionTitle eq 'Science and Engineering Practices'}">
			<c:set var="peLabel" value="practice"/>
			<c:set var="peExplanation" value="Practices describe behaviors that scientists engage in as they investigate and build models and theories about the natural world and the key set of engineering practices that engineers use as they design and build models and systems."/>
			<c:set var="sep">
			<div class="sep_container full_container">
			<h2><c:out value="${sectionTitle}"/> <img src="@GLOBAL_CONTEXT_URL@/jsapi/api_v1/strand_selector/images/question.gif" alt="${peExplanation}" title="${peExplanation}"/> </h2>
			<div class="ngss_inner_container">
			
			<c:forEach var="parent_type" items="${type.value}">
				<c:set var="parentText" value="${parent_type.key}"/>
				<c:set var="ngss_list" value="${parent_type.value}"/>
				<c:set var="aryLen" value="${fn:length(ngss_list)}"/>
				
				<c:set var="item_counter" value="1"/>
				<ul>
				<li><c:out value="${parentText}"/>
				<ul>
					<c:forEach var="ngss_item" items="${ngss_list}">
					
					<li><strong>
						${ngss_item.ngssText}
					</strong></li>
				
				
				
					<button id="pe_toggle_${alignment_counter}" class="pe_toggle pe_toggle_closed">Show Performance Expectation(s)</button>
					
					<script type="text/javascript">
					$('pe_toggle_${alignment_counter}').observe( 'click', function(e){
						doTogglePE('pe_toggle_${alignment_counter}');
					});
					$('pe_toggle_${alignment_counter}').observe( 'touchstart', function(e){
						doTogglePE('pe_toggle_${alignment_counter}');
					});
					</script>
					<div class="peContainer hide" id="pe_container_${alignment_counter}">
					<p>The above ${peLabel} supports the following NGSS Performance Expectation(s):</p>
					<ul>
					<c:forEach var="ngss_pe" items="${ngss_item.peHash}">	
						<li><strong>${ngss_pe.key}</strong>: ${ngss_pe.value}</li>
					</c:forEach>
					</ul>
					
					</div>
			
					<hr />
					
					<c:set var="alignment_counter" value="${alignment_counter + 1}"/>
					
					<c:set var="item_counter" value="${item_counter + 1}"/>
				</c:forEach>
				</ul>
				</li></ul>
			
			
			
			</c:forEach>
			
				</div>
			</div>
			
			</c:set>
		</c:when>
		<c:when test="${sectionTitle eq 'Disciplinary Core Ideas'}">
			<c:set var="peExplanation" value="Disciplinary core ideas have the power to focus K-12 science curriculum, instruction and assessments on the most important aspects of science. Disciplinary ideas are grouped in four domains: the physical sciences; the life sciences; the earth and space sciences; and engineering, technology and applications of science."/>
			<c:set var="peLabel" value="core idea"/>
			<c:set var="dci">
			<div class="dci_container full_container">
			<h2><c:out value="${sectionTitle}"/> <img src="@GLOBAL_CONTEXT_URL@/jsapi/api_v1/strand_selector/images/question.gif" alt="${peExplanation}" title="${peExplanation}"/> </h2>
			<div class="ngss_inner_container">
			
			<c:forEach var="parent_type" items="${type.value}">
				<c:set var="parentText" value="${parent_type.key}"/>
				<c:set var="ngss_list" value="${parent_type.value}"/>
				<c:set var="aryLen" value="${fn:length(ngss_list)}"/>
				
				<c:set var="item_counter" value="1"/>
				<ul>
				<li><c:out value="${parentText}"/>
				<ul>
					<c:forEach var="ngss_item" items="${ngss_list}">
					
					<li><strong>
						${ngss_item.ngssText}
					</strong></li>
				
				
				
					<button id="pe_toggle_${alignment_counter}" class="pe_toggle pe_toggle_closed">Show Performance Expectation(s)</button>
					
					<script type="text/javascript">
					$('pe_toggle_${alignment_counter}').observe( 'click', function(e){
						doTogglePE('pe_toggle_${alignment_counter}');
					});
					$('pe_toggle_${alignment_counter}').observe( 'touchstart', function(e){
						doTogglePE('pe_toggle_${alignment_counter}');
					});
					</script>
					<div class="peContainer hide" id="pe_container_${alignment_counter}">
					<p>The above ${peLabel} supports the following NGSS Performance Expectation(s):</p>
					<ul>
					<c:forEach var="ngss_pe" items="${ngss_item.peHash}">	
						<li><strong>${ngss_pe.key}</strong>: ${ngss_pe.value}</li>
					</c:forEach>
					</ul>
					
					</div>
			
					<c:if test="${item_counter < aryLen}">
					<hr />
					</c:if>
					<c:set var="alignment_counter" value="${alignment_counter + 1}"/>
					
					<c:set var="item_counter" value="${item_counter + 1}"/>
				</c:forEach>
				</ul>
				</li></ul>
			
			
			
			</c:forEach>
			
				</div>
			</div>
			</c:set>
		</c:when>
		<c:when test="${sectionTitle eq 'Crosscutting Concepts'}">
			<c:set var="peExplanation" value="Crosscutting concepts have application across all domains of science. As such, they are a way of linking the different domains of science."/>
			<c:set var="peLabel" value="crosscutting concept"/>
			<c:set var="cc">
			<div class="cc_container full_container">
			<h2><c:out value="${sectionTitle}"/> <img src="@GLOBAL_CONTEXT_URL@/jsapi/api_v1/strand_selector/images/question.gif" alt="${peExplanation}" title="${peExplanation}"/> </h2>
			<div class="ngss_inner_container">
			
			<c:forEach var="parent_type" items="${type.value}">
				<c:set var="parentText" value="${parent_type.key}"/>
				<c:set var="ngss_list" value="${parent_type.value}"/>
				<c:set var="aryLen" value="${fn:length(ngss_list)}"/>
				
				<c:set var="item_counter" value="1"/>
				<ul>
				<li><c:out value="${parentText}"/>
				<ul>
					<c:forEach var="ngss_item" items="${ngss_list}">
					
					<li><strong>
						${ngss_item.ngssText}
					</strong></li>
				
				
				
					<button id="pe_toggle_${alignment_counter}" class="pe_toggle pe_toggle_closed">Show Performance Expectation(s)</button>
					
					<script type="text/javascript">
					$('pe_toggle_${alignment_counter}').observe( 'click', function(e){
						doTogglePE('pe_toggle_${alignment_counter}');
					});
					$('pe_toggle_${alignment_counter}').observe( 'touchstart', function(e){
						doTogglePE('pe_toggle_${alignment_counter}');
					});
					</script>
					<div class="peContainer hide" id="pe_container_${alignment_counter}">
					<p>The above ${peLabel} supports the following NGSS Performance Expectation(s):</p>
					<ul>
					<c:forEach var="ngss_pe" items="${ngss_item.peHash}">	
						<li><strong>${ngss_pe.key}</strong>: ${ngss_pe.value}</li>
					</c:forEach>
					</ul>
					
					</div>
			
					<c:if test="${item_counter < aryLen}">
					<hr />
					</c:if>
					<c:set var="alignment_counter" value="${alignment_counter + 1}"/>
					
					<c:set var="item_counter" value="${item_counter + 1}"/>
				</c:forEach>
				</ul>
				</li></ul>
			
			
			
			</c:forEach>
			
				</div>
			</div>
			
			</c:set>
		</c:when>
	</c:choose>
	
	
</c:forEach>
<p>These <a href="http://www.nextgenscience.org/">Next Generation Science Standards (NGSS)</a> correspond to this Benchmark.  Note that some may appear very similar but are actually associated with different performance expectations.</p>
<c:out value="${sep}" escapeXml="false"/>
<c:out value="${dci}" escapeXml="false"/>
<c:out value="${cc}" escapeXml="false"/>
</c:set>
	
	displayNGSS(
	<json:object prettyPrint="true" escapeXml="false">
	 	<json:property name="ngssRes" value="${ngssResults}"/>
		<json:property name="displaytype" value="${displaytype}"/>
	</json:object>
)