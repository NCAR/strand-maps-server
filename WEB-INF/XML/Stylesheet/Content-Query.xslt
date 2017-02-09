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
 
 ideal query to retrieve appropriate benchmark given the asn id
 SELECT * FROM objects O INNER JOIN  relation R0 ON ( R0.ItemID1 = O.object_ID ) LEFT OUTER JOIN smstoasn SA ON (SA.SMS_ID=O.object_ID) WHERE O.object_id in (SELECT SMS_ID FROM smstoasn SA WHERE SA.asn_ID='S2366295'); 
 
 
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:c="http://sms.dlese.org">
	<xsl:output method="text" version="1.0" encoding="UTF-8" indent="yes"/>

<xsl:template name="content-query" match="c:Content-Query">

	<xsl:if test="boolean(./*)">
		<xsl:choose>
			<xsl:when test="$isAll = 'true'">WHERE O.object_id in ( SELECT O.object_id FROM objects O<xsl:call-template name="makeRelationVariables"/> WHERE (</xsl:when>
			<xsl:otherwise>and</xsl:otherwise>
		</xsl:choose>
	
		( <xsl:apply-templates/> )
	
<!--		<xsl:if test="$isAll = 'true'"> )  )</xsl:if> 		
		<xsl:if test="$isAll != 'true' ">) </xsl:if>  -->
		) )
		
	<!--	AND -->
		
	</xsl:if>
		
	<xsl:if test="$isAll = 'true' and boolean(./*)=false()"> WHERE </xsl:if>
	<xsl:if test="$isAll != 'true' and boolean(./*)=false()"> )  )</xsl:if>
		
</xsl:template>


<xsl:template match="c:Name">
	<xsl:param name="object"/>

	<xsl:variable name="matchType">
		<xsl:choose>
			<xsl:when test="@MatchType">
				<xsl:value-of select="normalize-space(@MatchType)"/>
			</xsl:when>
			<xsl:otherwise>Equals</xsl:otherwise>
		</xsl:choose>
	</xsl:variable> 
	
	<xsl:choose>

		<xsl:when test="$object = ''">O.<xsl:value-of select="local-name()"/>

		<xsl:choose>
			<xsl:when test="$matchType='Equals'"> = </xsl:when>
			<xsl:otherwise> REGEXP </xsl:otherwise>
		</xsl:choose>

 		 <xsl:choose>
				<xsl:when test="$matchType='Equals' or $matchType='Contains-phrase'">
					'<xsl:value-of select="normalize-space(.)"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-any-word'">
					'<xsl:value-of select="translate(normalize-space(.),' ','|')"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-all-words'">
						
					<xsl:call-template name="insert">
						<xsl:with-param name="value" select="normalize-space(.)"/>
						<xsl:with-param name="deLimit" select="' '"/>
						<xsl:with-param name="in" select=" concat(' and O.',local-name(),' REGEXP ')"/>
					</xsl:call-template>
					
				</xsl:when>
				
		</xsl:choose>
		
 		 </xsl:when>

		<xsl:otherwise>

			<xsl:value-of select="$object"/>.<xsl:value-of select="local-name()"/>


			<xsl:choose>
				<xsl:when test="$matchType='Equals'"> = </xsl:when>
				<xsl:otherwise> REGEXP </xsl:otherwise>
			</xsl:choose>

 		 <xsl:choose>
				<xsl:when test="$matchType='Equals' or $matchType='Contains-phrase'">
					'<xsl:value-of select="normalize-space(.)"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-any-word'">
					'<xsl:value-of select="translate(normalize-space(.),' ','|')"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-all-words'">
						
					<xsl:call-template name="insert">
						<xsl:with-param name="value" select="normalize-space(.)"/>
						<xsl:with-param name="deLimit" select="' '"/>
						<xsl:with-param name="in" select=" concat(' and O.',local-name(),' REGEXP ')"/>
					</xsl:call-template>
					
				</xsl:when>
				
		</xsl:choose>
			 
			 </xsl:otherwise>

	</xsl:choose>

</xsl:template>



<xsl:template match="c:Source">
	<xsl:param name="object"/>
	
	<xsl:variable name="matchType">
		<xsl:choose>
			<xsl:when test="@MatchType">
				<xsl:value-of select="normalize-space(@MatchType)"/>
			</xsl:when>
			<xsl:otherwise>Equals</xsl:otherwise>
		</xsl:choose>
	</xsl:variable> 

	<xsl:choose>
		<xsl:when test="$object = ''">O.<xsl:value-of select="local-name()"/>

		<xsl:choose>
			<xsl:when test="$matchType='Equals'"> = </xsl:when>
			<xsl:otherwise> REGEXP </xsl:otherwise>
		</xsl:choose>

 		 <xsl:choose>
				<xsl:when test="$matchType='Equals' or $matchType='Contains-phrase'">
					'<xsl:value-of select="normalize-space(.)"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-any-word'">
					'<xsl:value-of select="translate(normalize-space(.),' ','|')"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-all-words'">
						
					<xsl:call-template name="insert">
						<xsl:with-param name="value" select="normalize-space(.)"/>
						<xsl:with-param name="deLimit" select="' '"/>
						<xsl:with-param name="in" select=" concat(' and O.',local-name(),' REGEXP ')"/>
					</xsl:call-template>
					
				</xsl:when>
				
		</xsl:choose>
		 
		 </xsl:when>
		 
		 
		<xsl:otherwise><xsl:value-of select="$object"/>.<xsl:value-of select="local-name()"/>
		<xsl:choose>
			<xsl:when test="$matchType='Equals'"> = </xsl:when>
			<xsl:otherwise> REGEXP </xsl:otherwise>
		</xsl:choose>

 		 <xsl:choose>
				<xsl:when test="$matchType='Equals' or $matchType='Contains-phrase'">
					'<xsl:value-of select="normalize-space(.)"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-any-word'">
					'<xsl:value-of select="translate(normalize-space(.),' ','|')"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-all-words'">
						
					<xsl:call-template name="insert">
						<xsl:with-param name="value" select="normalize-space(.)"/>
						<xsl:with-param name="deLimit" select="' '"/>
						<xsl:with-param name="in" select=" concat(' and O.',local-name(),' REGEXP ')"/>
					</xsl:call-template>
					
				</xsl:when>
				
		</xsl:choose>
		 </xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!--
<xsl:template match="c:ObjectType">
	<xsl:param name="object"/>
	<xsl:param name="not"/>

	<xsl:choose>
		<xsl:when test="$object = ''">O.object_type
		 	<xsl:choose>
				<xsl:when test="$not">&lt;&gt;</xsl:when>
				<xsl:otherwise>=</xsl:otherwise>
			</xsl:choose>
		 '<xsl:value-of select="."/>'</xsl:when>
		<xsl:otherwise><xsl:value-of select="$object"/>.object_type
		 	<xsl:choose>
				<xsl:when test="$not">&lt;&gt;</xsl:when>
				<xsl:otherwise>=</xsl:otherwise>
			</xsl:choose>
		 '<xsl:value-of select="."/>'</xsl:otherwise>
	</xsl:choose>
</xsl:template>

-->

<xsl:template match="c:AAASCode">
	<xsl:param name="object"/>
	
	<xsl:variable name="matchType">
		<xsl:choose>
			<xsl:when test="@MatchType">
				<xsl:value-of select="normalize-space(@MatchType)"/>
			</xsl:when>
			<xsl:otherwise>Equals</xsl:otherwise>
		</xsl:choose>
	</xsl:variable> 

	<xsl:choose>
		<xsl:when test="$object = ''">O.aaas_code

					<xsl:choose>
						<xsl:when test="$matchType='Equals'"> = </xsl:when>
						<xsl:otherwise> REGEXP </xsl:otherwise>
					</xsl:choose>

 		 <xsl:choose>
				<xsl:when test="$matchType='Equals' or $matchType='Contains-phrase'">
					'<xsl:value-of select="normalize-space(.)"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-any-word'">
					'<xsl:value-of select="translate(normalize-space(.),' ','|')"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-all-words'">
						
					<xsl:call-template name="insert">
						<xsl:with-param name="value" select="normalize-space(.)"/>
						<xsl:with-param name="deLimit" select="' '"/>
						<xsl:with-param name="in" select="' and O.aaas_code REGEXP '"/>
					</xsl:call-template>
					
				</xsl:when>
				
		</xsl:choose>
		 
		 </xsl:when>
		
		<xsl:otherwise><xsl:value-of select="$object"/>.aaas_code
					<xsl:choose>
						<xsl:when test="$matchType='Equals'"> = </xsl:when>
						<xsl:otherwise> REGEXP </xsl:otherwise>
					</xsl:choose>

 		 <xsl:choose>
				<xsl:when test="$matchType='Equals' or $matchType='Contains-phrase'">
					'<xsl:value-of select="normalize-space(.)"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-any-word'">
					'<xsl:value-of select="translate(normalize-space(.),' ','|')"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-all-words'">
						
					<xsl:call-template name="insert">
						<xsl:with-param name="value" select="normalize-space(.)"/>
						<xsl:with-param name="deLimit" select="' '"/>
						<xsl:with-param name="in" select="' and O.aaas_code REGEXP '"/>
					</xsl:call-template>
					
				</xsl:when>
				
		</xsl:choose>
		 </xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="c:Description">
	<xsl:param name="object"/>
	
	<xsl:variable name="matchType">
		<xsl:choose>
			<xsl:when test="@MatchType">
				<xsl:value-of select="normalize-space(@MatchType)"/>
			</xsl:when>
			<xsl:otherwise>Equals</xsl:otherwise>
		</xsl:choose>
	</xsl:variable> 

	<xsl:choose>
		<xsl:when test="$object = ''">O.<xsl:value-of select="local-name()"/>

					<xsl:choose>
						<xsl:when test="$matchType='Equals'"> = </xsl:when>
						<xsl:otherwise> REGEXP </xsl:otherwise>
					</xsl:choose>

 		 <xsl:choose>
				<xsl:when test="$matchType='Equals' or $matchType='Contains-phrase'">
					'<xsl:value-of select="normalize-space(.)"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-any-word'">
					'<xsl:value-of select="translate(normalize-space(.),' ','|')"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-all-words'">
						
					<xsl:call-template name="insert">
						<xsl:with-param name="value" select="normalize-space(.)"/>
						<xsl:with-param name="deLimit" select="' '"/>
						<xsl:with-param name="in" select=" concat(' and O.',local-name(),' REGEXP ')"/>
					</xsl:call-template>
					
				</xsl:when>
				
		</xsl:choose>
		 
		 </xsl:when>
		<xsl:otherwise><xsl:value-of select="$object"/>.<xsl:value-of select="local-name()"/>
		 
					<xsl:choose>
						<xsl:when test="$matchType='Equals'"> = </xsl:when>
						<xsl:otherwise> REGEXP </xsl:otherwise>
					</xsl:choose>

 		 <xsl:choose>
				<xsl:when test="$matchType='Equals' or $matchType='Contains-phrase'">
					'<xsl:value-of select="normalize-space(.)"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-any-word'">
					'<xsl:value-of select="translate(normalize-space(.),' ','|')"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-all-words'">
						
					<xsl:call-template name="insert">
						<xsl:with-param name="value" select="normalize-space(.)"/>
						<xsl:with-param name="deLimit" select="' '"/>
						<xsl:with-param name="in" select=" concat(' and O.',local-name(),' REGEXP ')"/>
					</xsl:call-template>
					
				</xsl:when>
				
		</xsl:choose>
		 
		 </xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="c:FullText">
	<xsl:param name="object"/>
	
	<xsl:variable name="matchType">
		<xsl:choose>
			<xsl:when test="@MatchType">
				<xsl:value-of select="normalize-space(@MatchType)"/>
			</xsl:when>
			<xsl:otherwise>Equals</xsl:otherwise>
		</xsl:choose>
	</xsl:variable> 

	<xsl:choose>
		<xsl:when test="$object = ''">O.full_text 

					<xsl:choose>
						<xsl:when test="$matchType='Equals'"> = </xsl:when>
						<xsl:otherwise> REGEXP </xsl:otherwise>
					</xsl:choose>

 		 <xsl:choose>
				<xsl:when test="$matchType='Equals' or $matchType='Contains-phrase'">
					'<xsl:value-of select="normalize-space(.)"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-any-word'">
					'<xsl:value-of select="translate(normalize-space(.),' ','|')"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-all-words'">
						
					<xsl:call-template name="insert">
						<xsl:with-param name="value" select="normalize-space(.)"/>
						<xsl:with-param name="deLimit" select="' '"/>
						<xsl:with-param name="in" select="' and O.full_text REGEXP '"/>
					</xsl:call-template>
					
				</xsl:when>
				
		</xsl:choose>
		
		</xsl:when>
		
		<xsl:otherwise><xsl:value-of select="$object"/>.full_text
		 
					<xsl:choose>
						<xsl:when test="$matchType='Equals'"> = </xsl:when>
						<xsl:otherwise> REGEXP </xsl:otherwise>
					</xsl:choose>

 		 <xsl:choose>
				<xsl:when test="$matchType='Equals' or $matchType='Contains-phrase'">
					'<xsl:value-of select="normalize-space(.)"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-any-word'">
					'<xsl:value-of select="translate(normalize-space(.),' ','|')"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-all-words'">
						
					<xsl:call-template name="insert">
						<xsl:with-param name="value" select="normalize-space(.)"/>
						<xsl:with-param name="deLimit" select="' '"/>
						<xsl:with-param name="in" select="' and O.full_text REGEXP '"/>
					</xsl:call-template>
					
				</xsl:when>
				
		</xsl:choose>
		 
		 </xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="c:GradeRanges" name="GG">
	<xsl:param name="object"/>

	<xsl:variable name="matchType">
		<xsl:choose>
			<xsl:when test="@MatchType">
				<xsl:value-of select="normalize-space(@MatchType)"/>
			</xsl:when>
			<xsl:otherwise>Equals</xsl:otherwise>
		</xsl:choose>
	</xsl:variable> 
	
	<xsl:choose>

		<xsl:when test="$object = ''">O.Primary_grade

		<xsl:choose>
			<xsl:when test="$matchType='Equals'"> = </xsl:when>
			<xsl:otherwise> REGEXP </xsl:otherwise>
		</xsl:choose>

 		 <xsl:choose>
				<xsl:when test="$matchType='Equals' or $matchType='Contains-phrase'">
					'<xsl:value-of select="normalize-space(.)"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-any-word'">
					'<xsl:value-of select="translate(normalize-space(.),' ','|')"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-all-words'">
						
					<xsl:call-template name="insert">
						<xsl:with-param name="value" select="normalize-space(.)"/>
						<xsl:with-param name="deLimit" select="' '"/>
						<xsl:with-param name="in" select="' and O.Primary_Grade REGEXP '"/>
					</xsl:call-template>
					
				</xsl:when>
				
		</xsl:choose>
		
 		 </xsl:when>

		<xsl:otherwise>

			<xsl:value-of select="$object"/>.Primary_Grade


			<xsl:choose>
				<xsl:when test="$matchType='Equals'"> = </xsl:when>
				<xsl:otherwise> REGEXP </xsl:otherwise>
			</xsl:choose>

 		 <xsl:choose>
				<xsl:when test="$matchType='Equals' or $matchType='Contains-phrase'">
					'<xsl:value-of select="normalize-space(.)"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-any-word'">
					'<xsl:value-of select="translate(normalize-space(.),' ','|')"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-all-words'">
						
					<xsl:call-template name="insert">
						<xsl:with-param name="value" select="normalize-space(.)"/>
						<xsl:with-param name="deLimit" select="' '"/>
						<xsl:with-param name="in" select="' and O.Primary_Grade REGEXP '"/>
					</xsl:call-template>
					
				</xsl:when>
				
		</xsl:choose>
			 
			 </xsl:otherwise>

	</xsl:choose>

</xsl:template>

<xsl:template match="c:Subjects">
	<xsl:param name="object"/>

	<xsl:variable name="matchType">
		<xsl:choose>
			<xsl:when test="@MatchType">
				<xsl:value-of select="normalize-space(@MatchType)"/>
			</xsl:when>
			<xsl:otherwise>Equals</xsl:otherwise>
		</xsl:choose>
	</xsl:variable> 
	
	<xsl:choose>

		<xsl:when test="$object = ''">O.<xsl:value-of select="local-name()"/>

					<xsl:choose>
						<xsl:when test="$matchType='Equals'"> = </xsl:when>
						<xsl:otherwise> REGEXP </xsl:otherwise>
					</xsl:choose>

 		 <xsl:choose>
				<xsl:when test="$matchType='Equals' or $matchType='Contains-phrase'">
					'<xsl:value-of select="normalize-space(.)"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-any-word'">
					'<xsl:value-of select="translate(normalize-space(.),' ','|')"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-all-words'">
						
					<xsl:call-template name="insert">
						<xsl:with-param name="value" select="normalize-space(.)"/>
						<xsl:with-param name="deLimit" select="' '"/>
						<xsl:with-param name="in" select=" concat(' and O.',local-name(),' REGEXP ')"/>
					</xsl:call-template>
					
				</xsl:when>
				
		</xsl:choose>
		
 		 </xsl:when>

		<xsl:otherwise>

			<xsl:value-of select="$object"/>.<xsl:value-of select="local-name()"/>

					<xsl:choose>
						<xsl:when test="$matchType='Equals'"> = </xsl:when>
						<xsl:otherwise> REGEXP </xsl:otherwise>
					</xsl:choose>

 		 <xsl:choose>
				<xsl:when test="$matchType='Equals' or $matchType='Contains-phrase'">
					'<xsl:value-of select="normalize-space(.)"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-any-word'">
					'<xsl:value-of select="translate(normalize-space(.),' ','|')"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-all-words'">
						
					<xsl:call-template name="insert">
						<xsl:with-param name="value" select="normalize-space(.)"/>
						<xsl:with-param name="deLimit" select="' '"/>
						<xsl:with-param name="in" select=" concat(' and O.',local-name(),' REGEXP ')"/>
					</xsl:call-template>
					
				</xsl:when>
				
		</xsl:choose>
			 
			 </xsl:otherwise>

	</xsl:choose>
</xsl:template>



<xsl:template match="c:Keywords">
	<xsl:param name="object"/>

	<xsl:variable name="matchType">
		<xsl:choose>
			<xsl:when test="@MatchType">
				<xsl:value-of select="normalize-space(@MatchType)"/>
			</xsl:when>
			<xsl:otherwise>Equals</xsl:otherwise>
		</xsl:choose>
	</xsl:variable> 
	
	<xsl:choose>

		<xsl:when test="$object = ''">O.<xsl:value-of select="local-name()"/>


					<xsl:choose>
						<xsl:when test="$matchType='Equals'"> = </xsl:when>
						<xsl:otherwise> REGEXP </xsl:otherwise>
					</xsl:choose>

 		 <xsl:choose>
				<xsl:when test="$matchType='Equals' or $matchType='Contains-phrase'">
					'<xsl:value-of select="normalize-space(.)"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-any-word'">
					'<xsl:value-of select="translate(normalize-space(.),' ','|')"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-all-words'">
						
					<xsl:call-template name="insert">
						<xsl:with-param name="value" select="normalize-space(.)"/>
						<xsl:with-param name="deLimit" select="' '"/>
						<xsl:with-param name="in" select=" concat(' and O.',local-name(),' REGEXP ')"/>
					</xsl:call-template>
					
				</xsl:when>
				
		</xsl:choose>
		
 		 </xsl:when>

		<xsl:otherwise>

			<xsl:value-of select="$object"/>.<xsl:value-of select="local-name()"/>

					<xsl:choose>
						<xsl:when test="$matchType='Equals'"> = </xsl:when>
						<xsl:otherwise> REGEXP </xsl:otherwise>
					</xsl:choose>

 		 <xsl:choose>
				<xsl:when test="$matchType='Equals' or $matchType='Contains-phrase'">
					'<xsl:value-of select="normalize-space(.)"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-any-word'">
					'<xsl:value-of select="translate(normalize-space(.),' ','|')"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-all-words'">
						
					<xsl:call-template name="insert">
						<xsl:with-param name="value" select="normalize-space(.)"/>
						<xsl:with-param name="deLimit" select="' '"/>
						<xsl:with-param name="in" select=" concat(' and O.',local-name(),' REGEXP ')"/>
					</xsl:call-template>
					
				</xsl:when>
				
		</xsl:choose>
			 
			 </xsl:otherwise>

	</xsl:choose>
</xsl:template>






<xsl:template match="c:InternalRelationship">
	<xsl:param name="object"/>

	<xsl:variable name="matchType">
		<xsl:choose>
			<xsl:when test="@MatchType">
				<xsl:value-of select="normalize-space(@MatchType)"/>
			</xsl:when>
			<xsl:otherwise>Equals</xsl:otherwise>
		</xsl:choose>
	</xsl:variable> 

	<xsl:variable name="cur" select="self::node()"/>
	<xsl:variable name="par" select="ancestor::node()"/>
	<xsl:variable name="tpos" select="position()"/>


	<xsl:choose>
		<xsl:when test="$object = ''">( O.object_ID= R<xsl:value-of select="$tpos"/>.ItemID1 )</xsl:when>
		<xsl:otherwise>( <xsl:value-of select="$object"/>.<xsl:value-of select="local-name()"/> = '<xsl:value-of select="."/> )</xsl:otherwise>
	</xsl:choose>

	and
	( R<xsl:value-of select="$tpos"/>.ItemID2 
			<xsl:choose>
			<xsl:when test="$matchType='Equals'"> = </xsl:when>
			<xsl:otherwise> REGEXP </xsl:otherwise>
		</xsl:choose>
	
	<xsl:choose>
				<xsl:when test="$matchType='Equals' or $matchType='Contains-phrase'">
					'<xsl:value-of select="normalize-space(./@Object)"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-any-word'">
					'<xsl:value-of select="translate(normalize-space(./@Object),' ','|')"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-all-words'">
						
					<xsl:call-template name="insert">
						<xsl:with-param name="value" select="normalize-space(./@Object)"/>
						<xsl:with-param name="deLimit" select="' '"/>
						<xsl:with-param name="in" select=" concat(' and R',$tpos,'.ItemID2 REGEXP ')"/>
					</xsl:call-template>
					
				</xsl:when>
				
		</xsl:choose>
	
	 )

	<xsl:if test="./@Relation != 'Any'">
		and
		( R<xsl:value-of select="$tpos"/>.RelationType = '<xsl:value-of select="./@Relation"/>' )
	</xsl:if>
	
	<xsl:if test="position() != last()">and</xsl:if>
	
</xsl:template>

<xsl:template match="c:InternalRelationships">
	( <xsl:apply-templates/>) 
</xsl:template>


<xsl:template match="c:ResourceRelationship">
	<xsl:param name="object"/>

	<xsl:variable name="matchType">
		<xsl:choose>
			<xsl:when test="@MatchType">
				<xsl:value-of select="normalize-space(@MatchType)"/>
			</xsl:when>
			<xsl:otherwise>Equals</xsl:otherwise>
		</xsl:choose>
	</xsl:variable> 

	<xsl:variable name="cur" select="self::node()"/>
	<xsl:variable name="par" select="ancestor::node()"/>
	<xsl:variable name="tpos" select="position()+count(.//c:InternalRelationship)+count(.//c:ResourceRelationship)"/>

	( O.ExternalResources 
	
		<xsl:choose>
			<xsl:when test="$matchType='Equals'"> = </xsl:when>
			<xsl:otherwise> REGEXP </xsl:otherwise>
		</xsl:choose>
	
	<xsl:choose>
				<xsl:when test="$matchType='Equals' or $matchType='Contains-phrase'">
					'<xsl:value-of select="normalize-space($cur)"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-any-word'">
					'<xsl:value-of select="translate(normalize-space($cur),' ','|')"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-all-words'">
						
					<xsl:call-template name="insert">
						<xsl:with-param name="value" select="normalize-space($cur)"/>
						<xsl:with-param name="deLimit" select="' '"/>
						<xsl:with-param name="in" select=" concat(' and O.ExternalResources',' REGEXP ')"/>
					</xsl:call-template>
					
				</xsl:when>
				
		</xsl:choose>
 )

<!--
	<xsl:if test="./@Relation != 'Any'">
		and
		( R<xsl:value-of select="$tpos"/>.RelationType = '<xsl:value-of select="./@Relation"/>' )
	</xsl:if>
-->	
	<xsl:if test="position() != last()">and</xsl:if>
	
</xsl:template>

<xsl:template match="c:ResourceRelationships">
	( <xsl:apply-templates/> )
</xsl:template>

<xsl:template match="c:StandardRelationship">
	<xsl:param name="object"/>

	<xsl:variable name="matchType">
		<xsl:choose>
			<xsl:when test="@MatchType">
				<xsl:value-of select="normalize-space(@MatchType)"/>
			</xsl:when>
			<xsl:otherwise>Equals</xsl:otherwise>
		</xsl:choose>
	</xsl:variable> 

	<xsl:variable name="cur" select="self::node()"/>
	<xsl:variable name="par" select="ancestor::node()"/>
	<xsl:variable name="tpos" select="position()+count(.//c:InternalRelationship)+count(.//c:ResourceRelationship)"/>

	( O.Standards 
	
		<xsl:choose>
			<xsl:when test="$matchType='Equals'"> = </xsl:when>
			<xsl:otherwise> REGEXP </xsl:otherwise>
		</xsl:choose>
	
	<xsl:choose>
				<xsl:when test="$matchType='Equals' or $matchType='Contains-phrase'">
					'<xsl:value-of select="normalize-space($cur)"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-any-word'">
					'<xsl:value-of select="translate(normalize-space($cur),' ','|')"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-all-words'">
						
					<xsl:call-template name="insert">
						<xsl:with-param name="value" select="normalize-space($cur)"/>
						<xsl:with-param name="deLimit" select="' '"/>
						<xsl:with-param name="in" select=" concat(' and O.Standards',' REGEXP ')"/>
					</xsl:call-template>
					
				</xsl:when>
				
		</xsl:choose>
 )


<!--
	<xsl:if test="./@Relation != 'Any'">
		and
		( R<xsl:value-of select="$tpos"/>.RelationType = '<xsl:value-of select="./@Relation"/>' )
	</xsl:if>
-->	
	<xsl:if test="position() != last()">and</xsl:if>
</xsl:template>

<xsl:template match="c:NarrativeStudentIdeas">
	<xsl:param name="object"/>
	
	<xsl:variable name="matchType">
		<xsl:choose>
			<xsl:when test="@MatchType">
				<xsl:value-of select="normalize-space(@MatchType)"/>
			</xsl:when>
			<xsl:otherwise>Equals</xsl:otherwise>
		</xsl:choose>
	</xsl:variable> 

	<xsl:choose>
		<xsl:when test="$object = ''">O.o
		 
					<xsl:choose>
						<xsl:when test="$matchType='Equals'"> = </xsl:when>
						<xsl:otherwise> REGEXP </xsl:otherwise>
					</xsl:choose>

 		 <xsl:choose>
				<xsl:when test="$matchType='Equals' or $matchType='Contains-phrase'">
					'<xsl:value-of select="normalize-space(.)"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-any-word'">
					'<xsl:value-of select="translate(normalize-space(.),' ','|')"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-all-words'">
						
					<xsl:call-template name="insert">
						<xsl:with-param name="value" select="normalize-space(.)"/>
						<xsl:with-param name="deLimit" select="' '"/>
						<xsl:with-param name="in" select="' and O.o REGEXP '"/>
					</xsl:call-template>
					
				</xsl:when>
				
		</xsl:choose>
		 
		 </xsl:when>
		
		<xsl:otherwise><xsl:value-of select="$object"/>.o

					<xsl:choose>
						<xsl:when test="$matchType='Equals'"> = </xsl:when>
						<xsl:otherwise> REGEXP </xsl:otherwise>
					</xsl:choose>

 		 <xsl:choose>
				<xsl:when test="$matchType='Equals' or $matchType='Contains-phrase'">
					'<xsl:value-of select="normalize-space(.)"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-any-word'">
					'<xsl:value-of select="translate(normalize-space(.),' ','|')"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-all-words'">
						
					<xsl:call-template name="insert">
						<xsl:with-param name="value" select="normalize-space(.)"/>
						<xsl:with-param name="deLimit" select="' '"/>
						<xsl:with-param name="in" select="' and O.o REGEXP '"/>
					</xsl:call-template>
					
				</xsl:when>
				
		</xsl:choose>
		 
		 </xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="c:NarrativeExamples">
	<xsl:param name="object"/>
	
	<xsl:variable name="matchType">
		<xsl:choose>
			<xsl:when test="@MatchType">
				<xsl:value-of select="normalize-space(@MatchType)"/>
			</xsl:when>
			<xsl:otherwise>Equals</xsl:otherwise>
		</xsl:choose>
	</xsl:variable> 

	<xsl:choose>
		<xsl:when test="$object = ''">O.p

					<xsl:choose>
						<xsl:when test="$matchType='Equals'"> = </xsl:when>
						<xsl:otherwise> REGEXP </xsl:otherwise>
					</xsl:choose>

 		 <xsl:choose>
				<xsl:when test="$matchType='Equals' or $matchType='Contains-phrase'">
					'<xsl:value-of select="normalize-space(.)"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-any-word'">
					'<xsl:value-of select="translate(normalize-space(.),' ','|')"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-all-words'">
						
					<xsl:call-template name="insert">
						<xsl:with-param name="value" select="normalize-space(.)"/>
						<xsl:with-param name="deLimit" select="' '"/>
						<xsl:with-param name="in" select="' and O.p REGEXP '"/>
					</xsl:call-template>
					
				</xsl:when>
				
		</xsl:choose>
		 
		 </xsl:when>

		<xsl:otherwise><xsl:value-of select="$object"/>.p
		 
					<xsl:choose>
						<xsl:when test="$matchType='Equals'"> = </xsl:when>
						<xsl:otherwise> REGEXP </xsl:otherwise>
					</xsl:choose>

 		 <xsl:choose>
				<xsl:when test="$matchType='Equals' or $matchType='Contains-phrase'">
					'<xsl:value-of select="normalize-space(.)"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-any-word'">
					'<xsl:value-of select="translate(normalize-space(.),' ','|')"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-all-words'">
						
					<xsl:call-template name="insert">
						<xsl:with-param name="value" select="normalize-space(.)"/>
						<xsl:with-param name="deLimit" select="' '"/>
						<xsl:with-param name="in" select="' and O.p REGEXP '"/>
					</xsl:call-template>
					
				</xsl:when>
				
		</xsl:choose>
		 
		 </xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="c:NarrativeAssessment">
	<xsl:param name="object"/>
	
	<xsl:variable name="matchType">
		<xsl:choose>
			<xsl:when test="@MatchType">
				<xsl:value-of select="normalize-space(@MatchType)"/>
			</xsl:when>
			<xsl:otherwise>Equals</xsl:otherwise>
		</xsl:choose>
	</xsl:variable> 

	<xsl:choose>
		<xsl:when test="$object = ''">O.q

					<xsl:choose>
						<xsl:when test="$matchType='Equals'"> = </xsl:when>
						<xsl:otherwise> REGEXP </xsl:otherwise>
					</xsl:choose>

 		 <xsl:choose>
				<xsl:when test="$matchType='Equals' or $matchType='Contains-phrase'">
					'<xsl:value-of select="normalize-space(.)"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-any-word'">
					'<xsl:value-of select="translate(normalize-space(.),' ','|')"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-all-words'">
						
					<xsl:call-template name="insert">
						<xsl:with-param name="value" select="normalize-space(.)"/>
						<xsl:with-param name="deLimit" select="' '"/>
						<xsl:with-param name="in" select="' and O.q REGEXP '"/>
					</xsl:call-template>
					
				</xsl:when>
				
		</xsl:choose>
		 
		 </xsl:when>

		<xsl:otherwise><xsl:value-of select="$object"/>.q

					<xsl:choose>
						<xsl:when test="$matchType='Equals'"> = </xsl:when>
						<xsl:otherwise> REGEXP </xsl:otherwise>
					</xsl:choose>

 		 <xsl:choose>
				<xsl:when test="$matchType='Equals' or $matchType='Contains-phrase'">
					'<xsl:value-of select="normalize-space(.)"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-any-word'">
					'<xsl:value-of select="translate(normalize-space(.),' ','|')"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-all-words'">
						
					<xsl:call-template name="insert">
						<xsl:with-param name="value" select="normalize-space(.)"/>
						<xsl:with-param name="deLimit" select="' '"/>
						<xsl:with-param name="in" select="' and O.q REGEXP '"/>
					</xsl:call-template>
					
				</xsl:when>
				
		</xsl:choose>
		 
		 </xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="c:NarrativeInstructional">
	<xsl:param name="object"/>
	
	<xsl:variable name="matchType">
		<xsl:choose>
			<xsl:when test="@MatchType">
				<xsl:value-of select="normalize-space(@MatchType)"/>
			</xsl:when>
			<xsl:otherwise>Equals</xsl:otherwise>
		</xsl:choose>
	</xsl:variable> 

	<xsl:choose>
		<xsl:when test="$object = ''">O.r

					<xsl:choose>
						<xsl:when test="$matchType='Equals'"> = </xsl:when>
						<xsl:otherwise> REGEXP </xsl:otherwise>
					</xsl:choose>

 		 <xsl:choose>
				<xsl:when test="$matchType='Equals' or $matchType='Contains-phrase'">
					'<xsl:value-of select="normalize-space(.)"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-any-word'">
					'<xsl:value-of select="translate(normalize-space(.),' ','|')"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-all-words'">
						
					<xsl:call-template name="insert">
						<xsl:with-param name="value" select="normalize-space(.)"/>
						<xsl:with-param name="deLimit" select="' '"/>
						<xsl:with-param name="in" select="' and O.r REGEXP '"/>
					</xsl:call-template>
					
				</xsl:when>
				
		</xsl:choose>
		 
		 </xsl:when>
		<xsl:otherwise><xsl:value-of select="$object"/>.r

					<xsl:choose>
						<xsl:when test="$matchType='Equals'"> = </xsl:when>
						<xsl:otherwise> REGEXP </xsl:otherwise>
					</xsl:choose>

 		 <xsl:choose>
				<xsl:when test="$matchType='Equals' or $matchType='Contains-phrase'">
					'<xsl:value-of select="normalize-space(.)"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-any-word'">
					'<xsl:value-of select="translate(normalize-space(.),' ','|')"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-all-words'">
					
					<xsl:call-template name="insert">
						<xsl:with-param name="value" select="normalize-space(.)"/>
						<xsl:with-param name="deLimit" select="' '"/>
						<xsl:with-param name="in" select="' and O.r REGEXP '"/>
					</xsl:call-template>
					
				</xsl:when>
				
		</xsl:choose>
		 
		 </xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="c:NarrativeClarification">
	<xsl:param name="object"/>
	
	<xsl:variable name="matchType">
		<xsl:choose>
			<xsl:when test="@MatchType">
				<xsl:value-of select="normalize-space(@MatchType)"/>
			</xsl:when>
			<xsl:otherwise>Equals</xsl:otherwise>
		</xsl:choose>
	</xsl:variable> 

	<xsl:choose>
		<xsl:when test="$object = ''">O.s
		 
					<xsl:choose>
						<xsl:when test="$matchType='Equals'"> = </xsl:when>
						<xsl:otherwise> REGEXP </xsl:otherwise>
					</xsl:choose>

 		 <xsl:choose>
				<xsl:when test="$matchType='Equals' or $matchType='Contains-phrase'">
					'<xsl:value-of select="normalize-space(.)"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-any-word'">
					'<xsl:value-of select="translate(normalize-space(.),' ','|')"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-all-words'">
						
					<xsl:call-template name="insert">
						<xsl:with-param name="value" select="normalize-space(.)"/>
						<xsl:with-param name="deLimit" select="' '"/>
						<xsl:with-param name="in" select="' and O.s REGEXP '"/>
					</xsl:call-template>
					
				</xsl:when>
				
		</xsl:choose>
		 
		 </xsl:when>
		<xsl:otherwise><xsl:value-of select="$object"/>.s
		 
					<xsl:choose>
						<xsl:when test="$matchType='Equals'"> = </xsl:when>
						<xsl:otherwise> REGEXP </xsl:otherwise>
					</xsl:choose>

 		 <xsl:choose>
				<xsl:when test="$matchType='Equals' or $matchType='Contains-phrase'">
					'<xsl:value-of select="normalize-space(.)"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-any-word'">
					'<xsl:value-of select="translate(normalize-space(.),' ','|')"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-all-words'">
						
					<xsl:call-template name="insert">
						<xsl:with-param name="value" select="normalize-space(.)"/>
						<xsl:with-param name="deLimit" select="' '"/>
						<xsl:with-param name="in" select="' and O.s REGEXP '"/>
					</xsl:call-template>
					
				</xsl:when>
				
		</xsl:choose>
		 
		 </xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="c:Term">
	<xsl:param name="object"/>
	
	<xsl:variable name="matchType">
		<xsl:choose>
			<xsl:when test="@MatchType">
				<xsl:value-of select="normalize-space(@MatchType)"/>
			</xsl:when>
			<xsl:otherwise>Equals</xsl:otherwise>
		</xsl:choose>
	</xsl:variable> 


	<xsl:choose>
<!--
		<xsl:when test="$object = ''">O

					<xsl:choose>
						<xsl:when test="$matchType='Equals'"> = </xsl:when>
						<xsl:otherwise> REGEXP </xsl:otherwise>
					</xsl:choose>

 		 <xsl:choose>
				<xsl:when test="$matchType='Equals' or $matchType='Contains-phrase'">
					'<xsl:value-of select="normalize-space(.)"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-any-word'">
					'<xsl:value-of select="translate(normalize-space(.),' ','|')"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-all-words'">
						
					<xsl:call-template name="insert">
						<xsl:with-param name="value" select="normalize-space(.)"/>
						<xsl:with-param name="deLimit" select="' '"/>
						<xsl:with-param name="in" select="' and O REGEXP '"/>
					</xsl:call-template>
					
				</xsl:when>
				
		</xsl:choose>

		</xsl:when>		
		
-->
		<xsl:when test="$object = ''">
			( O.object_type 
					<xsl:choose>
						<xsl:when test="$matchType='Equals'"> = </xsl:when>
						<xsl:otherwise> REGEXP </xsl:otherwise>
					</xsl:choose>
			 		 <xsl:choose>
				<xsl:when test="$matchType='Equals' or $matchType='Contains-phrase'">
					'<xsl:value-of select="normalize-space(.)"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-any-word'">
					'<xsl:value-of select="translate(normalize-space(.),' ','|')"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-all-words'">
						
					<xsl:call-template name="insert">
						<xsl:with-param name="value" select="normalize-space(.)"/>
						<xsl:with-param name="deLimit" select="' '"/>
						<xsl:with-param name="in" select="' and O.object_type REGEXP '"/>
					</xsl:call-template>
					
				</xsl:when>
				
		</xsl:choose>
) or
			( O.object_ID
					<xsl:choose>
						<xsl:when test="$matchType='Equals'"> = </xsl:when>
						<xsl:otherwise> REGEXP </xsl:otherwise>
					</xsl:choose>
			  		 <xsl:choose>
				<xsl:when test="$matchType='Equals' or $matchType='Contains-phrase'">
					'<xsl:value-of select="normalize-space(.)"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-any-word'">
					'<xsl:value-of select="translate(normalize-space(.),' ','|')"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-all-words'">
						
					<xsl:call-template name="insert">
						<xsl:with-param name="value" select="normalize-space(.)"/>
						<xsl:with-param name="deLimit" select="' '"/>
						<xsl:with-param name="in" select="' and O.Object_ID REGEXP '"/>
					</xsl:call-template>
					
				</xsl:when>
				
		</xsl:choose>
) or
			( O.Name 
					<xsl:choose>
						<xsl:when test="$matchType='Equals'"> = </xsl:when>
						<xsl:otherwise> REGEXP </xsl:otherwise>
					</xsl:choose>
			  		 <xsl:choose>
				<xsl:when test="$matchType='Equals' or $matchType='Contains-phrase'">
					'<xsl:value-of select="normalize-space(.)"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-any-word'">
					'<xsl:value-of select="translate(normalize-space(.),' ','|')"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-all-words'">
						
					<xsl:call-template name="insert">
						<xsl:with-param name="value" select="normalize-space(.)"/>
						<xsl:with-param name="deLimit" select="' '"/>
						<xsl:with-param name="in" select="' and O.Name REGEXP '"/>
					</xsl:call-template>
					
				</xsl:when>
				
		</xsl:choose>
) or
			( O.source 
					<xsl:choose>
						<xsl:when test="$matchType='Equals'"> = </xsl:when>
						<xsl:otherwise> REGEXP </xsl:otherwise>
					</xsl:choose>
			 		 <xsl:choose>
				<xsl:when test="$matchType='Equals' or $matchType='Contains-phrase'">
					'<xsl:value-of select="normalize-space(.)"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-any-word'">
					'<xsl:value-of select="translate(normalize-space(.),' ','|')"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-all-words'">
						
					<xsl:call-template name="insert">
						<xsl:with-param name="value" select="normalize-space(.)"/>
						<xsl:with-param name="deLimit" select="' '"/>
						<xsl:with-param name="in" select=" ' and O.source REGEXP '"/>
					</xsl:call-template>
					
				</xsl:when>
				
		</xsl:choose>
) or
			( O.primary_grade
					<xsl:choose>
						<xsl:when test="$matchType='Equals'"> = </xsl:when>
						<xsl:otherwise> REGEXP </xsl:otherwise>
					</xsl:choose>
			  		 <xsl:choose>
				<xsl:when test="$matchType='Equals' or $matchType='Contains-phrase'">
					'<xsl:value-of select="normalize-space(.)"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-any-word'">
					'<xsl:value-of select="translate(normalize-space(.),' ','|')"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-all-words'">
						
					<xsl:call-template name="insert">
						<xsl:with-param name="value" select="normalize-space(.)"/>
						<xsl:with-param name="deLimit" select="' '"/>
						<xsl:with-param name="in" select="' and O.primary_grade REGEXP '"/>
					</xsl:call-template>
					
				</xsl:when>
				
		</xsl:choose>
) or
			( O.record_status 
					<xsl:choose>
						<xsl:when test="$matchType='Equals'"> = </xsl:when>
						<xsl:otherwise> REGEXP </xsl:otherwise>
					</xsl:choose>
			 		 <xsl:choose>
				<xsl:when test="$matchType='Equals' or $matchType='Contains-phrase'">
					'<xsl:value-of select="normalize-space(.)"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-any-word'">
					'<xsl:value-of select="translate(normalize-space(.),' ','|')"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-all-words'">
						
					<xsl:call-template name="insert">
						<xsl:with-param name="value" select="normalize-space(.)"/>
						<xsl:with-param name="deLimit" select="' '"/>
						<xsl:with-param name="in" select="' and O.record_status REGEXP '"/>
					</xsl:call-template>
					
				</xsl:when>
				
		</xsl:choose>
) or
			( O.full_text
					<xsl:choose>
						<xsl:when test="$matchType='Equals'"> = </xsl:when>
						<xsl:otherwise> REGEXP </xsl:otherwise>
					</xsl:choose>
			  		 <xsl:choose>
				<xsl:when test="$matchType='Equals' or $matchType='Contains-phrase'">
					'<xsl:value-of select="normalize-space(.)"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-any-word'">
					'<xsl:value-of select="translate(normalize-space(.),' ','|')"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-all-words'">
						
					<xsl:call-template name="insert">
						<xsl:with-param name="value" select="normalize-space(.)"/>
						<xsl:with-param name="deLimit" select="' '"/>
						<xsl:with-param name="in" select="' and O.full_text REGEXP '"/>
					</xsl:call-template>
					
				</xsl:when>
				
		</xsl:choose>
) or
			( O.description 
					<xsl:choose>
						<xsl:when test="$matchType='Equals'"> = </xsl:when>
						<xsl:otherwise> REGEXP </xsl:otherwise>
					</xsl:choose>
			 		 <xsl:choose>
				<xsl:when test="$matchType='Equals' or $matchType='Contains-phrase'">
					'<xsl:value-of select="normalize-space(.)"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-any-word'">
					'<xsl:value-of select="translate(normalize-space(.),' ','|')"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-all-words'">
						
					<xsl:call-template name="insert">
						<xsl:with-param name="value" select="normalize-space(.)"/>
						<xsl:with-param name="deLimit" select="' '"/>
						<xsl:with-param name="in" select="' and O.description REGEXP '"/>
					</xsl:call-template>
					
				</xsl:when>
				
		</xsl:choose>
) or
			( O.subjects
					<xsl:choose>
						<xsl:when test="$matchType='Equals'"> = </xsl:when>
						<xsl:otherwise> REGEXP </xsl:otherwise>
					</xsl:choose>
			   		 <xsl:choose>
				<xsl:when test="$matchType='Equals' or $matchType='Contains-phrase'">
					'<xsl:value-of select="normalize-space(.)"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-any-word'">
					'<xsl:value-of select="translate(normalize-space(.),' ','|')"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-all-words'">
						
					<xsl:call-template name="insert">
						<xsl:with-param name="value" select="normalize-space(.)"/>
						<xsl:with-param name="deLimit" select="' '"/>
						<xsl:with-param name="in" select="' and O.subjects REGEXP '"/>
					</xsl:call-template>
					
				</xsl:when>
				
		</xsl:choose>
) or
			( O.keywords 
					<xsl:choose>
						<xsl:when test="$matchType='Equals'"> = </xsl:when>
						<xsl:otherwise> REGEXP </xsl:otherwise>
					</xsl:choose>
			 		 <xsl:choose>
				<xsl:when test="$matchType='Equals' or $matchType='Contains-phrase'">
					'<xsl:value-of select="normalize-space(.)"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-any-word'">
					'<xsl:value-of select="translate(normalize-space(.),' ','|')"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-all-words'">
						
					<xsl:call-template name="insert">
						<xsl:with-param name="value" select="normalize-space(.)"/>
						<xsl:with-param name="deLimit" select="' '"/>
						<xsl:with-param name="in" select="' and O.keywords REGEXP '"/>
					</xsl:call-template>
					
				</xsl:when>
				
		</xsl:choose>
) or
			( O.date_created 
					<xsl:choose>
						<xsl:when test="$matchType='Equals'"> = </xsl:when>
						<xsl:otherwise> REGEXP </xsl:otherwise>
					</xsl:choose>
			 		 <xsl:choose>
				<xsl:when test="$matchType='Equals' or $matchType='Contains-phrase'">
					'<xsl:value-of select="normalize-space(.)"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-any-word'">
					'<xsl:value-of select="translate(normalize-space(.),' ','|')"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-all-words'">
						
					<xsl:call-template name="insert">
						<xsl:with-param name="value" select="normalize-space(.)"/>
						<xsl:with-param name="deLimit" select="' '"/>
						<xsl:with-param name="in" select="' and O.date_created REGEXP '"/>
					</xsl:call-template>
					
				</xsl:when>
				
		</xsl:choose>
) or
			( O.aaas_code 
					<xsl:choose>
						<xsl:when test="$matchType='Equals'"> = </xsl:when>
						<xsl:otherwise> REGEXP </xsl:otherwise>
					</xsl:choose>
			 		 <xsl:choose>
				<xsl:when test="$matchType='Equals' or $matchType='Contains-phrase'">
					'<xsl:value-of select="normalize-space(.)"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-any-word'">
					'<xsl:value-of select="translate(normalize-space(.),' ','|')"/>'
				</xsl:when>
				
				<xsl:when test="$matchType='Contains-all-words'">
						
					<xsl:call-template name="insert">
						<xsl:with-param name="value" select="normalize-space(.)"/>
						<xsl:with-param name="deLimit" select="' '"/>
						<xsl:with-param name="in" select="' and O.aaas_code REGEXP '"/>
					</xsl:call-template>
					
				</xsl:when>
				
		</xsl:choose>
)
		</xsl:when>

<!--	
		<xsl:otherwise>
			<xsl:value-of select="$object"/>.object_type 
		 	<xsl:choose>
				<xsl:when test="$not">&lt;&gt;</xsl:when>
				<xsl:otherwise>=</xsl:otherwise>
			</xsl:choose>
			 '<xsl:value-of select="."/>' ) or
			<xsl:value-of select="$object"/>.object_ID 
		 	<xsl:choose>
				<xsl:when test="$not">&lt;&gt;</xsl:when>
				<xsl:otherwise>=</xsl:otherwise>
			</xsl:choose>
			'<xsl:value-of select="."/>' ) or
			<xsl:value-of select="$object"/>.Name  
		 	<xsl:choose>
				<xsl:when test="$not">&lt;&gt;</xsl:when>
				<xsl:otherwise>=</xsl:otherwise>
			</xsl:choose>
			'<xsl:value-of select="."/>' ) or
			<xsl:value-of select="$object"/>.source 
		 	<xsl:choose>
				<xsl:when test="$not">&lt;&gt;</xsl:when>
				<xsl:otherwise>=</xsl:otherwise>
			</xsl:choose>
			'<xsl:value-of select="."/>' ) or
			<xsl:value-of select="$object"/>.primary_grade 
		 	<xsl:choose>
				<xsl:when test="$not">&lt;&gt;</xsl:when>
				<xsl:otherwise>=</xsl:otherwise>
			</xsl:choose>
			'<xsl:value-of select="."/>' ) or
			<xsl:value-of select="$object"/>.record_status 
		 	<xsl:choose>
				<xsl:when test="$not">&lt;&gt;</xsl:when>
				<xsl:otherwise>=</xsl:otherwise>
			</xsl:choose>
			'<xsl:value-of select="."/>' ) or
			<xsl:value-of select="$object"/>.full_text 
		 	<xsl:choose>
				<xsl:when test="$not">&lt;&gt;</xsl:when>
				<xsl:otherwise>=</xsl:otherwise>
			</xsl:choose>
			 '<xsl:value-of select="."/>' ) or
			<xsl:value-of select="$object"/>.description 
		 	<xsl:choose>
				<xsl:when test="$not">&lt;&gt;</xsl:when>
				<xsl:otherwise>=</xsl:otherwise>
			</xsl:choose>
			'<xsl:value-of select="."/>' ) or															
			<xsl:value-of select="$object"/>.subjects 
		 	<xsl:choose>
				<xsl:when test="$not">&lt;&gt;</xsl:when>
				<xsl:otherwise>=</xsl:otherwise>
			</xsl:choose>
			'<xsl:value-of select="."/>' ) or
			<xsl:value-of select="$object"/>.keywords 
		 	<xsl:choose>
				<xsl:when test="$not">&lt;&gt;</xsl:when>
				<xsl:otherwise>=</xsl:otherwise>
			</xsl:choose>
			'<xsl:value-of select="."/>' ) or
			<xsl:value-of select="$object"/>.date_created 
		 	<xsl:choose>
				<xsl:when test="$not">&lt;&gt;</xsl:when>
				<xsl:otherwise>=</xsl:otherwise>
			</xsl:choose>
			 '<xsl:value-of select="."/>' ) or
			<xsl:value-of select="$object"/>.aaas_code 
		 	<xsl:choose>
				<xsl:when test="$not">&lt;&gt;</xsl:when>
				<xsl:otherwise>=</xsl:otherwise>
			</xsl:choose>
			'<xsl:value-of select="."/>' )
		</xsl:otherwise>
-->		
	</xsl:choose>
</xsl:template>

<xsl:template match="c:ObjectID">

	<xsl:if test="not(boolean(//c:Navigational-Query))">
	
		<xsl:variable name="OID">
			'<xsl:value-of select="normalize-space(//c:ObjectID)"/>'
		</xsl:variable> 
		
		<xsl:variable name="Depth">
			<xsl:value-of select="//c:ObjectID/@Depth"/>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="string-length(normalize-space($Depth)) = 0"><xsl:call-template name="ObjectIDNil"><xsl:with-param name="OID" select="$OID"/></xsl:call-template></xsl:when>
			<xsl:when test="string-length(normalize-space($Depth)) = 1 and starts-with(normalize-space($Depth),'0')"><xsl:call-template name="ObjectIDNil"><xsl:with-param name="OID" select="$OID"/></xsl:call-template></xsl:when>
			<xsl:when test="starts-with(normalize-space($Depth),'-')"></xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>

	</xsl:if>

</xsl:template>

<xsl:template name="ObjectIDNil">
	<xsl:param name="OID"/>
	O.object_id = 	<xsl:value-of select="$OID"/>
</xsl:template>


<xsl:template match="c:AND" name="and">
	(
	<xsl:for-each select="./*">
		( <xsl:apply-templates select="."/> )
		<xsl:if test="position() != last()">and</xsl:if>
	</xsl:for-each>
	)
</xsl:template>


<xsl:template match="c:OR">
	(
	<xsl:for-each select="./*">
		( <xsl:apply-templates select="."/> )
		<xsl:if test="position() != last()">or</xsl:if>
	</xsl:for-each>
	)
</xsl:template>


<xsl:template match="c:NOT-AND">

	<xsl:variable name="cur" select="current()"/>
	<xsl:variable name="par" select="ancestor::node()"/>

	<xsl:variable name="pos">
		<xsl:for-each select="//c:NOT-AND | //c:NOT-OR">
			<xsl:variable name="check" select="ancestor::node()"/>
			<xsl:if test="$cur = . and count($par) = count($check)"><xsl:value-of select="position()"/></xsl:if>
		</xsl:for-each>
	</xsl:variable>
	
	<!-- 	except ( select * from objects O<xsl:value-of select="$pos"/> -->
	O.object_id not in(select O.object_id from objects O<xsl:call-template name="makeRelationVariables"/> where(
	<xsl:for-each select="./*">
		( <xsl:apply-templates select=".">
<!--			 <xsl:with-param name="object">O<xsl:value-of select="$pos"/></xsl:with-param>-->
		</xsl:apply-templates> )
		<xsl:if test="position() != last()">and</xsl:if>
	</xsl:for-each>
	))

</xsl:template>

<xsl:template match="c:NOT-OR">

	<xsl:variable name="cur" select="current()"/>
	<xsl:variable name="par" select="ancestor::node()"/>

	<xsl:variable name="pos">
		<xsl:for-each select="//c:NOT-AND | //c:NOT-OR">
			<xsl:variable name="check" select="ancestor::node()"/>
			<xsl:if test="$cur = . and count($par) = count($check)"><xsl:value-of select="position()"/></xsl:if>
		</xsl:for-each>
	</xsl:variable>
	
<!-- 	except ( select * from  objects O<xsl:value-of select="$pos"/> -->
	O.object_id not in(select O.object_id from objects O<xsl:call-template name="makeRelationVariables"/> where(
	<xsl:for-each select="./*">
		( <xsl:apply-templates select=".">
<!--			<xsl:with-param name="object">O<xsl:value-of select="$pos"/></xsl:with-param>-->
		</xsl:apply-templates> )
		<xsl:if test="position() != last()">or</xsl:if>
	</xsl:for-each>
	))

</xsl:template>



</xsl:stylesheet>
