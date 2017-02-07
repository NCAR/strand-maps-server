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

import org.xml.sax.EntityResolver;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

public class ER implements EntityResolver {

    public InputSource resolveEntity(String publicId, String systemId)
            throws SAXException, IOException {
        // /workspace/smsDevelopment/WEB-INF/XML

        // System.out.println("Real Path :
        // "+ExtendedActionServlet.cxt.getRealPath(systemId)+"\nSystem ID :
        // "+systemId);
        // systemId =
        // systemId.replaceFirst("CSIP.xsd","workspace/smsDevelopment/WEB-INF/XML/CSIP.xsd");
        // System.out.println("path = "+publicId+" : SystemID "+systemId);

        return new InputSource(systemId);
    }

}
