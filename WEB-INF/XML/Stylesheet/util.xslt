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
	
	<xsl:template name="makeRelationVariables">

			<xsl:if test="//c:Navigational-Query">
				,relation R
			</xsl:if>

			<xsl:if test="boolean(.//c:InternalRelationship)">
				<xsl:for-each select=".//c:InternalRelationship">
					,relation R<xsl:value-of select="position()"/> 
				</xsl:for-each>
			</xsl:if>

<!--	
			<xsl:if test="boolean(//c:ResourceRelationship)">
				<xsl:for-each select=".//c:ResourceRelationship">
					,ResourceRelation Re<xsl:value-of select="position()+count(.//c:InternalRelationship)"/>
				</xsl:for-each>
			</xsl:if>
	

			<xsl:if test="boolean(.//c:StandardRelationship)">
				<xsl:for-each select=".//c:StandardRelationship">
					,StandardRelation S<xsl:value-of select="position()+count(.//c:InternalRelationship)+count(.//c:ResourceRelationship)"/>
				</xsl:for-each>
			</xsl:if>
-->			
	</xsl:template>

	<xsl:template name="fixGrades">
		<xsl:param name="head"/>
		<xsl:param name="list"/>
		
		<xsl:variable name="dupCheck">
			<xsl:choose>
				<xsl:when test="$head = 'K' or $head = '1' or $head = '2' "><xsl:value-of select="contains($list,'K') or contains($list,'1') or contains($list,'2')"/></xsl:when>
				<xsl:when test="$head = '3' or $head = '4' or $head = '5' "><xsl:value-of select="contains($list,'3') or contains($list,'4') or contains($list,'5')"/></xsl:when>
				<xsl:when test="$head = '6' or $head = '7' or $head = '8' "><xsl:value-of select="contains($list,'6') or contains($list,'7') or contains($list,'8')"/></xsl:when>
				<xsl:when test="$head = '9' or $head = '10' or $head = '11' or $head = '12' "><xsl:value-of select="contains($list,'9') or contains($list,'10') or contains($list,'11') or contains($list,'12')"/></xsl:when>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:if test="$dupCheck = 'false' ">
			<xsl:variable name="grade">
				<xsl:choose>
					<xsl:when test="$head = 'K' or $head = '1' or $head = '2' ">'K-2'</xsl:when>
					<xsl:when test="$head = '3' or $head = '4' or $head = '5' ">'3-5'</xsl:when>
					<xsl:when test="$head = '6' or $head = '7' or $head = '8' ">'6-8'</xsl:when>
					<xsl:when test="$head = '9' or $head = '10' or $head = '11' or $head = '12' ">'9-12'</xsl:when>
					<xsl:otherwise>K-12</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
		
			( O.primary_grade = <xsl:value-of select="$grade"/> )

			<xsl:if test="$list != ''">
			and
			</xsl:if>


		</xsl:if>
		
		<xsl:if test="$list != ''">
			<xsl:call-template name="fixGrades">
				<xsl:with-param name="head" select="substring-before($list,'+')"/>
				<xsl:with-param name="list" select="substring-after($list,'+')"/>
			</xsl:call-template>
		</xsl:if>
		
	</xsl:template>


	<xsl:template name="makeList">
		<xsl:param name="deLimit"/>
		<xsl:param name="nodes"/>
		<xsl:param name="last"/>
		
		<xsl:for-each select="$nodes">
			<xsl:value-of select="."/>
			<xsl:if test="position() != last() or $last='true' ">
				<xsl:value-of select="$deLimit"/>
			</xsl:if>	
		</xsl:for-each>
	</xsl:template>
	

	<xsl:template name="insert">
		<xsl:param name="value"/>
		<xsl:param name="deLimit"/>
		<xsl:param name="in"/>
		
		<xsl:variable name="head" select="substring-before($value,$deLimit)"/>

		<xsl:variable name="tail" select="substring-after($value,$deLimit)"/>
	
		<xsl:if test="$tail = ''">
			'<xsl:value-of select="$value"/>'
		</xsl:if>
		
		<xsl:if test="$tail != ''">
			'<xsl:value-of select="$head"/>'<xsl:value-of select="$in"/>
			<xsl:call-template name="insert">
				<xsl:with-param name="value" select="$tail"/>
				<xsl:with-param name="deLimit" select="$deLimit"/>
				<xsl:with-param name="in" select="$in"/>
			</xsl:call-template>
		</xsl:if>
		
	</xsl:template>

</xsl:stylesheet>
