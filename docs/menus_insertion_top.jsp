<%-- 
	Include this page at the top of the <body> content in the JSP page.
	Inserts the necessary HTML, CSS and JavaScript to generate the menus.
	Menus are defined in the file 'documentation_menu.opml'. --%>
<%@ include file="/docs/TagLibIncludes.jsp" %> 

<link rel="shortcut icon" href="/favicon.ico?v=4" type="image/x-icon"/>
<LINK REL="stylesheet" TYPE="text/css" HREF="<c:url value='/docs/documentation_styles.css'/>">
<LINK REL="stylesheet" TYPE="text/css" HREF="<c:url value='/docs/tree_menu_styles.css'/>">
<LINK REL="stylesheet" TYPE="text/css" media="print" HREF="<c:url value='/docs/tree_menu_styles_print.css'/>">	
<table class="dlese_treeMenuTable"><tr>
	<td class="dlese_treeMenuTableCellMenu" valign="top">
		<%@ page import="org.dlese.dpc.gui.OPMLtoHTMLTreeMenu" %>
		<c:url var="menuOPML" value="/docs/documentation_menu.opml"/>
		<%= OPMLtoHTMLTreeMenu.getMenuHTML(
			(String)pageContext.getAttribute("menuOPML"), request ) %>
	</td>
	<td class="dlese_treeMenuTableCellText">
	<div style="margin-left:10px; margin-bottom:5px">
		<a href="<c:url value='/docs/index.jsp'/>"><img src="<c:url value='/docs/sms-logo.gif'/>" width="96" height="56" border="0" alt="Strand Map Service" /></a>
	</div>