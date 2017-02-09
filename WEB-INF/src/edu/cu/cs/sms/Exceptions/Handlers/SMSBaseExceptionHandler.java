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

package edu.cu.cs.sms.Exceptions.Handlers;

import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.PropertyResourceBundle;

import org.apache.struts.action.ExceptionHandler;

import edu.cu.cs.sms.ExtendedActionServlet;
import edu.cu.cs.sms.Exceptions.ResourceBundleNotFoundException;

public abstract class SMSBaseExceptionHandler extends ExceptionHandler {
    protected static PropertyResourceBundle information = null;

    protected static PropertyResourceBundle code = null;

    protected static PropertyResourceBundle description = null;

    protected static PropertyResourceBundle transfer = null;

    protected Exception initResourceBundles() {
        String bundlePath = null;

        try {
            if (information == null) {
                information = new PropertyResourceBundle(new BufferedInputStream(this.getClass().getClassLoader().getResourceAsStream(
                        "edu/cu/cs/sms/ApplicationResources.properties")));
            }

            if (code == null) {
                code = new PropertyResourceBundle(new BufferedInputStream(this.getClass().getClassLoader().getResourceAsStream(
                        "edu/cu/cs/sms/ErrorCodes.properties")));
            }

            if (description == null) {
                description = new PropertyResourceBundle(new BufferedInputStream(this.getClass().getClassLoader().getResourceAsStream(
                        "edu/cu/cs/sms/ErrorDescriptions.properties")));
            }

            if (transfer == null) {
                transfer = new PropertyResourceBundle(new BufferedInputStream(this.getClass().getClassLoader().getResourceAsStream(
                        "edu/cu/cs/sms/TransferKeys.properties")));
            }
        } catch (FileNotFoundException e) {
            return new ResourceBundleNotFoundException(e);
        } catch (IOException e) {
            return new ResourceBundleNotFoundException(e);
        }

        return null;
    }

}
