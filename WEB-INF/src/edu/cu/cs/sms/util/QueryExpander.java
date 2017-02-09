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

package edu.cu.cs.sms.util;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.StringReader;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Enumeration;
import java.util.LinkedList;
import java.util.List;
import java.util.Properties;

import org.apache.xerces.parsers.SAXParser;
import org.w3c.dom.Document;
import org.xml.sax.Attributes;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import edu.cu.cs.sms.ExtendedActionServlet;
import edu.cu.cs.sms.DTO.SMSData;

public class QueryExpander {
    private String DLquery = null;

    private String DLname = null;

    private String Encoding = null;

    public QueryExpander(String name, String inQuery, String code) {
        DLquery = inQuery;
        DLname = name;
        Encoding = code;
    }

    public String getDLquery(SMSData info) throws SAXException, IOException {
        String tQuery = "<TEMPSMSELEMENT>" + escapeXML(DLquery) + "</TEMPSMSELEMENT>"; //$NON-NLS-1$ //$NON-NLS-2$
        SAXParser parser = new SAXParser();
        Document doc = null;
        SAXHandler handle = new SAXHandler(info);

        parser.setContentHandler(handle);
        parser.setErrorHandler(handle);
        parser.parse(new InputSource(new BufferedReader(
                new StringReader(tQuery))));

        if (Encoding.equalsIgnoreCase("MIN-URL"))
            return escapeMinURL(handle.getResult());
        else if (Encoding.equalsIgnoreCase("None"))
            return handle.getResult();
        else
            return URLEncoder.encode(handle.getResult(), Encoding);
    }

    private String escapeMinURL(String string) {
        String temp = string.replaceAll("\"", "%22").replaceAll("&amp;", "&")
                .replaceAll(" ", "%20").replaceAll("\\^", "%5E").replaceAll(
                        "#", "%23").replaceAll("&quot;", "\"");

        return temp;
    }

    private String escapeXML(String string) {
        String temp = string.replaceAll("&", "&amp;");

        temp = temp.replaceAll("'", "&apos;");// .replaceAll("\"","&quot;");

        return temp;
    }

    public String getDLname() {
        return DLname;
    }

    private class SAXHandler extends DefaultHandler {
        SMSData info = null;

        StringBuffer result = new StringBuffer();

        String[] lookup = null;

        boolean processingGroup = false;

        private String cycleType = null;

        private List gList = new LinkedList();

        private int minGroup = 10000;

        public void endElement(String URI, String localName, String rawName)
                throws SAXException {
            int location = Arrays.binarySearch(lookup, localName);

            if (location > -1
                    && lookup[location].toLowerCase().matches("group")) {
                processingGroup = false;
                result.append(spitGroup());
            }

            if (location < 0 && !processingGroup)
                result.append("</" + rawName + ">");

            if (location < 0 && processingGroup)
                gList.add("</" + rawName + ">");
        }

        private String spitGroup() {
            StringBuffer compose = new StringBuffer();

            for (int index = 0; index < minGroup; index++) {
                for (int counter = 0; counter < gList.size(); counter++) {
                    Object in = gList.get(counter);
                    if (in instanceof String)
                        compose.append(in);
                    if (in instanceof List)
                        compose.append(((List) in).get(index));
                }

                if (index < minGroup - 1)
                    compose.append(cycleType);
            }

            if (minGroup <= 0) {
                for (int counter = 0; counter < gList.size(); counter++) {
                    Object in = gList.get(counter);
                    if (in instanceof String)
                        compose.append(in);
                }
            }

            return compose.toString();
        }

        public void startElement(String URI, String localName, String rawName,
                Attributes attributes) throws SAXException {
            int location = Arrays.binarySearch(lookup, localName);
            String value = null;

            if (processingGroup) {
                pgGroup(URI, localName, attributes, rawName);
                return;
            }

            if (location >= 0) {
                if (lookup[location].equalsIgnoreCase("name"))
                    value = info.getName();
                else if (lookup[location].equalsIgnoreCase("source"))
                    value = info.getSource();
                else if (lookup[location].equalsIgnoreCase("objecttype"))
                    value = info.getObject_type();
                else if (lookup[location].equalsIgnoreCase("aaascode"))
                    value = info.getAaas_code();
                else if (lookup[location].equalsIgnoreCase("description"))
                    value = info.getDescription();
                else if (lookup[location].equalsIgnoreCase("fulltext"))
                    value = info.getFull_text();
                else if (lookup[location]
                        .equalsIgnoreCase("narrativestudentideas"))
                    value = info.getStudent_conceptions();
                else if (lookup[location].equalsIgnoreCase("narrativeexamples"))
                    value = info.getExamples();
                else if (lookup[location]
                        .equalsIgnoreCase("narrativeassessment"))
                    value = info.getAssessments();
                else if (lookup[location]
                        .equalsIgnoreCase("narrativeinstructional"))
                    value = info.getInstructional_information();
                else if (lookup[location]
                        .equalsIgnoreCase("narrativeclarification"))
                    value = info.getClarification();
                else if (lookup[location].equalsIgnoreCase("idnumber"))
                    value = info.getObject_id();
                else if (lookup[location].equalsIgnoreCase("graderanges")) {
                    value = info.getPrimary_grade().replaceAll(" *, *", "+");
                } else if (lookup[location].equalsIgnoreCase("subjects")) {
                    value = simpleList(
                            info.getSubjects().replaceAll(" *, *", "+"),
                            attributes.getValue("Paran")).toString();
                    value = value.substring(1, value.length() - 1).replaceAll(
                            " *, *", "+");
                } else if (lookup[location].equalsIgnoreCase("keywords")) {
                    value = simpleList(
                            info.getKeywords().replaceAll(" *, *", "+"),
                            attributes.getValue("Paran")).toString();
                    value = value.substring(1, value.length() - 1).replaceAll(
                            " *, *", "+");
                } else if (lookup[location]
                        .equalsIgnoreCase("internalrelationship")) {
                    value = info.getRelationType().toString();
                    value = value.substring(1, value.length() - 1).replaceAll(
                            " *, *", "+");
                } else if (lookup[location].equalsIgnoreCase("ids")) {
                    value = info.getItemID2().toString();
                    value = value.substring(1, value.length() - 1).replaceAll(
                            " *, *", "+");
                } else if (lookup[location].equalsIgnoreCase("group")) {
                    processingGroup = true;
                    processGroup(attributes);
                } else if (lookup[location]
                        .equalsIgnoreCase("externalresources")) {
                    value = info.getResources();
                    value = value.substring(1, value.length() - 1).replaceAll(
                            " *, *", "+");
                } else if (lookup[location].equalsIgnoreCase("standards"))
                    value = new Formator().FormatWholeStandard(info
                            .getStandards());
                else if (lookup[location].equalsIgnoreCase("standardname"))
                    value = new Formator().getSName(info.getStandards());
                else if (lookup[location].equalsIgnoreCase("standardgrades"))
                    value = new Formator().getSGrade(info.getStandards());
                else if (lookup[location].equalsIgnoreCase("standardlink"))
                    value = new Formator().getSLink(info.getStandards());
                else if (lookup[location].equalsIgnoreCase("standardlevel"))
                    value = new Formator().getSLevel(info.getStandards(),
                            attributes.getValue("Level"));

                if (attributes.getLength() != 0) {
                    String delimiter = attributes.getValue("Delimiter");

                    if (delimiter != null)
                        value = value.replaceAll("\\+", delimiter);
                }

                if (value != null)
                    result.append(value);
            }

            if (location < 0) {
                result.append("<" + rawName + " ");

                if (attributes.getLength() == 0)
                    result.append(" xmlns:" + rawName.split(":")[0] + "=\""
                            + URI + "\"" + ">");
                else {
                    for (int index = 0; index < attributes.getLength(); index++)
                        result.append(attributes.getQName(index) + "=\""
                                + attributes.getValue(index) + "\" ");
                    result.append(">");
                }

            }
        }

        private void pgGroup(String URI, String localName,
                Attributes attributes, String rawName) {
            int location = Arrays.binarySearch(lookup, localName);
            String value = null;

            if (location >= 0) {
                if (lookup[location].equalsIgnoreCase("name"))
                    gList.add(info.getName());
                else if (lookup[location].equalsIgnoreCase("source"))
                    gList.add(info.getSource());
                else if (lookup[location].equalsIgnoreCase("objecttype"))
                    gList.add(info.getObject_type());
                else if (lookup[location].equalsIgnoreCase("aaascode"))
                    gList.add(info.getAaas_code());
                else if (lookup[location].equalsIgnoreCase("description"))
                    gList.add(info.getDescription());
                else if (lookup[location].equalsIgnoreCase("fulltext"))
                    gList.add(info.getFull_text());
                else if (lookup[location]
                        .equalsIgnoreCase("narrativestudentideas"))
                    gList.add(info.getStudent_conceptions());
                else if (lookup[location].equalsIgnoreCase("narrativeexamples"))
                    gList.add(info.getExamples());
                else if (lookup[location]
                        .equalsIgnoreCase("narrativeassessment"))
                    gList.add(info.getAssessments());
                else if (lookup[location]
                        .equalsIgnoreCase("narrativeinstructional"))
                    gList.add(info.getInstructional_information());
                else if (lookup[location]
                        .equalsIgnoreCase("narrativeclarification"))
                    gList.add(info.getClarification());
                else if (lookup[location].equalsIgnoreCase("idnumber"))
                    gList.add(info.getObject_id());
                else if (lookup[location].equalsIgnoreCase("graderanges")) {
                    value = info.getPrimary_grade().replaceAll(", *", "+");
                } else if (lookup[location].equalsIgnoreCase("subjects"))
                    gList.add(simpleList(info.getSubjects().replaceAll(" *, *",
                            "+"), attributes.getValue("Paran")));
                else if (lookup[location].equalsIgnoreCase("keywords"))
                    gList.add(simpleList(info.getKeywords().replaceAll(" *, *",
                            "+"), attributes.getValue("Paran")));
                else if (lookup[location]
                        .equalsIgnoreCase("internalrelationship"))
                    gList.add(info.getRelationType());
                else if (lookup[location].equalsIgnoreCase("ids"))
                    gList.add(info.getItemID2());
                else if (lookup[location].equalsIgnoreCase("externalresources"))
                    gList.add(info.getResources().substring(1,
                            value.length() - 1).replaceAll(" *, *", "+"));
                else if (lookup[location].equalsIgnoreCase("standards"))
                    gList.add(new Formator().FormatWholeStandard(info
                            .getStandards()));
                else if (lookup[location].equalsIgnoreCase("standardname"))
                    gList.add(sName(info.getStandards(), 0));
                else if (lookup[location].equalsIgnoreCase("standardgrades"))
                    gList.add(sName(info.getStandards(), 1));
                else if (lookup[location].equalsIgnoreCase("standardlink"))
                    gList.add(sName(info.getStandards(), 2));
                else if (lookup[location].equalsIgnoreCase("standardlevel"))
                    gList.add(sLevel(info.getStandards(), attributes
                            .getValue("Level")));

            }

            if (location < 0) {
                gList.add("<" + rawName + " ");

                if (attributes.getLength() == 0)
                    gList.add(" xmlns:" + rawName.split(":")[0] + "=\"" + URI
                            + "\"" + ">");
                else {
                    for (int index = 0; index < attributes.getLength(); index++)
                        gList.add(attributes.getQName(index) + "=\""
                                + attributes.getValue(index) + "\" ");
                    gList.add(">");
                }

            }

        }

        private List sLevel(String string, String string2) {
            int level = Integer.parseInt(string2);
            String[] sList = string.split("###start###");
            String[] lList = new String[sList.length];
            String[] temp = null;
            List ll = new LinkedList();

            for (int index = 0; index < sList.length; index++) {
                sList[index] = sList[index].replaceAll("###end###", "").trim();
                temp = sList[index].split("\\?\\?\\?sep\\?\\?\\?");
                lList[index] = temp[temp.length - 1];
            }

            for (int index = 0; index < lList.length; index++) {
                temp = lList[index].split("\\^\\^\\^l-next\\^\\^\\^");
                if (level < temp.length && level >= 0
                        && !temp[level].equalsIgnoreCase(""))
                    ll.add(temp[level]);
            }

            if (ll.size() < minGroup)
                minGroup = ll.size();

            return ll;
        }

        private List sName(String string, int pos) {
            String[] stds = string.split("###start###");
            List names = new LinkedList();

            for (int index = 0; index < stds.length; index++)
                if (!stds[index].equalsIgnoreCase(""))
                    names.add(stds[index].toLowerCase().split(
                            "\\?\\?\\?sep\\?\\?\\?")[pos].trim());

            if (names.size() < minGroup)
                minGroup = names.size();

            return names;
        }

        private List simpleList(String string, String string2) {
            String[] all = string.split("\\+");
            List allList = new LinkedList();

            for (int index = 0; index < all.length; index++)
                if (!all[index].equalsIgnoreCase(""))
                    if (string2.equalsIgnoreCase("true"))
                        allList.add("(" + all[index].trim() + ")");
                    else
                        allList.add(all[index].trim());

            if (allList.size() < minGroup)
                minGroup = allList.size();

            return allList;
        }

        private void processGroup(Attributes attributes) {
            cycleType = attributes.getValue("Repeat");
            gList.clear();
            minGroup = 10000;
        }

        public void characters(char[] ch, int start, int length)
                throws SAXException {
            if (!processingGroup)
                result.append(ch, start, length);
            else
                gList.add(new String(ch, start, length));
        }

        public String getResult() {
            return reverseXMLescape(result.toString());
        }

        private String reverseXMLescape(String string) {
            return string.replaceAll("&quot;", "\"");
        }

        public SAXHandler(SMSData info) throws FileNotFoundException,
                IOException {
            super();
            this.info = info;
            Properties tags = new Properties();
            ArrayList tList = new ArrayList();

            tags.load(new BufferedInputStream(this.getClass().getClassLoader().getResourceAsStream(
                    "edu/cu/cs/sms/util/QueryExpander.properties")));

            Enumeration en = tags.keys();

            while (en.hasMoreElements())
                tList.add(tags.getProperty((String) en.nextElement()).trim());

            tList.trimToSize();

            lookup = new String[tList.size() + 1];

            for (int index = 0; index < tList.size(); index++)
                lookup[index] = (String) tList.get(index);

            lookup[lookup.length - 1] = "TEMPSMSELEMENT";

            Arrays.sort(lookup);
        }

    }

    public String getEncoding() {
        return Encoding;
    }
}
