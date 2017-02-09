<?xml version="1.0" encoding="UTF-8"?>
<!-- 
 Copyright 2002-2005 Boulder Learning Technologies Lab & American Association for the Advancement of Science, 
 DLC-1B20, Department of Computer Science, University of Colorado at Boulder,
 CO-80309, Tel: 303-492-0916, email: fahmad@colorado.edu
 
 This file is part of the Concept Map Service Software Project.
 
 The Concept Map Service Project is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public License as
 published by the Free Software Foundation; either version 2 of the
 License, or (at your option) any later version.
 
 The Concept Map Service OAI Project is distributed in the hope that it will be
 useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with The Concept Map Service System; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
 USA
 
 Author: Faisal Ahmad
 Date  : Sept 14, 2005
 email : fahmad@colorado.edu
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:csip="http://sms.dlese.org">

<!-- Imports -->
<xsl:import href="util.xslt"/>
<xsl:import href="AttributeProcessing.xslt"/>
<xsl:import href="Content-Query.xslt"/>
<xsl:import href="Navigational-Query.xslt"/>
<xsl:import href="ASNLookup-Query.xslt"/>

<!-- Output and processing settings-->
<xsl:output method="text" version="1.0" encoding="UTF-8" indent="yes"/>
<xsl:strip-space elements="*"/>

<!-- Global variable declerations -->
<xsl:variable name="isAll">
	<xsl:choose>
		<xsl:when test="//csip:Query/@Scope='ALL'">
			<xsl:value-of select="true()"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="false()"/>
		</xsl:otherwise> 
	</xsl:choose>
</xsl:variable>

<xsl:template name="query" match="csip:Query">

	<xsl:variable name="SQL">  
		SELECT * FROM objects O INNER JOIN  relation R0 ON ( R0.ItemID1 = O.object_ID ) LEFT OUTER JOIN smstoasn SA ON (SA.SMS_ID=O.object_ID) <!-- <xsl:call-template name="makeRelationVariables"/> -->

		
		<xsl:if test="$isAll != 'true'">
			WHERE O.object_id in ( SELECT O.object_id FROM objects O
			<xsl:call-template name="makeRelationVariables"/> WHERE (
			( <xsl:call-template name="ProcessScope">
				<xsl:with-param name="rest" select="concat(./@Scope,'+')"/>
			</xsl:call-template> ) 
		</xsl:if>
		
		<xsl:apply-templates/>




	</xsl:variable> 


	<xsl:value-of select="normalize-space($SQL)"/>

<!--
	<xsl:value-of select="$SQL"/>
-->
	
</xsl:template>

		
</xsl:stylesheet>
