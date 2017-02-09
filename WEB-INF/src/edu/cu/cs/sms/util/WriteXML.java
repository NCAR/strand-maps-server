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

import org.w3c.dom.*;

public final class WriteXML {
    private StringBuffer sbuff = new StringBuffer();

    public String writeXML(Node root) {

        if (root == null)
            return null;

        switch (root.getNodeType()) {
        case Node.ATTRIBUTE_NODE:
            break;
        case Node.CDATA_SECTION_NODE: {
            sbuff.append("<!CDATA[[" + root.getNodeValue() + "]]>");
            break;
        }
        case Node.COMMENT_NODE:
            break;
        case Node.DOCUMENT_FRAGMENT_NODE:
            break;
        case Node.DOCUMENT_NODE: {
            sbuff.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
            writeXML(((Document) root).getDocumentElement());

            break;
        }
        case Node.DOCUMENT_TYPE_NODE:
            break;
        case Node.ELEMENT_NODE: {
            sbuff.append("<" + root.getNodeName());

            int length = (root.getAttributes() != null) ? root.getAttributes()
                    .getLength() : 0;
            Attr attributes[] = new Attr[length];

            for (int loopIndex = 0; loopIndex < length; loopIndex++)
                attributes[loopIndex] = (Attr) root.getAttributes().item(
                        loopIndex);

            for (int loopIndex = 0; loopIndex < attributes.length; loopIndex++) {
                Attr attribute = attributes[loopIndex];
                sbuff.append(" " + attribute.getNodeName() + "=\""
                        + attribute.getNodeValue() + "\"");
            }

            sbuff.append(">");

            NodeList childNodes = root.getChildNodes();

            if (childNodes != null) {
                length = childNodes.getLength();

                for (int loopIndex = 0; loopIndex < length; loopIndex++)
                    writeXML(childNodes.item(loopIndex));
            }

            break;
        }
        case Node.ENTITY_NODE:
            break;
        case Node.ENTITY_REFERENCE_NODE:
            break;
        case Node.NOTATION_NODE:
            break;
        case Node.PROCESSING_INSTRUCTION_NODE: {
            sbuff.append("<?");

            String text = root.getNodeValue();

            if (text != null && text.length() > 0)
                sbuff.append(text);

            sbuff.append("?>");

            break;
        }
        case Node.TEXT_NODE: {
            String newText = root.getNodeValue();

            if (newText != null) {
                newText = newText.trim();

                if (newText.indexOf("\n") < 0 && newText.length() > 0)
                    sbuff.append(newText);
            }
            break;
        }
        }

        if (root.getNodeType() == Node.ELEMENT_NODE) {
            sbuff.append("</" + root.getNodeName() + ">");
        }

        return sbuff.toString();
    }

    public void setSbuff(StringBuffer sbuff) {
        this.sbuff = sbuff;
    }
}
