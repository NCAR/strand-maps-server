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

public class Formator {
    public String FormatWholeStandard(String inStandard) {
        StringBuffer sb = new StringBuffer();
        String value = inStandard;
        String[] sList = value.split("###start###");

        if (sList != null && sList.length != 0) {
            for (int index = 0; index < sList.length; index++) {
                if (!sList[index].equalsIgnoreCase("")) {
                    sList[index] = sList[index].replaceAll("###end###", "");

                    String[] cList = sList[index]
                            .split("\\?\\?\\?sep\\?\\?\\?");

                    if (cList != null && cList.length != 0) {
                        if (sb.length() != 0)
                            sb.append("+");

                        for (int counter = 0; counter < cList.length; counter++) {
                            if (counter < cList.length - 1) {
                                sb.append(cList[counter]);
                                sb.append("+");
                            } else {
                                String[] lList = cList[counter]
                                        .split("\\^\\^\\^l-next\\^\\^\\^");

                                if (lList != null && lList.length != 0) {
                                    for (int levels = 0; levels < lList.length; levels++) {
                                        sb.append(lList[levels]);

                                        if (levels < lList.length - 1)
                                            sb.append("+");
                                    }
                                }
                            }

                        }
                    }
                }
            }
        }
        return sb.toString();
    }

    public String getSName(String string) {
        return getSPart(string, 0);
    }

    private String getSPart(String in, int partNo) {
        String value = "";
        String[] sList = in.split("###start###");

        if (sList != null && sList.length != 0) {
            for (int index = 0; index < sList.length; index++) {
                if (!sList[index].equalsIgnoreCase("")) {
                    sList[index] = sList[index].replaceAll("###end###", "");

                    String[] cList = sList[index]
                            .split("\\?\\?\\?sep\\?\\?\\?");

                    if (cList != null && cList.length != 0
                            && partNo < cList.length && partNo > -1)
                        value = cList[partNo];
                    break;
                }
            }
        }

        return value;

    }

    public String getSGrade(String string) {
        return getSPart(string, 1);
    }

    public String getSLevel(String string, String string2) {
        if (string2 == null)
            return "";

        int level = Integer.parseInt(string2) - 1;
        String value = "";
        String[] sList = string.split("###start###");
        boolean flag = true;

        back: if (sList != null && sList.length != 0 && flag) {
            for (int index = 0; index < sList.length; index++) {
                if (!sList[index].equalsIgnoreCase("")) {
                    sList[index] = sList[index].replaceAll("###end###", "");

                    String[] cList = sList[index]
                            .split("\\?\\?\\?sep\\?\\?\\?");

                    if (cList != null && cList.length != 0) {

                        for (int counter = 0; counter < cList.length; counter++) {
                            String[] lList = cList[counter]
                                    .split("\\^\\^\\^l-next\\^\\^\\^");

                            if (lList != null && lList.length != 0
                                    && level < lList.length && level > -1) {
                                value = lList[level];
                                flag = false;
                                break back;
                            }
                        }
                    }
                }
            }
        }
        return value;
    }

    public String getSLink(String string) {
        return getSPart(string, 2);
    }
}
