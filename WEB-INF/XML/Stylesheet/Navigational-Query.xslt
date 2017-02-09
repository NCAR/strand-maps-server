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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:c="http://sms.dlese.org">
	<xsl:output method="text" version="1.0" encoding="UTF-8" indent="yes"/>

<xsl:variable name="OID">
	'<xsl:value-of select="normalize-space(//c:ObjectID)"/>'
</xsl:variable> 

<xsl:template name="content-query" match="c:Navigational-Query">

		<xsl:choose>
			<xsl:when test="$isAll = 'true'">where O.object_id in ( select O.object_id from objects O, relation R where </xsl:when>
			<xsl:otherwise>and</xsl:otherwise>
		</xsl:choose>
	

	( <xsl:apply-templates/> )

		
)

	<!--xsl:choose>
		<xsl:when test="$isAll = 'true'">and</xsl:when>
		<xsl:otherwise>)</xsl:otherwise>
	</xsl:choose -->
	<xsl:choose>
		<xsl:when test="$isAll = 'true'"></xsl:when>
		<xsl:otherwise>)</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<xsl:template match="c:Prerequisite" name="Prerequisite">

R.itemid2 =  <xsl:value-of select="$OID"/>  and R.relationtype='Contributes to achieving' and R.itemid1=O.object_id

</xsl:template>

<xsl:template match="c:Post-Requisite" name="Post-Requisite">

R.itemid1 =  <xsl:value-of select="$OID"/>  and R.relationtype='Contributes to achieving' and R.itemid2=O.object_id

</xsl:template>

<xsl:template match="c:Is-part-of">
	<xsl:call-template name="directRelation">
		<xsl:with-param name="relation" select="'Is part of'"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="c:Is-closely-related-to">
	<xsl:call-template name="directRelation">
		<xsl:with-param name="relation" select="'Is closely related to'"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="c:Is-similar-to">
	<xsl:call-template name="directRelation">
		<xsl:with-param name="relation" select="'Is similar to'"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="c:Contributes-to-achieving">
	<xsl:call-template name="directRelation">
		<xsl:with-param name="relation" select="'Contributes to achieving'"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="c:References">
	<xsl:call-template name="directRelation">
		<xsl:with-param name="relation" select="'References'"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="c:Is-associated-with">
	<xsl:call-template name="directRelation">
		<xsl:with-param name="relation" select="'Is associated with'"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="c:Is-referenced-by">
	<xsl:call-template name="directRelation">
		<xsl:with-param name="relation" select="'Is referenced by'"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="c:Supports">
	<xsl:call-template name="directRelation">
		<xsl:with-param name="relation" select="'Supports'"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="c:Contributes-to-and-relies-upon">
	<xsl:call-template name="directRelation">
		<xsl:with-param name="relation" select="'Contributes to and relies upon'"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="c:Needs-or-require">
	<xsl:call-template name="directRelation">
		<xsl:with-param name="relation" select="'Needs or require'"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="c:Contains">

(R.itemid2=<xsl:value-of select="$OID"/> and R.relationtype = 'Is part of' and  R.itemid1=O.object_id)

</xsl:template>


<xsl:template match="c:Neighbor">

	<xsl:call-template name="Prerequisite"/> or <xsl:call-template name="Post-Requisite"/> or
	(R.itemid1=<xsl:value-of select="$OID"/> and R.relationtype &lt;&gt; 'Is part of' and R.relationtype &lt;&gt; 'Contains' and R.itemid2=O.object_id) or
	(R.itemid2=<xsl:value-of select="$OID"/> and R.relationtype &lt;&gt; 'Is part of' and R.relationtype &lt;&gt; 'Contains' and R.itemid1=O.object_id) 

</xsl:template>

<xsl:template name="directRelation">
	<xsl:param name="relation"/>

 R.itemid1 = <xsl:value-of select="$OID"/> and R.relationType='<xsl:value-of select="$relation"/>' and R.itemid2=O.object_id

</xsl:template>


<xsl:template match="c:Any" name="Any">
	R.itemid1=<xsl:value-of select="$OID"/> and  R.itemid2=O.object_id
</xsl:template>

</xsl:stylesheet>
