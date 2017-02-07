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
 * The Concept Map Service Project is distributed in the hope that it will be
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

package edu.cu.cs.sms;

import java.util.Date;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import edu.cu.cs.sms.Exceptions.InsufficientParamertersException;

public class SubmitResource extends SMSAction {

    public ActionForward execute(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        MessageResources information = getResources(request, "Info");

        // Extracting objectid, Reosurce and email from the URL and stores them
        // in appropriate variables
        String ObjectID = request.getParameter("ObjectID");
        String Resource = request.getParameter("Resource");
        String from = request.getParameter("email");

        // Extracts the send to address from servlet context
        String toAddress = information.getMessage("mail.AAAS.address");

        // Preparing subject and body of email
        String subject = information.getMessage("mail.AAAS.subject");
        String body = information.getMessage("mail.AAAS.body", Resource,
                ObjectID)
                + (request.getParameter("comments") != null ? "\nComments : "
                        + request.getParameter("comments") : "");

        // Checking to see if all the required parameters are valid
        if (ObjectID == null || Resource == null || from == null
                || !ObjectID.matches("[a-zA-z]{3}-[a-zA-z]{3}-[0-9]{4}"))
            throw new InsufficientParamertersException();

        sendMail(from, toAddress, subject, body, information.getMessage(
                "mail.debug").matches("true") ? true : false, information
                .getMessage("mail.SMTP.host"));

        subject = information.getMessage("mail.response.subject");
        body = information.getMessage("mail.response.body");

        sendMail(toAddress, from, subject, body, information.getMessage(
                "mail.debug").matches("true") ? true : false, information
                .getMessage("mail.SMTP.host"));

        return null;
    }

    /**
     * @param email
     * @param toAddress
     * @param subject
     * @param body
     * @throws MessagingException
     * @throws AddressException
     */
    private void sendMail(String email, String toAddress, String subject,
            String body, boolean debug, String SMTPhost)
            throws MessagingException, AddressException {
        // Setting up properties for javamail session object
        Properties prop = new Properties();
        prop.put("mail.smtp.host", SMTPhost);

        // Setting up default javamail session
        Session session = Session.getDefaultInstance(prop, null);
        session.setDebug(debug);

        // Constructing a message
        Message msg = new MimeMessage(session);
        msg.setFrom(new InternetAddress(email));

        // Setting up to address, subject and date
        InternetAddress[] to = { new InternetAddress(toAddress) };
        msg.setRecipients(Message.RecipientType.TO, to);
        msg.setSubject(subject);
        msg.setSentDate(new Date());

        // Constructing the email body
        MimeBodyPart mbp1 = new MimeBodyPart();
        mbp1.setText(body);

        // Conxtructing a mutlipart message body
        Multipart mp = new MimeMultipart();
        mp.addBodyPart(mbp1);

        // Adding the multipart message body to message
        msg.setContent(mp);

        // Sending the message
        Transport.send(msg);
    }
}
