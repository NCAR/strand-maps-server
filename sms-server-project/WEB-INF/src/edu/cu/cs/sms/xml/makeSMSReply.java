/* 
 * Copyright 2002-2005 Boulder Learning Technologies Lab & American Association for the Advancement of Science, 
 * DLC-1B20, Department of Computer Science, University of Colorado at Boulder,
 * CO-80309, Tel: 303-492-0916, email: fahmad@colorado.edu
 * 
 * This file is part of the Concept Map Service Software Project.
 * 
 * The Concept Map Service Project is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of the
 * License, or (at your option) any later version.
 * 
 * The Concept Map Service OAI Project is distributed in the hope that it will be
 * useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with The Concept Map Service System; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
 * USA
 * 
 * Author: Faisal Ahmad
 * Date  : Sept 14, 2005
 * email : fahmad@colorado.edu
 */

package edu.cu.cs.sms.xml;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Date;

import org.apache.xerces.dom.DocumentImpl;
import org.w3c.dom.Attr;
import org.w3c.dom.Element;
import org.w3c.dom.Text;
import org.xml.sax.SAXException;

import edu.cu.cs.sms.DTO.SMSData;
import edu.cu.cs.sms.Database.SMSResultSet;
import edu.cu.cs.sms.util.Formator;
import edu.cu.cs.sms.util.QueryExpander;
import edu.cu.cs.sms.util.WriteXML;

public class makeSMSReply implements GenerateXML {
	
    DocumentImpl dDoc;

    SMSResultSet data;

    public byte[] populate(SMSResultSet info) throws Exception {
        String sb;

        this.data = info;
        dDoc = new DocumentImpl();

        Element root = dDoc.createElement("SMS-CSIP");
        Element QueryResponse = dDoc.createElement("QueryResponse");
        Element SMS = dDoc.createElement("SMS");

        Attr Number = dDoc.createAttribute("Number");
        Attr nameSpace = dDoc.createAttribute("xmlns");

        nameSpace.setValue("http://sms.dlese.org");
        Number.setValue(Integer.toString(data.getTotalObjects()));

        root.appendChild(QueryResponse);
        QueryResponse.appendChild(SMS);
        dDoc.appendChild(root);

        SMS.setAttributeNode(Number);
        root.setAttributeNode(nameSpace);

        for (int loopIndex = 0; loopIndex < data.getTotalObjects(); loopIndex++) {
            Element rec = dDoc.createElement("Record");
            rec.appendChild(createSMS(data.getObject(loopIndex)));
            SMS.appendChild(rec);
        }

        // sb = dDoc.saveXML(null);
        sb = new WriteXML().writeXML(dDoc);

        return sb.getBytes();
    }

    private Element createSMS(SMSData in) throws SAXException, IOException {
        List DLQ = null;
        // Constructing the top level SMS metadata element
        Element itemRecord = dDoc.createElement("itemRecord");
        itemRecord.setAttribute("xmlns", "http://sms.dlese.org");
        itemRecord.setAttribute("xmlns:xsi",
                "http://www.w3.org/2001/XMLSchema-instance");
        itemRecord
                .setAttribute(
                        "xsi:schemaLocation",
                        "http://sms.dlese.org http://www.dlese.org/Metadata/strandmaps/0.1.01/Record.xsd");

        // making data element
        Element Data = dDoc.createElement("Data");
        itemRecord.appendChild(Data);

        // making admin element
        Element Admin = dDoc.createElement("Admin");
        itemRecord.appendChild(Admin);

        if (in.getObject_type().equalsIgnoreCase("Benchmark"))
            DLQ = data.getBMKDLQueries();
        else if (in.getObject_type().equalsIgnoreCase("Grade group"))
            DLQ = data.getGRDDLQueries();
        else if (in.getObject_type().equalsIgnoreCase("Strand"))
            DLQ = data.getSTDDLQueries();
        else if (in.getObject_type().equalsIgnoreCase("Map"))
            DLQ = data.getMAPDLQueries();
        else if (in.getObject_type().equalsIgnoreCase("Cluster"))
            DLQ = data.getCLSDLQueries();
        else if (in.getObject_type().equalsIgnoreCase("Chapter"))
            DLQ = data.getCHPDLQueries();
        else if (in.getObject_type().equalsIgnoreCase("Atlas"))
            DLQ = data.getATLDLQueries();
        else if (in.getObject_type().equalsIgnoreCase("Section"))
            DLQ = data.getSECDLQueries();
        else if (in.getObject_type().equalsIgnoreCase(
                "Science for all americans paragraph"))
            DLQ = data.getSFAADLQueries();

        if (DLQ.size() == 0)
            DLQ = data.getALLDLQueries();

        if (DLQ.size() > 0) {
            Element DLQueries = dDoc.createElement("DLQueries");
            itemRecord.appendChild(DLQueries);

            for (int index = 0; index < DLQ.size(); index++) {
                QueryExpander d = (QueryExpander) DLQ.get(index);
                Element Query = dDoc.createElement("Query");
                Text q = dDoc.createTextNode(d.getDLquery(in));
                Query.setAttribute("DLName", d.getDLname());
                Query.appendChild(q);
                DLQueries.appendChild(Query);
            }
        }

        // making skeleton data sub-elements
        Element Name = dDoc.createElement("Name");
        Name.appendChild(dDoc.createTextNode(in.getName()));

        Element ObjectType = dDoc.createElement("ObjectType");
        ObjectType.appendChild(dDoc.createTextNode(in.getObject_type()));

        Element AAASCode = dDoc.createElement("AAASCode");
        AAASCode.appendChild(dDoc.createTextNode(in.getAaas_code()));

        Element Description = dDoc.createElement("Description");
        Description.appendChild(dDoc.createTextNode(in.getDescription()));

        Element IDNumber = dDoc.createElement("IDNumber");
        IDNumber.appendChild(dDoc.createTextNode(in.getObject_id()));
        
        Element IR = dDoc.createElement("InternalRelationship");

        ArrayList objectID = in.getItemID2();
        ArrayList relation = in.getRelationType();
        ArrayList body = in.getRelationCategory();

        for (int loopIndex = 0; loopIndex < objectID.size(); loopIndex++) {
            Element CatalogID = dDoc.createElement("CatalogID");
            CatalogID.setAttribute("RelationType", (String) relation
                    .get(loopIndex));
            CatalogID.setAttribute("CatalogNumber", (String) objectID
                    .get(loopIndex));
            CatalogID.appendChild(dDoc.createTextNode((String) body
                    .get(loopIndex)));

            IR.appendChild(CatalogID);
        }

        
        Element EXTR = dDoc.createElement("ExternalRelationship");
        
        ArrayList NGSSID = in.getNGSS_ID();
        ArrayList NGSSType = in.getNGSS_Type();
        if(!NGSSID.toString().equals("[null]") && !NGSSID.toString().equals("[]") && NGSSID.size() >= 1){
	        
	        Element AlignedTo = dDoc.createElement("AlignedTo"); 
	        Element NGSS_ELM = dDoc.createElement("NGSS"); 
	        
	        for (int loopIndex = 0; loopIndex < NGSSID.size(); loopIndex++) {
	            Element NGSS_ID = dDoc.createElement("ItemID");
	            NGSS_ID.setAttribute("NgssType", (String) NGSSType
                    .get(loopIndex));
	            NGSS_ID.appendChild(dDoc.createTextNode("http://asn.jesandco.org/resources/"+(String) NGSSID
                    .get(loopIndex)));
	            NGSS_ELM.appendChild(NGSS_ID);
	        }
	        AlignedTo.appendChild(NGSS_ELM);
	        EXTR.appendChild(AlignedTo);
        }
        
        
        
        Element AC = dDoc.createElement("ASNIDs");

        ArrayList asnid = in.getAsn_ID();
        ArrayList asn_matchtype = in.getAsn_MatchType();
        ArrayList asn_matchpercent = in.getAsn_MatchPercent();

         // only if there actually is an asn
         if(!asnid.toString().equals("[null]") && !asnid.toString().equals("[]") && asnid.size() >= 1){
	        for (int loopIndex = 0; loopIndex < asnid.size(); loopIndex++) {
	            Element asnID = dDoc.createElement("ASNID");
	            asnID.setAttribute("ASNNumber", "http://asn.jesandco.org/resources/"+(String) asnid
	                    .get(loopIndex));
	            asnID.setAttribute("MatchType", (String) asn_matchtype
	                    .get(loopIndex));
	             asnID.setAttribute("MatchPercent", (String) asn_matchpercent
	                    .get(loopIndex));
	
	            AC.appendChild(asnID);
	        }  
		}
		
        
        Data.appendChild(Name);
        Data.appendChild(ObjectType);
        Data.appendChild(AAASCode);
        Data.appendChild(AC);
        Admin.appendChild(IDNumber);
        Data.appendChild(IR);
        Data.appendChild(EXTR);
        Data.appendChild(Description);

        // making detailed elements
        if (data.getDetail().equalsIgnoreCase("Detailed")) {

            Element Source = dDoc.createElement("Source");
            Source.appendChild(dDoc.createTextNode(in.getSource()));

            Element FullText = dDoc.createElement("FullText");
            FullText.appendChild(dDoc.createTextNode(in.getFull_text()));

            Element NSI = dDoc.createElement("NarrativeStudentIdeas");
            NSI.appendChild(dDoc.createTextNode(in.getStudent_conceptions()));

            Element NE = dDoc.createElement("NarrativeExamples");
            NE.appendChild(dDoc.createTextNode(in.getExamples()));

            Element NA = dDoc.createElement("NarrativeAssessment");
            NA.appendChild(dDoc.createTextNode(in.getAssessments()));

            Element NI = dDoc.createElement("NarrativeInstructional");
            NI.appendChild(dDoc.createTextNode(in.getInstructional_information()));

            Element NC = dDoc.createElement("NarrativeClarification");
            NC.appendChild(dDoc.createTextNode(in.getClarification()));

            Element ER = dDoc.createElement("ExternalResources");
            ER.appendChild(dDoc.createTextNode(in.getResources()));

            Element GRS = dDoc.createElement("GradeRanges");

            String[] GG = in.getPrimary_grade().split(",");

            for (int i = 0; i < GG.length; i++) {
                Element G = dDoc.createElement("GradeRange");
                G.appendChild(dDoc.createTextNode(GG[i]));
                GRS.appendChild(G);
            }

            Element SS = dDoc.createElement("Subjects");

            if (in.getSubjects() != null && !in.getSubjects().equalsIgnoreCase("")) 
            {

                String[] S = in.getSubjects().split(",");

                for (int i = 0; i < S.length; i++) 
                {
                    Element p = dDoc.createElement("Subject");
                    p.appendChild(dDoc.createTextNode(S[i]));
                    SS.appendChild(p);
                }
            }
            
            Data.appendChild(SS);

            Element KYS = dDoc.createElement("Keywords");

            if (in.getKeywords() != null && !in.getKeywords().equalsIgnoreCase("")) 
            {

                String[] K = in.getKeywords().split(",");

                for (int i = 0; i < K.length; i++) {
                    Element q = dDoc.createElement("keyword");
                    q.appendChild(dDoc.createTextNode(K[i]));
                    KYS.appendChild(q);
                }
            }

            Data.appendChild(KYS);

            Element SR = dDoc.createElement("Standards");
            SR.appendChild(dDoc.createTextNode(new Formator()
                    .FormatWholeStandard(in.getStandards())));

            Data.appendChild(Source);
            Data.appendChild(FullText);
            Data.appendChild(NSI);
            Data.appendChild(NE);
            Data.appendChild(NA);
            Data.appendChild(NI);
            Data.appendChild(NC);
            Data.appendChild(GRS);
            Data.appendChild(ER);
            Data.appendChild(SR);

            Element Cataloger = dDoc.createElement("Cataloger");

            Element RecordStatus = dDoc.createElement("RecordStatus");
            RecordStatus
                    .appendChild(dDoc.createTextNode(in.getRecord_status()));

            Element Lang = dDoc.createElement("Lang");
            Lang.appendChild(dDoc.createTextNode(in.getLang()));

            Element date = dDoc.createElement("Date");
            date.appendChild(dDoc.createTextNode(in.getDate_created()));
            Cataloger.appendChild(date);

            Admin.appendChild(Cataloger);
            Admin.appendChild(RecordStatus);
            Admin.appendChild(Lang);
        }

        return itemRecord;
    }

    public String getFormat() {
        return "SMS";
    }

    public boolean isBinary() {
        return false;
    }

    public String mimeType() {
        return "text/xml";
    }
	
	public Date getLastModifiedDate() {
		return new Date(); 
	}	

}
