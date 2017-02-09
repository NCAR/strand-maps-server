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
 
 query:
 SELECT * FROM objects O INNER JOIN  relation R0 ON ( R0.ItemID1 = O.object_ID ) LEFT OUTER JOIN smstoasn SA ON (SA.SMS_ID=O.object_ID) WHERE O.object_id in (SELECT SMS_ID FROM smstoasn SA WHERE SA.asn_ID='S2366295');
 <SMS-CSIP xmlns="http://sms.dlese.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<Query Color="skyblue" DetailLevel="Skeleton" Format="SMS" Scope="ALL" ThirdPartyQuery="">
		<ASNLookup-Query>
			<ObjectID>SMS-STD-0036</ObjectID>
		</ASNLookup-Query>
	</Query>
</SMS-CSIP>
 
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:c="http://sms.dlese.org">
	<xsl:output method="text" version="1.0" encoding="UTF-8" indent="yes"/>
<xsl:variable name="OID">
	'<xsl:call-template name="removeASNURL">
		<xsl:with-param name="ASNIDString">
			<xsl:value-of select="normalize-space(//c:ASNID)"/>
		</xsl:with-param>
	</xsl:call-template>'
</xsl:variable> 



<xsl:template name="content-query" match="c:ASNLookup-Query">
	where O.object_id in ( select SA.SMS_ID from smstoasn SA where SA.asn_ID=<xsl:value-of select="$OID"/>)
</xsl:template>



<xsl:template name="removeASNURL">
	<xsl:param name="ASNIDString"/>
    <xsl:choose>
		<xsl:when test="contains($ASNIDString, 'http://asn.jesandco.org/resources/')">
			<xsl:value-of select="substring($ASNIDString,35)"/>
		</xsl:when>
		<xsl:when test="contains($ASNIDString, 'http://purl.org/asn/resources/')">
			<xsl:value-of select="substring($ASNIDString,31)"/>
		</xsl:when>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
