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
 * Author: Qianyi Gu
 * Date  : Sept 14, 2005
 * email : Qianyi.Gu@colorado.edu
 */
package edu.cu.cs.sms.svg;

import java.io.*;
import java.util.*;
// import java.net.*;
import java.sql.*;

// import java.lang.*;

// package com.microsoft.*;

public class my_process {

  /*  private Vector benchmarkList = new Vector();

    private Vector benchmarkPool = new Vector();

    private Vector B_temp_list1 = new Vector();

    private Vector B_temp_list2 = new Vector();

    private Vector seatList = new Vector();

    private Vector seatAssigned = new Vector();

    private benchmark curr_b, curr_b1, curr_b2;

    private String filename = "newTest.svg";

    private PrintWriter outs2;

    private String centerID;

    
     * public static void main(String[] args) throws Exception {
     * initBenchmark(); test(); System.out.println("Finished");
     * 
     *  }
     
    public my_process(String ID, int flag) throws Exception {

        centerID = ID;

        // System.out.println("\nID SVG : "+ID);

        initBenchmark();
        // build up the map from here:
        String mysURL = "jdbc:microsoft:sqlserver://localhost;databasename=StrandMap;user=colorado2;password=colorado2";
        Class.forName("com.microsoft.jdbc.sqlserver.SQLServerDriver");

        Connection myCon;
        Statement stmt, stmt2;
        ResultSet rs, rs2;
        String SQLStatement = "";
        String sConnectURL = mysURL;
        myCon = DriverManager.getConnection(sConnectURL);

        SQLStatement = " select distinct O.object_ID from objects O , relation R1, relation R2 where O.object_ID=R2.ItemID1 and R1.ItemID2='"
                + centerID
                + "' and R1.ItemID1=R2.ItemID2 and O.object_type='benchmark'  ";
        stmt = myCon.createStatement();
        rs = stmt.executeQuery(SQLStatement);

        try {

            while (rs.next()) {
                // construct a new benchmark:

                String map_ID = "";
                map_ID = rs.getString(1);
                benchmark map_bm = retrieveBM(map_ID);
                benchmarkPool.add((Object) map_bm);

            }
        } catch (SQLException sqle) {
        }
        rs.close();
        stmt.close();

        outs2 = new PrintWriter(new FileOutputStream(".\\" + filename), true);

        test();
        // System.out.println("Finished");

    }

    public void setID(String ID) {
        centerID = ID;

    }

    public void test() throws Exception {
        
         * benchmark my_bm = retrieveBM("10660000000019"); benchmarkPool=
         * my_bm.getToBenchmark(); for (int i=0;i<benchmarkPool.size();i++) {
         * System.out.println(((benchmark)benchmarkPool.elementAt(i)).getID()); }
         * 
         

        // benchmarkPool = benchmarkList;
        v_order();
        h_order();
        h_reorder();
        // post_process();

        drawMap();
        // System.out.println(centerID);

    }

    public benchmark retrieveBM(String myID) {
        benchmark my_b;
        String curr_ID;
        int limit = benchmarkList.size();
        int i = 0;
        my_b = (benchmark) benchmarkList.elementAt(i);
        curr_ID = my_b.getID();
        if (curr_ID.equals(myID)) {
            return my_b;

        } // end of if
        for (i = 1; i < limit; i++) {
            my_b = (benchmark) benchmarkList.elementAt(i);
            curr_ID = my_b.getID();
            if (curr_ID.equals(myID)) {
                return my_b;

            } // end of if
        } // end for loop

        return my_b;

    }

    public void initBenchmark() throws Exception {
        // connect to database:

        String mysURL = "jdbc:microsoft:sqlserver://localhost;databasename=StrandMap;user=colorado2;password=colorado2";
        Class.forName("com.microsoft.jdbc.sqlserver.SQLServerDriver");

        Connection myCon;
        Statement stmt, stmt2;
        ResultSet rs, rs2;
        String SQLStatement = "";
        String sConnectURL = mysURL;
        myCon = DriverManager.getConnection(sConnectURL);

        SQLStatement = " select B.object_ID, B.Name, B.primary_grade, B.description,B.aaas_code from objects B where B.object_type='benchmark' ";
        stmt = myCon.createStatement();
        rs = stmt.executeQuery(SQLStatement);

        try {

            while (rs.next()) {
                // construct a new benchmark:

                String ID = "", Name = "", Grade = "", Text = "", Code = "";
                ID = rs.getString(1);
                Name = rs.getString(2);
                Grade = rs.getString(3);
                Text = rs.getString(4);
                Code = rs.getString(5);
                curr_b = new benchmark(ID, Name, Grade, Text, Code, null, null);
                benchmarkList.addElement((Object) curr_b);

            }
        } catch (SQLException sqle) {
        }
        rs.close();
        stmt.close();

        // retrieve the benchmark relations info:

        SQLStatement = " select ItemID1, ItemID2 from relation R where R.RelationType='to'";
        stmt = myCon.createStatement();
        rs = stmt.executeQuery(SQLStatement);
        try {

            while (rs.next()) {
                // construct a new benchmark:

                String ID1 = "", ID2 = "";
                ID1 = rs.getString(1);
                ID2 = rs.getString(2);
                curr_b1 = retrieveBM(ID1);
                curr_b2 = retrieveBM(ID2);
                curr_b1.addToBenchmark((Object) curr_b2);
                curr_b2.addFromBenchmark((Object) curr_b1);

            }
        } catch (SQLException sqle) {

        }
        rs.close();
        stmt.close();
        
         * String
         * startPool="1066000000008,1066000000009,10660000000019,10660000000027,10660000000026,10660000000021,10660000000022,10660000000018,10660000000014,10660000000012";
         * String startB[] = startPool.split(","); int startN=10; for (int k=0;k<startN;k++){
         * benchmark ben = retrieveBM(startB[k]);
         * benchmarkPool.add((Object)ben); }
         

    }

    public void generateSeats(int X, int Y) {
        int i, j;
        for (i = 1; i <= X; i++) {
            for (j = 1; j <= Y; j++) {
                seat curr_seat = new seat(i, j);
                seatList.add((Object) curr_seat);
            }
        }
    }

    public boolean conflict(seat s1, seat s2) {
        int x1, x2, y1, y2;
        x1 = s1.getX();
        x2 = s2.getX();
        y1 = s1.getY();
        y2 = s2.getY();

        return true;

    } // end of method

    public benchmark root() {
        benchmark curr_b = (benchmark) benchmarkPool.elementAt(0);
        for (int i = 0; i < benchmarkPool.size(); i++) {
            curr_b = (benchmark) benchmarkPool.elementAt(i);
            if (curr_b.getToBenchmark().size() == 0) {
                return curr_b;
            }
        }

        return curr_b;

    } // end of root

    public Vector rootList(Vector currentPool) {

        Vector my_list = new Vector();
        benchmark my_b, temp_b;
        boolean isroot;
        // System.out.println("currentPool size is: "+ currentPool.size());
        for (int i = 0; i < currentPool.size(); i++) {
            my_b = (benchmark) currentPool.elementAt(i);
            isroot = true;
            // System.out.println(my_b.getID());
            // System.out.println(my_b.getToBenchmark().size());

            // if(my_b.getToBenchmark().size()==0){ my_list.add((Object)my_b); }

            for (int j = 0; j < my_b.getToBenchmark().size(); j++) {
                temp_b = (benchmark) my_b.getToBenchmark().elementAt(j);
                if (currentPool.contains((Object) temp_b)) {
                    isroot = false;
                }

            }
            if (isroot) {
                my_list.add((Object) my_b);
            }

        }
        return my_list;
    } // end of rootList

    public void v_order() {

        int level = 0;
        Vector processPool = new Vector();
        processPool = (Vector) benchmarkPool.clone();
        benchmark curr_b;
        Vector temp_list = new Vector();
        while (processPool.size() > 0) {
            // System.out.println("level is: "+ level);
            // System.out.println("processPool size is"+ processPool.size());
            // System.out.println("rootList size is"+
            // rootList(processPool).size());
            for (int i = 0; i < rootList(processPool).size(); i++) {

                curr_b = (benchmark) rootList(processPool).elementAt(i);
                curr_b.setVValue(level);
                // System.out.println("Assign:"+curr_b.getID()+": "+level);

                temp_list.add((Object) curr_b);
            } // end of for

            for (int i = 0; i < temp_list.size(); i++) {
                curr_b = (benchmark) temp_list.elementAt(i);
                processPool.remove((Object) curr_b);
            } // end of for

            level++;
        } // end of while

    } // end of v_order

    public void h_order() {

        int level = 0;
        boolean split = false;
        double unit = 0.0;

        Vector processPool = new Vector();
        processPool = (Vector) benchmarkPool.clone();
        benchmark curr_b;
        Vector temp_list = new Vector();
        while (processPool.size() > 0) {
            // System.out.println("level is: "+ level);
            // System.out.println("processPool size is"+ processPool.size());
            // System.out.println("rootList size is"+
            // rootList(processPool).size());
            for (int i = 0; i < rootList(processPool).size(); i++) {
                curr_b = (benchmark) rootList(processPool).elementAt(i);
                if ((split == false) && (rootList(processPool).size() == 1)) {
                    curr_b.setHValue(0.0);
                    // System.out.println("Assign:"+curr_b.getID()+": "+0.0);

                } else if ((split == false)
                        && (rootList(processPool).size() > 1)) {
                    unit = 2.0 / (rootList(processPool).size() - 1.0);
                    double myh_value = (((double) i) * unit) - 1.0;
                    curr_b.setHValue((((double) i) * unit) - 1.0);
                    // System.out.println("Assign:"+curr_b.getID()+":
                    // "+myh_value);
                    if (i == (rootList(processPool).size() - 1)) {
                        split = true;
                    }
                } else {
                    double sumH = 0.0;
                    for (int j = 0; j < curr_b.getToBenchmark().size(); j++) {
                        sumH = sumH
                                + ((benchmark) (curr_b.getToBenchmark()
                                        .elementAt(j))).getHValue();

                    }
                    sumH = sumH / curr_b.getToBenchmark().size();
                    curr_b.setHValue(sumH);
                    // System.out.println("Assign:"+curr_b.getID()+": "+sumH);
                }

                temp_list.add((Object) curr_b);
            } // end of for

            for (int i = 0; i < temp_list.size(); i++) {
                curr_b = (benchmark) temp_list.elementAt(i);
                processPool.remove((Object) curr_b);
            } // end of for

            level++;
        } // end of while

    } // end of h_order

    public void h_reorder() {

        // sort the bechmarkPool by hValue and put into processPool:
        Vector processPool = new Vector();
        Vector tempPool = new Vector();
        Vector pointerPool = new Vector();
        pointerPool.setSize(100);
        tempPool = (Vector) benchmarkPool.clone();
        while (tempPool.size() > 0) {
            double minH = 100.0;
            int minIndex = 0;

            for (int j = 0; j < tempPool.size(); j++) {
                benchmark curr_b = (benchmark) tempPool.elementAt(j);
                if (minH >= curr_b.getHValue()) {
                    minH = curr_b.getHValue();
                    minIndex = j;
                }

            }
            processPool.add((Object) tempPool.elementAt(minIndex));
            tempPool.remove(minIndex);

        }

        int Hlimit = 0;
        int limit = 0;
        double previous_h = -100.0;
        double current_h = 0.0;
        double th = 0.01;

        for (int i = 0; i < benchmarkPool.size(); i++) {
            benchmark my_b = (benchmark) processPool.elementAt(i);
            current_h = my_b.getHValue();

            int vPoint = my_b.getVValue();
            if (pointerPool.elementAt(vPoint) == null) {
                Hlimit = 0;
            } else {
                Hlimit = ((benchmark) pointerPool.elementAt(vPoint))
                        .getH2Value();

            }
            if (current_h > (previous_h + th)) {
                limit++;
            }
            if (Hlimit >= limit) {
                limit++;
            }

            my_b.setH2Value(limit);
            pointerPool.setElementAt((Object) my_b, vPoint);
            previous_h = current_h;
            // System.out.println("X: "+ my_b.getH2Value()+", Y:
            // "+my_b.getVValue());

        }

    } // end of h_reorder

    public void drawMap() throws Exception {
        double width, height;
        double box_w = 100.0, box_h = 100.0;
        double white_ratio = 1.1;

        double v_scale = 0.0, h_scale = 0.0;
        int maxV = 0;
        double minH = 2.0, maxH = -2.0;
        for (int i = 0; i < benchmarkPool.size(); i++) {

            benchmark curr_b = (benchmark) benchmarkPool.elementAt(i);
            if (maxV < curr_b.getVValue()) {
                maxV = curr_b.getVValue();
            }
            if (minH > curr_b.getH2Value()) {
                minH = (double) curr_b.getH2Value();
            }
            if (maxH < curr_b.getH2Value()) {
                maxH = (double) curr_b.getH2Value();
            }

        } // end of for
        maxV = maxV + 1;
        maxH = maxH + 1.0;
        height = ((double) maxV) * white_ratio * box_h;
        width = ((double) maxH) * white_ratio * box_w;
        // outs2 = new PrintWriter(new FileOutputStream("C:\\Program
        // Files\\Apache Tomcat
        // 4.0\\webapps\\examples\\MYJSP\\"+filename),true);
        outs2
                .println("<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>"
                        + " <!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 1.0//EN\" \"http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd\">"
                        + "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\""
                        + width + "\" height=\"" + height + "\">");
        post_process();

        v_scale = height / (double) maxV;
        h_scale = width / (maxH - minH);
        // System.out.println("V: "+v_scale+ ", H: "+h_scale);
        for (int i = 0; i < benchmarkPool.size(); i++) {
            benchmark curr_b = (benchmark) benchmarkPool.elementAt(i);
            String text = curr_b.getText();
            double X = 0.0, Y = 0.0;
            X = ((double) curr_b.getH2Value() - minH) * h_scale;
            X = X + (white_ratio - 1.0) / 2.0 * box_w;

            Y = (double) curr_b.getVValue() * v_scale;
            // Y is center of block:
            Y = Y + white_ratio / 2.0 * box_h;

            drawBox(X, Y, box_w, box_h, text, "#E0E0C2");

            // draw the links from that box:
            for (int h = 0; h < (curr_b.getToBenchmark()).size(); h++) {
                benchmark bb = (benchmark) ((curr_b.getToBenchmark())
                        .elementAt(h));
                if (benchmarkPool.contains((Object) bb)) {

                    String text2 = bb.getText();
                    double X2 = 0.0, Y2 = 0.0;
                    X2 = ((double) bb.getH2Value() - minH) * h_scale;
                    X2 = X2 + (white_ratio - 1.0) / 2.0 * box_w;

                    Y2 = (double) bb.getVValue() * v_scale;
                    // Y is center of block:
                    Y2 = Y2 + white_ratio / 2.0 * box_h;
                    draw_link(X, Y, X2, Y2, text, text2, box_w, box_h);
                }

            }

        }

        // ---------------------------
        // end of file:
        outs2.println("</svg>");
        outs2.close();

    } // end of drawMap

    public void drawBox(double X, double Y, double box_w, double box_h,
            String brief_text, String color) {

        // Y is center of box;

        ArrayList texts;
        double current_x, current_y;
        texts = breakLine(brief_text, (int) (box_w / (5.0)));
        int point_tracker = 0;
        int my_size = texts.size();
        if (my_size > 6) {
            my_size = 6;
        }
        point_tracker = 9 * (my_size + 1);
        current_x = X;
        current_y = Y - point_tracker / 2;

        // current_y=(row-1)*sbh+0.5*(sbh-sh)+0.5*(sh-point_tracker);

        outs2.println("<rect width=\"" + box_w + "\" height=\"" + point_tracker
                + "\" x=\"" + current_x + "\" y=\"" + current_y
                + "\" rx=\"0\" style=\"fill:" + color + "; stroke:none;\"/>");

        for (int k1 = 0; k1 < my_size; k1++) {
            String tls = (String) texts.get(k1);
            // System.out.println(texts.size());
            outs2.println("<text x=\"" + (current_x + 5) + "\" y=\""
                    + ((current_y + 9) + (k1 * 9))
                    + "\" style=\"font-size:10\">" + tls + "</text>");

        }

    } // end of drawBox

    public void post_process() {

        if (centerID.equals("SMS-MAP-9001")) {

            benchmark bm = retrieveBM("SMS-BMK-0295");
            int H2 = bm.getVValue();
            H2 = H2 + 1;
            bm.setVValue(H2);

            bm = retrieveBM("SMS-BMK-0299");
            H2 = bm.getVValue();
            H2 = H2 + 2;
            bm.setVValue(H2);

            bm = retrieveBM("SMS-BMK-0299");
            H2 = bm.getH2Value();
            H2 = H2 - 1;
            bm.setH2Value(H2);

            bm = retrieveBM("SMS-BMK-9019");
            H2 = bm.getH2Value();
            H2 = H2 - 1;
            bm.setH2Value(H2);

            bm = retrieveBM("SMS-BMK-0297");
            H2 = bm.getVValue();
            H2 = H2 + 1;
            bm.setVValue(H2);

            bm = retrieveBM("SMS-BMK-0286");
            H2 = bm.getVValue();
            H2 = H2 + 1;
            bm.setVValue(H2);

            bm = retrieveBM("SMS-BMK-9009");
            H2 = bm.getVValue();
            H2 = H2 + 1;
            bm.setVValue(H2);

            bm = retrieveBM("SMS-BMK-9024");
            H2 = bm.getVValue();
            H2 = H2 + 1;
            bm.setVValue(H2);
            bm = retrieveBM("SMS-BMK-9024");
            H2 = bm.getH2Value();
            H2 = H2 - 4;
            bm.setH2Value(H2);

            bm = retrieveBM("SMS-BMK-9020");
            H2 = bm.getH2Value();
            H2 = H2 + 4;
            bm.setH2Value(H2);

            bm = retrieveBM("SMS-BMK-9020");
            H2 = bm.getVValue();
            H2 = H2 + 2;
            bm.setVValue(H2);

            bm = retrieveBM("SMS-BMK-9010");
            H2 = bm.getH2Value();
            H2 = H2 + 4;
            bm.setH2Value(H2);

            bm = retrieveBM("SMS-BMK-0305");
            H2 = bm.getH2Value();
            H2 = H2 + 3;
            bm.setH2Value(H2);

            // grade:
            outs2
                    .println("<line x1=\"0\" y1=\"210\" x2=\"180%\" y2=\"210\" style=\"stroke:gray;stroke-width:5;stroke-opacity:.6\"/>");
            outs2
                    .println("<line x1=\"0\" y1=\"780\" x2=\"180%\" y2=\"780\" style=\"stroke:gray;stroke-width:5;stroke-opacity:.6\"/>");
            outs2
                    .println("<line x1=\"0\" y1=\"680\" x2=\"180%\" y2=\"680\" style=\"stroke:gray;stroke-width:5;stroke-opacity:.6\"/>");

            outs2.println("<text x=\"0\" y=\"20\">9-12</text>");
            outs2.println("<text x=\"0\" y=\"230\">6-8</text>");
            outs2.println("<text x=\"0\" y=\"700\">3-5</text>");
            outs2.println("<text x=\"0\" y=\"800\">K-2</text>");

            
             * outs2.println("<text x=\"150\" y=\"870\">plants making food</text>");
             * outs2.println("<text x=\"750\" y=\"870\">food web</text>");
             * outs2.println("<text x=\"1300\" y=\"870\">matter cycles</text>");
             
            outs2.println("<text x=\"150\" y=\"20\">plants making food</text>");
            outs2.println("<text x=\"750\" y=\"20\">food web</text>");
            outs2.println("<text x=\"1300\" y=\"20\">matter cycles</text>");

        }

        if (centerID.equals("10660000000049")) {
            // post process plate tectonics map:
            benchmark bm = retrieveBM("10660000000025");
            int H2 = bm.getH2Value();
            H2 = H2 + 1;
            bm.setH2Value(H2);

            bm = retrieveBM("10660000000031");
            H2 = bm.getH2Value();
            H2 = H2 - 1;
            bm.setH2Value(H2);

            bm = retrieveBM("10660000000034");
            H2 = bm.getH2Value();
            H2 = H2 + 4;
            bm.setH2Value(H2);

            // grade:
            outs2
                    .println("<line x1=\"0\" y1=\"555\" x2=\"100%\" y2=\"555\" style=\"stroke:gray;stroke-width:5;stroke-opacity:.6\"/>");
            outs2.println("<text x=\"0\" y=\"70\">9-12</text>");
            outs2.println("<text x=\"0\" y=\"600\">6-8</text>");

            
             * outs2.println("<text x=\"750\" y=\"870\">evidence of plates</text>");
             * outs2.println("<text x=\"450\" y=\"870\">earthquakes and
             * volcanoes</text>"); outs2.println("<text x=\"150\"
             * y=\"870\">the earth's interior </text>");
             

            outs2.println("<text x=\"750\" y=\"20\">evidence of plates</text>");
            outs2
                    .println("<text x=\"450\" y=\"20\">earthquakes and volcanoes</text>");
            outs2
                    .println("<text x=\"150\" y=\"20\">the earth's interior </text>");

        }
        if (centerID.equals("10660000000048")) {
            benchmark bm = retrieveBM("10660000000026");
            int H2 = bm.getH2Value();
            H2 = H2 + 4;
            bm.setH2Value(H2);

            bm = retrieveBM("10660000000027");
            H2 = bm.getH2Value();
            H2 = H2 - 2;
            bm.setH2Value(H2);

            bm = retrieveBM("10660000000023");
            H2 = bm.getH2Value();
            H2 = H2 + 9;
            bm.setH2Value(H2);

            bm = retrieveBM("10660000000027");
            H2 = bm.getH2Value();
            H2 = H2 - 4;
            bm.setH2Value(H2);

            bm = retrieveBM("10660000000025");
            H2 = bm.getH2Value();
            H2 = H2 - 10;
            bm.setH2Value(H2);

            bm = retrieveBM("10660000000021");
            H2 = bm.getH2Value();
            H2 = H2 - 4;
            bm.setH2Value(H2);

            bm = retrieveBM("10660000000018");
            H2 = bm.getVValue();
            H2 = H2 - 1;
            bm.setVValue(H2);

            bm = retrieveBM("10660000000007");
            H2 = bm.getVValue();
            H2 = H2 + 1;
            bm.setVValue(H2);

            bm = retrieveBM("10660000000009");
            H2 = bm.getVValue();
            H2 = H2 + 1;
            bm.setVValue(H2);

            bm = retrieveBM("10660000000023");
            H2 = bm.getVValue();
            H2 = H2 + 1;
            bm.setVValue(H2);

            bm = retrieveBM("10660000000024");
            H2 = bm.getVValue();
            H2 = H2 - 1;
            bm.setVValue(H2);

            bm = retrieveBM("10660000000024");
            H2 = bm.getH2Value();
            H2 = H2 + 6;
            bm.setH2Value(H2);

            bm = retrieveBM("10660000000013");
            H2 = bm.getH2Value();
            H2 = H2 + 1;
            bm.setH2Value(H2);

            bm = retrieveBM("10660000000013");
            H2 = bm.getVValue();
            H2 = H2 + 1;
            bm.setVValue(H2);

            bm = retrieveBM("10660000000008");
            H2 = bm.getVValue();
            H2 = H2 + 1;
            bm.setVValue(H2);

            bm = retrieveBM("10660000000017");
            H2 = bm.getVValue();
            H2 = H2 - 1;
            bm.setVValue(H2);

            bm = retrieveBM("10660000000017");
            H2 = bm.getH2Value();
            H2 = H2 - 8;
            bm.setH2Value(H2);

            // grade:

            outs2
                    .println("<line x1=\"0\" y1=\"230\" x2=\"100%\" y2=\"230\" style=\"stroke:gray;stroke-width:5;stroke-opacity:.6\"/>");
            outs2
                    .println("<line x1=\"0\" y1=\"650\" x2=\"100%\" y2=\"650\" style=\"stroke:gray;stroke-width:5;stroke-opacity:.6\"/>");
            outs2
                    .println("<line x1=\"0\" y1=\"875\" x2=\"100%\" y2=\"875\" style=\"stroke:gray;stroke-width:5;stroke-opacity:.6\"/>");
            outs2.println("<text x=\"0\" y=\"70\">9-12</text>");
            outs2.println("<text x=\"0\" y=\"260\">6-8</text>");
            outs2.println("<text x=\"0\" y=\"680\">3-5</text>");
            outs2.println("<text x=\"0\" y=\"900\">K-2</text>");
            
             * outs2.println("<text x=\"550\" y=\"1080\">rates of change</text>");
             * outs2.println("<text x=\"120\" y=\"1080\">earthquakes and
             * volcanoes</text>"); outs2.println("<text x=\"800\"
             * y=\"1080\">weathering and erosion </text>"); outs2.println("<text
             * x=\"1100\" y=\"1080\">rocks and sediments</text>");
             

            outs2.println("<text x=\"550\" y=\"20\">rates of change</text>");
            outs2
                    .println("<text x=\"120\" y=\"20\">earthquakes and volcanoes</text>");
            outs2
                    .println("<text x=\"800\" y=\"20\">weathering and erosion </text>");
            outs2
                    .println("<text x=\"1100\" y=\"20\">rocks and sediments</text>");

        } // end of if

    } // end of post process

    public ArrayList breakLine(String in, int width) {

        int dlen = 0;
        String[] words;

        ArrayList lines = new ArrayList();
        String tl = "";
        dlen = in.length();
        words = in.split(" ");
        for (int i = 0; i < java.lang.reflect.Array.getLength(words); i++) {
            tl = tl + " " + words[i];

            if (tl.length()
                    + ((i == java.lang.reflect.Array.getLength(words) - 1) ? 0
                            : words[i + 1].length()) > width) {

                // System.out.println(tl);

                lines.add(tl);

                tl = "";
            }
        }

        lines.add(tl);
        tl = "";
        return lines;
    } // end of breakLine

    public void draw_link(double in_x1, double in_y1, double in_x2,
            double in_y2, String brief_text1, String brief_text2, double sw,
            double sh) {

        ArrayList texts;
        texts = breakLine(brief_text1, (int) (sw / (5.0)));
        int my_size = texts.size();
        if (my_size > 6) {
            my_size = 6;
        }

        int point_tracker1 = 9 * (my_size + 1);
        texts = breakLine(brief_text2, (int) (sw / (5.0)));
        my_size = texts.size();
        if (my_size > 6) {
            my_size = 6;
        }
        int point_tracker2 = 9 * (my_size + 1);

        double x1, y1, x2, y2, kl, tx, ty, xs, ys, xe, ye;
        double X1, X2, X3, X4, X5, Y1, Y2, Y3, Y4, Y5;
        double sh1 = point_tracker1, sw1 = sw, sh2 = point_tracker2, sw2 = sw;

        // row=row1;
        // column=column1;
        // current_x=(column-1)*sbw+0.5*sbw;
        double current_x = in_x1 + 0.5 * sw;
        double current_y = in_y1;

        // current_y=(row-1)*sbh+0.5*sbh;
        x1 = current_x;
        y1 = current_y;

        // row=row2;
        // column=column2;
        // current_x=(column-1)*sbw+0.5*sbw;
        // current_y=(row-1)*sbh+0.5*sbh;
        current_x = in_x2 + 0.5 * sw;
        current_y = in_y2;

        x2 = current_x;
        y2 = current_y;

        // calculate the line equation:

        if ((x2 - x1) == 0)
            x2++;
        // if ((y2-y1)==0) y2++;
        kl = (y2 - y1) / (x2 - x1);
        if (kl == 0.0)
            kl = 0.01;

        // calculate the starting point:
        if (y1 == y2) {
            if (x1 > x2) {
                x1 = x1 - sw1 / 2;
                x2 = x2 + sw2 / 2;
            } else {
                x1 = x1 + sw1 / 2;
                x2 = x2 - sw2 / 2;
            }

        } else {
            // calculate the starting point:
            tx = ((y1 - sh1 / 2) - y1 + kl * x1) / kl;
            if ((tx > (x1 - sw1 / 2)) && (tx < (x1 + sw1 / 2))) {
                xs = tx;
                ys = y1 - sh1 / 2;
            } else {

                if (tx <= (x1 - sw1 / 2)) {
                    xs = x1 - sw1 / 2;
                    ys = kl * xs + (y1 - kl * x1);
                } else {
                    xs = x1 + sw1 / 2;
                    ys = kl * xs + (y1 - kl * x1);
                }

            }

            x1 = xs;
            y1 = ys;

            // calculate the end point:
            tx = ((y2 + sh2 / 2) - y1 + kl * x1) / kl;
            if ((tx >= (x2 - sw2 / 2)) && (tx <= x2 + sw2 / 2)) {
                xe = tx;
                ye = y2 + sh2 / 2;
            } else if (tx < (x2 - sw2 / 2)) {
                xe = x2 - sw2 / 2;
                ye = kl * xe + (y1 - kl * x1);
            } else {
                xe = x2 + sw2 / 2;
                ye = kl * xe + (y1 - kl * x1);
            }

            x2 = xe;
            y2 = ye;

        } // end of else

        outs2.println("<line x1=\"" + x1 + "\" y1=\"" + y1 + "\" x2=\"" + x2
                + "\" y2=\"" + y2
                + "\" style=\"stroke:black;stroke-width:1;\"/>");

        // calculate and draw the triangle:

        X1 = (double) x2;
        X3 = (double) x1;
        Y1 = (double) y2;
        Y3 = (double) y1;
        double k2 = 0.0, k = 0.0, l = 0.0, r = 0.0, a = 5.0;
        k2 = (Y3 - Y1) / (X3 - X1);
        if (k2 == 0)
            k2 = 0.1;
        k = (-1.0) / k2;
        l = java.lang.Math
                .sqrt(((X3 - X1) * (X3 - X1) + (Y3 - Y1) * (Y3 - Y1)));
        r = a / l;
        X2 = X1 + (X3 - X1) * r;
        Y2 = Y1 + (Y3 - Y1) * r;

        X4 = java.lang.Math.sqrt(((a * a) / (k * k + 1))) + X2;
        X5 = (-1.0) * java.lang.Math.sqrt(((a * a) / (k * k + 1))) + X2;
        Y4 = k * (X4 - X2) + Y2;
        Y5 = k * (X5 - X2) + Y2;
        // X5=X3;
        // Y5=Y3;
        outs2.println("<polygon points=\"" + X1 + "," + Y1 + " " + X4 + ","
                + Y4 + " " + X5 + "," + Y5 + " " + X1 + "," + Y1 + "\"/>");
    }*/

}
